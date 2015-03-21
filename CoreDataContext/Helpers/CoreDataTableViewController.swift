//
//  CoreDataTableViewController.swift
//  CoreDataContext
//
//  Created by Rafael Veronezi on 9/30/14.
//  Copyright (c) 2014 Syligo. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //
    // MARK: - Properties
    
    public var fetchedResultsController: NSFetchedResultsController? {
        didSet {
            if self.fetchedResultsController !== oldValue {
                if let frc = self.fetchedResultsController {
                    // Set title if it is empty
                    if (self.title == nil || self.title == oldValue?.fetchRequest.entity?.name) &&
                        (self.navigationController == nil || self.navigationItem.title == nil) {
                            self.title = frc.fetchRequest.entity!.name
                    }
                    
                    frc.delegate = self
                    self.performFetch()
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //
    // MARK: - Support Methods
    
    public func performFetch() {
        if let frc = self.fetchedResultsController {
            var error: NSError?
            var success = frc.performFetch(&error)
            if !success {
                NSLog("performFetch: failed")
            }
            if let e = error {
                NSLog("%@ (%@)", e.localizedDescription, e.localizedFailureReason!)
            }
        } else {
            
        }
        self.tableView.reloadData()
    }
    
    //
    // MARK: - UITableViewDataSource
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections = self.fetchedResultsController?.sections?.count ?? 0
        return sections
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        var sections = self.fetchedResultsController?.sections?.count ?? 0
        if sections > 0 {
            var sectionInfo = self.fetchedResultsController!.sections![section] as NSFetchedResultsSectionInfo
            rows = sectionInfo.numberOfObjects
        }
        
        return rows
    }
    
    override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let frc = self.fetchedResultsController {
            if let sectionInfo = frc.sections?[section] as? NSFetchedResultsSectionInfo {
                return sectionInfo.name
            }
        }
        return nil
    }
    
    override public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.fetchedResultsController?.sectionForSectionIndexTitle(title, atIndex: index) ?? 0
    }
    
    override public func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.fetchedResultsController?.sectionIndexTitles
    }
    
    //
    // MARK: - FetchedResultsControllerDelegate
    
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            break
        }
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([ newIndexPath! ], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([ indexPath! ], withRowAnimation: .Fade)
        case .Update:
            self.tableView.reloadRowsAtIndexPaths([ indexPath! ], withRowAnimation: .Fade)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([ indexPath! ], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([ newIndexPath! ], withRowAnimation: .Fade)
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
}
