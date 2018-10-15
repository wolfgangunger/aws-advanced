exports.handler = async (event) => {
    console.log("param1 = " + event.key1);
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello ' + event.key1)
    };
    return response;
};