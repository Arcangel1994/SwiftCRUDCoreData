//
//  TablaViewController.swift
//  CrudCoreData
//
//  Created by Raúl Torres on 11/23/18.
//  Copyright © 2018 ISA. All rights reserved.
//

import UIKit
import CoreData

class TablaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    var personas: [Personas] = []
    
    func conexion() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla.reloadData()
        tabla.delegate = self
        tabla.dataSource = self
        mostrarDatos()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let persona = personas[indexPath.row]
        
        if persona.activo {
            cell.textLabel?.text = "💚 \(persona.nombre!)"
            cell.detailTextLabel?.text = "\(persona.edad)"
        }else{
            cell.textLabel?.text = "❤️ \(persona.nombre!)"
            cell.detailTextLabel?.text = "\(persona.edad)"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "enviarEditar", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "enviarEditar"{
            
            if let id = tabla.indexPathForSelectedRow{
                
                let fila = personas[id.row]
                
                let destino = segue.destination as! EditarViewController
                
                destino.personaEditar = fila
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let contexto = conexion()
        let persona = personas[indexPath.row]
        
        if editingStyle == .delete{
            
            contexto.delete(persona)
            
            do{
                
                try contexto.save()
                
            }catch let error as NSError{
                print("No se puede borrar", error)
            }
            
        }
        
        mostrarDatos()
        tabla.reloadData()
        
    }
    
    func mostrarDatos(){
        
        let contexto = conexion()
        
        let fetchRequest : NSFetchRequest<Personas> = Personas.fetchRequest()
        
        do{
            personas = try contexto.fetch(fetchRequest)
        }catch let error as NSError{
            print("Error al traer los datos", error)
        }
        
    }
    
}
