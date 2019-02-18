//
//  EditarViewController.swift
//  CrudCoreData
//
//  Created by Raúl Torres on 11/23/18.
//  Copyright © 2018 ISA. All rights reserved.
//

import UIKit
import CoreData

class EditarViewController: UIViewController {

    var personaEditar : Personas!
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var edad: UITextField!
    @IBOutlet weak var activo: UISwitch!
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombre.text = personaEditar.nombre
        edad.text = "\(personaEditar.edad)"

        if personaEditar.activo {
            activo.isOn = true
        }else{
            activo.isOn = false
        }
        
    }
    
    
    @IBAction func editar(_ sender: UIButton) {

        let contexto = conexion()
        
        let edadPersona = Int16(edad.text!)
        personaEditar.setValue(nombre.text, forKey: "nombre")
        personaEditar.setValue(edadPersona, forKey: "edad")
        personaEditar.setValue(activo.isOn, forKey: "activo")
        
        do{
            
            edad.resignFirstResponder()
            nombre.resignFirstResponder()
            
            try contexto.save()
            
        self.navigationController?.popViewController(animated: true)
            
        }catch let error as NSError {
            print("No se puede editar", error)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
