using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Net;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Text;
namespace CS3ComparationClient
{
    class SetClientStrucs
    {
        
        static void Main(string[] args)
        {
            Dictionary<string,List<string>> StrucsList = new Dictionary<string,List<string>>();
            string Root = System.IO.Directory.GetCurrentDirectory();
            List<string> fills = new List<string>();

            String DataSource = Properties.Settings.Default.DataSoruce;
            String Base = Properties.Settings.Default.Base;
            String Usuario = Properties.Settings.Default.Usuario;
            String Contraseña = Properties.Settings.Default.Contraseña;
          
            fills = GetStruc(DataSource, Base, Usuario, Contraseña, "Tables", Root);
            StrucsList.Add("Tables", fills);

            fills = GetStruc(DataSource, Base, Usuario, Contraseña, "Atributtes", Root);
            StrucsList.Add("Atributtes", fills);

            fills = GetStruc(DataSource, Base, Usuario, Contraseña, "AtributtesLength", Root);
            StrucsList.Add("AtributtesLength", fills);

            fills = GetStruc(DataSource, Base, Usuario, Contraseña, "Foreign", Root);
            StrucsList.Add("Foreign", fills);

            fills = GetStruc(DataSource, Base, Usuario, Contraseña, "Index", Root);
            StrucsList.Add("Index", fills);
        }
        private static string QueryType(string Root, string BD, string type)
        {
            string line;
            string query = "";
            if (type.Equals("Tables"))
            {
                System.IO.StreamReader file = new System.IO.StreamReader(@Root);
                while ((line = file.ReadLine()) != null)
                {
                    query = query + " " + line;

                    //"SELECT ini.name FROM " + BD + ".sys.Tables as ini order by ini.name";
                }
                file.Close();
                query = query.Replace("<<ORIGEN>>", BD);
            }
            else if (type.Equals("Atributtes"))
            {
                System.IO.StreamReader file = new System.IO.StreamReader(@Root);
                while ((line = file.ReadLine()) != null)
                {
                    query = query + " " + line;
                }
                file.Close();
                query = query.Replace("<<ORIGEN>>", BD);
                //"SELECT icol.name FROM "+BD+".sys.Tables as ini INNER JOIN "+BD+".sys.Columns as icol On ini.object_id=icol.object_id";
            }
            else if (type.Equals("AtributtesLength"))
            {
                System.IO.StreamReader file = new System.IO.StreamReader(@Root);
                while ((line = file.ReadLine()) != null)
                {
                    query = query + " " + line;
                }
                file.Close();
                query = query.Replace("<<ORIGEN>>", BD);
            }
            else if (type.Equals("Foreign"))
            {
                System.IO.StreamReader file = new System.IO.StreamReader(@Root);
                while ((line = file.ReadLine()) != null)
                {
                    query = query + " " + line;
                }
                file.Close();
                query = query.Replace("<<ORIGEN>>", BD);
                //"select t.name	as [Table] ,fkk.name	as [ID]from  " + BD + ".sys.foreign_key_columns as fk inner join " + BD + ".sys.tables as t on fk.parent_object_id = t.object_id inner join " + BD + ".sys.columns as c on fk.parent_object_id = c.object_id and fk.parent_column_id = c.column_id inner join " + BD + ".sys.objects as fkk ON fkk.object_id = fk.constraint_object_id";
            }
            else if (type.Equals("Index"))
            {
                System.IO.StreamReader file = new System.IO.StreamReader(@Root);
                while ((line = file.ReadLine()) != null)
                {
                    query = query + " " + line;
                }
                file.Close();
                query = query.Replace("<<ORIGEN>>", BD);
            }
            return query;
        }
        private static string GetConecciont(string DataSource,string DataBase,string User,string PassWord)
        {

            //string conectionstring = "Data Source=190.190.200.100,1433;Network Library=DBMSSOCN;Initial Catalog=myDataBase;User ID=myUsername;Password=myPassword;"
            SqlConnectionStringBuilder builderconnection = new SqlConnectionStringBuilder();

            builderconnection.DataSource = DataSource;
            builderconnection.InitialCatalog = DataBase;
            builderconnection.IntegratedSecurity = false;
            builderconnection.UserID = User;
            builderconnection.Password = PassWord;
            return builderconnection.ConnectionString;
        }
        private static List<string> GetStruc(string DataSource ,string Base, string Usuario,string PassWord, string type, string Root)
        {
            string connectionstring = GetConecciont(DataSource,Base,Usuario,PassWord);
            List<string> fills = new List<string>();
            string queryString = "";
            string RootAux = Root;

            queryString = QueryType(RootAux = GetQueryPath(Root, type), Base, type);
            fills = GetQueryConnection(queryString, connectionstring);

            return fills;
        }
        private static List<string> GetQueryConnection(string queryconnection, string connectionstring)
        {
            List<string> fills = new List<string>();
            using (SqlConnection connection = new SqlConnection(connectionstring))
            {
                SqlCommand command = connection.CreateCommand();
                command.CommandText = queryconnection;
                try
                {
                    connection.Open();

                    SqlDataReader reader = command.ExecuteReader();

                    while (reader.Read())
                    {

                        fills.Add(reader[0].ToString());


                        Console.WriteLine("\t{0}",
                            reader[0]);
                    }
                    reader.Close();

                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }


            }
            return fills;

        }
        private static string GetQueryPath(string Root, string type)
        {
            string a = "";
            if (type.Equals("Tables"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlTables.sql");
            }
            else if (type.Equals("Atributtes"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlAtributtes.sql");
            }
            else if (type.Equals("AtributtesLength"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlAtributtesLength.sql");
            }
            else if (type.Equals("Foreign"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlForeign.sql");
            }
            else if (type.Equals("Index"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlIndex.sql");
            }
            return a;
        }
    }
}
