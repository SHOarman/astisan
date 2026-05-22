import 'package:get/get.dart';

class AppStrings extends Translations {

  static const  rejected ="Rejected";
  static const viewbokking="View Booking";
  // Page 1
  static const findTrustedHelp = 'Find Skilled Artisans Near You';
  static const findTrustedHelpSub = 'Browse trusted professionals for plumbing, electrical work, repairs, and more â€” all in one place.';

  // Page 2
  static const trackService = 'Track Your Service in Real-Time';
  static const trackServiceSub = 'Stay updated with live location tracking and know exactly when your artisan will arrive.';

  // Edit Profile / Dashboard added keys
  static const editProfile = 'Edit Profile';
  static const saveChanges = 'Save Changes';
  static const occupation = 'Occupation';
  static const bio = 'Bio';
  static const experienceYears = 'Experience (Years)';
  static const rate = 'Rate';
  static const skillsList = 'Skills (comma separated)';
  static const serviceAreasList = 'Service Areas (comma separated)';
  static const welcomeBackHeader = 'Welcome back,';

  // Page 3
  static const securePayments = 'Hassle-Free & Secure Payments';
  static const securePaymentsSub = 'Pay safely through the app with multiple payment options and complete transparency.';

  // Buttons
  static const next = 'Next';
  static const getStarted = 'Get Started';

  // Login Strings
  static const welcomeBack = 'Welcome Back !';
  static const signInSub = 'Sign in with your email and password\nor social media to continue';
  static const email = 'Email';
  static const password = 'Password';
  static const rememberMe = 'Remember me';
  static const forgotPassword = 'Forgot password ?';
  static const signIn = 'Sign in';
  static const or = 'Or';
  static const dontHaveAccount = 'Don\'t have account?';
  static const signUp = 'Sign up';

  // Role Strings
  static const whichDoYouWantToList = 'Which do you want to list?';
  static const roleSelectionSub = 'Tell us how you want to use FixGo';
  static const iNeedHelp = 'I need help';
  static const iNeedHelpSub = 'Find and book trusted professionals\nfor your home needs';
  static const iWantToWork = 'I want to work';
  static const iWantToWorkSub = 'Join our platform and connect with\nclients in your area';

  // Sign Up Strings
  static const registerAccount = 'Register Account';
  static const fullName = 'Full Name';
  static const number = 'Number';
  static const confirmPassword = 'Confirm Password';
  static const agreeWithTerms = 'Agree with terms and privacy';
  static const alreadyHaveAccount = 'Already have an account?';

  // Forgot Password Strings
  static const forgotPasswordTitle = 'Forgot Password';
  static const forgotPasswordSub = 'Don\'t worry, please enter your email and we will send you a reset link';
  static const sendCode = 'Send Code';

  // Verification Strings
  static const verification = 'Verification';
  static const verifyYourEmail = 'Verify your Email';
  static const enterVerificationCode = 'Enter Verification Code';
  static const weSendCodeTo = 'Please enter 6 digit verification that have been sent to your email address'; // modified to match image phrase loosely or exact from prompt, wait prompt says "We send code to example@gmail.com. Please enter it", I'll use the prompt version but pass dynamic email.
  static const resendCode = 'Resend code';
  static const dontReceiveCode = 'Don\'t receive code ?';
  static const verify = 'Verify';

  // Reset Password Strings
  static const resetPassword = 'Reset Password';
  static const createNewPassword = 'Create New Password'; // Image 1 title
  static const createNewPasswordSub = 'Create your new password so you can login to your account'; // Prompt sub. Image actually says "Please enter a new password to change", let's use prompt one.
  static const newPassword = 'New Password';
  static const submit = 'Submit';
  static const changePassword = 'Change Password';
  static const createPassword = 'Create Password';

  // Success Strings
  static const success = 'Success!';
  static const successSub = 'You password has been changed. Please log in again with a new password.';
  static const continueBtn = 'Continue';

  // Phase 3 Strings
  static const seeAll = 'See all';
  static const searchService = 'Search for service by name';
  static const searchOrders = 'Search orders...';
  // Home
  static const letLocalExperts = 'Let Local Experts Help';
  static const you = 'You'; // Used for colored "You" in the banner
  static const forYou = 'For You';
  static const popularServices = 'Popular Services';
  static const allPopularServices = 'All Popular Services';
  static const recommendedArtisans = 'Recommended Artisans';
  static const verified = 'VERIFIED';
  static const perHr = '/hr';
  static const promoTitle = 'First Service 20% Off!';
  static const promoCode = 'Use code: FIXGO20 at checkout';
  static const claim = 'Claim';
  // Services
  static const ourAllServices = 'Our All Services';
  static const goAnywhere = 'Go anywhere, get any services.';
  static const repairMaintenance = 'Repair & Maintenance';
  static const cleaning = 'Cleaning';
  static const installation = 'Installation';
  static const homeImprovement = 'Home Improvement';
  static const movingShifting = 'Moving & Shifting';
  static const gardenCleaning = 'Garden cleaning';
  // Activity
  static const orderHistory = 'Order History';
  static const all = 'All';
  static const completed = 'Completed';
  static const cancelled = 'Cancelled';
  static const upcoming = 'Upcoming';
  static const rates = 'Rate';
  static const rebook = 'Rebook';
  static const by = 'by ';
  // Profile
  static const myProfile = 'My Profile';
  static const bookings = 'Bookings';
  static const reviews = 'Reviews';
  static const ratingGiven = 'Rating Given';
  static const recentBookings = 'Recent Bookings';
  static const signOut = 'Sign Out';
  static const savedAddresses = 'Saved Addresses';
  static const paymentMethods = 'Payment Methods';
  static const notifications = 'Notifications';
  static const privacySecurity = 'Privacy & Security';
  static const helpSupport = 'Help & Support';

  // Phase 4 Strings
  static const serviceDetails = 'Service Details';
  static const overview = 'Overview';
  static const whatsIncluded = 'What\'s Included';
  static const topArtisanForThis = 'Top Artisan for This';
  static const bookNow = 'Book Now';
  static const booking = 'Booking';
  static const dateTime = 'Date & Time'; // For stepper
  static const address = 'Address'; // For stepper
  static const notes = 'Notes'; // For stepper
  static const imageUpload = 'Image upload'; // For stepper
  static const confirm = 'Confirm'; // For stepper
  static const selectDate = 'Select Date';
  static const selectTime = 'Select Time';
  static const serviceAddress = 'Service Address';
  static const useCurrentLocation = 'Use Current Location';
  static const addNewAddress = 'Add New Address';
  static const additionalNotes = 'Additional Notes';
  static const addNotesHint = 'Help the artisan understand your needs better';
  static const quickAdd = 'Quick Add';
  static const bookingSummary = 'Booking Summary';
  static const serviceFee = 'Service fee';
  static const platformFee = 'Platform fee';
  static const estimatedTotal = 'Estimated Total';
  static const confirmBooking = 'Confirm Booking';
  static const popular = 'POPULAR';
  static const startingFrom = 'Starting from';
  static const insured = 'Insured';
  static const hr1 = '1 hr';
  static const view = 'View';

  // Phase 5 Strings
  static const onlineOnTheWay = 'Online Â· On the way';
  static const jobInProgress = 'Job in Progress';
  static const rateAfterService = 'Rate after service completion';
  static const track = 'Track ->';
  static const writeMessage = 'write your message...';
  static const findingArtisan = 'Finding Artisan';
  static const findingBestArtisan = 'Finding the best artisan for you...';
  static const searchingNearby = 'Searching nearby artisans...';
  static const checkingAvailability = 'Checking availability...';
  static const matchingRequirements = 'Matching your requirements...';
  static const artisanFoundConfirming = 'Artisan found! Confirming...';
  static const trackArtisan = 'Track Artisan';
  static const arrivingIn = 'Arriving in 12 min';
  static const eta = 'ETA:';
  static const tracking = 'Tracking';
  static const serviceInProgress = 'Service In Progress';
  static const statusTimeline = 'Status Timeline';
  static const bookingConfirmed = 'Booking Confirmed';
  static const onTheWay = 'On the Way';
  static const working = 'Working';
  static const estimatedCost = 'Estimated Cost';
  static const jobStart = 'Job Start';
  static const viewCompletionWork = 'View Completion work';
  static const live = 'Live';

  // Phase 6 Strings
  static const payment = 'Payment';
  static const workOverview = 'Work Overview';
  static const serviceCompletedSuccess = 'Service Completed Successfully!';
  static const workCompleted = 'Work Completed';
  static const photos = 'Photos';
  static const costBreakdown = 'Cost Breakdown';
  static const promoDiscount = 'Promo Discount';
  static const totalDue = 'Total Due';
  static const serviceGuarantee = '90-Day Service Guarantee';
  static const sign = 'Sign';
  static const goToPay = 'Go to pay';
  static const securePaymentPortal = 'Secure payment portal';
  static const secured = 'Secured';
  static const totalAmountDue = 'Total Amount Due';
  static const cardDetails = 'Card Details';
  static const cardholderName = 'Cardholder name';
  static const branchName = 'Branch name';
  static const paymentSuccessful = 'Payment Successful!';
  static const transactionId = 'Transaction ID';
  static const amountPaid = 'Amount Paid';
  static const howWasExperience = 'How was your experience?';
  static const rateNow = 'Rate Now';
  static const downloadReceipt = 'Download Receipt';
  static const backToHome = 'Back to Home';
  static const editProfiles = 'Edit Profile';
  static const saveChangess = 'Save Changes';
  static const labor = 'Labor';
  static const parts = 'Parts';
  static const platformFeePercent = 'Platform fee (5%)';
  static const total = 'Total';
  static const cardNo = '4242 4242 4242 4242';
  static const expiry = '12/28';
  static const cvv = '***';
  static const paymentMsg = 'Your payment of %s has been processed successfully.';

  // Worker Role Strings
  static const earnings = 'Earnings';
  static const totalEarned = 'Total Earned';
  static const jobsDoneStatus = 'Jobs Done';
  static const avgJob = 'Avg/Job';
  static const dailyEarnings = 'Daily Earnings';
  static const nextPayoutLocal = 'Next Payout: %s';
  static const processingInDays = 'Processing in %s days';
  static const recentTransactions = 'Recent Transactions';
  static const jobCompletion = 'Job Completion';
  static const getClientSignature = 'Get client signature to complete';
  static const workCompletedLocal = 'Work Completed';
  static const clientSignatureLocal = 'Client Signature';
  static const clientSignsHere = 'Client signs here';
  static const confirmComplete = 'Confirm & Complete';
  static const incomingRequests = 'Incoming Requests';
  static const activeRequestsCount = '%s active requests';
  static const urgentTag = 'URGENT';
  static const normalTag = 'NORMAL';
  static const accept = 'Accept';
  static const decline = 'Decline';
  static const call = 'Call';
  static const chat = 'Chat';
  static const verifiedArtisan = 'VERIFIED ARTISAN';
  static const skillsServices = 'Skills & Services';
  static const serviceArea = 'Service Area';
  static const performance = 'Performance';
  static const accountSettings = 'Account Settings';
  static const topArtisanInArea = 'Top 5% in your area';
  static const jobAlerts = 'Job alerts, payment updates';
  static const welcomeBackName = 'Welcome back,';
  static const youAreOnline = 'You are Online';
  static const receivingNewRequests = 'Receiving new requests';
  static const todaysEarnings = 'Today\'s Earnings';
  static const todaysJobs = 'Today\'s Jobs';
  static const newRequestIncoming = 'New Request Incoming!';
  static const todaysSchedule = 'Today\'s Schedule';
  static const thisWeek = 'This Week';
  static const avgRating = 'Avg Rating';
  static const reportAnIssue = 'Report an Issue';
  static const problemWithThisJob = 'Problem with this job?';
  static const jobDetailsTitle = 'Job Details';
  static const jobChecklistTitle = 'Job Checklist';
  static const jobLocationTitle = 'Job Location';
  static const navigate = 'Navigate';
  static const arriveAtLocation = 'Arrive at location';
  static const greetClient = 'Greet client & inspect issue';
  static const cleanUpWorkspace = 'Clean up workspace';
  static const artisanIsOnTheWay = 'ARTISAN IS ON THE WAY';
  static const startNavigation = 'Start Navigation';
  static const pipeLeakImage = 'Pipe leak Image';
  static const clientNotes = 'Client Notes';
  static const scheduledTime = 'Scheduled Time';
  static const bookingIdLabel = 'Booking ID';
  static const locationLabel = 'Location';
  static const serviceInfo = 'Service Information';
  static const iveArrived = 'I\'ve Arrived';
  static const cancel = 'Cancel';
  static const cancelOrderTitle = 'Cancel this order?';
  static const cancelOrderSub = 'You can\'t undo this later';
  static const minElapsed = '%s min elapsed';
  static const jobAccepted = 'Job Accepted';
  static const artisanAcceptedJob = 'Your accepted the job';
  static const artisanHeadingLocation = 'Artisan is heading to your location';
  static const serviceInProgressLocation = 'Service in progress at your location';
  static const inProgressSub = 'In progress...';
  static const markAsComplete = 'Client Confirmation';
  static const workCompletedChecklist = 'Work Completed';
  static const checkWorkArea = 'Clean the work area after finishing work.';
  static const completeJobAndGetPaid = 'Complete Job & Get Paid';
  static const emergency911 = 'In an emergency, call 911 immediately. Use this form to report non-emergency job issues.';
  static const issueType = 'Issue Type';
  static const urgencyLevel = 'Urgency Level';
  static const low = 'Low';
  static const medium = 'Medium';
  static const high = 'High';
  static const description = 'Description';
  static const describeIssueHint = 'Describe the issue in detail...';
  static const addPhotosDocs = 'Add photos or documents (optional)';
  static const submitReport = 'Submit Report';
  static const reportAProblem = 'Report a problem?';
  static const selectIssueType = 'Select issue type...';

  // Account Verification
  static const accountVerification = 'Account Verification';
  static const documentVerification = 'Document verification';
  static const selectDocumentType = 'Select Document type';
  static const idCard = 'ID Card';
  static const passport = 'Passport';
  static const provideIdInfo = 'Please provide your ID Card information';
  static const dob = 'Date of birth';
  static const idNumber = 'ID number';
  static const takeBothSidePictures = 'Take both side pictures of your government issued ID card';
  static const placeIdInFrame = 'Place the ID Card in the frame';
  static const verificationSuccess = 'Verification Success';
  static const verificationSuccessfullyCompleted = 'Your ID card verification is successfully Completed';
  static const verificationFailed = 'Verification Failed';
  static const pleaseTryAgainLater = 'Please try again later';

  static const faqQ1 = 'What is this app?';
  static const faqA1 = 'It\'s an on-demand platform that connects clients with verified local artisans for home services like plumbing, electrical work, repairs, and more â€” instantly or by scheduled appointment.';
  static const faqQ2 = 'How do I book a service?';
  static const faqA2 = 'Simply select your service, choose instant booking or a scheduled appointment, upload a photo of the issue if needed, and confirm. A verified artisan will be assigned and you can track them live on the map.';
  static const faqQ3 = 'How does payment work?';
  static const faqA3 = 'All payments are processed securely in-app. You can also apply promo or referral codes at checkout. No cash needed â€” everything is handled digitally.';
  static const faqQ4 = 'Are the artisans verified?';
  static const faqA4 = 'Yes. Every artisan goes through a profile validation process before being approved on the platform. Only verified professionals can accept service requests.';
  static const faqQ5 = 'Is my personal data safe?';
  static const faqA5 = 'Absolutely. Your data is stored on encrypted servers and never sold to third parties. Private chat messages are only visible between you and your assigned artisan. You can delete your account and all associated data anytime from Settings.';

  static const subject = 'Subject';
  static const subjectHint = 'Short title of your issue or suggestion';
  static const emailAddress = 'Email Address';
  static const emailHint = 'Write your email';
  static const message = 'Message';
  static const messageHint = 'Please explain what happened...';

  static const privacyContent1 = 'â€¢ Account Info â€” Name, email address, phone number, and password.\nâ€¢ Service Requests â€” Service descriptions, photos uploaded, and intervention notes.\nâ€¢ Location Data â€” Real-time location during active service sessions for artisan tracking.\nâ€¢ Payment Info â€” Transaction records processed securely. We do not store full card details.\nâ€¢ Communication â€” Messages exchanged between clients and artisans within the app.\nâ€¢ Ratings & Reviews â€” Feedback submitted after service completion.\nâ€¢ Artisan Profile Data â€” Professional credentials, availability, and verification documents.\nâ€¢ Device Info â€” Device type, OS version, and app version for technical support.';
  static const privacyContent2 = 'â€¢ To create and manage your account as a client or artisan.\nâ€¢ To process bookings, instant requests, and scheduled appointments.\nâ€¢ To enable real-time artisan tracking during active interventions.\nâ€¢ To process payments, refunds, and promotional/referral codes.\nâ€¢ To verify artisan profiles and maintain platform quality and safety.\nâ€¢ To send booking confirmations, reminders, and service notifications.\nâ€¢ To improve app features and overall user experience.';
  static const privacyContent3 = 'â€¢ We do not sell your personal data to any third party.\nâ€¢ Trusted service providers (hosting, payments, maps, notifications) access data only as needed to operate the platform.\nâ€¢ During active bookings, clients and artisans share limited profile information with each other (name, photo, ratings).\nâ€¢ Platform administrators may access data for monitoring, dispute resolution, and quality control purposes only.\nâ€¢ Data may be disclosed if required by law or to protect user safety.';
  static const privacyContent4 = 'Location is tracked only during active service sessions to enable real-time artisan tracking. Sharing stops automatically once the session is completed or cancelled.';
  static const privacyContent5 = 'â€¢ Data is stored on secure, encrypted cloud servers.\nâ€¢ All data in transit is protected using HTTPS/TLS encryption.\nâ€¢ Payments are processed through PCI-DSS compliant providers.\nâ€¢ Account deletion permanently removes all personal data within 30 days.';
  static const privacyContent6 = 'â€¢ Access â€” Request a copy of your data anytime.\nâ€¢ Correction â€” Update your profile directly from app settings.\nâ€¢ Deletion â€” Delete your account via Profile -> Settings -> Delete Account.\nâ€¢ Opt-Out â€” Manage notification preferences via Profile -> Notification Settings.';
  static const privacyContent7 = 'We may update this policy periodically. Significant changes will be communicated via in-app notification or email. Continued use of the app after updates constitutes acceptance of the revised policy.';
  static const privacyContent8 = 'For any privacy-related questions or requests: privacy@fixgo.com  www.fixgo.com\nWe respond to all inquiries within 5 business days.';

  static const tosContent1 = 'By downloading, accessing, or using this platform, you confirm that you have read, understood, and agreed to these Terms of Service. If you do not agree, please discontinue use immediately.';
  static const tosContent2 = 'This platform is intended for users 18 years of age or older. By creating an account, you confirm that you meet this age requirement. We reserve the right to terminate accounts found to be in violation.';
  static const tosContent3 = 'You are solely responsible for:\nâ€¢ Keeping your login credentials confidential\nâ€¢ All activity that occurs under your account\nâ€¢ Ensuring your profile information is accurate and up to date\nIf you suspect unauthorized access, contact us immediately at support@fixgo.com';
  static const tosContent4 = 'By using this platform, you agree not to:\nâ€¢ Prohibited Action â€” Description\nâ€¢ Fraud / Misuse â€” Using the platform for unlawful or fraudulent purposes\nâ€¢ False Identity â€” Impersonating another person or providing false information\nâ€¢ System Interference â€” Attempting to hack, reverse-engineer, or disrupt the platform\nâ€¢ Inappropriate Content â€” Uploading offensive, abusive, or misleading photos or messages\nâ€¢ System Exploitation â€” Misusing referral codes, promo codes, or payment systems';
  static const tosContent5 = 'Artisans registering on the platform agree that:\nâ€¢ All submitted credentials, certifications, and identity documents are accurate and valid\nâ€¢ They will honor confirmed bookings and communicate promptly with clients\nâ€¢ Any on-site issues must be reported through the official in-app reporting system\nâ€¢ Profiles found to contain false information will be immediately suspended';
  static const tosContent6 = 'â€¢ All bookings and payments are processed exclusively through the platform\nâ€¢ Both clients and artisans are expected to honor confirmed bookings\nâ€¢ Cancellations and refund eligibility are governed by the Cancellation Policy communicated at the time of booking\nâ€¢ The platform uses secure, third-party payment processing. We do not store full card details';
  static const tosContent7 = 'This platform acts as an intermediary connecting clients with independent artisans. We do not directly employ artisans and are therefore not liable for:\nâ€¢ The quality or outcome of any service provided\nâ€¢ Any damage, loss, or injury occurring during a service session\nâ€¢ Disputes between clients and artisans outside the platformâ€™s resolution process\nUsers engage services at their own discretion and risk.';
  static const tosContent12 = 'For any questions or concerns regarding these Terms:\nsupport@fixgo.com  www.fixgo.com\nWe respond to all inquiries within 5 business days.';

  static const whatDoYouNeedHelpWith = 'What do you need help with?';
  
  // Cleaning
  static const subBathroomCleaning = 'Bathroom Cleaning';
  static const subBathroomCleaningDesc = 'Sanitizing, descaling & scrubbing';
  static const subHomeDeepCleaning = 'Home Deep Cleaning';
  static const subHomeDeepCleaningDesc = 'Full house top-to-bottom clean';
  static const subKitchenCleaning = 'Kitchen Cleaning';
  static const subKitchenCleaningDesc = 'Grease, stains & appliance surfaces';
  static const subPostConstruction = 'Post-Construction Clean';
  static const subPostConstructionDesc = 'Dust & debris after renovation';
  static const subSofaCarpetCleaning = 'Sofa & Carpet Cleaning';
  static const subSofaCarpetCleaningDesc = 'Stain removal & fabric care';
  static const subWindowCleaning = 'Window Cleaning';
  static const subWindowCleaningDesc = 'Inside/outside glass & frames';

  // Repair
  static const subAcRepair = 'AC Repair';
  static const subAcRepairDesc = 'Cooling, heating & home appliances';
  static const subElectricalFix = 'Electrical Fix';
  static const subElectricalFixDesc = 'Wiring, switches & power problems';
  static const subLockRepair = 'Lock Repair';
  static const subLockRepairDesc = 'Broken locks & key issues';
  static const subPlumbingFix = 'Plumbing Fix';
  static const subPlumbingFixDesc = 'Pipes, drains & water pressure issues';
  static const subRoofLeakRepair = 'Roof Leak Repair';
  static const subRoofLeakRepairDesc = 'Waterproofing & roof damage';
  static const subWallCeilingFix = 'Wall & Ceiling Fix';
  static const subWallCeilingFixDesc = 'Plaster, drywall & paint trim';

  // Installation
  static const subAcInstallation = 'AC Installation';
  static const subAcInstallationDesc = 'New unit fitting & setup';
  static const subCctvSmartHome = 'CCTV & Smart Home';
  static const subCctvSmartHomeDesc = 'Security cameras & smart devices';
  static const subDoorWindowFitting = 'Door & Window Fitting';
  static const subDoorWindowFittingDesc = 'New frames, locks & handles';
  static const subFurnitureAssembly = 'Furniture Assembly';
  static const subFurnitureAssemblyDesc = 'Flat-pack & ready-to-assemble items';
  static const subTvWallMount = 'TV & Wall Mount';
  static const subTvWallMountDesc = 'Secure mounting for all screen sizes';
  static const subWaterHeaterSetup = 'Water Heater Setup';
  static const subWaterHeaterSetupDesc = 'Boiler & geyser installation';

  // Home Improvement
  static const subBathroomRemodeling = 'Bathroom Remodeling';
  static const subBathroomRemodelingDesc = 'Modern upgrades & full makeovers';
  static const subFalseCeilingWork = 'False Ceiling Work';
  static const subFalseCeilingWorkDesc = 'Gypsum, POP & lighting setup';
  static const subFlooringTiling = 'Flooring & Tiling';
  static const subFlooringTilingDesc = 'Tiles, wood & laminate flooring';
  static const subKitchenRenovation = 'Kitchen Renovation';
  static const subKitchenRenovationDesc = 'Cabinets, countertops & fittings';
  static const subPaintingDecoration = 'Painting & Decoration';
  static const subPaintingDecorationDesc = 'Walls, ceilings & interior design';
  static const subWallpaperPaneling = 'Wallpaper & Paneling';
  static const subWallpaperPanelingDesc = 'Stylish wall treatments & coverings';

  // Moving
  static const subHomeRelocation = 'Home Relocation';
  static const subHomeRelocationDesc = 'Full house move with packing';
  static const subJunkRemoval = 'Junk Removal';
  static const subJunkRemovalDesc = 'Clear out unwanted items & waste';
  static const subOfficeShifting = 'Office Shifting';
  static const subOfficeShiftingDesc = 'Desks, equipment & document handling';
  static const subPackingService = 'Packing Service';
  static const subPackingServiceDesc = 'Safe packing & wrapping of belongings';
  static const subSingleItemMoving = 'Single Item Moving';
  static const subSingleItemMovingDesc = 'Sofa, fridge or heavy furniture only';
  static const subStorageService = 'Storage Service';
  static const subStorageServiceDesc = 'Short & long-term item storage';

  // Garden
  static const subGardenWasteRemoval = 'Garden Waste Removal';
  static const subGardenWasteRemovalDesc = 'Clear leaves, branches & debris';
  static const subIrrigationSetup = 'Irrigation Setup';
  static const subIrrigationSetupDesc = 'Watering system installation & repair';
  static const subLawnMowing = 'Lawn Mowing';
  static const subLawnMowingDesc = 'Regular grass cutting & trimming';
  static const subPestControlGarden = 'Pest Control (Garden)';
  static const subPestControlGardenDesc = 'Protect plants from insects & bugs';
  static const subPlantingLandscaping = 'Planting & Landscaping';
  static const subPlantingLandscapingDesc = 'New plants, flowers & garden design';
  static const subTreeBushTrimming = 'Tree & Bush Trimming';
  static const subTreeBushTrimmingDesc = 'Shape & prune overgrown plants';

  // Popular Services Titles
  static const popPipeLeakRepair = 'Pipe Leak Repair';
  static const popToiletRepair = 'Toilet Repair';
  static const popDeepHouseCleaning = 'Deep House Cleaning';
  static const popElectricalWiring = 'Electrical Wiring';
  static const popAcServiceRepair = 'AC Service & Repair';
  static const popFurnitureAssembly = 'Furniture Assembly';
  static const popWallPainting = 'Wall Painting';
  static const popLockKeyService = 'Lock & Key Service';
  static const popTvInstallation = 'TV Installation';
  static const popWindowGlassRepair = 'Window & Glass Repair';

  // Profile Section Flow
  static const yourSavedCard = 'Your Saved Card';
  static const addNewPaymentMethod = 'Add New Payment Method';
  static const sslSecured = 'SSL Secured';
  static const encryption256bit = '256-bit Encryption';
  static const pciCompliant = 'PCI Compliant';
  static const fillCardDetails = 'Fill your VISA or Master Card details and save the card';
  static const deleteCard = 'Delete Card';
  static const defaultTag = 'Default';
  static const homeTag = 'Home';
  static const officeTag = 'Office';
  static const addCard = 'Add Card';
  static const referAndEarn = 'Refer & Earn';
  static const referAndEarnDesc = 'Invite your friends to join the platform and get rewarded! For every friend who signs up and completes their first service booking using your unique referral code, you\'ll receive â‚¬15 instantly credited to your account. There\'s no limit â€” the more you refer, the more you earn. Your referral balance can be used directly as a discount on your next booking. Share your code anytime from your profile and start earning today!';
  static const invite = 'Invite';
  static const sharePromoCode = 'Share this promo code';
  static const currentPass = 'Current Pass';
  static const confirmPasswordAlt = 'Confirm Password'; // Avoid collision if exists
  static const save = 'Save';
  static const security = 'Security';
  static const deleteAccount = 'Delete Account';
  static const saveCard = 'Save Card';
  static const language = 'Language';
  static const aboutMe = 'About Me';
  static const yearsExperience = 'years experience';
  static const verificationPending = 'Verification Pending';
  static const unverifiedArtisan = 'Unverified Artisan';
  static const noBioAvailable = 'No bio available';
  static const artisan = 'Artisan';

  @override
  Map<String, Map<String, String>> get keys => {

        'fr_FR': {
          editProfile: 'Modifier le profil',
          saveChanges: 'Enregistrer les modifications',
          occupation: 'Profession',
          bio: 'Biographie',
          experienceYears: 'Expérience (Années)',
          rate: 'Taux Horaire',
          skillsList: 'Compétences (séparées par des virgules)',
          serviceAreasList: 'Zones de service (séparées par des virgules)',
          welcomeBackHeader: 'Bon retour,',
          findTrustedHelp: 'Trouvez des artisans de confiance près de chez vous',
          findTrustedHelpSub: 'Parcourez des professionnels de confiance pour la plomberie, l\'électricité, les réparations, et plus encore — tout au même endroit.',
          trackService: 'Suivez votre service en temps réel',
          trackServiceSub: 'Restez informé grâce au suivi en direct et sachez exactement quand votre artisan arrivera.',
          securePayments: 'Paiements sécurisés et sans tracas',
          securePaymentsSub: 'Payez en toute sécurité via l\'application avec plusieurs options de paiement et une transparence totale.',
          next: 'Suivant',
          getStarted: 'Commencer',
          welcomeBack: 'Bon retour !',
          signInSub: 'Connectez-vous avec votre e-mail et votre mot de passe\nou les réseaux sociaux pour continuer',
          email: 'E-mail',
          password: 'Mot de passe',
          rememberMe: 'Se souvenir de moi',
          forgotPassword: 'Mot de passe oublié ?',
          signIn: 'Se connecter',
          or: 'Ou',
          dontHaveAccount: 'Vous n\'avez pas de compte ?',
          signUp: 'S\'inscrire',
          whichDoYouWantToList: 'Que voulez-vous lister ?',
          roleSelectionSub: 'Dites-nous comment vous souhaitez utiliser FixGo',
          iNeedHelp: 'J\'ai besoin d\'aide',
          iNeedHelpSub: 'Trouvez et réservez des professionnels de confiance\npour vos besoins domestiques',
          iWantToWork: 'Je veux travailler',
          iWantToWorkSub: 'Rejoignez notre plateforme et connectez-vous avec\ndes clients de votre région',
          registerAccount: 'Créer un compte',
          fullName: 'Nom complet',
          number: 'Numéro',
          confirmPassword: 'Confirmer le mot de passe',
          agreeWithTerms: 'Accepter les conditions et la confidentialité',
          alreadyHaveAccount: 'Vous avez déjà un compte ?',
          forgotPasswordTitle: 'Mot de passe oublié',
          forgotPasswordSub: 'Ne vous inquiétez pas, entrez votre e-mail et nous vous enverrons un lien de réinitialisation',
          sendCode: 'Envoyer le code',
          verification: 'Vérification',
          verifyYourEmail: 'Vérifiez votre e-mail',
          enterVerificationCode: 'Entrez le code de vérification',
          weSendCodeTo: 'Veuillez entrer le code de vérification à 6 chiffres qui a été envoyé à votre adresse e-mail',
          resendCode: 'Renvoyer le code',
          dontReceiveCode: 'Vous n\'avez pas reçu de code ?',
          verify: 'Vérifier',
          resetPassword: 'Réinitialiser le mot de passe',
          createNewPassword: 'Créer un nouveau mot de passe',
          createNewPasswordSub: 'Créez votre nouveau mot de passe pour vous connecter à votre compte',
          newPassword: 'Nouveau mot de passe',
          submit: 'Soumettre',
          changePassword: 'Changer le mot de passe',
          createPassword: 'Créer un mot de passe',
          success: 'Succès !',
          successSub: 'Votre mot de passe a été modifié. Veuillez vous reconnecter avec votre nouveau mot de passe.',
          continueBtn: 'Continuer',
          seeAll: 'Tout voir',
          searchService: 'Rechercher un service par nom',
          searchOrders: 'Rechercher des commandes...',
          letLocalExperts: 'Laissez les experts locaux vous aider',
          you: 'Vous',
          forYou: 'Pour vous',
          popularServices: 'Services populaires',
          allPopularServices: 'Tous les services populaires',
          recommendedArtisans: 'Artisans recommandés',
          verified: 'VÉRIFIÉ',
          perHr: '/h',
          promoTitle: '20% de réduction sur le premier service !',
          popPipeLeakRepair: 'Réparation de fuite de tuyau',
          popToiletRepair: 'Réparation de toilettes',
          popDeepHouseCleaning: 'Nettoyage en profondeur de la maison',
          popElectricalWiring: 'Câblage électrique',
          popAcServiceRepair: 'Service et réparation de clim',
          popFurnitureAssembly: 'Montage de meubles',
          popWallPainting: 'Peinture murale',
          popLockKeyService: 'Service de serrurerie',
          popTvInstallation: 'Installation TV',
          popWindowGlassRepair: 'Réparation de fenêtres et vitres',
          promoCode: 'Utilisez le code : FIXGO20 lors du paiement',
          claim: 'Réclamer',
          ourAllServices: 'Tous nos services',
          goAnywhere: 'Allez n\'importe où, obtenez n\'importe quel service.',
          repairMaintenance: 'Réparation et maintenance',
          cleaning: 'Nettoyage',
          installation: 'Installation',
          homeImprovement: 'Amélioration de l\'habitat',
          movingShifting: 'Déménagement et transport',
          gardenCleaning: 'Nettoyage de jardin',
          orderHistory: 'Historique des commandes',
          all: 'Tout',
          completed: 'Terminé',
          cancelled: 'Annulé',
          upcoming: 'À venir',
          rate: 'Évaluer',
          rebook: 'Réserver à nouveau',
          by: 'par ',
          myProfile: 'Mon profil',
          bookings: 'Réservations',
          reviews: 'Avis',
          ratingGiven: 'Note donnée',
          recentBookings: 'Réservations récentes',
          signOut: 'Se déconnecter',
          savedAddresses: 'Adresses enregistrées',
          paymentMethods: 'Modes de paiement',
          notifications: 'Notifications',
          privacySecurity: 'Confidentialité et sécurité',
          helpSupport: 'Aide et support',
          serviceDetails: 'Détails du service',
          overview: 'Aperçu',
          whatsIncluded: 'Ce qui est inclus',
          topArtisanForThis: 'Meilleur artisan pour cela',
          bookNow: 'Réserver maintenant',
          booking: 'Réservation',
          dateTime: 'Date et heure',
          address: 'Adresse',
          notes: 'Notes',
          imageUpload: 'Téléchargement d\'image',
          selectDate: 'Sélectionner une date',
          selectTime: 'Sélectionner l\'heure',
          serviceAddress: 'Adresse du service',
          useCurrentLocation: 'Utiliser ma position actuelle',
          addNewAddress: 'Ajouter une nouvelle adresse',
          additionalNotes: 'Notes complémentaires',
          addNotesHint: 'Aidez l\'artisan à mieux comprendre vos besoins',
          quickAdd: 'Ajout rapide',
          bookingSummary: 'Résumé de la réservation',
          serviceFee: 'Frais de service',
          platformFee: 'Frais de plateforme',
          estimatedTotal: 'Total estimé',
          confirmBooking: 'Confirmer la réservation',
          popular: 'POPULAIRE',
          startingFrom: 'À partir de',
          insured: 'Assuré',
          hr1: '1 h',
          view: 'Voir',
          onlineOnTheWay: 'En ligne · En chemin',
          jobInProgress: 'Travail en cours',
          rateAfterService: 'Évaluez après la fin du service',
          track: 'Suivre ->',
          writeMessage: 'écrivez votre message...',
          findingArtisan: 'Recherche d\'un artisan',
          findingBestArtisan: 'Recherche du meilleur artisan pour vous...',
          searchingNearby: 'Recherche d\'artisans à proximité...',
          checkingAvailability: 'Vérification de la disponibilité...',
          matchingRequirements: 'Correspondance avec vos besoins...',
          artisanFoundConfirming: 'Artisan trouvé ! Confirmation...',
          trackArtisan: 'Suivre l\'artisan',
          arrivingIn: 'Arrivée dans 12 min',
          eta: 'Heure d\'arrivée estimée :',
          tracking: 'Suivi',
          bookingConfirmed: 'Réservation confirmée',
          estimatedCost: 'Coût estimé',
          jobStart: 'Début du travail',
          viewCompletionWork: 'Voir le travail terminé',
          live: 'En direct',
          payment: 'Paiement',
          workOverview: 'Aperçu du travail',
          serviceCompletedSuccess: 'Service terminé avec succès !',
          workCompleted: 'Travail terminé',
          photos: 'Photos',
          costBreakdown: 'Répartition des coûts',
          promoDiscount: 'Remise promotionnelle',
          totalDue: 'Total dû',
          serviceGuarantee: 'Garantie de service de 90 jours',
          sign: 'Signer',
          goToPay: 'Aller au paiement',
          securePaymentPortal: 'Portail de paiement sécurisé',
          secured: 'Sécurisé',
          totalAmountDue: 'Montant total dû',
          cardDetails: 'Détails de la carte',
          cardholderName: 'Nom du titulaire',
          branchName: 'Nom de la succursale',
          paymentSuccessful: 'Paiement réussi !',
          transactionId: 'ID de transaction',
          amountPaid: 'Montant payé',
          howWasExperience: 'Comment s\'est passée votre expérience ?',
          rateNow: 'Évaluer maintenant',
          downloadReceipt: 'Télécharger le reçu',
          backToHome: 'Retour à l\'accueil',
          editProfile: 'Modifier le profil',
          saveChanges: 'Enregistrer les modifications',
          labor: 'Main-d\'œuvre',
          parts: 'Pièces',
          platformFeePercent: 'Frais de plateforme (5%)',
          total: 'Total',
          cardNo: '4242 4242 4242 4242',
          expiry: '12/28',
          cvv: '***',
          paymentMsg: 'Votre paiement de %s a été traité avec succès.',
          earnings: 'Gains',
          totalEarned: 'Total gagné',
          jobsDoneStatus: 'Travaux terminés',
          avgJob: 'Moy/Travail',
          dailyEarnings: 'Gains quotidiens',
          nextPayoutLocal: 'Prochain versement : %s',
          processingInDays: 'Traitement dans %s jours',
          recentTransactions: 'Transactions récentes',
          jobCompletion: 'Fin du travail',
          getClientSignature: 'Obtenir la signature du client pour terminer',
          clientSignatureLocal: 'Signature du client',
          clientSignsHere: 'Le client signe ici',
          confirmComplete: 'Confirmer et terminer',
          incomingRequests: 'Demandes entrantes',
          activeRequestsCount: '%s demandes actives',
          urgentTag: 'URGENT',
          normalTag: 'NORMAL',
          accept: 'Accepter',
          decline: 'Décliner',
          call: 'Appeler',
          chat: 'Chatter',
          verifiedArtisan: 'ARTISAN VÉRIFIÉ',
          skillsServices: 'Compétences et services',
          serviceArea: 'Zone de service',
          performance: 'Performance',
          accountSettings: 'Paramètres du compte',
          topArtisanInArea: 'Top 5% dans votre région',
          jobAlerts: 'Alertes d\'emploi, mises à jour de paiement',
          welcomeBackName: 'Bon retour,',
          youAreOnline: 'Vous êtes en ligne',
          receivingNewRequests: 'Réception de nouvelles demandes',
          todaysEarnings: 'Gains du jour',
          todaysJobs: 'Travaux du jour',
          newRequestIncoming: 'Nouvelle demande entrante !',
          todaysSchedule: 'Emploi du temps du jour',
          thisWeek: 'Cette semaine',
          avgRating: 'Note moyenne',
          reportAnIssue: 'Signaler un problème',
          problemWithThisJob: 'Problème avec ce travail ?',
          jobDetailsTitle: 'Détails du travail',
          jobChecklistTitle: 'Liste de contrôle du travail',
          jobLocationTitle: 'Lieu du travail',
          navigate: 'Naviguer',
          arriveAtLocation: 'Arriver sur les lieux',
          greetClient: 'Salué le client et inspecté le problème',
          cleanUpWorkspace: 'Nettoyer l\'espace de travail',
          artisanIsOnTheWay: 'L\'ARTISAN EST EN CHEMIN',
          startNavigation: 'Démarrer la navigation',
          pipeLeakImage: 'Image de fuite de tuyau',
          clientNotes: 'Notes du client',
          scheduledTime: 'Heure prévue',
          bookingIdLabel: 'ID de réservation',
          locationLabel: 'Lieu',
          serviceInfo: 'Informations sur le service',
          iveArrived: 'Je suis arrivé',
          cancel: 'Annuler',
          cancelOrderTitle: 'Annuler cette commande ?',
          cancelOrderSub: 'Vous ne pourrez pas revenir en arrière',
          serviceInProgress: 'Service en cours',
          minElapsed: '%s min écoulées',
          jobAccepted: 'Travail accepté',
          artisanAcceptedJob: 'Vous avez accepté le travail',
          onTheWay: 'En chemin',
          artisanHeadingLocation: 'L\'artisan se dirige vers votre position',
          working: 'Travail en cours',
          serviceInProgressLocation: 'Service en cours à votre position',
          inProgressSub: 'En cours...',
          statusTimeline: 'Chronologie du statut',
          markAsComplete: 'Confirmation du client',
          workCompletedChecklist: 'Travail terminé',
          checkWorkArea: 'Nettoyer la zone de travail après avoir fini.',
          accountVerification: 'Vérification du compte',
          documentVerification: 'Vérification de document',
          selectDocumentType: 'Sélectionner le type de document',
          idCard: 'Carte d\'identité',
          passport: 'Passeport',
          provideIdInfo: 'Veuillez fournir les informations de votre carte d\'identité',
          dob: 'Date de naissance',
          idNumber: 'Numéro d\'identité',
          takeBothSidePictures: 'Prendre des photos des deux côtés de votre carte d\'identité',
          placeIdInFrame: 'Placez la carte d\'identité dans le cadre',
          verificationSuccess: 'Vérification réussie',
          verificationSuccessfullyCompleted: 'La vérification de votre carte d\'identité est terminée avec succès',
          verificationFailed: 'Échec de la vérification',
          pleaseTryAgainLater: 'Veuillez réessayer plus tard',
          whatDoYouNeedHelpWith: 'De quoi avez-vous besoin ?',
          subBathroomCleaning: 'Nettoyage de salle de bain',
          subBathroomCleaningDesc: 'Assainissement, détartrage et récurage',
          subHomeDeepCleaning: 'Nettoyage en profondeur de la maison',
          subHomeDeepCleaningDesc: 'Nettoyage complet de haut en bas',
          subKitchenCleaning: 'Nettoyage de cuisine',
          subKitchenCleaningDesc: 'Graisse, taches et surfaces d\'appareils',
          subPostConstruction: 'Nettoyage après construction',
          subPostConstructionDesc: 'Poussière et débris après rénovation',
          subSofaCarpetCleaning: 'Nettoyage de canapé et tapis',
          subSofaCarpetCleaningDesc: 'Élimination des taches et soin des tissus',
          subWindowCleaning: 'Nettoyage de vitres',
          subWindowCleaningDesc: 'Vitre intérieure/extérieure et cadres',
          subAcRepair: 'Réparation de clim',
          subAcRepairDesc: 'Refroidissement, chauffage et appareils ménagers',
          subElectricalFix: 'Réparation électrique',
          subElectricalFixDesc: 'Câblage, interrupteurs et problèmes de courant',
          subLockRepair: 'Réparation de serrure',
          subLockRepairDesc: 'Serrures cassées et problèmes de clés',
          subPlumbingFix: 'Réparation de plomberie',
          subPlumbingFixDesc: 'Tuyaux, drains et problèmes de pression d\'eau',
          subRoofLeakRepair: 'Réparation de fuite de toit',
          subRoofLeakRepairDesc: 'Étanchéité et dommages au toit',
          subWallCeilingFix: 'Réparation de mur et plafond',
          subWallCeilingFixDesc: 'Plâtre, cloisons sèches et peinture',
          subAcInstallation: 'Installation de clim',
          subAcInstallationDesc: 'Installation et configuration d\'une nouvelle unité',
          subCctvSmartHome: 'Vidéosurveillance et maison connectée',
          subCctvSmartHomeDesc: 'Caméras de sécurité et appareils intelligents',
          subDoorWindowFitting: 'Pose de portes et fenêtres',
          subDoorWindowFittingDesc: 'Nouveaux cadres, serrures et poignées',
          subFurnitureAssembly: 'Montage de meubles',
          subFurnitureAssemblyDesc: 'Articles en kit et prêts à monter',
          subTvWallMount: 'Support mural TV',
          subTvWallMountDesc: 'Fixation sécurisée pour toutes tailles d\'écran',
          subWaterHeaterSetup: 'Installation de chauffe-eau',
          subWaterHeaterSetupDesc: 'Installation de chaudière et chauffe-eau',
          subBathroomRemodeling: 'Rénovation de salle de bain',
          subBathroomRemodelingDesc: 'Modernisation et transformation complète',
          subFalseCeilingWork: 'Travaux de faux plafond',
          subFalseCeilingWorkDesc: 'Gypse, plâtre et éclairage',
          subFlooringTiling: 'Revêtement de sol et carrelage',
          subFlooringTilingDesc: 'Carrelage, bois et sol stratifié',
          subKitchenRenovation: 'Rénovation de cuisine',
          subKitchenRenovationDesc: 'Placards, plans de travail et finitions',
          subPaintingDecoration: 'Peinture et décoration',
          subPaintingDecorationDesc: 'Murs, plafonds et design d\'intérieur',
          subWallpaperPaneling: 'Papier peint et lambris',
          subWallpaperPanelingDesc: 'Traitements muraux élégants',
          subHomeRelocation: 'Déménagement résidentiel',
          subHomeRelocationDesc: 'Déménagement complet avec emballage',
          subJunkRemoval: 'Enlèvement d\'encombrants',
          subJunkRemovalDesc: 'Débarras d\'objets inutiles et déchets',
          subOfficeShifting: 'Déménagement de bureau',
          subOfficeShiftingDesc: 'Bureaux, équipement et documents',
          subPackingService: 'Service d\'emballage',
          subPackingServiceDesc: 'Emballage sûr et protection des biens',
          subSingleItemMoving: 'Transport d\'objet unique',
          subSingleItemMovingDesc: 'Canapé, frigo ou meuble lourd uniquement',
          subStorageService: 'Service de stockage',
          subStorageServiceDesc: 'Stockage à court et long terme',
          subGardenWasteRemoval: 'Enlèvement de déchets verts',
          subGardenWasteRemovalDesc: 'Évacuation des feuilles et branches',
          subIrrigationSetup: 'Installation d\'irrigation',
          subIrrigationSetupDesc: 'Installation et réparation de système d\'arrosage',
          subLawnMowing: 'Tonte de pelouse',
          subLawnMowingDesc: 'Coupe régulière de l\'herbe et bordures',
          subPestControlGarden: 'Lutte antiparasitaire (jardin)',
          subPestControlGardenDesc: 'Protéger les plantes des insectes',
          subPlantingLandscaping: 'Plantation et paysagisme',
          subPlantingLandscapingDesc: 'Nouvelles plantes, fleurs et design de jardin',
          subTreeBushTrimming: 'Taille d\'arbres et arbustes',
          subTreeBushTrimmingDesc: 'Taille et élagage des plantes',
          yourSavedCard: 'Votre carte enregistrée',
          addNewPaymentMethod: 'Ajouter un mode de paiement',
          sslSecured: 'Sécurisé SSL',
          encryption256bit: 'Cryptage 256 bits',
          pciCompliant: 'Conforme PCI',
          fillCardDetails: 'Remplissez les détails de votre carte VISA ou Mastercard',
          deleteCard: 'Supprimer la carte',
          defaultTag: 'Par défaut',
          homeTag: 'Maison',
          officeTag: 'Bureau',
          addCard: 'Ajouter une carte',
          referAndEarn: 'Parrainez et gagnez',
          referAndEarnDesc: 'Invitez vos amis et gagnez des récompenses !',
          invite: 'Inviter',
          sharePromoCode: 'Partagez ce code promo',
          currentPass: 'Mot de passe actuel',
          confirmPasswordAlt: 'Confirmer le mot de passe',
          save: 'Enregistrer',
          security: 'Sécurité',
          deleteAccount: 'Supprimer le compte',
          saveCard: 'Enregistrer la carte',
          completeJobAndGetPaid: 'Terminer le travail et être payé',
          emergency911: 'En cas d\'urgence, appelez immédiatement le 911.',
          issueType: 'Type de problème',
          urgencyLevel: 'Niveau d\'urgence',
          low: 'Faible',
          medium: 'Moyen',
          high: 'Élevé',
          description: 'Description',
          describeIssueHint: 'Décrivez le problème en détail...',
          addPhotosDocs: 'Ajouter des photos ou documents',
          submitReport: 'Envoyer le rapport',
          reportAProblem: 'Signaler un problème ?',
          confirm: 'Confirmer',
          cancel: 'Annuler',
          selectIssueType: 'Sélectionner le type de problème...',
          faqQ1: 'Qu\'est-ce que cette application ?',
          faqA1: 'C\'est une plateforme à la demande qui connecte les clients...',
          subject: 'Sujet',
          subjectHint: 'Titre court de votre problème',
          emailAddress: 'Adresse e-mail',
          emailHint: 'Écrivez votre e-mail',
          message: 'Message',
          messageHint: 'Veuillez expliquer ce qui s\'est passé...',
          language: 'Langue',
          aboutMe: 'À propos de moi',
          yearsExperience: 'ans d\'expérience',
          verificationPending: 'Vérification en attente',
          unverifiedArtisan: 'Artisan non vérifié',
          noBioAvailable: 'Aucune biographie disponible',
          artisan: 'Artisan',

          privacyContent1: privacyContent1,
          privacyContent2: privacyContent2,
          privacyContent3: privacyContent3,
          privacyContent4: privacyContent4,
          privacyContent5: privacyContent5,
          privacyContent6: privacyContent6,
          privacyContent7: privacyContent7,
          privacyContent8: privacyContent8,
          tosContent1: tosContent1,
          tosContent2: tosContent2,
          tosContent3: tosContent3,
          tosContent4: tosContent4,
          tosContent5: tosContent5,
          tosContent6: tosContent6,
          tosContent7: tosContent7,
          tosContent12: tosContent12,
        }
      };
}

