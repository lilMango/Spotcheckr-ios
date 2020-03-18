import PromiseKit

protocol ExercisePostProtocol {
    func getPost(withId id: String) -> Promise<ExercisePost>
    func getPosts(success: @escaping ([ExercisePost])->Void) -> Promise<[ExercisePost]>
    func getPosts(forUser user: User) -> Promise<[ExercisePost]>
    func getUpvoteCount(forPostWithId postId: String, collection: String) -> Promise<Int>
    func getDownvoteCount(forPostWithId postId: String, collection: String) -> Promise<Int>
    func getViewsCount(forPostWithId postId: String) -> Promise<Int>
    func getExercises(forPostWithId postId: String) -> Promise<[Exercise]>
    func getExercises() -> Promise<[String:Exercise]>
    func getAnswers(byUserWithId userId: String) -> Promise<[Answer]>
    func getAnswers(forPostWithId postId: String) -> Promise<[Answer]>
    func votePost(postId: String, userId: String, direction: VoteDirection) -> Promise<Void>
    func voteAnswer(answerId: String, userId: String, direction: VoteDirection) -> Promise<Void>
    func getVoteDirection(forPostWithId: String) -> Promise<VoteDirection>
    
    func writePost(dict: [String: Any]) -> Promise<Void>
    func createPost(post: ExercisePost) -> Promise<ExercisePost>
    func writeAnswer(answer: Answer) -> Promise<Void>
    
    func updatePost(withId id:String, dict: [String: Any]) -> Promise<Void>
    
    func deletePost(_ post: ExercisePost) -> Promise<Void>
    func deleteAnswers(forPostWithId postId: String) -> Promise<Void>
    func deleteAnswer(withId id: String) -> Promise<Void>
}
