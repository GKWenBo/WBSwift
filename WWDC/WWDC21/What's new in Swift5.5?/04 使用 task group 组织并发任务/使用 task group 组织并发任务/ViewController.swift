//
//  ViewController.swift
//  使用 task group 组织并发任务
//
//  Created by wenbo on 2021/11/18.
//

/*
 1、非使用task group
 2、async let
 3、withTaskGroup
 4、组织task group结构
 */

import UIKit

enum Food {
    case vegetable
    case meat
}

struct Meal {}

struct Oven {
    // 预先加热
    func preheatOven() async {
        print("Preheat oven.")
    }
    
    func cook(_ foods: [Food], seconds: Int) -> Meal {
        print("Cook \(seconds) seconds.")
        return Meal()
    }
}

struct Dinner {
    // 切菜
    func chopVegetable() async -> Food {
        print("Chopping vegetables")
        return .vegetable
    }
    
    // 腌肉
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
            print(Thread.current)
            // test 非使用task group
//            _ = await makeDinner()
            
            // test async let
//            _ = await makeDinner1()
            
            // test 组织task group结构
            await makeDinnerWithTaskGroup1()
        }
    }

    // MARK: - 1、非使用task group
    /*
     在 makeDinner 的实现里，虽然 chopVegetable，marinateMeat，preHeatOven 都是异步方法，但 makeDinner 的执行过程却是“同步”的，只有切完菜才能腌肉，只有腌完肉才能预热烤箱。这显然是不太合理的，这三个步骤完全可以并行完成。这里只有一个操作是需要等待的，就是 cook。只有切完菜、腌完肉并且烤箱已经预热好了之后，才能够进行烤制。
     */
    func makeDinner() async -> Meal {
        let dinner = Dinner()
        let vegeies = await dinner.chopVegetable()
        let meat = await dinner.marinateMeat()
        
        let oven = Oven()
        await oven.preheatOven()
        let meal = Oven().cook([vegeies, meat], seconds: 300)
        return meal
    }
    
    // MARK: - 2、async let
    /*
     concurrently-executing child task： 使用 async let修饰chopVegetable、marinateMeat会被挂起，该线程继续执行其他任务， 直到遇到 try await 才会执行
     */
    func makeDinner1() async -> Meal {
        let dinner = Dinner()
        let oven = Oven()
        
        async let vegeies = dinner.chopVegetable()
        async let meat = dinner.marinateMeat()
        
        await oven.preheatOven()
        
        let meal = oven.cook(await [vegeies, meat], seconds: 300)
        return meal
    }
    
    // MARK: - 3、withTaskGroup
    /*
     这里，我们用泛型函数 withTaskGroup 创建一个 task group。它的第一个参数 of 表示这个 group 里的任务完成后返回值的类型。第二个参数是一个 closure，它接受一个 TaskGroup 类型的参数，这个参数有两个作用：
     1、一个是用它的 addTask 方法在 task group 中创建要并行执行的任务。现在，切菜和腌肉就可以并行执行了；
     2、另外，由于 TaskGroup 是一个实现了 AsyncSequence 的类型，我们可以通过等待它来获取所有异步任务的执行结果；
     */
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
    
    // MARK: - 4、组织task group结构
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
            
            // sub task
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

