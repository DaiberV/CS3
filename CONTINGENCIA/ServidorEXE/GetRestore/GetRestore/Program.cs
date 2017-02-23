using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace GetRestore
{
    class Program
    {
        static void Main(string[] args)
        {
            Restore.HQBackupsWsRestoreBackupSoapPortClient client = new Restore.HQBackupsWsRestoreBackupSoapPortClient();
            Restore.SdtRestore my_sdt = new Restore.SdtRestore();

            if (args.Length == 2)
            {
                my_sdt.BckNom = args[0];
                my_sdt.BckMsg = args[1];
                my_sdt.BckEst = false;

            }
            else
            {
                my_sdt.BckNom = args[0];
                my_sdt.BckMsg = "Proceso de Contingencia Realizado Satisfactoriamente";
                my_sdt.BckEst = true;
            
            
            }
            client.Open();
            client.Execute(my_sdt);
            client.Abort();
        }
    }
}
