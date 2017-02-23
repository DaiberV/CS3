using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Text.RegularExpressions;
using GetCmdOutput.ServiceReference1;
using System.Data;

namespace GetCmdOutput
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("PAUSA1");

            ServiceReference1.SdtBackup webservice = new ServiceReference1.SdtBackup();
            ServiceReference1.HQBackupsWsNotificacionBackupSoapPortClient client = new HQBackupsWsNotificacionBackupSoapPortClient();
            Console.Write("PAUSA2");
            ProcessStartInfo pinfo = new ProcessStartInfo("git", "remote show origin");
            Console.Write("PAUSA3");
            ProcessStartInfo commit = new ProcessStartInfo("git", "log -n 1");
            Console.Write("PAUSA4");
            ProcessStartInfo branch = new ProcessStartInfo("git", "branch");
            Console.Write("PAUSA5");
            pinfo.UseShellExecute = false;
            pinfo.RedirectStandardOutput = true;
            commit.UseShellExecute = false;
            commit.RedirectStandardOutput = true;
            branch.UseShellExecute = false;
            branch.RedirectStandardOutput = true;
            Console.Write("PAUSA6");

            Process p = Process.Start(pinfo);
            p.Start();
            p.WaitForExit();
            string my_info = p.StandardOutput.ReadToEnd();

            Process com = Process.Start(commit);
            com.Start();
            com.WaitForExit();
            string my_commit = com.StandardOutput.ReadToEnd();

            Console.Write("PAUSA8");
            Process br = Process.Start(branch);
            br.Start();
            br.WaitForExit();
            string my_branch = br.StandardOutput.ReadToEnd();
            Console.Write("PAUSA9");
            string pattrn = "Fetch URL: (.+)";
            string reslt = "";
            Console.Write("PAUSA9");
            string pattrn2 = @"commi\w(.+)";
            string reslt2 = "";

            if (Regex.IsMatch(my_info, pattrn))
            {
                var match = Regex.Match(my_info, pattrn);

                reslt = match.Result("$1");
            }
            Console.Write("PAUSA10");
            if (Regex.IsMatch(my_commit, pattrn2))
            {
                var match = Regex.Match(my_commit, pattrn2);

                reslt2 = match.Result("$1");
            }
            Console.Write("PAUSA11");
            if (args.Length == 0)
                Console.WriteLine("No se pasaron parametros");
            else
            {
                Console.WriteLine(args.Length);
                if (args[0].Equals("ERROR_NO_SE_GENERO_EL_BACK_UP"))
                {
                    webservice.BckNom = "Back up fallido";
                    webservice.BckMsg = args[0];
                    webservice.BckEst = false;
                    webservice.ProdCod = args[1];
                    webservice.ClieCod = args[2];
                    webservice.BckTam = 0;
                    webservice.BckLastReorg = args[4];
                    webservice.BckGitBranch = my_branch;
                    webservice.BckGitCommit = reslt2;
                    webservice.BckGitRemote = reslt;
                }
                else
                {
                    webservice.BckNom = args[0];
                    webservice.BckEst = true;
                    webservice.ProdCod = args[1];
                    webservice.ClieCod = args[2];
                    webservice.BckTam = Convert.ToInt32(args[3]);
                    webservice.BckLastReorg = args[4];
                    webservice.BckMsg = "El backup se realizo satisfactoriamente";
                    webservice.BckGitBranch = my_branch;
                    webservice.BckGitCommit = reslt2;
                    webservice.BckGitRemote = reslt;
                }
            }
            client.Execute(webservice);

        }
    }
}