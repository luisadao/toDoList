//
//  ToDoDetailViewControllerDelegate.swift
//  ToDoList
//
//  Created by User on 13/12/2024.
//

import Foundation

protocol ToDoDetailViewControllerDelegate: AnyObject {
    func didSaveToDoItem(_ toDo: ToDo)
}
