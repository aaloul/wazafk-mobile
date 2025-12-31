class Endpoints {
  static const base_url = base_url_prod;
  static const base_url_staging = 'https://wazafk.lcp.website/api/';

  static const base_url_prod = 'https://wazafk.lcp.website/api/';
  static const authenticateChannel = 'communication/authenticateChannel';

  //APP
  static const banners = 'app/banners';
  static const interestOptions = 'app/interestOptions';
  static const categories = 'app/categories';
  static const interestCategories = 'app/interestCategories';
  static const skills = 'app/skills';
  static const faqs = 'app/faqs';
  static const termsAndConditions = 'app/termsAndConditions';
  static const privacyPolicy = 'app/privacyPolicy';
  static const aboutUs = 'app/aboutUs';
  static const freelancerHome = 'home/freelancerHome';
  static const employerHome = 'home/employerHome';

  //ACCOUNT
  static const login = 'account/login';
  static const register = 'account/register';
  static const faceMatch = 'account/faceMatch';
  static const forgotPasswordConfirm = 'account/resetPassword';
  static const sendOTP = 'account/sendOTP';
  static const sendGuestOTP = 'account/sendGuestOTP';
  static const verifyGuestOTP = 'account/verifyGuestOTP';
  static const verifyOTP = 'account/verifyOTP';
  static const logout = 'account/logout';
  static const changePassword = 'account/changePassword';
  static const changeLanguage = 'account/changeLanguage';
  static const changeNotificationPreferences =
      'account/changeNotificationPreferences';
  static const activityLog = 'account/activityLog';
  static const deleteAccount = 'account/deleteAccount';

  //MEMBER
  static const checkMemberExists = 'member/checkMemberExists';
  static const members = 'member/members';
  static const profile = 'member/profile';
  static const memberProfile = 'member/memberProfile';
  static const editProfile = 'member/editProfile';
  static const editProfileImage = 'member/editProfileImage';
  static const saveInterests = 'member/saveInterests';
  static const interests = 'member/interests';
  static const addSkill = 'member/addSkill';
  static const removeSkill = 'member/removeSkill';
  static const memberSkills = 'member/skills';
  static const saveDocument = 'member/saveDocument';
  static const documents = 'member/documents';
  static const addAddress = 'member/addAddress';
  static const saveAddress = 'member/saveAddress';
  static const deleteAddress = 'member/deleteAddress';
  static const addresses = 'member/addresses';
  static const addScheduleTask = 'member/addScheduleTask';
  static const saveScheduleTask = 'member/saveScheduleTask';
  static const deleteScheduleTask = 'member/deleteScheduleTask';
  static const scheduleTasks = 'member/scheduleTasks';

  //SERVICE
  static const addService = 'service/addService';
  static const saveService = 'service/saveService';
  static const serviceStatus = 'service/serviceStatus';
  static const services = 'service/services';
  static const service = 'service/service';

  //PACKAGE
  static const addPackage = 'package/addPackage';
  static const savePackage = 'package/savePackage';
  static const packageStatus = 'package/packageStatus';
  static const packages = 'package/packages';
  static const package = 'package/package';

  //JOB
  static const addJob = 'job/addJob';
  static const saveJob = 'job/saveJob';
  static const jobStatus = 'job/jobStatus';
  static const jobs = 'job/jobs';
  static const job = 'job/job';
  static const jobApplicants = 'job/jobApplicants';

  //ENGAGEMENT
  static const submitEngagement = 'engagement/submitEngagement';
  static const acceptRejectEngagement = 'engagement/acceptRejectEngagement';
  static const submitEngagementChangeRequest =
      'engagement/submitEngagementChangeRequest';
  static const acceptRejectEngagementChangeRequest =
      'engagement/acceptRejectEngagementChangeRequest';
  static const finishEngagement = 'engagement/finishEngagement';
  static const acceptRejectFinishEngagement =
      'engagement/acceptRejectFinishEngagement';
  static const submitDispute = 'engagement/submitDispute';
  static const engagements = 'engagement/engagements';
  static const engagement = 'engagement/engagement';

  //WALLET
  static const wallet = 'wallet/wallet';
  static const walletTransactions = 'wallet/walletTransactions';
  static const submitPayment = 'wallet/submitPayment';
  static const payments = 'wallet/payments';
  static const chargeWalletWithPayment = 'wallet/chargeWalletWithPayment';

  //FAVORITE
  static const addFavoriteMember = 'favorite/addFavoriteMember';
  static const removeFavoriteMember = 'favorite/removeFavoriteMember';
  static const addFavoriteJob = 'favorite/addFavoriteJob';
  static const removeFavoriteJob = 'favorite/removeFavoriteJob';
  static const favorites = 'favorite/favorites';
  static const favoriteJobs = 'favorite/favorites';
  static const addFavoriteService = 'favorite/addFavoriteService';
  static const removeFavoriteService = 'favorite/removeFavoriteService';
  static const addFavoritePackage = 'favorite/addFavoritePackage';
  static const removeFavoritePackage = 'favorite/removeFavoritePackage';

  //COMMUNICATION
  static const contacts = 'communication/contacts';
  static const messages = 'communication/getConversationMessages';
  static const sendMessage = 'communication/sendMessage';
  static const coversations = 'communication/coversations';

  //RATING
  static const ratingCriteria = 'rating/ratingCriteria';
  static const rateMember = 'rating/rateMember';
  static const rateBulk = 'rating/rateBulk';
  static const rateApp = 'rating/rateApp';
  static const memberRatings = 'rating/memberRatings';

  //NOTIFICATION
  static const notifications = 'notification/notifications';
  static const markNotificationRead = 'notification/markNotificationRead';
  static const markAllNotificationsRead =
      'notification/markAllNotificationsRead';

  //SUPPORT
  static const supportCategories = 'support/supportCategories';
  static const startConversation = 'support/startConversation';
  static const closeConversation = 'support/closeConversation';
  static const lastConversation = 'support/lastConversation';
  static const sendSupportMessage = 'support/sendMessage';
  static const getSupportConversationMessages = 'support/getConversationMessages';
  static const getSupportConversations = 'support/listConversations';


  //SEARCH
  static const employerSearch = 'search/employerSearch';
  static const freelancerSearch = 'search/freelancerSearch';
}

class Params {
  static const authorization = 'Authorization';
  static const language = 'language';
  static const id = 'id';
  static const mobile = 'mobile';
}
