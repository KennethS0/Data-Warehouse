using RestSharp;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExchangeRateBCCR
{
    class Consumer
    {
        private String baseUrl = "https://gee.bccr.fi.cr/Indicadores/Suscripciones/WS/wsindicadoreseconomicos.asmx";
        private String requestUrl = "https://gee.bccr.fi.cr/Indicadores/Suscripciones/WS/wsindicadoreseconomicos.asmx/ObtenerIndicadoresEconomicos";
        private String bccrWebServiceToken = "2STA4UR0LM";
        private String registeredName = "Josue Rojas Vega";
        private String registeredEmail = "basesdedatos2.2020@gmail.com";
        private String date;
        private int indicatorId;

        public Consumer(int indicatorId, String date) { 
            this.indicatorId = indicatorId;
            this.date = date;
        }

        public String consumeWebService()
        {
            try
            {
                var client = new RestClient();
                client.BaseUrl = new Uri(this.baseUrl);

                var request = new RestRequest(requestUrl, Method.POST)
                    .AddParameter("Indicador", this.indicatorId.ToString())
                    .AddParameter("FechaInicio", this.date)
                    .AddParameter("FechaFinal", this.date)
                    .AddParameter("Nombre", this.registeredName)
                    .AddParameter("SubNiveles", "Si")
                    .AddParameter("CorreoElectronico", this.registeredEmail)
                    .AddParameter("Token", this.bccrWebServiceToken);

                var response = client.Execute(request);

                return response.Content;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.StackTrace);
                return String.Empty;
            }
        }

    }
}
