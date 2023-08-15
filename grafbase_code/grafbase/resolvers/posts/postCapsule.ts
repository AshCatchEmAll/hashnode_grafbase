

export default async function Resolver(_, args, { request }) {
  const { headers } = request;



  console.log("headers", JSON.stringify(headers));

  // Call this ur; https://woefulsleepykernel.gottacatchemall.repl.co

  const url = "https://woefulsleepykernel.gottacatchemall.repl.co";
  const options = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(args),
  };

  const response = await fetch(url, options);
  const data = await response.json();

  console.log(JSON.stringify(data));
  console.log("args", JSON.stringify(args));
  return 2;
}
