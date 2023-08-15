import { g, auth, config } from "@grafbase/sdk";

const location = g
  .model("Location", {
    address: g.string(),
    lat: g.float(),
    lng: g.float(),
  })
  .search();

const capsule = g
  .model("Capsule", {
    caption: g.string().default(""),
    content: g.string().optional(),
    members: g.string().list(),
    location: g.relation(location),
    availableAt: g.string(),
    cron: g.string(),
    tapCount: g.int().default(0), //Amount of people tapped to open [used for group capsules]
  })
  .search();

const post = g
  .model("Post", {
    caption: g.string().default(""),
    content: g.string().optional(),
    sub: g.string(),
  })
  .search();

const user = g
  .model("User", {
    sub: g.string().unique(),
    email: g.email().unique(),
  })
  .search();

g.mutation("test", {
  args: { word: g.string() },
  returns: g.int(),
  resolver: "posts/test",
});

g.mutation("schedulePost", {
  args: {
    mediaURL: g.string().optional(),
    caption: g.string().optional(),
    cron: g.string(),
    timezone: g.string(),
    expiresAt: g.string().optional().default("0"),
  },
  returns: g.string(),
  resolver: "posts/schedulePost",
});

g.mutation("postCapsule", {
  args: {
    postID: g.string(),
  },
  returns: g.string(),
  resolver: "posts/postCapsule",
});

g.mutation("unlockCapsule", {
  args: {
    capsuleID: g.id(),
	userLat : g.float(),
	userLng : g.float(),
  },
  returns: g.id(),
  resolver: "capsules/unlockCapsule",
});




// const provider = auth.JWT({
//   issuer: g.env('SUPABASE_URL'),
//   secret: g.env('SUPABASE_JWT_SECRET')
// })

export default config({
  schema: g,
  // Integrate Auth
  // https://grafbase.com/docs/auth
  // auth: {
  //   providers: [provider],
  //   rules: (rules) => {
  //     rules.private()
  //   }
  // }
});

