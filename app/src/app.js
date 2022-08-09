const express =  require('express');
const app = express();
const hello = require('./hello');

app.get("/", (req, res) => {
    res.send(hello.getHelloWorld());
});

app.get("/eks", (req, res) => {

    output = JSON.stringify({
        "originApplication":"jenkins",
        "transactionId":"5726c7f7-8389-4d4c-8cde-bb7074cd3701",
        "transactionName":"poc eks",
        "requestingApplication":"cloudwatch",
        "application":"template-api-ecs-docker",
        "payload":
        {
            "status": 400,
            "code": "Código do erro: pode ser utilizado para auxiliar o time de desenvolvedores e suporte em caso de dúvidas",
            "message": "Mensagem descrevendo o erro de maneira geral",
            "details": [
                {
                    "field": "(opcional) Campo da entidade que originou o erro, se for o caso",
                    "message": "Mensagem com mais informações e detalhes do erro no campo especificado"
                },
                {
                    "field": "(opcional) Campo da entidade que originou o erro, se for o caso",
                    "message": "Mensagem com mais informações e detalhes do erro no campo especificado"
                }
            ]
        }
    })

    console.log(output)

    res.send("EKS");
});

app.listen(8080, () => {
    console.log("Aplicação iniciada na porta 8080: http://localhost:8080");
})