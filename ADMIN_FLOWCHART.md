# 📊 Admin Visual Workflows - City Guide App

> Visual representations of key admin processes and decision trees

---

## 🔐 1. Admin Authentication Flow

```
                    START
                      |
                      ▼
            ┌─────────────────┐
            │  Open Admin     │
            │  Portal         │
            └────────┬────────┘
                     │
                     ▼
            ┌─────────────────┐
            │ Enter Email &   │
            │ Password        │
            └────────┬────────┘
                     │
                     ▼
         ┌───────────────────────┐
         │  Validate Credentials │
         └───────┬───────────────┘
                 │
        ┌────────┴────────┐
        │                 │
      Valid             Invalid
        │                 │
        ▼                 ▼
┌──────────────┐   ┌──────────────┐
│ Check Admin  │   │ Show Error   │
│ Role         │   │ Message      │
└──────┬───────┘   └──────┬───────┘
       │                  │
    Has Role           No Role
       │                  │
       ▼                  ▼
┌──────────────┐   ┌──────────────┐
│ Send 2FA     │   │ Access       │
│ Code         │   │ Denied       │
└──────┬───────┘   └──────────────┘
       │
       ▼
┌──────────────┐
│ Enter 2FA    │
│ Code         │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Verify Code  │
└──────┬───────┘
       │
   ┌───┴───┐
   │       │
 Valid   Invalid
   │       │
   ▼       ▼
┌────┐   ┌────┐
│ ✅ │   │ ❌ │
└─┬──┘   └─┬──┘
  │        │
  ▼        ▼
Admin    Retry
Dashboard (Max 3)
```

---

## 📍 2. Attraction Management Flow

### 2.1 Add New Attraction

```
      START: Admin clicks "Add Attraction"
                    |
                    ▼
      ┌──────────────────────────────┐
      │  Step 1: Basic Information   │
      │  - Name                       │
      │  - Category                   │
      │  - Description                │
      │  - City                       │
      └──────────┬───────────────────┘
                 │
                 ▼
      ┌──────────────────────────────┐
      │  Step 2: Location Details    │
      │  - Address                    │
      │  - GPS Coordinates            │
      │  - Map Preview                │
      └──────────┬───────────────────┘
                 │
                 ▼
      ┌──────────────────────────────┐
      │  Step 3: Contact Info        │
      │  - Phone                      │
      │  - Email                      │
      │  - Website                    │
      │  - Opening Hours              │
      └──────────┬───────────────────┘
                 │
                 ▼
      ┌──────────────────────────────┐
      │  Step 4: Images & Media      │
      │  - Main Image                 │
      │  - Gallery (up to 10)         │
      │  - Video URL                  │
      └──────────┬───────────────────┘
                 │
                 ▼
      ┌──────────────────────────────┐
      │  Step 5: Amenities           │
      │  - Select features            │
      │  - Price range                │
      └──────────┬───────────────────┘
                 │
                 ▼
      ┌──────────────────────────────┐
      │  Step 6: Review & Publish    │
      │  - Preview                    │
      │  - Set status                 │
      │  - Notification option        │
      └──────────┬───────────────────┘
                 │
         ┌───────┴────────┐
         │                │
    Publish            Save Draft
         │                │
         ▼                ▼
    ┌─────────┐      ┌─────────┐
    │ Live ✅ │      │ Draft 📝│
    └────┬────┘      └─────────┘
         │
         ▼
    Notify Users
    (if selected)
         │
         ▼
       END
```

### 2.2 Attraction Approval Flow

```
              User Submits Attraction
                        |
                        ▼
              ┌──────────────────┐
              │ Admin Notified   │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ Admin Reviews    │
              │ Submission       │
              └────────┬─────────┘
                       │
           ┌───────────┼───────────┐
           │           │           │
     Complete    Missing Info   Poor Quality
           │           │           │
           ▼           ▼           ▼
    ┌──────────┐ ┌──────────┐ ┌──────────┐
    │ Verify   │ │ Request  │ │ Reject   │
    │ Details  │ │ More     │ │ with     │
    │          │ │ Info     │ │ Feedback │
    └────┬─────┘ └────┬─────┘ └────┬─────┘
         │            │            │
    Accurate?    User Updates   Notify
         │            │         Submitter
    ┌────┴────┐       │            │
    │         │       │            ▼
  Yes       No        ▼          END
    │         │    Back to
    │         │    Review
    ▼         │       │
┌────────┐    │       │
│Approve │    │       │
│& Pub-  │◄───┘       │
│lish ✅ │            │
└───┬────┘            │
    │                 │
    ├─────────────────┘
    │
    ▼
┌─────────────────┐
│ Update Stats    │
│ Send Notification│
└─────────────────┘
    │
    ▼
  END
```

---

## 💬 3. Review Moderation Flow

### 3.1 Standard Review Processing

```
        User Submits Review
                |
                ▼
      ┌──────────────────┐
      │ Auto-Filter      │
      │ (Check keywords, │
      │  spam patterns)  │
      └────────┬─────────┘
               │
       ┌───────┴────────┐
       │                │
   Pass Auto        Flagged
   Filter          Suspicious
       │                │
       ▼                ▼
┌──────────────┐ ┌──────────────┐
│ Publish      │ │ Hold for     │
│ Immediately  │ │ Review       │
└──────┬───────┘ └──────┬───────┘
       │                │
       ▼                ▼
┌──────────────┐ ┌──────────────┐
│ Update       │ │ Admin Queue  │
│ Rating       │ └──────┬───────┘
└──────────────┘        │
                        ▼
                ┌──────────────┐
                │ Admin        │
                │ Reviews      │
                └──────┬───────┘
                       │
          ┌────────────┼────────────┐
          │            │            │
      Approve      Edit &       Reject
                  Approve
          │            │            │
          ▼            ▼            ▼
    ┌─────────┐  ┌─────────┐  ┌─────────┐
    │Publish  │  │Make     │  │Delete & │
    │✅       │  │Changes  │  │Log      │
    └────┬────┘  └────┬────┘  └────┬────┘
         │            │            │
         │            ▼            │
         │       ┌─────────┐       │
         │       │Publish  │       │
         │       │with Note│       │
         │       └────┬────┘       │
         │            │            │
         └────────────┼────────────┘
                      │
                      ▼
              ┌──────────────┐
              │ Notify User  │
              └──────────────┘
                      │
                      ▼
                    END
```

### 3.2 Flagged Review Process

```
            Review Gets Flagged
                    |
                    ▼
          ┌──────────────────┐
          │ Count Flags      │
          └────────┬─────────┘
                   │
           ┌───────┴────────┐
           │                │
      1-2 Flags        3+ Flags
           │                │
           ▼                ▼
    ┌──────────┐      ┌──────────┐
    │ Admin    │      │ Auto-    │
    │ Review   │      │ Remove   │
    │ Queue    │      │ Temp.    │
    └────┬─────┘      └────┬─────┘
         │                 │
         │                 │
         └────────┬────────┘
                  │
                  ▼
          ┌──────────────────┐
          │ Admin Investigates│
          │ - Review content  │
          │ - Check flags     │
          │ - User history    │
          └────────┬─────────┘
                   │
      ┌────────────┼────────────┐
      │            │            │
  Valid       Borderline    Invalid
  Report       Case         Report
      │            │            │
      ▼            ▼            ▼
┌─────────┐  ┌─────────┐  ┌─────────┐
│Remove   │  │Request  │  │Restore  │
│Review   │  │Second   │  │Review   │
└────┬────┘  │Opinion  │  └────┬────┘
     │       └────┬────┘       │
     │            │            │
     ▼            ▼            ▼
┌─────────┐  ┌─────────┐  ┌─────────┐
│Warn/Ban │  │Final    │  │Dismiss  │
│User     │  │Decision │  │Flags    │
└────┬────┘  └────┬────┘  └────┬────┘
     │            │            │
     └────────────┼────────────┘
                  │
                  ▼
          ┌──────────────────┐
          │ Update Records   │
          │ Notify Reporter  │
          │ Notify Review    │
          │ Author           │
          └──────────────────┘
                  │
                  ▼
                END
```

---

## 👥 4. User Management Flow

### 4.1 User Violation Tracking

```
        User Action/Content
                |
                ▼
        ┌──────────────┐
        │ Violation    │
        │ Detected     │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │ Check User   │
        │ History      │
        └──────┬───────┘
               │
    ┌──────────┼──────────┐
    │          │          │
1st Time   2nd Time   3rd Time
    │          │          │
    ▼          ▼          ▼
┌────────┐ ┌────────┐ ┌────────┐
│Warning │ │2nd     │ │Temp or │
│Email   │ │Warning │ │Perm    │
│        │ │+Restrict│ │Ban     │
└───┬────┘ └───┬────┘ └───┬────┘
    │          │          │
    ▼          ▼          ▼
┌────────┐ ┌────────┐ ┌────────┐
│Log     │ │24hr    │ │Account │
│Violation│ │Posting │ │Suspend │
│        │ │Ban     │ │        │
└───┬────┘ └───┬────┘ └───┬────┘
    │          │          │
    └──────────┼──────────┘
               │
               ▼
        ┌──────────────┐
        │ Update User  │
        │ Record       │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │ Send         │
        │ Notification │
        └──────────────┘
               │
               ▼
             END
```

### 4.2 Ban Decision Tree

```
                Violation Report
                       |
                       ▼
              ┌──────────────┐
              │ Assess       │
              │ Severity     │
              └──────┬───────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
     Minor        Medium       Severe
   (Spam)      (Harassment)  (Illegal)
        │            │            │
        ▼            ▼            ▼
    ┌───────┐   ┌────────┐   ┌────────┐
    │Warning│   │Temp Ban│   │Perm Ban│
    │       │   │        │   │        │
    └───┬───┘   └───┬────┘   └───┬────┘
        │           │            │
        ▼           ▼            ▼
    ┌───────┐   ┌────────┐   ┌────────┐
    │Keep   │   │7-30    │   │Delete  │
    │Content│   │Days    │   │All     │
    │       │   │        │   │Content │
    └───┬───┘   └───┬────┘   └───┬────┘
        │           │            │
        └───────────┼────────────┘
                    │
                    ▼
            ┌──────────────┐
            │ Document     │
            │ Decision     │
            └──────┬───────┘
                   │
                   ▼
            ┌──────────────┐
            │ Notify User  │
            │ & Reporter   │
            └──────────────┘
                   │
                   ▼
                 END
```

---

## 🔔 5. Notification Management Flow

### 5.1 Creating & Sending Notification

```
      Admin Initiates Notification
                  |
                  ▼
        ┌──────────────────┐
        │ Select Type      │
        │ - Event          │
        │ - Promotion      │
        │ - System Update  │
        │ - Custom         │
        └────────┬─────────┘
                 │
                 ▼
        ┌──────────────────┐
        │ Define Target    │
        │ - All users      │
        │ - By city        │
        │ - By interest    │
        │ - Custom segment │
        └────────┬─────────┘
                 │
                 ▼
        ┌──────────────────┐
        │ Create Content   │
        │ - Title          │
        │ - Message        │
        │ - Image          │
        │ - Action Button  │
        └────────┬─────────┘
                 │
                 ▼
        ┌──────────────────┐
        │ Preview          │
        └────────┬─────────┘
                 │
         ┌───────┴────────┐
         │                │
    Looks Good         Needs Edit
         │                │
         ▼                │
    ┌─────────┐           │
    │Schedule?│           │
    └────┬────┘           │
         │                │
    ┌────┴────┐           │
    │         │           │
  Now      Later          │
    │         │           │
    ▼         ▼           │
┌───────┐ ┌───────┐       │
│Send   │ │Save   │       │
│Now    │ │for    │       │
│       │ │Later  │       │
└───┬───┘ └───┬───┘       │
    │         │           │
    └────┬────┘           │
         │                │
         ▼                │
    ┌─────────┐           │
    │Send to  │◄──────────┘
    │Queue    │
    └────┬────┘
         │
         ▼
    ┌─────────┐
    │Deliver  │
    │to Users │
    └────┬────┘
         │
         ▼
    ┌─────────┐
    │Track    │
    │Metrics  │
    │-Delivered│
    │-Opened  │
    │-Clicked │
    └─────────┘
         │
         ▼
       END
```

---

## 📊 6. Content Lifecycle

```
                    START
                      |
                      ▼
          ┌──────────────────────┐
          │ DRAFT                │
          │ - Being created      │
          │ - Not visible        │
          └──────┬───────────────┘
                 │
                 ▼
          ┌──────────────────────┐
          │ PENDING REVIEW       │
          │ - Submitted          │
          │ - Awaiting approval  │
          └──────┬───────────────┘
                 │
        ┌────────┴────────┐
        │                 │
    Approved          Rejected
        │                 │
        ▼                 ▼
┌──────────────┐   ┌──────────────┐
│ ACTIVE       │   │ REJECTED     │
│ - Published  │   │ - Feedback   │
│ - Visible    │   │ - Can revise │
└──────┬───────┘   └──────┬───────┘
       │                  │
       │                  │
       ▼                  ▼
┌──────────────┐   ┌──────────────┐
│ FEATURED     │   │ RESUBMITTED  │
│ - Highlighted│   │ - Back to    │
│ - Promoted   │   │   Review     │
└──────┬───────┘   └──────┬───────┘
       │                  │
       ▼                  │
┌──────────────┐          │
│ NEEDS UPDATE │          │
│ - Info outdated│        │
│ - Needs work │          │
└──────┬───────┘          │
       │                  │
       ▼                  │
┌──────────────┐          │
│ INACTIVE     │          │
│ - Not visible│          │
│ - Archived   │          │
└──────┬───────┘          │
       │                  │
       ▼                  │
┌──────────────┐          │
│ DELETED      │◄─────────┘
│ - Permanently│
│   removed    │
└──────────────┘
       │
       ▼
     END
```

---

## 🔄 7. Daily Admin Routine

```
        Login (9:00 AM)
              |
              ▼
    ┌──────────────────┐
    │ Check Dashboard  │
    │ - Pending items  │
    │ - Alerts         │
    │ - Statistics     │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Review Reports   │
    │ (15-30 mins)     │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Process Reviews  │
    │ (30-45 mins)     │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Approve Content  │
    │ (30 mins)        │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Update Listings  │
    │ (30 mins)        │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Check Analytics  │
    │ (15 mins)        │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Handle Issues    │
    │ (As needed)      │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Plan Tomorrow    │
    │ - Schedule       │
    │ - Tasks          │
    └────────┬─────────┘
             │
             ▼
        Logout (5:00 PM)
```

---

## 🎯 8. Decision Trees

### 8.1 Should This Review Be Removed?

```
                    START
                      |
                      ▼
              Is it spam?────────Yes───→ REMOVE
                      |
                     No
                      ▼
          Contains profanity?────Yes───→ EDIT or REMOVE
                      |
                     No
                      ▼
          Is it off-topic?───────Yes───→ REMOVE
                      |
                     No
                      ▼
        Contains personal info?──Yes───→ EDIT to remove
                      |
                     No
                      ▼
            Is it harassment?────Yes───→ REMOVE + WARN
                      |
                     No
                      ▼
          Is it constructive?────Yes───→ APPROVE
                      |
                     No
                      ▼
        Does it follow guidelines?─Yes───→ APPROVE
                      |
                     No
                      ▼
              REQUEST REVISION
```

### 8.2 Attraction Approval Decision

```
                    START
                      |
                      ▼
          All required fields?────No───→ REQUEST INFO
                      |
                     Yes
                      ▼
          Images good quality?────No───→ REQUEST BETTER
                      |
                     Yes
                      ▼
        Location verified?─────No───→ VERIFY or REJECT
                      |
                     Yes
                      ▼
        Info accurate & current?─No───→ REQUEST UPDATE
                      |
                     Yes
                      ▼
          Duplicate listing?──────Yes───→ REJECT
                      |
                     No
                      ▼
        Appropriate category?───No───→ SUGGEST CORRECT
                      |
                     Yes
                      ▼
           Professional tone?────No───→ REQUEST REVISION
                      |
                     Yes
                      ▼
                  APPROVE ✅
```

---

## 📈 9. Escalation Matrix

```
┌────────────────────────────────────────────────┐
│              ISSUE ESCALATION                  │
├────────────────────────────────────────────────┤
│                                                │
│  Level 1: Moderator                           │
│  ├─ Basic review moderation                   │
│  ├─ Simple user queries                       │
│  └─ Routine content approval                  │
│       │                                        │
│       ▼ (If unsure or severe)                │
│                                                │
│  Level 2: Content Manager                     │
│  ├─ Complex content decisions                 │
│  ├─ User warnings                             │
│  └─ Sensitive reports                         │
│       │                                        │
│       ▼ (If legal/policy concern)            │
│                                                │
│  Level 3: Admin Lead                          │
│  ├─ Policy violations                         │
│  ├─ User bans                                 │
│  └─ Content disputes                          │
│       │                                        │
│       ▼ (If critical/legal)                  │
│                                                │
│  Level 4: Super Admin                         │
│  ├─ Legal issues                              │
│  ├─ System-wide decisions                     │
│  ├─ Major policy changes                      │
│  └─ Data breaches                             │
│       │                                        │
│       ▼ (If extremely severe)                │
│                                                │
│  Level 5: Management                          │
│  ├─ Legal action required                     │
│  ├─ PR crises                                 │
│  └─ Major security incidents                  │
│                                                │
└────────────────────────────────────────────────┘
```

---

## 📞 10. Emergency Response Flow

```
        Critical Issue Detected
                  |
                  ▼
        ┌──────────────────┐
        │ Assess Severity  │
        └────────┬─────────┘
                 │
      ┌──────────┼──────────┐
      │          │          │
    Low       Medium     HIGH
      │          │          │
      ▼          ▼          ▼
  ┌──────┐  ┌────────┐  ┌────────┐
  │Log & │  │Alert   │  │IMMEDIATE│
  │Queue │  │Lead    │  │ACTION   │
  └──────┘  └───┬────┘  └───┬────┘
                │           │
                ▼           ▼
          ┌──────────┐  ┌──────────┐
          │Investigate│  │Stop      │
          │within 2hrs│  │Service   │
          └─────┬─────┘  │if needed │
                │        └────┬─────┘
                │             │
                └──────┬──────┘
                       │
                       ▼
              ┌──────────────┐
              │ Take Action  │
              │ - Fix issue  │
              │ - Ban users  │
              │ - Remove     │
              └──────┬───────┘
                     │
                     ▼
              ┌──────────────┐
              │ Document     │
              │ Everything   │
              └──────┬───────┘
                     │
                     ▼
              ┌──────────────┐
              │ Notify       │
              │ Stakeholders │
              └──────┬───────┘
                     │
                     ▼
              ┌──────────────┐
              │ Post-Mortem  │
              │ Analysis     │
              └──────────────┘
                     │
                     ▼
                   END
```

---

*These flowcharts complement the detailed Admin Flow documentation and provide quick visual reference for admin processes.*