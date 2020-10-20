import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {
  User(
      this.login,
      this.id,
      this.node_id,
      this.avatar_url,
      this.gravatar_id,
      this.url,
      this.html_url,
      this.followers_url,
      this.following_url,
      this.gists_url,
      this.starred_url,
      this.subscriptions_url,
      this.organizations_url,
      this.repos_url,
      this.events_url,
      this.received_events_url,
      this.type,
      this.site_admin,
      this.name,
      this.company,
      this.blog,
      this.location,
      this.email,
      this.starred,
      this.bio,
      this.public_repos,
      this.public_gists,
      this.followers,
      this.following,
      this.created_at,
      this.updated_at,
      this.private_gists,
      this.total_private_repos,
      this.owned_private_repos,
      this.disk_usage,
      this.collaborators,
      this.two_factor_authentication);

  String login;
  int id;
  String node_id;
  String avatar_url;
  String gravatar_id;
  String url;
  String html_url;
  String followers_url;
  String following_url;
  String gists_url;
  String starred_url;
  String subscriptions_url;
  String organizations_url;
  String repos_url;
  String events_url;
  String received_events_url;
  String type;
  bool site_admin;
  String name;
  String company;
  String blog;
  String location;
  String email;
  String starred;
  String bio;
  int public_repos;
  int public_gists;
  int followers;
  int following;
  DateTime created_at;
  DateTime updated_at;
  int private_gists;
  int total_private_repos;
  int owned_private_repos;
  int disk_usage;
  int collaborators;
  bool two_factor_authentication;


  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);


  Map<String, dynamic> toJson() => _$UserToJson(this);

  // 命名构造函数
  User.empty();

  @override
  String toString() {
    return 'User{login: $login, id: $id, node_id: $node_id, avatar_url: $avatar_url, gravatar_id: $gravatar_id, url: $url, html_url: $html_url, followers_url: $followers_url, following_url: $following_url, gists_url: $gists_url, starred_url: $starred_url, subscriptions_url: $subscriptions_url, organizations_url: $organizations_url, repos_url: $repos_url, events_url: $events_url, received_events_url: $received_events_url, type: $type, site_admin: $site_admin, name: $name, company: $company, blog: $blog, location: $location, email: $email, starred: $starred, bio: $bio, public_repos: $public_repos, public_gists: $public_gists, followers: $followers, following: $following, created_at: $created_at, updated_at: $updated_at, private_gists: $private_gists, total_private_repos: $total_private_repos, owned_private_repos: $owned_private_repos, disk_usage: $disk_usage, collaborators: $collaborators, two_factor_authentication: $two_factor_authentication}';
  }
}
