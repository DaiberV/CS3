using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Data.SqlClient;
using System.Text;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            string Root = System.IO.Directory.GetCurrentDirectory();
            string DESTINO = "PTributario";
            string ORIGEN = "PTributario_Base";
            string currentPath = System.IO.Directory.GetCurrentDirectory();



            //CREANDO TABLAS
            IEnumerable<string> Resultados = ComparacionItems(ORIGEN, DESTINO, "Tables",Root);
            List<string> Results = Resultados.ToList();
            string a = CreateStrucs(Results, "TablesCreate", ORIGEN, DESTINO,Root);


            //CREANDO ATRIBUTOS
            Resultados = ComparacionItems(ORIGEN, DESTINO, "Atributtes", Root);
            Results = Resultados.ToList();
            a = CreateStrucs(Results, "AtributtesCreate", ORIGEN, DESTINO, Root);
            
            //CREANDO FORANEAS
            Resultados = ComparacionItems(ORIGEN, DESTINO, "Foreign", Root);
            Results = Resultados.ToList();
            a = CreateStrucs(Results, "ForeignCreate", ORIGEN, DESTINO, Root);

            //CREANDO INDICES
            Resultados = ComparacionItems(ORIGEN, DESTINO, "Index", Root);
            Results = Resultados.ToList();
            a = CreateStrucs(Results, "IndexCreate", ORIGEN, DESTINO, Root);
        }
        //CREA LOS PARAMETROS DE CONEXION CON LA BASE DE DATOS RECIBE BASE,DIRECCION,USUARIO,CONTRASEÑA
        private static string GetConecciont(string DataBase)
        {
            SqlConnectionStringBuilder builderconnection = new SqlConnectionStringBuilder();
            builderconnection.DataSource = ".\\DAIBERP,1433";
            builderconnection.InitialCatalog = DataBase;
            builderconnection.IntegratedSecurity = false;
            builderconnection.UserID = "PruebaCShardP";
            builderconnection.Password = "123456";
            return builderconnection.ConnectionString;
        }
        //CREA LA CONSULTA SEGUN EL TIPO ENVIADO
        private static string QueryType(string Root,string BD,string type,string Objeto)
        {
            string line;
            string query="";
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
            else if (type.Equals("TablesCreate"))
            {
                System.IO.StreamReader file = new System.IO.StreamReader(@Root);
                while ((line = file.ReadLine()) != null)
                {
                    query = query + " " + line;
                }
                file.Close();
                query = query.Replace("<<OBJETO>>", Objeto);
                    //"DECLARE @table_name SYSNAME;SELECT @table_name = 'dbo." + Objeto + "'DECLARE       @object_name SYSNAME    , @object_id INT;SELECT       @object_name = '[' + s.name + '].[' + o.name + ']'    , @object_id = o.[object_id]FROM sys.objects o WITH (NOWAIT)JOIN sys.schemas s WITH (NOWAIT) ON o.[schema_id] = s.[schema_id]WHERE s.name + '.' + o.name = @table_name    AND o.[type] = 'U'    AND o.is_ms_shipped = 0DECLARE @SQL NVARCHAR(MAX) = '';;WITH index_column AS (    SELECT           ic.[object_id]        , ic.index_id        , ic.is_descending_key        , ic.is_included_column        , c.name    FROM sys.index_columns ic WITH (NOWAIT)    JOIN sys.columns c WITH (NOWAIT) ON ic.[object_id] = c.[object_id] AND ic.column_id = c.column_id    WHERE ic.[object_id] = @object_id),fk_columns AS (     SELECT           k.constraint_object_id        , cname = c.name        , rcname = rc.name    FROM sys.foreign_key_columns k WITH (NOWAIT)    JOIN sys.columns rc WITH (NOWAIT) ON rc.[object_id] = k.referenced_object_id AND rc.column_id = k.referenced_column_id     JOIN sys.columns c WITH (NOWAIT) ON c.[object_id] = k.parent_object_id AND c.column_id = k.parent_column_id    WHERE k.parent_object_id = @object_id)SELECT @SQL = 'CREATE TABLE ' + @object_name + CHAR(13) + '(' + CHAR(13) + STUFF((    SELECT CHAR(9) + ', [' + c.name + '] ' +         CASE WHEN c.is_computed = 1            THEN 'AS ' + cc.[definition]             ELSE UPPER(tp.name) +                 CASE WHEN tp.name IN ('varchar', 'char', 'varbinary', 'binary', 'text')                       THEN '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length AS VARCHAR(5)) END + ')'                     WHEN tp.name IN ('nvarchar', 'nchar', 'ntext')                       THEN '(' + CASE WHEN c.max_length = -1 THEN 'MAX' ELSE CAST(c.max_length / 2 AS VARCHAR(5)) END + ')'                     WHEN tp.name IN ('datetime2', 'time2', 'datetimeoffset')                        THEN '(' + CAST(c.scale AS VARCHAR(5)) + ')'                     WHEN tp.name = 'decimal'                        THEN '(' + CAST(c.[precision] AS VARCHAR(5)) + ',' + CAST(c.scale AS VARCHAR(5)) + ')'                    ELSE ''                END +                CASE WHEN c.collation_name IS NOT NULL THEN ' COLLATE ' + c.collation_name ELSE '' END +                CASE WHEN c.is_nullable = 1 THEN ' NULL' ELSE ' NOT NULL' END +                CASE WHEN dc.[definition] IS NOT NULL THEN ' DEFAULT' + dc.[definition] ELSE '' END +                 CASE WHEN ic.is_identity = 1 THEN ' IDENTITY(' + CAST(ISNULL(ic.seed_value, '0') AS CHAR(1)) + ',' + CAST(ISNULL(ic.increment_value, '1') AS CHAR(1)) + ')' ELSE '' END         END + CHAR(13)    FROM sys.columns c WITH (NOWAIT)    JOIN sys.types tp WITH (NOWAIT) ON c.user_type_id = tp.user_type_id    LEFT JOIN sys.computed_columns cc WITH (NOWAIT) ON c.[object_id] = cc.[object_id] AND c.column_id = cc.column_id    LEFT JOIN sys.default_constraints dc WITH (NOWAIT) ON c.default_object_id != 0 AND c.[object_id] = dc.parent_object_id AND c.column_id = dc.parent_column_id    LEFT JOIN sys.identity_columns ic WITH (NOWAIT) ON c.is_identity = 1 AND c.[object_id] = ic.[object_id] AND c.column_id = ic.column_id    WHERE c.[object_id] = @object_id    ORDER BY c.column_id    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, CHAR(9) + ' ')    + ISNULL((SELECT CHAR(9) + ', CONSTRAINT [' + k.name + '] PRIMARY KEY (' +                     (SELECT STUFF((                         SELECT ', [' + c.name + '] ' + CASE WHEN ic.is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END                         FROM sys.index_columns ic WITH (NOWAIT)                         JOIN sys.columns c WITH (NOWAIT) ON c.[object_id] = ic.[object_id] AND c.column_id = ic.column_id                         WHERE ic.is_included_column = 0                             AND ic.[object_id] = k.parent_object_id                              AND ic.index_id = k.unique_index_id                              FOR XML PATH(N''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, ''))            + ')' + CHAR(13)            FROM sys.key_constraints k WITH (NOWAIT)            WHERE k.parent_object_id = @object_id                 AND k.[type] = 'PK'), '') + ')'  + CHAR(13)    + ISNULL((SELECT (        SELECT CHAR(13) +             'ALTER TABLE ' + @object_name + ' WITH'             + CASE WHEN fk.is_not_trusted = 1                 THEN ' NOCHECK'                 ELSE ' CHECK'               END +               ' ADD CONSTRAINT [' + fk.name  + '] FOREIGN KEY('               + STUFF((                SELECT ', [' + k.cname + ']'                FROM fk_columns k                WHERE k.constraint_object_id = fk.[object_id]                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')               + ')' +              ' REFERENCES [' + SCHEMA_NAME(ro.[schema_id]) + '].[' + ro.name + '] ('              + STUFF((                SELECT ', [' + k.rcname + ']'                FROM fk_columns k                WHERE k.constraint_object_id = fk.[object_id]                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '')               + ')'            + CASE                 WHEN fk.delete_referential_action = 1 THEN ' ON DELETE CASCADE'                 WHEN fk.delete_referential_action = 2 THEN ' ON DELETE SET NULL'                WHEN fk.delete_referential_action = 3 THEN ' ON DELETE SET DEFAULT'                 ELSE ''               END            + CASE                 WHEN fk.update_referential_action = 1 THEN ' ON UPDATE CASCADE'                WHEN fk.update_referential_action = 2 THEN ' ON UPDATE SET NULL'                WHEN fk.update_referential_action = 3 THEN ' ON UPDATE SET DEFAULT'                  ELSE ''               END             + CHAR(13) + 'ALTER TABLE ' + @object_name + ' CHECK CONSTRAINT [' + fk.name  + ']' + CHAR(13)        FROM sys.foreign_keys fk WITH (NOWAIT)        JOIN sys.objects ro WITH (NOWAIT) ON ro.[object_id] = fk.referenced_object_id        WHERE fk.parent_object_id = @object_id        FOR XML PATH(N''), TYPE).value('.', 'NVARCHAR(MAX)')), '')    + ISNULL(((SELECT         CHAR(13) + 'CREATE' + CASE WHEN i.is_unique = 1 THEN ' UNIQUE' ELSE '' END                 + ' NONCLUSTERED INDEX [' + i.name + '] ON ' + @object_name + ' (' +                STUFF((                SELECT ', [' + c.name + ']' + CASE WHEN c.is_descending_key = 1 THEN ' DESC' ELSE ' ASC' END                FROM index_column c                WHERE c.is_included_column = 0                    AND c.index_id = i.index_id                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ')'                  + ISNULL(CHAR(13) + 'INCLUDE (' +                     STUFF((                    SELECT ', [' + c.name + ']'                    FROM index_column c                    WHERE c.is_included_column = 1                        AND c.index_id = i.index_id                    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ')', '')  + CHAR(13)        FROM sys.indexes i WITH (NOWAIT)        WHERE i.[object_id] = @object_id            AND i.is_primary_key = 0            AND i.[type] = 2        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')    ), '')SELECT @SQL";
            }
            else if (type.Equals("AtributtesCreate"))
            {
                System.IO.StreamReader file = new System.IO.StreamReader(@Root);
                while ((line = file.ReadLine()) != null)
                {
                    query = query + " " + line;
                }
                    //"SELECT 'ALTER TABLE '+ini.name+' ADD '+icol.name+' '+type_name(icol.system_type_id)+(CASE WHEN type_name(icol.system_type_id) = 'decimal' and icol.max_length = 9 THEN '(15,2)' WHEN type_name(icol.system_type_id) in ('datetime','bit','int','smallint','money','smallmoney') THEN '' WHEN type_name(icol.system_type_id) in ('varchar','varbinary') THEN '(max)' ELSE '('+CONVERT(VARCHAR(4),icol.max_length)+')' END)+' null;' FROM "+BD+".sys.Tables as ini INNER JOIN "+BD+".sys.Columns as icol On ini.object_id=icol.object_id Where icol.name = "+Objeto+";";
                file.Close();
                query = query.Replace("<<OBJETO>>", Objeto);
                query = query.Replace("<<ORIGEN>>", BD);
            }
            else if (type.Equals("ForeignCreate"))
            {
                System.IO.StreamReader file = new System.IO.StreamReader(@Root);
                while ((line = file.ReadLine()) != null)
                {
                    query = query + " " + line;
                }
                file.Close();
                query = query.Replace("<<OBJETO>>", Objeto);
                query = query.Replace("<<ORIGEN>>", BD);
            }
            else if (type.Equals("IndexCreate"))
            {
                System.IO.StreamReader file = new System.IO.StreamReader(@Root);
                while ((line = file.ReadLine()) != null)
                {
                    query = query + " " + line;
                }
                file.Close();
                query = query.Replace("<<OBJETO>>", Objeto);
                query = query.Replace("<<ORIGEN>>", BD);
            }
            Console.Write(query);
            return query;
        }
        //CREA LA CONEXION Y ENVIA EL QUERY 
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
        //HACE LA COMPARACION DE LAS LISTAS DE OBJETOS FALTANTES
        private static IEnumerable<string> Comparation(List<string> fills,List<string> fills2)
            {
                IEnumerable<string> a = fills2.Except(fills);
                return a;
            }
        //EJECUTA LOS QUERY CREADOS EN LA BASE DE DATOS DESTINO
        private static void ExecuteStruc(List<string> resultados) { }
        //CREA LAS ESTRUCCTURAS A PARTIR DE UNA LISTA DE OBJETOS
        private static string CreateStrucs(List<string> strucs,string type,string ORIGEN,string DESTINO,string Root)
        {
            List<string> resultados = new List<string>();
            string RootAux = Root;
            switch (type)
            {
                case "TablesCreate":
                    foreach (string a in strucs)
                    {
                        string ConnectionString = GetConecciont(ORIGEN);
                        string QueryString = QueryType(RootAux = GetQueryPath(Root, "TablesCreate"), ORIGEN, "TablesCreate", a);
                        resultados = GetQueryConnection(QueryString, ConnectionString);

                        Console.ReadLine();
                    }
                    break;
                case "AtributtesCreate":
                    foreach (string a in strucs)
                    {
                        string ConnectionString = GetConecciont(ORIGEN);
                        string QueryString = QueryType(RootAux = GetQueryPath(Root, "AtributtesCreate"), ORIGEN, "AtributtesCreate", a);
                        resultados = GetQueryConnection(QueryString, ConnectionString);
                    }
                    break;
                case "ForeignCreate":
                    foreach (string a in strucs)
                    {
                        string ConnectionString = GetConecciont(ORIGEN);
                        string QueryString = QueryType(RootAux = GetQueryPath(Root, "ForeignCreate"), ORIGEN, "ForeignCreate", a);
                        resultados = GetQueryConnection(QueryString,ConnectionString);
                    }
                    break;
                case "IndexCreate":
                    foreach (string a in strucs)
                    {
                        string ConnectionString = GetConecciont(ORIGEN);
                        string QueryString = QueryType(RootAux = GetQueryPath(Root, "IndexCreate"), ORIGEN, "IndexCreate", a);
                        resultados = GetQueryConnection(QueryString, ConnectionString);
                    }
                    break;
            }
            return "YES";
        }
        //COMPARACION DE DATOS
        private static IEnumerable<string> ComparacionItems(string origen, string destino, string type, string Root)
        {
            IEnumerable<string> Results;
            string connectionstring = GetConecciont(origen);
            string connectionstring2 = GetConecciont(destino);
            List<string> fills = new List<string>();
            List<string> fills2 = new List<string>();
            string queryString = "";
            string queryString2 = "";
            string RootAux = Root;
            if (type.Equals ("Tables"))
            {
                queryString = QueryType(RootAux = GetQueryPath(Root, type), destino, type, "");
                RootAux = Root;
                queryString2 = QueryType(RootAux = GetQueryPath(Root, type), origen, type, "");
                fills = GetQueryConnection(queryString, connectionstring);
                fills2 = GetQueryConnection(queryString2, connectionstring2);
            }
            else if (type.Equals("Atributtes"))
            {
                queryString = QueryType(RootAux = GetQueryPath(Root, type), destino, type, "");
                RootAux = Root;
                queryString2 = QueryType(RootAux = GetQueryPath(Root, type), origen, type, "");
                fills = GetQueryConnection(queryString, connectionstring);
                fills2 = GetQueryConnection(queryString2, connectionstring2);
            }
            else if (type.Equals("Foreign"))
            {
                queryString = QueryType(RootAux = GetQueryPath(Root, type), destino, type, "");
                RootAux = Root;
                queryString2 = QueryType(RootAux = GetQueryPath(Root, type), origen, type, "");
                fills = GetQueryConnection(queryString, connectionstring);
                fills2 = GetQueryConnection(queryString2, connectionstring2);
            }
            else if (type.Equals("Index"))
            {
                queryString = QueryType(RootAux = GetQueryPath(Root, type), destino, type, "");
                RootAux = Root;
                queryString2 = QueryType(RootAux = GetQueryPath(Root, type), destino, type, "");
                fills = GetQueryConnection(queryString, connectionstring);
                fills2 = GetQueryConnection(queryString2, connectionstring2);
            }
            Results = Comparation(fills, fills2);
            return Results;
        }
        //Extraccion de Archivos
        private static string GetQueryPath(string Root,string type)
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
            else if (type.Equals("Foreign"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlForeign.sql");
            }
            else if (type.Equals("Index"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlIndex.sql");
            }
            else if (type.Equals("TablesCreate"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlTablesCreate.sql");
            }
            else if (type.Equals("AtributtesCreate"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlAtributtesCreate.sql");
            }
            else if (type.Equals("ForeignCreate"))
            {
                a = Root.Replace(Root = "\\Debug", "\\Debug\\SqlForeignCreate.sql");
            }
            return a;
        }
    }
}
