using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace ExchangeRateBCCR
{
    class Parser
    {
        private String data;

        public String updateDate { get; set; }
        public Decimal value { get; set; }

        public Parser(String data) { this.data = data; }

        public void extract() {

            var xmlDocument = new XmlDocument();
            xmlDocument.LoadXml(this.data);

            XmlNamespaceManager nsmgr = new XmlNamespaceManager(xmlDocument.NameTable);
            nsmgr.AddNamespace("ns", "http://ws.sdde.bccr.fi.cr");
            nsmgr.AddNamespace("dg", "urn:schemas-microsoft-com:xml-diffgram-v1");

            XmlNodeList xNodeResult = 
                xmlDocument.SelectNodes("ns:DataSet/dg:diffgram/Datos_de_INGC011_CAT_INDICADORECONOMIC/INGC011_CAT_INDICADORECONOMIC", nsmgr);

            this.updateDate =
               Convert.ToDateTime(
                    xNodeResult.Item(0).SelectNodes("(DES_FECHA)[1]", null).Item(0).InnerText
                ).ToString("dd/MM/yyyy");

            this.value =
               Convert.ToDecimal(
                   xNodeResult.Item(0).SelectNodes("(NUM_VALOR)[1]", null).Item(0).InnerText
               );
        }
       
    }
}
