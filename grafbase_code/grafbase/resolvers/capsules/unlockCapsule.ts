import jwt from "@tsndr/cloudflare-worker-jwt";

type LatLng = {
  lat: number;
  lng: number;
};

export default async function Resolver(root, args, { request }) {
  try {
    const { headers } = request;
    const { capsuleID, userLat, userLong } = args;
    const userLocation: LatLng = {
      lat: userLat,
      lng: userLong,
    };
    const authorization = headers["authorization"];
    const token = authorization.split("Bearer ").pop();
    const capsule = await getCapsuleByID(token, capsuleID);
    console.log("capsule", JSON.stringify(capsule));
    const capsuleData = capsule.data.capsule;

    const members = capsuleData.members;
    const decoded = jwt.decode(token);
    console.log("jwt", JSON.stringify(decoded.payload));
    const sub = decoded.payload.sub;

    if (sub === undefined) {
      throw new Error("You are not authorized to unlock this capsule");
    }
    // check if sub is in members
    if (!members.includes(sub)) {
      throw new Error("You are not authorized to unlock this capsule");
    }

    // check if capsule location is within 100m of user location

    const capsuleLocation: LatLng = {
      lat: capsuleData.location.lat,
      lng: capsuleData.location.lng,
    };
    const isLocationCorrect = checkCapsuleLocation(
      capsuleLocation,
      userLocation
    );
    if (!isLocationCorrect) {
      throw new Error("Your location is not close enough to the capsule");
    }
    await postCapsuleForAllMembers(members, capsuleData, token);

   
    
    const deleteCapsuleResponse = await deleteCapsule(token, capsuleID);
    console.log("deleteCapsuleResponse", deleteCapsuleResponse);
    return "OK";
  } catch (error) {
    console.log(error);
    throw new Error("");
  }
}

async function postCapsuleForAllMembers(
  memebrs: string[],
  capsule: any,
  token: string
) {
 

  for (let i = 0; i < memebrs.length; i++) {
    const member = memebrs[i];
    const post = await createPost(
      capsule.caption,
      capsule.content,
      member,
      token
    );
    console.log(`post for ${member}`, JSON.stringify(post));
    const postID = post.data.postCreate.post.id;
    console.log("New post ID", postID);
  }
}

function checkCapsuleLocation(capsuleLocation: LatLng, userLocation: LatLng) {
  console.log("capsuleLocation", capsuleLocation.lat, capsuleLocation.lng);
  if (capsuleLocation.lat === 0 && capsuleLocation.lng === 0) {
    return true;
  }
  const distance = haversineDistance(userLocation, capsuleLocation);

  if (distance > 50) {
    return false;
  }
}

function haversineDistance(coord1: LatLng, coord2: LatLng) {
  const R = 6371; // Radius of the Earth in kilometers
  const dLat = toRad(coord2.lat - coord1.lat);
  const dLng = toRad(coord2.lng - coord1.lng);

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(coord1.lat)) *
      Math.cos(toRad(coord2.lat)) *
      Math.sin(dLng / 2) *
      Math.sin(dLng / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const distance = R * c;

  return distance;
}

function toRad(value: number) {
  return (value * Math.PI) / 180;
}
async function deleteCapsule(token: string, capsuleID: string) {
  try {
    const mutation = `
    mutation CapsuleDelete(
        $id: ID!
      ) {
        capsuleDelete(by: {
          id: $id
        }) {
          deletedId
        }
      }
    `;

    const variables = {
      id: capsuleID,
    };
    //@ts-nocheck
    const response = await fetch(process.env.GB_URL!, {
      method: "POST",
      headers: {
        Authorization: "Bearer " + token,
        "Content-Type": "application/json",
        "x-api-key": process.env.GB_KEY!,
      },
      body: JSON.stringify({
        query: mutation,
        variables: variables,
      }),
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.log("error deleting a capsule: ", error);
    throw error;
  }
}

async function createPost(
  caption: string,
  content: string,
  sub: string,
  token: string
) {
  try {
    const mutation = `mutation PostCreate(
        $caption: String!
        $content : String
        $sub : String!
      ) {
        postCreate(input: {
          caption:$caption
          content : $content 
          sub : $sub
        }) {
          post {
            caption
            content
            sub
            id
            createdAt
            updatedAt
          }
        }
      }`;

    const variables = {
      caption: caption,
      content: content,
      sub: sub,
    };

    //@ts-nocheck
    const response = await fetch(process.env.GB_URL!, {
      method: "POST",
      headers: {
        Authorization: "Bearer " + token,
        "Content-Type": "application/json",
        "x-api-key": process.env.GB_KEY!,
      },
      body: JSON.stringify({
        query: mutation,
        variables: variables,
      }),
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.log("error creating a post: ", error);
    throw error;
  }
}

async function getCapsuleByID(token: string, capsuleID: string) {
  const query = `

            query Capsule(
                $id:ID!
            ) {
                capsule(by: {
                id:$id
                }){ 
                caption
                members
                content
                location {
                    address
                    lat
                    lng
                }
                availableAt
                }
            }`;

  const variables = {
    id: capsuleID,
  };

  //@ts-nocheck
  const response = await fetch(process.env.GB_URL!, {
    method: "POST",
    headers: {
      Authorization: "Bearer " + token,
      "Content-Type": "application/json",
      "x-api-key": process.env.GB_KEY!,
    },
    body: JSON.stringify({
      query: query,
      variables: variables,
    }),
  });

  const data = await response.json();
  return data;
}



