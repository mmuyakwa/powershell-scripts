Configuration LNServiceStates
{
    # It is best practice to explicitly import any resources used in your Configurations.
    Import-DSCResource -Name Service -Module PSDesiredStateConfiguration

    foreach ($computer in @('localhost'))
    {
        if (Test-Connection -ComputerName $computer)
        {
            Node $computer
            {
                WindowsFeature "Printing-Server-Role"
                {
                    Ensure               = 'Present'
                    Name                 = 'Spooler'
                }
                Service "Spooler"
                {
                    Name = "Spooler"
                    State = "Running"
                }
                WindowsFeature "Printing-LPDPrintService"
                {
                    Ensure               = 'Present'
                    Name                 = 'LPDSVC'
                }
                WindowsFeature "Printing-LPRPortMonitor"
                {
                    Ensure               = 'Present'
                    Name                 = 'LPDSVC'
                }
                Service "LPDSVC"
                {
                    Name = "LPDSVC"
                    State = "Running"
                }
            }
        }
    }
}

LNServiceStates
