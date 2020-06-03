local lib = import 'gmailctl.libsonnet';

local me = {
  or: [
    { to: 'akshay@akshayshah.org' },
    { to: 'amazon@akshayshah.org' },
    { to: 'ashah@loom.fyi' },
    { to: 'shah@uber.com' },
  ],
};
local code = {
  newsletter: {
    markSpam: false,
    category: 'updates',
    labels: [
      'code',
      'underwater',
    ],
  },
  newsgroup: {
    markSpam: false,
    category: 'forums',
    labels: [
      'code',
      'underwater',
    ],
  },
  marketing: {
    markSpam: false,
    category: 'promotions',
    labels: [
      'code',
      'underwater',
    ],
  },
};
local founders = {
  markSpam: false,
  category: 'updates',
  labels: [
    'founders',
    'underwater',
  ],
};
local social = {
  archive(name): {
    archive: true,
    markRead: true,
    markSpam: false,
    category: 'social',
    labels: [
      'networks/%s' % name,
    ],
  },
  tag(name): {
    category: 'social',
    labels: [
      'networks/%s' % name,
    ],
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
        { from: 'pacificprimary.org' },
        { and: [{ from: 'parentsquare.com' }, { has: 'Pacific Primary' }] },
      ],
    },
    actions: {
      markSpam: false,
      category: 'forums',
      labels: [
        'schools/pacific-primary',
      ],
    },
  },
  {
    filter: {
      or: [
        { from: 'belann@pacificprimary.org' },
        { from: 'Belann Giaretto via ParentSquare' },
      ],
    },
    actions: {
      markImportant: true,
    },
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

  // Chatty or self-produced email, archive automatically.
  {
    filter: { to: 'later@akshayshah.org' },
    actions: exhaust.archive('delayed'),
  },
  {
    filter: {
      and: [
        { from: 'DONOTREPLY@myhealth.stanfordhealthcare.org' },
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
    filter: { list: '100002289.xt.local' },
    actions: social.archive('yale'),  // Yale Today
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

  // Marketing, archive automatically.
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
      labels: ['underwater'],
    },
  },
  {
    filter: { list: 'aeedd0ef0b39f157ce1f1e58b.435885.list-id.mcsv.net' },
    actions: {  // Why Blu Book Club
      markSpam: false,
      category: 'updates',
      labels: ['underwater'],
    },
  },
  {
    filter: { list: '4188b6afbe9e5d43111fef4d4.597133.list-id.mcsv.net' },
    actions: code.newsletter,  // The Morning Paper
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
    { name: 'founders' },
    { name: 'networks' },
    { name: 'networks/facebook' },
    { name: 'networks/linkedin' },
    { name: 'networks/urbansitter' },
    { name: 'networks/wordpress' },
    { name: 'networks/yale' },
    { name: 'schools' },
    { name: 'schools/pacific-primary' },
    { name: 'tax' },
    { name: 'underwater' },
    { name: 'work' },
    { name: 'work/hearsay' },
    { name: 'work/loom' },
    { name: 'work/uber' },
  ],
  rules: rules,
}
