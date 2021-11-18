//
//  ViewController.swift
//  使用 task group 组织并发任务
//
//  Created by wenbo on 2021/11/18.
//

import UIKit

enum Food {
    case vegetable
    case meat
}

struct Meal {}

struct Oven {
    func preheatOven() async {
        print("Preheat oven.")
    }
    
    func cook(_ foods: [Food], seconds: Int) -> Meal {
        print("Cook \(seconds) seconds.")
        return Meal()
    }
}

struct Dinner {
    func chopVegetable() async -> Food {
        print("Chopping vegetables")
        return .vegetable
    }
    
    func marinateMeat() async -> Food {
        print("Marinate meat")
        return .meat
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
//            await makeDinner()
            await makeDinnerWithTaskGroup1()
        }
    }

    func makeDinner() async -> Meal {
        let dinner = Dinner()
        let vegeies = await dinner.chopVegetable()
        let meat = await dinner.marinateMeat()
        
        let oven = Oven()
        await oven.preheatOven()
        let meal = Oven().cook([vegeies, meat], seconds: 300)
        return meal
    }
    
    func makeDinnerWithTaskGroup() async -> Meal {
        var foods: [Food] = []
        let oven = Oven()
        
        await withTaskGroup(of: Food.self) { group in
            let dinner = Dinner()
            
            group.addTask {
                await dinner.chopVegetable()
            }
            
            group.addTask {
                await dinner.marinateMeat()
            }
            
            for await food in group {
                foods.append(food)
            }
        }
        
        await oven.preheatOven()
        
        return oven.cook(foods, seconds: 300)
    }
    
    /*
     不过，看到这里你可能会觉得，其实 preheatOven 也完全可以和准备食材并行进行呀。实际情况当然是这样的，但由于 preheatOven 的返回值和准备食材的方法不同，我们不能把它和切菜以及腌肉的方法放到一个 task group 里。为了实现这个效果，我们可以创建一个更大的 task group，然后把准备食材的过程，作为一个 sub task group：
     */
    func makeDinnerWithTaskGroup1() async -> Meal {
        var foods: [Food] = []
        let oven = Oven()
        
        await withTaskGroup(of: Void.self, body: {
            $0.addTask {
                await oven.preheatOven()
            }
            
            await withTaskGroup(of: Food.self) { group in
                let dinner = Dinner()
                
                group.addTask {
                    await dinner.chopVegetable()
                }
                
                group.addTask {
                    await dinner.marinateMeat()
                }
                
                for await food in group {
                    foods.append(food)
                }
            }
        })
        return oven.cook(foods, seconds: 300)
    }

}

