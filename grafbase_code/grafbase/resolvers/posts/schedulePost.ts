import { format, addHours } from "date-fns";
import jwt from "@tsndr/cloudflare-worker-jwt";
import base64url from "base64url";



type CronObj = {
  minute: string;
  hour: string;
  day: string;
  month: string;
  weekday: string;
};

export default async function Resolver(root, args, { request }) {
  try {
    const {
     
      mediaURL,
      caption,
     
      cron,
      timezone,
      expiresAt,
      
    } = args;

    const cronObj = strToCronObj(cron);

    console.log("cronObj", JSON.stringify(cronObj));

    console.log("Timezone", timezone);

    const { headers } = request;

    const authorization = headers["authorization"];
    const token = authorization.split("Bearer ").pop();

    const isValid = await jwt.verify(token, "secret");

    // Check for validity
    if (!isValid) console.log("Invalid token");

    // Decoding token
    const decoded = jwt.decode(token);
    console.log("jwt", JSON.stringify(decoded.payload));
    const sub = decoded.payload.sub;
    
    // const mutation = `mutation PostUpdate {
    //   postUpdate(by: {id:"post_01H7GGR0073FCHWKMMXMA0E6EH"}, input: {
    //     caption: "Updated just now V2"
    //   })  {
    //     post {
    //       content

    //     }
    //   }
    // }`;

    // const variables = {
    //   postID: "post_01H7GGR0073FCHWKMMXMA0E6EH",
    // };
    const mutation = `
    mutation PC(
        $sub: String!,
        
      
        $caption: String!,
        $content: String,
       
    ) {
      postCreate(
        input: {
          sub: $sub
        
        
          caption: $caption
          content: $content
          
        }
      ) {
        post {
          id
          slug
          sub
        }
      }
    }
    `;

    const variables = {
      sub: sub,
     
      
      caption: caption,
      content: mediaURL,
     
    };
    const payload = {
      job: {
        enabled: true,
        url: process.env.GB_URL,
        requestMethod: 1,
        saveResponses: true,
        extendedData: {
          headers: {
            Authorization: "Bearer " + token,
            "Content-Type": "application/json",
            "x-api-key": process.env.GB_KEY,
          },
          body: JSON.stringify({ query: mutation, variables: variables }),
        },

        schedule: {
          timezone: timezone,
          expiresAt: expiresAt,
          hours: [cronObj["hour"]],
          mdays: [cronObj["day"]],
          minutes: [cronObj["minute"]],
          months: [cronObj["month"]],
          wdays: [cronObj["weekday"]],
        },
      },
    };

    const response = await fetch(`https://api.cron-job.org/jobs`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: "Bearer " + process.env.CRON_API_KEY,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      throw new Error("Network response was not ok");
    }

    const data = await response.json();

    data["input"] = args;
    data["input"]["sub"] = sub;

    console.log(JSON.stringify(data));

    return JSON.stringify(data);
  } catch (e) {

    console.log(e);
    throw Error(e);
  }
}

function strToCronObj(str: string): CronObj {
  const [minute, hour, day, month, weekday] = str.split(" ");
  return {
    minute,
    hour,
    day,
    month,
    weekday,
  };
}

