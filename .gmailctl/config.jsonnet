local lib = import 'gmailctl.libsonnet';

local me = {
  or: [
    { to: 'akshay@akshayshah.org' },
    { to: 'me@akshayshah.org' },
    { to: 'amazon@akshayshah.org' },
    { to: 'akshay@shahfam.org' },
    { to: 'ashah@hearsaycorp.com' },
    { to: 'akshay@hearsaycorp.com' },
    { to: 'shah@uber.com' },
    { to: 'ashah@loom.fyi' },
  ],
};
local fromMe = {
  or: [
    { from: 'akshay@akshayshah.org' },
    { from: 'amazon@akshayshah.org' },
    { from: 'ashah@hearsaycorp.com' },
    { from: 'akshay@hearsaycorp.com' },
    { from: 'shah@uber.com' },
    { from: 'ashah@loom.fyi' },
  ],
};
local ham = { markSpam: false };
local code = {
  newsletter: {
    markSpam: false,
    category: 'updates',
    labels: [
      'code',
      'optional',
    ],
  },
  newsgroup: {
    markSpam: false,
    category: 'forums',
    labels: [
      'code',
      'optional',
    ],
  },
  marketing: {
    markSpam: false,
    category: 'promotions',
    labels: [
      'code',
      'optional',
    ],
  },
};
local merchants = {
  marketing: {
    archive: true,
    markRead: true,
    markSpam: false,
    category: 'promotions',
    labels: [
      'optional',
    ],
  },
};
local founders = {
  markSpam: false,
  category: 'updates',
  labels: [
    'founders',
    'optional',
  ],
};
local archive = {
  archive: true,
  markRead: true,
  markSpam: false,
};
local social = {
  archive(name): {
    archive: true,
    markRead: true,
    markSpam: false,
    category: 'social',
    labels: ['networks/%s' % name],
  },
  tag(name): {
    category: 'social',
    labels: ['networks/%s' % name],
  },
};
local school = {
  archive(name): {
    archive: true,
    markRead: true,
    markSpam: false,
    labels: ['schools/%s' % name],
  },
  tag(name): {
    markSpam: false,
    labels: ['schools/%s' % name],
  },
};
local exhaust = {
  archive(name): {
    archive: true,
    markRead: true,
    markSpam: false,
    markImportant: false,
    labels: [
      'exhaust/%s' % name,
    ],
  },
};

local rules = [
  // Keep in inbox, but tag automatically.
  {
    filter: {
      or: [
        { to: 'ishaan@shahfam.org' },
        { to: 'akshay+ishaan@akshayshah.org' },
      ],
    },
    actions: {
      markImportant: true,
      markSpam: false,
      labels: ['ishaan', 'fam'],
    },
  },
  {
    filter: {
      or: [
        { to: 'maia@shahfam.org' },
        { to: 'akshay+maia@akshayshah.org' },
      ],
    },
    actions: {
      markImportant: true,
      markSpam: false,
      labels: ['maia', 'fam'],
    },
  },
  {
    filter: { to: 'hi@shahfam.org' },
    actions: {
      markImportant: true,
      markSpam: false,
      labels: ['fam'],
    },
  },
  {
    filter: {
      or: [
        { from: 'pacificprimary.org' },
        { and: [{ from: 'parentsquare.com' }, { has: 'Pacific Primary' }] },
      ],
    },
    actions: school.tag('pacific-primary'),
  },
  {
    filter: {
      or: [
        { from: 'ilsa@pacificprimary.org' },
        { from: 'Ilsa Miller via ParentSquare' },
      ],
    },
    actions: {
      markImportant: true,
    },
  },
  {
    filter: {
      or: [
        { from: 'sfday.org' },
        { from: 'smarttuition.com' },
      ],
    },
    actions: school.tag('sfday'),
  },
  {
    filter: { from: 'pacheightskidz@gmail.com' },
    actions: school.tag('pac-heights-kidz'),
  },
  {
    filter: {
      or: [
        { from: 'make@thebutterflyjoint.com' },
        { from: 'sanfranciscosoccercamp@gmail.com' },
        { from: 'info@culinaryartistas.com' },
        { from: 'coastalcamp@naturebridge.org' },
        { from: 'info@wheelkids.com' },
      ],
    },
    actions: school.tag('summer'),
  },
  {
    filter: { from: 'choate.edu' },
    actions: school.tag('choate'),
  },
  {
    filter: { from: 'notifications@github.com' },
    actions: {
      markSpam: false,
      labels: [
        'code',
      ],
    },
  },
  {
    filter: {
      or: [
        { from: 'connections@linkedin.com' },
        { from: 'groups-noreply@linkedin.com' },
        { from: 'hit-reply-premium-inmail@linkedin.com' },
        { from: 'hit-reply@linkedin.com' },
        { from: 'inmail-hit-reply@linkedin.com' },
        { from: 'invitations-noreply@linkedin.com' },
        { from: 'jobs-listings@linkedin.com' },
        { from: 'jobs-noreply@linkedin.com' },
        { from: 'jobalerts-noreply@linkedin.com' },
        { from: 'legalnotice@linkedin.com' },
        { from: 'member@linkedin.com' },
        { from: 'messages-noreply@linkedin.com' },
        { from: 'messaging-digest-noreply@linkedin.com' },
        { from: 'news-noreply@linkedin.com' },
        { from: 'news@linkedin.com' },
        { from: 'notifications-noreply@linkedin.com' },
        { from: 'security-noreply@linkedin.com' },
      ],
    },
    actions: social.tag('linkedin'),
  },
  {
    filter: {
      or: [
        { from: 'noreply@developers.facebook.com' },
      ],
    },
    actions: social.tag('facebook'),
  },
  {
    filter: {
      and: [
        { from: 'whyblu.com' },
        { not: { list: 'aeedd0ef0b39f157ce1f1e58b.435885.list-id.mcsv.net' } },
      ],
    },
    actions: {
      markSpam: false,
      markImportant: true,
      labels: ['tax'],
    },
  },
  {
    filter: { from: 'refills@getquip.com' },
    actions: ham,
  },

  // Chatty or self-produced email, archive automatically.
  {
    filter: {
      and: [
        { subject: '[engineering] Loom daily activity' },
        { from: 'no-reply@loom.fyi' },
      ],
    },
    actions: archive,
  },
  {
    filter: {
      and: [
        { from: 'noreply-dmarc-support@google.com' },
      ],
    },
    actions: archive,
  },
  {
    filter: { from: 'ama-assn.org' },
    actions: archive,
  },
  {
    filter: { to: 'later@akshayshah.org' },
    actions: exhaust.archive('delayed'),
  },
  {
    filter: {
      and: [
        { from: 'proxyvote.com' },
        {
          or: [
            { has: 'new shareholder communication available for you to review online' },
            { has: 'new available shareholders documents' },
          ],
        },
      ],
    },
    actions: archive,
  },
  {
    filter: {
      and: [
        {
          or: [
            { from: 'DONOTREPLY@myhealth.stanfordhealthcare.org' },
            { from: 'donotreply.myhealth@stanfordhealthcare.org' },
          ],
        },
        { has: 'Jagdish Shah' },
      ],
    },
    actions: exhaust.archive('myhealth'),
  },
  {
    filter: {
      and: [
        { from: 'action@ifttt.com' },
        { subject: 'Archived:' },
        { has: 'via Pocket' },
      ],
    },
    actions: exhaust.archive('pocket'),
  },
  {
    filter: {
      and: [
        { from: 'action@ifttt.com' },
        { subject: 'Favorite tweet' },
        { has: 'via Twitter' },
      ],
    },
    actions: exhaust.archive('twitter-favorites'),
  },

  // Social networks, archive automatically.
  {
    filter: {
      and: [
        { from: 'choate.edu' },
        { or: [{ subject: 'webinar' }, { subject: 'ConnectsUs Newsletter' }] },
      ],
    },
    actions: school.archive('choate'),
  },
  {
    filter: {
      or: [
        { list: '100002289.xt.local' },  // Yale Today
        { from: 'yaawebtech@yale.edu' },  // Yale Alumni Digital Events
        { from: 'weilitheyalie@yale.edu' },  // YAA News
        { from: 'alumniacademy@yale.edu' },  // Yale Alumni Academy
        { from: 'yalealumninews@yale.edu' }, // Yale Alumni News
      ],
    },
    actions: school.archive('yale'),
  },
  {
    filter: { from: 'facebookmail.com' },
    actions: social.archive('facebook'),
  },
  {
    filter: { from: 'invitations@linkedin.com' },
    actions: social.archive('linkedin'),
  },
  {
    filter: {
      and: [
        { from: 'donotreply@wordpress.com' },
        { has: 'requested that the password be reset for akshay' },
      ],
    },
    actions: social.archive('wordpress'),
  },
  {
    filter: { from: 'support@urbansitter.com' },
    actions: social.archive('urbansitter'),
  },

  // For startup founders (mostly VC newsletters).
  {
    filter: { list: 'dbca87c0c0a96a01ae10f5a13.88785.list-id.mcsv.net' },
    actions: founders,  // First Round Review
  },
  {
    filter: { from: 'newsletter@sequoiacap.com' },
    actions: founders,  // Sequoia's 7 Questions
  },
  {
    filter: { from: 'newsletter@sequoiacap.com' },
    actions: founders,  // Sequoia's 7 Questions
  },

  // Marketing, archive automatically.
  {
    filter: {
      and: [
        { from: 'email.gap.com' },
        { not: { from: 'orders@email.gap.com' } },
        { not: { from: 'GapCash' } },
      ],
    },
    actions: merchants.marketing,
  },
  {
    filter: {
      or: [
        { from: 'email.bananarepublicfactory.com' },
        { from: 'email.bananarepublic.com' },
      ],
    },
    actions: merchants.marketing,
  },
  {
    filter: { from: 'hello@kickeepants.com' },
    actions: merchants.marketing,
  },
  {
    filter: { from: 'hello@e.lululemon.com' },
    actions: merchants.marketing,
  },
  {
    filter: { from: 'hello@send.vuoriclothing.com' },
    actions: merchants.marketing,
  },
  {
    filter: { from: 'teacollection.com' },
    actions: { labels: ['optional'] },
  },
  {
    filter: { from: 'doordash.com' },
    actions: { labels: ['optional'] },
  },
  {
    filter: { list: 'grpc-io@googlegroups.com' },
    actions: code.marketing,
  },
  {
    filter: { from: 'theinformation.com' },
    actions: code.marketing,
  },
  {
    filter: { from: 'noreply@uber.com' },
    actions: { labels: ['optional'] },
  },
  {
    filter: { from: 'announcements@buf.build' },
    actions: archive,
  },
  {
    filter: { list: 'GoSF-list.meetup.com' },
    actions: code.marketing,
  },
  {
    filter: { from: 'hi@coleadership.com' },
    actions: code.marketing,
  },
  {
    filter: {
      or: [
        { from: 'ben@gitprime.com' },
        { from: 'brook@gitprime.com' },
      ],
    },
    actions: code.marketing,
  },
  {
    filter: { from: 'newsletters@angel.co' },
    actions: code.marketing,
  },

  // Newsletters.
  {
    filter: {
      and: [
        { from: 'dailydigest@ifttt.com' },
        { has: 'via RSS Feed' },
      ],
    },
    actions: {  // misc RSS feeds
      markSpam: false,
      category: 'updates',
      labels: ['optional'],
    },
  },
  {
    filter: { list: 'aeedd0ef0b39f157ce1f1e58b.435885.list-id.mcsv.net' },
    actions: {  // Why Blu Book Club
      markSpam: false,
      category: 'updates',
      labels: ['optional'],
    },
  },
  {
    filter: { list: 'f77362877d5d4b37b4acda931.211553.list-id.mcsv.net' },
    actions: code.newsletter,  // objc.io
  },
  {
    filter: { list: '4188b6afbe9e5d43111fef4d4.597133.list-id.mcsv.net' },
    actions: code.newsletter,  // The Morning Paper
  },
  {
    filter: { from: 'pointer.io' },
    actions: code.newsletter, // Pointer
  },
  {
    filter: { from: 'leaddev.com' },
    actions: code.newsletter, // LeadDev
  },
  {
    filter: {
      or: [
        { from: 'contact@golangweekly.com' },  // old
        { from: 'peter@golangweekly.com' },
      ],
    },
    actions: code.newsletter,  // Golang Weekly
  },
  {
    filter: { list: 'faa8eb4ef3a111cef92c4f3d4.583821.list-id.mcsv.net' },
    actions: code.newsletter,  // Hacker Newsletter
  },
  {
    filter: {
      or: [
        { list: '9735795484d2e4c204da82a29.26793.list-id.mcsv.net' },  // old
        { from: 'admin@pycoders.com' },
      ],
    },
    actions: code.newsletter,  // PyCoder's Weekly
  },
  {
    filter: { list: 'fd84c1c757e02889a9b08d289.122677.list-id.mcsv.net' },
    actions: code.newsletter,  // This Week in Rust
  },
  {
    filter: { list: 'ab0f46cf302c0ed836e0bf0ad.11193.list-id.mcsv.net' },
    actions: code.newsletter,  // Morning Cup of Coding
  },
  {
    filter: { list: '1a258e0fefbb23214c59c5a8d.24205.list-id.mcsv.net' },
    actions: code.newsletter,  // Software Lead Weekly
  },
  {
    filter: { from: 'zdenko@gcpweekly.com' },
    actions: code.newsletter,  // GCP Weekly
  },
  {
    filter: { list: 'c5c0614e6c57b2af2259dc51a.39919.list-id.mcsv.net' },
    actions: code.newsletter,  // Raw Signal (Johnathan & Melissa Nightingale)
  },
  {
    filter: { from: 'weekly@changelog.com' },
    actions: code.newsletter,  // Changelog Weekly
  },
  {
    filter: { from: 'swiftui-weekly@getrevue.co' },
    actions: code.newsletter,  // SwiftUI Weekly
  },
  {
    filter: { list: 'c8d8d18b6e2c6316ddc1d48a0.37209.list-id.mcsv.net' },
    actions: code.newsletter,  // Flutter Weekly
  },
  {
    filter: { list: 'matthewyglesias@substack.com' },
    actions: code.newsletter,  // Matt Yglesias: Slow Boring
  },
  {
    filter: { from: 'newsletter@roamresearch.com' },
    actions: code.newsletter,  // Roaman Times
  },
  {
    filter: { from: 'nytdirect@nytimes.com' },
    actions: code.newsletter,  // NY Times
  },
  {
    filter: { from: 'info@highergroundlabs.com' },
    actions: code.newsletter,  // Higher Ground
  },
  {
    filter: { from: 'team@theprepared.org' },
    actions: code.newsletter,  // The Prepared
  },
  {
    filter: { from: 'james@jamesclear.com' },
    actions: code.newsletter, // James Clear (Atomic Habits)
  },
  {
    filter: { from: 'members@arc.net' },
    actions: code.newsletter, // Arc browser updates
  },
  {
    filter: { from: 'news@changelog.com' },
    actions: code.newsletter, // Changelog News
  },


  // Newsgroups.
  {
    filter: { list: 'golang-announce.googlegroups.com' },
    actions: {
      category: 'forums',
      markSpam: false,
      markImportant: true,
      labels: ['code'],
    },
  },
  {
    filter: {
      or: [
        { list: 'golang-nuts.googlegroups.com' },
        { list: 'golang-dev.googlegroups.com' },
      ],
    },
    actions: code.newsgroup,
  },
  {
    filter: { list: 'go.golang.github.com' },
    actions: code.newsgroup,
  },
  {
    filter: { list: 'bazel-gazelle.bazelbuild.github.com' },
    actions: code.newsgroup,
  },
  {
    filter: { list: 'grpc-go.grpc.github.com' },
    actions: code.newsgroup,
  },
  {
    filter: { list: 'bazel-go-discuss.googlegroups.com' },
    actions: code.newsgroup,
  },
  {
    filter: { list: 'bazel.bazelbuild.github.com' },
    actions: code.newsgroup,
  },
  {
    filter: { list: 'proposal.grpc.github.com' },
    actions: code.newsgroup,
  },
  {
    filter: { list: 'rules_go.bazelbuild.github.com' },
    actions: code.newsgroup,
  },
];

{
  version: 'v1alpha3',
  author: {
    name: 'Akshay Shah',
    email: 'akshay@akshayshah.org',
  },
  labels: [
    { name: 'code' },
    { name: 'exhaust' },
    { name: 'exhaust/delayed' },
    { name: 'exhaust/myhealth' },
    { name: 'exhaust/pocket' },
    { name: 'exhaust/twitter-favorites' },
    { name: 'expenses' },
    { name: 'fam' },
    { name: 'founders' },
    { name: 'ishaan' },
    { name: 'maia' },
    { name: 'networks' },
    { name: 'networks/facebook' },
    { name: 'networks/linkedin' },
    { name: 'networks/urbansitter' },
    { name: 'networks/wordpress' },
    { name: 'optional' },
    { name: 'optional/purged' },
    { name: 'reference' },
    { name: 'schools' },
    { name: 'schools/choate' },
    { name: 'schools/pac-heights-kidz' },
    { name: 'schools/pacific-primary' },
    { name: 'schools/sfday' },
    { name: 'schools/summer' },
    { name: 'schools/yale' },
    { name: 'tax' },
    { name: 'work' },
    { name: 'work/hearsay' },
    { name: 'work/loom' },
    { name: 'work/uber' },
  ],
  rules: rules,
}
