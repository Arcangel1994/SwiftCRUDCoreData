//
//  ViewController.swift
//  CrudCoreData
//
//  Created by Raúl Torres on 11/22/18.
//  Copyright © 2018 ISA. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var edad: UITextField!
    @IBOutlet weak var activo: UISwitch!
    @IBOutlet weak var estatus: UILabel!
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }

    @IBAction func guardar(_ sender: UIButton) {
        
        let contexto = conexion()
        let entidadPersonas = NSEntityDescription.entity(forEntityName: "Personas", in: contexto)
        let newPersona = NSManagedObject(entity: entidadPersonas!, insertInto: contexto)
        
        let edadPersona = Int16(edad.text!)
        newPersona.setValue(nombre.text, forKey: "nombre")
        newPersona.setValue(edadPersona, forKey: "edad")
        newPersona.setValue(activo.isOn, forKey: "activo")
        
        do{
            try contexto.save()
            print("guardo")
            nombre.text = ""
            edad.text = ""
            activo.isOn = false
            
            edad.resignFirstResponder()
            nombre.resignFirstResponder()
            
        }catch let error as NSError {
            print("Error al guardar estos datos", error)
        }
        
    }
    
    
    @IBAction func changeEstatus(_ sender: UISwitch) {
        
        if sender.isOn {
            estatus.text = "Activo"
        }else{
            estatus.text = "Inactivo"
        }
        
    }
    
    
    @IBAction func mostrar(_ sender: UIButton) {
        
        let contexto = conexion()
        let fetchRequest : NSFetchRequest<Personas> = Personas.fetchRequest()
        
        do{
            let resultados = try contexto.fetch(fetchRequest)
            
            print("Numero de registros \(resultados.count)")
            
            for res in resultados as [NSManagedObject] {
                let nombre = res.value(forKey: "nombre")
                let edad = res.value(forKey: "edad")
                let activo = res.value(forKey: "activo")
                
                print("Nombre: \(nombre!), Edad: \(edad!), Activo: \(activo!)")
                
            }
            
        }catch let error as NSError {
            print("Error al traer los datos", error)
        }
        
    }
    
    
    @IBAction func borrar(_ sender: UIButton) {
        
        let contexto = conexion()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Personas")
        let borrar = NSBatchDeleteRequest(fetchRequest: fetchRequest)
     
        do{
            
            try contexto.execute(borrar)
            print("Todo se a borrado")
            
        }catch let error as NSError {
            print("Error al eliminar todos", error)
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

