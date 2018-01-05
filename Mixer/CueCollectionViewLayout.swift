//
//  CueCollectionViewLayout.swift
//  Mixer
//
//  Created by Jacob R. Abraham on 1/5/18.
//  Copyright © 2018 Jacob R. Abraham. All rights reserved.
//

import UIKit

//build off of flow layout to keep sizes the same when reordering cells
class CueCollectionViewLayout: UICollectionViewFlowLayout {
    //keep cell sizes the same
    override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {
        //get the super class context so as not to mess stuff up, that is what will be edited here
        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)
        //get the current collection views deleagte
        let delegate = collectionView?.delegate as! CueCollectionViewDelegate
        //move the previous cell to the target
        delegate.collectionView(collectionView!, moveItemAt: previousIndexPaths.first!, to: targetIndexPaths.first!)
        
        //return the context
        return context
    }
}
