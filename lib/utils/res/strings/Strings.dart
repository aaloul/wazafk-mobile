/// Interface strings
abstract class Strings {
  // Auth Screens
  String get login;

  String get continueAsGuest;

  String get loginRequired;

  String get loginRequiredMessage;

  String get createAccount;

  String get welcome;

  String get forgetYourPassword;

  String get resetMyPassword;

  String get verifyYourIdentity;

  String get startYourJourney;

  String get uploadAndVerify;

  String get verifyAndContinue;

  String get verifyAndApply;

  String get verify;

  // Form Labels
  String get firstName;

  String get lastName;

  String get title;

  String get emailAddress;

  String get password;

  String get confirmPassword;

  String get newPassword;

  String get oldPassword;

  String get gender;

  String get male;

  String get female;

  String get dateOfBirth;

  String get phoneNumber;

  String get duration;

  String get messageToEmployer;

  String get messageToClient;

  String get messageToFreelancer;

  String get yourReview;

  String get passport;

  String get frontId;

  String get backId;

  String get label;

  String get address;

  String get city;

  String get street;

  String get building;

  String get apartment;

  String get category;

  String get subcategory;

  String get hourlyRate;

  String get startingAt;

  String get pricingType;

  String get hourlyRateOption;

  String get fixedRateOption;

  String get overview;

  String get responsibilities;

  String get requirements;

  String get workExperience;

  String get workingHours;

  String get message;

  // Attachment strings
  String get selectAttachment;

  String get video;

  String get document;

  String get file;

  String get microphonePermissionDenied;

  String get fileTooLarge;

  String get portfolioLink;

  String get portfolio;

  String get about;

  String get tellUsAboutYourself;

  // Form Hints
  String get amountInUsd;

  String get briefDescription;

  String get jobOverviewHint;

  String get enterYourPrice;

  String get enterEstimatedHours;

  String get enterTheReasonForDispute;

  String get enterYourMessage;

  String get searchJobsServicesPackages;

  String get searchCategories;

  String get searchSubcategories;

  String get addYourFeedback;

  String get startTypingToSearch;

  String get recentSearches;

  String get clearAll;

  String get searchHistoryCleared;

  String get chooseLocation;

  String get selectExpiryDate;

  String get selectExpiryTime;

  String get selectServices;

  String get selectTime;

  String get setTime;

  String get selectDate;

  String get editJobPost;

  String get addJobPost;

  String get updateJob;

  String get postJob;

  String get listKeyResponsibilities;

  String get listRequiredSkillsQualifications;

  // Button Labels
  String get back;

  String get next;

  String get continueBtn;

  String get close;

  String get acceptRequest;

  String get accept;

  String get decline;

  String get negotiate;

  // --- Engagement inquiry / details (new design) ---
  String get inquiry;

  String get yourInquiry;

  String get clientsBudget;

  String get freelancerPriceRequest;

  String get amountRequest;

  String get requestDifferentDatesIfNeeded;

  String get sendInquiry;

  String get enterMessageToEmployerHere;

  String get finalizeJob;

  String get needHelpContactSupport;

  String get timeEstimation;

  String get aboutTheJob;

  String get bookingRequest;

  String get brief;

  String get yourRequest;

  String get messageFromFreelancer;

  // --- Success message sheets ---
  String get ok;

  String get inquirySent;

  String get jobAccepted;

  String get application;

  String get applicationSent;

  String get viewApplication;

  String get inquirySentWaitEmployer;

  String get inquirySentWaitFreelancer;

  String youAcceptedInquiry(String date);

  String jobWillStartOn(String date);

  String jobWillStartInDays(int days);

  String get jobStartsToday;

  String youAcceptedApplication(String name, String date);

  String applicationSentMessage(String job);

  String get finishTask;

  String get submitDispute;

  String get acceptFinish;

  String get rejectFinish;

  String get submitNegotiation;

  String get acceptChange;

  String get declineChange;

  String get bookNow;
  String get request;

  String get submitApplication;

  String get addNewAddress;

  String get applyNow;

  String get logout;

  String get delete;

  String get cancel;

  String get add;

  String get createNewJob;

  String get editAddress;

  String get addAddress;

  String get saveAddress;

  String get createNewPack;

  String get createNewService;

  String get updateProfile;

  String get jobUpdated;

  String get jobPosted;

  String get editProfileImage;

  String get editImage;

  // Navigation & Screen Titles
  String get task;

  String get chat;

  String get notifications;

  String get allCategories;

  String get selectPortal;

  String get allJobs;

  String get allTasks;

  String get services;

  // Validation Messages
  String get firstNameRequired;

  String get lastNameRequired;

  String get titleRequired;

  String get emailRequired;

  String get invalidEmail;

  String get passwordRequired;

  String get newPasswordRequired;

  String get passwordsDoNotMatch;

  String get pleaseEnterCurrentPassword;

  String get pleaseConfirmNewPassword;

  String get passwordMustBeAtLeast6Characters;

  String get pleaseEnterValidOtp;

  String get pleaseEnterJobTitle;

  String get pleaseSelectLocation;

  String get pleaseSelectCategory;

  String get pleaseSelectJobType;

  String get pleaseEnterHourlyRate;

  String get pleaseEnterOverview;

  String get pleaseEnterRequirements;

  String get pleaseSelectRating;

  String get pleaseEnterFeedback;

  String get pleaseEnterLabel;

  String get pleaseEnterAddress;

  String get pleaseEnterStreet;

  String get pleaseEnterBuilding;

  String get pleaseEnterApartment;

  String get pleaseEnterCity;

  String get pleaseMakeChange;

  String get pleaseSelectDuration;

  String get pleaseEnterYourBudget;

  String get pleaseSelectStartDate;

  String get pleaseSelectStartTime;

  String get pleaseSelectAtLeastOneSkill;

  String get pleaseEnterResponsibilities;

  String get pleaseEnterTitle;

  String get pleaseEnterDescription;

  String get pleaseEnterUnitPrice;

  String get pleaseEnterTotalPrice;

  String get pleaseSelectAtLeastOneAddress;

  String get pleaseSelectAtLeastOneArea;

  String get selectAreas;

  String get noAreasAvailable;

  String get pleaseEnterWorkExperience;

  // Success Messages
  String get addedToFavorites;

  String get removedFromFavorites;

  String get addressDeletedSuccessfully;

  String get accountDeletedSuccessfully;

  String get loggedOutSuccessfully;

  String get yourJobIsNowLive;

  String get yourPackageIsNowLive;

  String get yourServiceIsNowLive;

  String get packageUpdated;

  String get packagePosted;

  String get serviceUpdated;

  String get servicePosted;

  String get serviceDisabled;

  String get packageDisabled;

  String get jobDisabled;

  String get serviceNowLiveDescription;

  String get serviceDisabledDescription;

  String get packageNowLiveDescription;

  String get packageDisabledDescription;

  String get jobNowLiveDescription;

  String get jobDisabledDescription;

  String get failedToLoadServices;

  String errorLoadingServices(String error);

  String get failedToUpdateServiceStatus;

  String errorUpdatingServiceStatus(String error);

  String get failedToLoadPackages;

  String errorLoadingPackages(String error);

  String get failedToUpdatePackageStatus;

  String errorUpdatingPackageStatus(String error);

  String get failedToUpdateJobStatus;

  String errorUpdatingJobStatus(String error);

  String get viewProfile;

  // Error Messages
  String errorLoadingJobs(String error);

  String errorLoadingSkills(String error);

  String errorLoadingWallet(String error);

  String errorLoadingProfile(String error);

  String errorLoadingFaqs(String error);

  String errorLoadingData(String error);

  String errorSearching(String error);

  String errorLoadingMore(String error);

  String errorBookingService(String error);

  String errorDisablingJob(String error);

  String errorSelectingCv(String error);

  String errorCapturingImage(String error);

  String errorSelectingImage(String error);

  String errorSelectingFile(String error);

  String error(String error);

  String get errorSubmittingDispute;

  String get failedToRemoveFavorite;

  String get failedToLoadContacts;

  String get failedToLoadConversations;

  String get failedToDeleteAddress;

  String get failedToDeleteAccount;

  String get logoutFailed;

  String get noInternetConnection;

  String get errorUpdatingJob;

  String get errorPostingJob;

  String errorUpdatingJobWithParam(String error);

  String errorPostingJobWithParam(String error);

  String get failedToUpdatePackage;

  String get failedToAddPackage;

  String errorAddingPackageWithParam(String error);

  String get failedToUpdateService;

  String get failedToAddService;

  String errorAddingServiceWithParam(String error);

  String get failedToLoadServiceDetails;

  String errorLoadingServiceDetails(String error);

  // Network Error Messages
  String errorDuringCommunication(String error);

  String invalidRequest(String error);

  String unauthorised(String error);

  String invalidInput(String error);

  String couldNotLaunchUrl(String url);

  // Empty States
  String get noCategoriesAvailable;

  String get noJobsAvailable;

  String get noServicesAvailable;

  String get noPackagesAvailable;

  String get noAddressesFound;

  String get noDocumentsFound;

  String get noContentAvailable;

  String get noFaqsAvailable;

  String get noResultsFound;

  String get noDataAvailable;

  String get noChangeRequestDetailsAvailable;

  String get noTaskDetailsAvailable;

  String get noTasksAvailable;

  String get noApplicantsYet;

  String get noJobDetailsAvailable;

  String get noNotificationsYet;

  String get notificationsDescription;

  String get noPackageDetailsAvailable;

  String get noProfileDetailsAvailable;

  String get noRatingCriteriaAvailable;

  String get noServiceDetailsAvailable;

  String get noSkillsAddedYet;

  String get applicationsWillAppearHere;

  String get trySearchingWithDifferentKeywords;

  // Dialog Messages
  String get areYouSureLogout;

  String get areYouSureDeleteAccount;

  String get areYouSureDeleteAddress;

  // UI Component Text
  String get addProfileImage;

  String get applications;

  String get totalTransactions;

  String get totalPayout;

  String get today;

  String get yesterday;

  String daysAgo(int days);

  String hoursAgo(int hours);

  String minutesAgo(int minutes);

  String get justNow;

  String get unknown;

  String get notAvailable;

  String get notAvailableShort;

  String get due;

  String get done;

  String get amount;

  String get rating;

  String get location;

  String get remote;

  String get hybrid;

  String get onsite;

  String get date;

  String get dates;

  String get applicants;

  String get completedJobs;

  String get jobsPosted;

  String get availableJobs;

  String get jobType;

  String get startTime;

  String get startDate;

  String get expiryDate;

  String get expiryTime;

  String get serviceType;

  String get recentTransactions;

  String get remaining;

  String get totalValue;

  String get sortBy;

  String get viewAll;

  String get verifyNow;

  String get notVerified;

  String get verifiedPill;

  String get freelancerHired;

  String get freelancer;

  String get employer;

  String memberSince(String year);

  // Additional Task Strings
  String get negotiateTerms;

  String get reason;

  String get enterReasonForDispute;

  String get booking;

  String get milestones;

  String get changeRequest;

  String get yourChangeRequestPendingApproval;

  String get yourTaskRequestPendingApproval;

  String get start;

  String get requestedBy;

  String get changedFields;

  String get currentPrice;

  String get newPrice;

  String get currentTotal;

  String get newTotal;

  String get currentHours;

  String get newHours;

  String get currentStartDate;

  String get newStartDate;

  String get currentDueDate;

  String get newDueDate;

  String get taskDetails;

  String get uploadDeliverables;

  String get pleaseUploadCompletedWorkDeliverables;

  String get tapToUploadFile;

  String get finalSubmission;

  String get finalSubmissionSubtitle;

  String get uploadFileHere;

  String get cvFile;

  String get completedDeliverables;

  String get deliverablesFile;

  String get waitingForReply;

  String get upcomingTasksAndProjects;

  // Additional Error Messages
  String errorFetchingAddresses(String error);

  String errorInitializingCamera(String error);

  String get noCategoriesFound;

  // App Title
  String get appTitle;

  // Phone Number & Verification
  String get loginRegister;

  String get messageAndDateRates;

  String get dontHaveAccount;

  String get registerNow;

  String get byContinuingAgreeTo;

  String get termsOfUse;

  String get and;

  String get privacyPolicy;

  String get enterVerificationCode;

  String get otpHasBeenSent;

  String get didntReceiveOtp;

  String get resendCode;

  // Update email flow (Figma p136, p138)
  String get updateEmailAddress;
  String get sendEmailConfirmation;
  String get emailAlreadyTaken;
  String get otpTitle;
  String get otpSentToNewEmail;
  String get resendOtp;

  // Portal Selection
  String get freelancerPortal;

  String get employerPortal;

  // Onboarding
  String get skip;

  // Main Navigation
  String get home;

  String get projects;

  String get myJobs;

  String get activity;

  String get projectsAndServices;

  String get pending;

  String get closedPaused;

  String get pins;

  String get ongoingProject;

  String get savedJobs;

  String get noOngoingProjects;

  String get noPendingProjects;

  String get noCompletedProjects;

  String get noDisputedProjects;

  String get noSavedPins;

  String get noSavedJobs;

  String get profile;

  // Chat
  String get ongoingChat;

  String get activeEmployers;

  String get noOngoingChats;

  String get noActiveEmployers;

  String get chatConversations;

  String get supportConversations;

  String get support;

  String get dispute;

  String get noSupportConversations;

  String get active;

  String get closed;

  String get supportTicket;

  String get generalSupport;

  String get noMessagesYet;

  // Days of the week
  String get monday;

  String get tuesday;

  String get wednesday;

  String get thursday;

  String get friday;

  String get saturday;

  String get sunday;

  // Search
  String get search;

  String get searchJobsProjects;

  String get trySearchingDifferentKeywords;

  // Subcategories
  String get noSubcategoriesFound;

  // Job Application
  String get jobDetailsNotAvailable;

  String get amountRequiredForThisJob;

  String get perHour;

  String get editService;

  String get addService;

  String get updateService;

  String get saveService;

  String get postService;

  String daysSelected(int count);

  String get editPackage;

  String get addPackage;

  String get updatePackage;

  String get savePackage;

  String get postPackage;

  String servicesSelected(int count);

  String get noServicesSelected;

  String get noSkillsSelected;

  String get imageSelected;

  String get uploadImage;

  String get youllReceive;

  String get profit;

  String get applicationCommissionFees;

  String get howLongWillItTake;

  String get selectDuration;

  String get hours;

  String get description;

  String get attachments;

  String get cvSelected;

  String get uploadCv;

  String get chooseFile;

  String get perProject;

  String get clientRequested;

  String get ofProfit;

  String get maxFileSizeNote;

  String get briefDescriptionSuitableCandidate;

  // Task Details
  String get viewTask;

  String get viewApplications;

  String get disableTask;

  String get enableJob;

  String get viewChanges;

  String get submitAndFinish;

  String get price;

  String get estimatedHours;

  String get selectDateRange;

  String get verifyFaceMatch;

  String get takeASelfieToVerify;

  String get initializingCamera;

  String get cameraNotAvailable;

  String get pleaseCheckCameraPermissions;

  // Create Account Steps
  String get chooseInterest;

  String get chooseUpToFiveInterests;

  String get personalId;

  String get tapToScan;

  String get optional;

  // Upload Documents
  String get uploadYourDocuments;

  String get uploadClearPhotoOfIdentity;

  // Rating
  String get submitRating;

  String get rateTask;

  String get rateFreelancer;

  String get rateClient;

  String get rateJob;

  String get rateService;

  String get pleaseRateAllCriteria;

  String get addComment;

  String get wouldYouLikeToRateThisTask;

  String get rateNow;

  String get later;

  // Package/Service Forms
  String get enterPackageDescription;

  String get enterYourDescription;

  String get unitPrice;

  String get totalPrice;

  String get jobRate;

  String get perJob;

  String get bufferTime;

  String get enterYourExperience;

  String get selectCategory;

  String get selectSubcategory;

  String get selectBufferTime;

  String get packDetails;

  String get coverImage;

  String get areasYouCover;

  String get availability;

  String get generalDetails;

  String get skillsAdditionNote;

  // Password
  String get changePassword;

  // Skills Sheet
  String get apply;

  String get noSkillsAvailableForCategory;

  String get selectSkills;

  // Address Sheet
  String get selectAddress;

  String get selectAddresses;

  String get noAddressesAvailable;

  String get pleaseAddAddressFromProfile;

  // Activity
  String get servicesAndPackages;

  String get skills;

  String get workHistory;
  String get hiringHistory;
  String get jobsDone;
  String get hires;
  String get posts;

  String get workPackages;

  String get jobDetails;

  String get howCanWeHelpYou;

  // Profile Settings Menu
  String get settings;

  String get personalInformation;

  String get myDocuments;

  String get packs;

  String get myAddresses;

  String get loginAndSecurity;

  String get paymentsAndEarnings;

  String get privacyAndSharing;

  String get changeLanguage;

  String get wayOfPayment;

  String get workingDays;

  String get rewardsAndCredits;

  String get shareApp;

  String get aboutUs;

  String get helpCenter;

  String get giveUsFeedback;

  String get deleteAccount;

  // Login & Security
  String get savedLogin;

  String get whereYoureLoggedIn;

  String get loginAlerts;

  String get passwordAndSecurity;

  String get securityChecks;

  // Notifications
  String get notificationsOption;

  String get generalNotification;

  String get sound;

  String get vibrate;

  String get systemAndServicesUpdate;

  String get appUpdates;

  String get billReminder;

  String get promotion;

  String get discountAvailable;

  String get paymentRequest;

  String get other;

  String get newJobsAvailable;

  String get newTalentsAvailable;

  // Notification channels / settings (Figma p159, p165)
  String get notificationChannels;
  String get pushNotifications;
  String get emailNotifications;
  String get inAppNotifications;
  String get newApplications;
  String get jobUpdates;
  String get newJobPostings;
  String get applicationUpdates;
  String get jobRequests;
  String get soundAndAlerts;
  String get notificationsSound;
  String get generalGroup;
  String get messagesNotif;
  String get reviewsNotif;
  String get wazafakAnnouncements;
  String get promotionsAndOffers;

  // Tab Names
  String get all;

  String get freelancers;

  String get packages;

  String get package;

  String get requests;

  String get payments;

  String get jobs;

  // Time Durations
  String get fifteenMinutes;

  String get thirtyMinutes;

  String get fortyFiveMinutes;

  String get sixtyMinutes;

  String get ninetyMinutes;

  String get oneHundredTwentyMinutes;

  String get oneHundredEightyMinutes;

  // Statistics
  String get totalEarnings;

  String get earnings;

  String get activeJobs;

  String get completed;

  String get successRate;

  String get wallet;

  // Job Details
  String get freelancersApplications;

  // Service/Package Details
  String get bookPackage;

  // Invite Friends
  String get inviteAFriend;

  String get byEmailAddress;

  String get byWhatsapp;

  String get download;

  String get enterEmailAssociatedWithAccount;

  String get verification;

  String get hiredOrWorked;

  String get inviteFriendAndGet;

  String get rateUsAndLeaveFeedback;

  String get yourOpinionMatters;

  String get yourRating;

  // Working Hours
  String get saveWorkingHours;

  // Services Selection
  String get confirmSelection;

  // Image Source
  String get selectImageSource;

  String get camera;

  String get takeANewPhoto;

  String get gallery;

  String get chooseFromGallery;

  String get capturePhoto;

  String get retakePhoto;

  String get pleaseUseCameraToVerifyTask;

  String get pleaseUseCameraToVerifyJob;

  String get pleaseUseCameraToVerifyService;

  // Location
  String get selectLocation;

  String get confirm;

  String get save;

  // Apply Language
  String get applyLanguage;

  // Empty States & Retry
  String get retry;

  String get noDataAvailableCheckLater;

  // Freelancers & Services
  String get freelancersAndServices;

  // Verify & Book
  String get verifyAndBook;



  // Common Success Messages
  String get imageCapturedSuccessfully;

  String get uploadedSuccessfully;

  String get submittedSuccessfully;

  String get acceptedSuccessfully;

  String get rejectedSuccessfully;

  String get selectedSuccessfully;

  String get packageImageSelectedSuccessfully;

  String get portfolioImageSelectedSuccessfully;

  // Common Error Messages
  String get failedToLoad;

  String get failedToUpload;

  String get failedToSubmit;

  String get failedToAccept;

  String get failedToReject;

  String get failedToAddToFavorites;

  String get failedToRemoveFromFavorites;

  String get failedToDisableJob;

  String get failedToLoadFaqs;

  String errorUploadingData(String error);

  String errorLoadingCategories(String error);

  String errorLoadingAddresses(String error);

  String errorLoadingTasks(String error);

  String errorLoadingEmployerHomeData(String error);

  // Information Not Available Messages
  String get memberInformationNotAvailable;

  String get serviceInformationNotAvailable;

  String get packageInformationNotAvailable;

  String get servicePackageInformationNotAvailable;

  String get jobInformationNotAvailable;

  String get taskInformationNotAvailable;

  // Face Verification Messages
  String get faceVerifiedSuccessfully;

  String get faceVerificationFailed;

  String get cameraNotInitialized;

  String get pleaseCaptureImageFirst;

  String errorVerifyingFaceMatch(String error);

  // Upload Documents Messages
  String get pleaseUploadPassportImage;

  String get pleaseUploadBothFrontAndBackIdImages;

  String get documentsUploadedSuccessfully;

  String get failedToUploadDocuments;

  String errorUploadingDocuments(String error);

  // Task Messages
  String get failedToLoadTaskDetails;

  String get errorLoadingTaskDetails;

  String get taskAcceptedSuccessfully;

  String get failedToAcceptTask;

  String get errorAcceptingTask;

  String get taskRejectedSuccessfully;

  String get failedToRejectTask;

  String get errorRejectingTask;

  String get noDatesSelected;

  String get negotiationSubmittedSuccessfully;

  String get failedToSubmitNegotiation;

  String errorSubmittingNegotiation(String error);

  String get pleaseEnterReasonForDispute;

  String get disputeSubmittedSuccessfully;

  String get failedToSubmitDispute;

  String get changeRequestAcceptedSuccessfully;

  String get failedToAcceptChangeRequest;

  String errorAcceptingChangeRequest(String error);

  String get changeRequestRejectedSuccessfully;

  String get failedToRejectChangeRequest;

  String errorRejectingChangeRequest(String error);

  String get fileSelectedSuccessfully;

  String get pleaseUploadDeliverablesFile;

  String get taskFinishedSuccessfully;

  String get failedToFinishTask;

  String errorFinishingTask(String error);

  String get finishTaskAcceptedSuccessfully;

  String get failedToAcceptFinishTask;

  String errorAcceptingFinishTask(String error);

  String get finishTaskRejectedSuccessfully;

  String get failedToRejectFinishTask;

  String errorRejectingFinishTask(String error);

  // Booking Messages
  String get pleaseSelectDateRange;

  String get pleaseSelectServiceType;

  // Application Messages
  String get applicationSubmittedSuccessfully;

  // Home/Search Messages
  String get failedToLoadCategories;

  String get failedToLoadJobs;

  String get failedToLoadSkills;

  String get failedToLoadAddresses;

  String get failedToLoadWallet;

  String get failedToLoadProfile;

  String get failedToLoadTasks;

  String get failedToLoadEmployerHomeData;

  String errorUpdatingFavorites(String error);

  // Rating Messages
  String get failedToLoadRatingCriteria;

  String get failedToLoadMemberProfile;

  String get pleaseRateAtLeastOneCriterion;

  String get ratingSubmittedSuccessfully;

  String get failedToSubmitRating;

  // Category Messages
  String get errorFetchingCategories;

  // Validation Messages
  String get mustNotBeEmpty;

  // Other
  String errorOccuredCommunication(String statusCode);

  String get noInternetConnectionLowercase;

  // Payments & Earnings - Sorting Options
  String get paymentOverview;

  String get earningsOverview;

  String get dateAscending;

  String get dateDescending;

  String get amountAscending;

  String get amountDescending;

  // Help Center
  String get contactSupport;

  String get supportCategory;

  String get endConversation;

  String get areYouSureEndConversation;

  String get conversationEndedSuccessfully;

  String get viewMyServices;
  String get viewMyJobs;
  String get viewMyPackages;

  // Conversation
  String get openConversation;
  String get wouldYouLikeToContactFreelancer;

  String get verifyUserId;
  String get verifyPassport;
  String get onceApproved;
  String get voucher;
  String get legal;
  String get edit;

  String get locationPin;
  String get profileReview;

  // Notifications categories / sub-categories
  String get account;
  String get hiring;
  String get hiringUpdates;
  String get workRequests;
  String get opportunities;

  // Auth / Change password
  String get forgotPassword;

  // Payment methods (Figma p146)
  String get paymentMethods;
  String get addCard;
  String get endingWith;
  String get expires;

  // Voucher / Add Card / Privacy
  String get vouchers;
  String get noVouchersYet;
  String get cardNumber;
  String get cvv;

  // Documents / Share / Feedback (Figma p149, p166, p170)
  String get uploadDoc;
  String get docVerified;
  String get inviteFriend;
  String get inviteHero;
  String get howItWorks;
  String get verificationDesc;
  String get inviteAction;
  String get inviteActionDesc;
  String get invite;
  String get inviteStepsPriorVoucher;
  String get downloadStep;
  String get downloadStepDesc;
  String get inviteByWhatsapp;
  String get inviteByEmail;
  String get submitFeedback;
  String get rejected;
  String get review;

  // Activate / Publish modals (Figma p191, p194, p204, p223)
  String get activateService;
  String get publishLabel;
  String get keepServiceLive;
  String get serviceRenewsMonthly;
  String get serviceMonthly;
  String get extraSkills;
  String get subscriptionMo;
  String get totalToday;
  String get walletBalanceCaps;
  String get enoughBadge;
  String get topUpPill;
  String get firstServiceOnUs;
  String get renewAtAfter90Days;
  String get firstServicePromo;
  String get firstJobPostOnUs;
  String get publishInstantly;
  String get firstJobPostPromo;
  String get jobPostFee;
  String get afterThisJobCosts;
  String get editDetails;
  String get nextRenewalHint;

  // Payment receipt / invoice (Figma p61, p116)
  String get paymentReceiptTitle;
  String get paymentInvoiceTitle;
  String get jobCompletedOn;
  String get paymentFromLabel;
  String get paymentToLabel;
  String get receiptLabel;
  String get invoiceLabel;
  String get transactionIdLabel;
  String get escrowDeposit;
  String get released;
  String get jobAmount;
  String get wazafkFee;
  String get received;
  String get paid;

  // Wallet — Top Up / Withdraw / History (Figma p76, p101, p102)
  String get topUpTitle;
  String get withdraw;
  String get walletHistory;
  String get yourBalance;
  String get withdrawAmount;
  String get topUpAmount;
  String get enterAmount;
  String get paymentMethod;
  String get otherAmount;
  String get bestValue;
  String get addPromoCode;
  String get promoCode;
  String get subtotal;
  String get total;
  String get change;
  String get noTransactions;

  // Filter Sheet
  String get filter;
  String get reset;
  String get recommended;
  String get newest;
  String get highestBudget;
  String get budget;
  String get distance;
  String get km;
  String get employerRating;
  String get andUp;
  String get applyFilter;

  // Pause Service
  String get pauseService;
  String get pauseServiceDescription;
  String get pause;

  // Help Center
  String get faqs;
  String get general;
  String get searchQuestion;

  // Get Support
  String get getSupport;
  String get doYouHaveAnIssue;
  String get getSupportSubtitle;

  // Edit Phone Number
  String get editPhoneNumber;
  String get phoneNumberWillReplace;
  String get otpSentToNewNumber;
  String get phoneNumberChangedSuccess;

  // Calendar / Schedule
  String get calendar;
  String get todaysSchedule;
  String jobDueInDays(int days);
  String get jobDueToday;
  String get saved;
  String get noSavedItems;

  // Where you're logged in
  String get currentlyLoggedInOn;
  String get loginsOnOtherDevices;
  String notYouLoggedInLogoutOf(String device);
  String get noActiveSessions;
  String get deviceLogoutUnavailable;
  String get upcoming;
  String get inProgress;
  String get noScheduleForDay;

  // Job post form (design p185 / p186)
  String get jobPostTitle;
  String get editJobTitle;
  String get noChargeYet;
  String get onSite;
  String get selectAreasYouCover;
  String get jobTypeProject;
  String get jobTypeOneTime;
  String get startDatePlaceholder;
  String get startTimePlaceholder;
  String get pleaseSelectLocationType;

  // Service form (design p112 / p107)
  String get newService;
  String get editServices;
  String get approximateRate;
  String get saveChanges;
  String get onLabel;
  String get offLabel;

  // Add Skill step (design p181)
  String get addSkill;
  String firstSkillFreeNote(String price);
  String get selectedCaps;
  String get extraCostCaps;
  String get moreSkillsWiderReach;
  String maxSkillsReached(int max);

  // Job expiry (optional, below the start date/time)
  String get expiryDatePlaceholder;
  String get expiryTimePlaceholder;

  String get pleaseCompleteExpiryDateTime;
  String get expiryMustBeAfterStart;

  // Publish job step (design p194 / p232)
  String jobPostShortfallNote(String cost, String short);
  String get availableLabel;
  String get chargeToday;
  String suggestedTopUpNote(String amount);
  String get topUpAndPublish;
  String get lowBadge;

  String get addServiceBeforePack;

  // Work package form (design p113 / p115)
  String get workPackageTitle;
  String get editPackageTitle;
  String get amountRequiredForPackage;
  String get packDescriptionHint;
  String get postWorkPackage;

  // Camera permission (upload documents)
  String get cameraPermissionRequired;
  String get cameraPermissionDenied;
  String get openSettings;

  String get applicationNotFound;

  String get searchForJob;

  String get viewJobPosts;

  String firstSkillsFreeNote(int count, String price);

  // Limit-reached sheets (design p174 / p114)
  String get jobPostLimitTitle;
  String jobPostLimitMessage(String price);
  String get workPackLimitTitle;
  String workPackLimitMessage(String price);

  // Work package publish step (mirrors the job one)
  String get workPackFee;
  String get firstPackOnUs;
  String get firstPackPromo;
  String afterThisPackCosts(String price);
  String afterThisJobCostsAmount(String price);
  String packShortfallNote(String cost, String short);
  String get topUpAndPost;

  // Service activation summary (shares the job publish screen)
  String afterThisServiceCosts(String price);
  String serviceShortfallNote(String cost, String short);
  String get topUpAndActivate;

  String freePostsLeft(int count);
}
