using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;

namespace ExchangeRateBCCR
{
    class Synchronizer
    {
        public Decimal dollarPurchaseValue, dollarSellValue;

        public String connString = 
            "Server=tcp:rocket-bd2.database.windows.net,1433;"+
            "Initial Catalog=ROCKET-BD2;"+
            "Persist Security Info=False;"+
            "User ID=rocket-admin;"+
            "Password=2020-bd2-2020;"+
            "MultipleActiveResultSets=False;"+
            "Encrypt=True;"+
            "TrustServerCertificate=False;"+
            "Connection Timeout=30;";

        public Synchronizer() { }

        /// <summary>
        ///     Synchronizes the exchange rate dimension in the data warehouse with current values 
        ///     for dollar purchase and sell to register the incoming sales
        /// </summary>
        public void synchronize()
        {
            using (var conn = new SqlConnection(this.connString))
            {
                Console.WriteLine("Opening connection");
                conn.Open();

                DateTime lastDate = this.getLastUpdateDate(conn).AddDays(1);
                DateTime today = DateTime.ParseExact(DateTime.Now.ToString("dd/MM/yyyy"), "dd/MM/yyyy", null);

                Console.WriteLine("Fetching data since: {0}\n", lastDate.ToString("dd/MM/yyyy"));
                int rowCount = 0;

                while ( lastDate <= today || (DateTime.Now.Hour >= 6 && lastDate.ToString("dd/MM/yyyy") == DateTime.Now.ToString("dd/MM/yyyy")) )
                {
                    // get purchase and sell value from web service
                    var responseForDollarPurchase = 
                        new Parser(new Consumer(317, lastDate.ToString("dd/MM/yyyy")).consumeWebService());

                    responseForDollarPurchase.extract();
                    this.dollarPurchaseValue = responseForDollarPurchase.value;

                    var responseForDollarSell =
                        new Parser( new Consumer(318, lastDate.ToString("dd/MM/yyyy")).consumeWebService());

                    responseForDollarSell.extract();
                    this.dollarSellValue = responseForDollarSell.value;

                    // register in db
                    using (var command = conn.CreateCommand())
                    {
                        command.CommandText = @"INSERT INTO DIM_EXCHANGE_RATE (update_date, dollar_purchase_crc, dollar_sell_crc) VALUES (@ud, @dpc, @dsc);";

                        command.Parameters.AddWithValue("@ud", lastDate);
                        command.Parameters.AddWithValue("@dpc", this.dollarPurchaseValue);
                        command.Parameters.AddWithValue("@dsc", this.dollarSellValue);

                        Console.WriteLine("[{0}]: Purchase: {1}, Sell {2}", lastDate.ToString("dd/MM/yyyy"), this.dollarPurchaseValue, this.dollarSellValue);

                        rowCount += command.ExecuteNonQuery();
                    }

                    lastDate = lastDate.AddDays(1);
                }

                if (rowCount == 0)
                    Console.WriteLine("Exchange rate is updated!");
                else
                    Console.WriteLine(String.Format("Number of rows inserted={0}", rowCount));
            }
        }

        /// <summary>
        ///     Get the last update date from the DIM_EXCHANGE_RATE table
        /// </summary>
        /// <param name="conn"> SQLConnection to query the db</param>
        /// <returns> Last update date or 01/01/2017 (by specs) </returns>
        private DateTime getLastUpdateDate(SqlConnection conn) {

            using (var command = conn.CreateCommand())
            {
                // get last date from db
                command.CommandText = "SELECT TOP(1) update_date FROM DIM_EXCHANGE_RATE ORDER BY update_date DESC";

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                        return DateTime.ParseExact(reader.GetDateTime(0).ToString("dd/MM/yyyy"), "dd/MM/yyyy", null);
                }
            }

            return DateTime.ParseExact("01/01/2017", "dd/MM/yyyy", null);
        }
    }
}
