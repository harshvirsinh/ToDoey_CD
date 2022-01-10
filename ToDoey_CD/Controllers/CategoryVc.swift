//
//  CategoryVc.swift
//  ToDoey_CD
//
//  Created by Harshvirsinh Parmar on 10/01/22.
//

import UIKit
import CoreData
import Lottie

class CategoryVc: UITableViewController {
    var categoryArray = [Category]()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var animationView: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Path Where Data Model Container....", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadItems()
    }

   
    @IBAction func addCategoryBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
       let action = UIAlertAction(title: "Add", style: .default) { (action) in
       
           let newitem = Category(context: self.contex)
            newitem.name = textField.text!
           
            self.categoryArray.append(newitem)
            self.tableView.reloadData()
          self.lottieAnimation(name: "Thumbanimate", animationSpeed: 0.8, asynceafter: 1.0)

            self.saveItems()
            //MARK: -ThumbANimation When Item Added
//            self.animationView!.play()
//           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                self.animationView.removeFromSuperview()
//            }
//            self.view.addSubview(self.animationView)
        }
        let cancleAction = UIAlertAction(title: "Cancle", style: .destructive) {(cancle) in
            self.dismiss(animated: true, completion: nil)
        }
        let alert = UIAlertController(title: "Add Items ", message: "Add Items To Your ToDO List", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New...."
            //Disable AddButton If TextField Is empty....
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:{_ in
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                action.isEnabled = textIsNotEmpty
                
            })
        }
        
        action.isEnabled = false
        alert.addAction(cancleAction)
        alert.addAction(action)
    
        present(alert, animated: true, completion: nil)
        
    }
   
    //MARK: -Lottie Animation
     func lottieAnimation(name: String,animationSpeed: Double,asynceafter: Double){
    
         animationView.animation = Animation.named(name)
        animationView!.contentMode = .scaleToFill
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = animationSpeed
        animationView.center.x = self.view.center.x
        animationView.center.y = self.view.center.y
    
        animationView!.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + asynceafter) {
            self.animationView.removeFromSuperview()
        }
        view.addSubview(animationView!)
    }
    func saveItems(){
       
        do{
            try contex.save()
        }catch{
            print("Error Saving Contex\(error)")
        }
        self.tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
      //  let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
           categoryArray =  try contex.fetch(request)
        }
        catch{
            print("Error Fetching Items From DataModel",error)
        }
        tableView.reloadData()
    }
        // MARK: - Table view data source

       

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return categoryArray.count
        }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let item = categoryArray[indexPath.row]
        content.text = item.name
        cell.contentConfiguration = content
      //  cell.accessoryType = item.done ? .checkmark: .none
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        return cell
        
    }
    
    }

