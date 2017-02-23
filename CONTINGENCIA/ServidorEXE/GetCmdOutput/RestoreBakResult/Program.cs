using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Text.RegularExpressions;
using RestoreBakResult.Restore;
using System.Data;

namespace RestoreBakResult
{
    class Program
    {
        static void Main(string[] args)
        {
            Restore.HQBackupsWsRestoreBackupSoapPortClient cliente = new HQBackupsWsRestoreBackupSoapPortClient();
            Restore.SdtRestore my = new SdtRestore();


            if (args.Length == 2)
            {
                my.BckEst = true;
                my.BckMsg = "Fallo la Restauracion"+args[1];
                my.BckNom = args[0];
                cliente.Execute(my);

            }
            else
            {
                my.BckEst = false;
                my.BckMsg = "Proceso de Contingencia Realizado satisfactoriamente";
                my.BckNom = args[0];
                cliente.Execute(my);
            }



        }
    }
}
