# Source: https://techwizard.cloud/2018/12/22/powershell-tip-reveal-wifi-networks-password-on-your-computer/
# Print Wifi-Passwords stored in MS Windows.

(netsh wlan show profiles) | Select-String “\:(.+)$” | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} |

%{(netsh wlan show profile name=”$name” key=clear)} | Select-String “Key Content\W+\:(.+)$” |

%{$pass=$_.Matches.Groups[1].Value.Trim(); $_} |

%{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} |

Format-Table -AutoSize