export default function Resolver(_,  args, { request }) {
    const { headers } = request;

    console.log("headers",JSON.stringify(headers));

    console.log("args",JSON.stringify(args));
    return 2;
}
  