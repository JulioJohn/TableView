//
//  ViewController.swift
//  Tableview training
//
//  Created by Júlio John Tavares Ramos on 20/05/19.
//  Copyright © 2019 Júlio John Tavares Ramos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    //*******************************************
    //*****************VARIABLES*****************
    //*******************************************
    
    @IBOutlet weak var txt_pickUpData: UITextField!
    
    //*****> PERSON VARIABLES <*****
    var days: [String] = []
    var personDay: [PersonDay] = []
    var newPersonDay: [PersonDay]? = nil //guarda as mudancas
    var lastTime: PersonDay = .Pedro
    
    //*****> TABLE VIEW VARIABLES <*****
    let cellIdentifier = "CellIdentifier"
    var myTableView: UITableView!
    var mySelectedView: myTableCell!
    var mySelectedViewIndex: Int!
    var standardStatus: StatusEnum = .sim
    var actualStatus: StatusEnum = .sim
    
    //*****> PICKER VIEW VARIABLES <*****
    var myPickerView: UIPickerView!
    var pickerData: [StatusEnum] = [.sim, .nao, .nenhum]
    //como a pickerView so pega quando gira, caso o usuario de "done" sem girar, o primeiro do vetor pickerData[1] devera ser usado, no caso eh o .sim
    var textField: UITextField!
    
    //*****> SEARCH BAR VARIABLES <*****
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    var filtered:[String] = []
    
    //*******************************************
    //***************VIEW DIDLOAD****************
    //*******************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        days = ["Segunda", "Terca", "Quarta", "Quinta", "Sexta"]
        for _ in 0...days.count - 1
        {
            if(lastTime) == .Pedro
            {
                personDay.append(.Julio)
                lastTime = .Julio
            }
            else
            {
                personDay.append(.Pedro)
                lastTime = .Pedro
            }
        }
        textField = UITextField()
    }
    
    //*******************************************
    //****************TABLE VIEW*****************
    //*******************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = days.count
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let day = days[indexPath.row]
        
        cell.textLabel?.text = day
        cell.detailTextLabel?.text = nameOfDayPerson(personOfTheDay: personDay[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView = tableView
        mySelectedView = tableView.cellForRow(at: indexPath) as? myTableCell
        mySelectedViewIndex = indexPath.row
        
        self.pickUp(txt_pickUpData)
        txt_pickUpData.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.bounds.height) / CGFloat(tableView.numberOfRows(inSection: 0))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let right = rightAction(at: indexPath)
        let wrong = wrongAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [right, wrong])
    }
    
    func rightAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Right") { (action, view, completion) in
            self.actualStatus = .sim
            self.makeTheFunction()
            completion(true)
        }
        action.title = "Sim"
        action.backgroundColor = .green
        return action
    }
    
    func wrongAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Wrong") { (action, view, completion) in
            self.actualStatus = .nao
            self.makeTheFunction()
            completion(true)
        }
        action.title = "Não"
        action.backgroundColor = .red
        return action
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        //animacao de aparecer as celulas devagar
        UIView.animate(
            withDuration: 1.0,
            delay: 0.15 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    //*******************************************
    //****************PICKER VIEW****************
    //*******************************************
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusOfBuyed(statusDay: pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        actualStatus = pickerData[row]
    }
    
    
    //cria e instancia a pickerView, junto dela uma toolbar
    //para puxar essa toolbar no modo teclado tem uma textField generica fora da tela, famosa gambeta
    func pickUp(_ textField : UITextField) {
        // Criando PickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        // Criando Toolbar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Botao na toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    //*******************************************
    //****************SEARCH BAR*****************
    //*******************************************
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        personDay.filter { (person) -> Bool in
//            person.
//        }
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.myTableView.reloadData()
//    }
    
    //*******************************************
    //**********FUNCTION PERSONALIZED************
    //*******************************************
    
    //botao de done toolbar da PickerView
    @objc func doneClick() {
        makeTheFunction()
        txt_pickUpData.resignFirstResponder()
        actualStatus = standardStatus
    }
    //botao de cancel toolbar da PickerView
    @objc func cancelClick() {
        txt_pickUpData.resignFirstResponder()
    }
    
    //Verifica o status atual e atualiza o status
    func makeTheFunction()
    {
        if(actualStatus == .sim)
        {
            mySelectedView!.backgroundColor = UIColor.FlatColor.Green.ChateauGreen
            mySelectedView.title?.textColor = .white
            mySelectedView.label?.textColor = .white
            //manter a ordem dos dias
        }
        else if(actualStatus == .nao)
        {
            mySelectedView!.backgroundColor = UIColor.FlatColor.Red.WellRead
            mySelectedView.title?.textColor = .white
            mySelectedView.label?.textColor = .white
            //alterar a ordem dos dias
            
            if(4 != mySelectedViewIndex)
            {
                newPersonDay = []
                var lastPersonInadinplent: PersonDay? = nil
                
                for quantityOfRow in 0 ... mySelectedViewIndex {
                    newPersonDay?.append(personDay[quantityOfRow])
                    if personDay[quantityOfRow] != PersonDay.none {
                        lastPersonInadinplent = personDay[quantityOfRow]
                    }
                    else {
                        lastPersonInadinplent = .error
                    }
                }
                
                for quantityOfRow in mySelectedViewIndex+1 ... 4 {
                    //o primeiro elemento apos aquele dia da semana sera o inadinplente
                    if(quantityOfRow == mySelectedViewIndex + 1) {
                        newPersonDay?.append(lastPersonInadinplent!)
                    }
                    else {
                        newPersonDay?.append(personDay[quantityOfRow])
                    }
                }
                
                personDay = newPersonDay!
                newPersonDay = nil
                
                //atualizar labels agora
                var cells: myTableCell
                for row in 0 ... 4 {
                    cells = myTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! myTableCell
                    cells.label.text = nameOfDayPerson(personOfTheDay: personDay[row])
                }
            }
        }
        else if(actualStatus == .nenhum)
        {
            mySelectedView!.backgroundColor = UIColor.FlatColor.Orange.NeonCarrot
            mySelectedView.title?.textColor = .white
            mySelectedView.label?.textColor = .white
            //pular um dia, no caso o atual
            
            if(4 != mySelectedViewIndex)
            {
                newPersonDay = []
                let emptyDayCoke: PersonDay = .none
                
                for quantityOfRow in 0 ... mySelectedViewIndex {
                    newPersonDay?.append(personDay[quantityOfRow])
                }
                
                for quantityOfRow in mySelectedViewIndex ... 4
                {
                    //o primeiro elemento apos aquele dia da semana sera o inadinplente
                    if(quantityOfRow == mySelectedViewIndex) {
                        newPersonDay?.removeLast()
                        newPersonDay?.append(emptyDayCoke)
                    }
                    else {
                        newPersonDay?.append(personDay[quantityOfRow])
                    }
                }
                
                personDay = newPersonDay!
                newPersonDay = nil
                
                //atualizar labels agora
                var cells: myTableCell
                for row in 0 ... 4 {
                    cells = myTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! myTableCell
                    cells.label.text = nameOfDayPerson(personOfTheDay: personDay[row])
                }
            }
        }
        mySelectedView.isSelected = false
    }

}

