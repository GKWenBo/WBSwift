import UIKit

func loadSignature() async throws -> String? {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "")!)
    return String(data: data, encoding: .utf8)
}

func loadResultRemotely() async throws {
    /// “模拟网络加载的耗时”
    try await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
}

func someSyncMethod() {
    Task {
        /// “除了 async let 外，另一种创建结构化并发的方式，是使用任务组 (Task group)”
        await withThrowingTaskGroup(of: Void.self, body: { group in
            group.addTask {
                try await loadResultRemotely()
            }
            
            /// 指定优先级
            group.addTask(priority: .low) {
                _ = try await loadSignature()
            }
        })
    }
}
