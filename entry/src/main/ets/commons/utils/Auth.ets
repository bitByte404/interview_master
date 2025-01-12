import { User } from "../../models"

export const UserInterviewKey = 'interview-user'

class Auth {
  initUser() {
    PersistentStorage.persistProp<User>(UserInterviewKey, {} as User)
  }

  getUser(): User {
    return AppStorage.get(UserInterviewKey) || {} as User
  }

  setUser(user: User) {
    AppStorage.setOrCreate(UserInterviewKey, user)
  }
}

export const auth = new Auth()