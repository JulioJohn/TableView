//
//  EnumIntoString.swift
//  Tableview training
//
//  Created by Júlio John Tavares Ramos on 21/05/19.
//  Copyright © 2019 Júlio John Tavares Ramos. All rights reserved.
//

import Foundation

func statusOfBuyed(statusDay: StatusEnum) -> String
{
    if(statusDay == .sim)
    {
        return "Sim"
    }
    else if (statusDay == .nao)
    {
        return "Nao"
    }
    else if (statusDay == .nenhum)
    {
        return "Ninguem comprou"
    }
    else {
        return "Status invalido"
    }
}

func nameOfDayPerson(personOfTheDay: PersonDay) -> String
{
    if(personOfTheDay == .Julio)
    {
        return "Julio"
    }
    else if (personOfTheDay == .Pedro){
        return "Pedro"
    }
    else {
        return "Não tomaram coquinha nesse dia!"
    }
    
}
