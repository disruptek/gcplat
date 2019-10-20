
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud SQL Admin
## version: v1beta4
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates and manages Cloud SQL instances, which provide fully managed MySQL or PostgreSQL databases.
## 
## https://cloud.google.com/sql/docs/reference/latest
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "sqladmin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SqlFlagsList_578618 = ref object of OpenApiRestCall_578348
proc url_SqlFlagsList_578620(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SqlFlagsList_578619(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all available database flags for Cloud SQL instances.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   databaseVersion: JString
  ##                  : Database type and version you want to retrieve flags for. By default, this method returns flags for all database types and versions.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578732 = query.getOrDefault("key")
  valid_578732 = validateParameter(valid_578732, JString, required = false,
                                 default = nil)
  if valid_578732 != nil:
    section.add "key", valid_578732
  var valid_578746 = query.getOrDefault("prettyPrint")
  valid_578746 = validateParameter(valid_578746, JBool, required = false,
                                 default = newJBool(true))
  if valid_578746 != nil:
    section.add "prettyPrint", valid_578746
  var valid_578747 = query.getOrDefault("oauth_token")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "oauth_token", valid_578747
  var valid_578748 = query.getOrDefault("alt")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = newJString("json"))
  if valid_578748 != nil:
    section.add "alt", valid_578748
  var valid_578749 = query.getOrDefault("userIp")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "userIp", valid_578749
  var valid_578750 = query.getOrDefault("databaseVersion")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "databaseVersion", valid_578750
  var valid_578751 = query.getOrDefault("quotaUser")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "quotaUser", valid_578751
  var valid_578752 = query.getOrDefault("fields")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "fields", valid_578752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578775: Call_SqlFlagsList_578618; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all available database flags for Cloud SQL instances.
  ## 
  let valid = call_578775.validator(path, query, header, formData, body)
  let scheme = call_578775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578775.url(scheme.get, call_578775.host, call_578775.base,
                         call_578775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578775, url, valid)

proc call*(call_578846: Call_SqlFlagsList_578618; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; databaseVersion: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## sqlFlagsList
  ## List all available database flags for Cloud SQL instances.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   databaseVersion: string
  ##                  : Database type and version you want to retrieve flags for. By default, this method returns flags for all database types and versions.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578847 = newJObject()
  add(query_578847, "key", newJString(key))
  add(query_578847, "prettyPrint", newJBool(prettyPrint))
  add(query_578847, "oauth_token", newJString(oauthToken))
  add(query_578847, "alt", newJString(alt))
  add(query_578847, "userIp", newJString(userIp))
  add(query_578847, "databaseVersion", newJString(databaseVersion))
  add(query_578847, "quotaUser", newJString(quotaUser))
  add(query_578847, "fields", newJString(fields))
  result = call_578846.call(nil, query_578847, nil, nil, nil)

var sqlFlagsList* = Call_SqlFlagsList_578618(name: "sqlFlagsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/flags",
    validator: validate_SqlFlagsList_578619, base: "/sql/v1beta4",
    url: url_SqlFlagsList_578620, schemes: {Scheme.Https})
type
  Call_SqlInstancesInsert_578919 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesInsert_578921(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesInsert_578920(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project to which the newly created Cloud SQL instances should belong.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578922 = path.getOrDefault("project")
  valid_578922 = validateParameter(valid_578922, JString, required = true,
                                 default = nil)
  if valid_578922 != nil:
    section.add "project", valid_578922
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578923 = query.getOrDefault("key")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "key", valid_578923
  var valid_578924 = query.getOrDefault("prettyPrint")
  valid_578924 = validateParameter(valid_578924, JBool, required = false,
                                 default = newJBool(true))
  if valid_578924 != nil:
    section.add "prettyPrint", valid_578924
  var valid_578925 = query.getOrDefault("oauth_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "oauth_token", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("userIp")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "userIp", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("fields")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "fields", valid_578929
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578931: Call_SqlInstancesInsert_578919; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Cloud SQL instance.
  ## 
  let valid = call_578931.validator(path, query, header, formData, body)
  let scheme = call_578931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578931.url(scheme.get, call_578931.host, call_578931.base,
                         call_578931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578931, url, valid)

proc call*(call_578932: Call_SqlInstancesInsert_578919; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesInsert
  ## Creates a new Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Project ID of the project to which the newly created Cloud SQL instances should belong.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578933 = newJObject()
  var query_578934 = newJObject()
  var body_578935 = newJObject()
  add(query_578934, "key", newJString(key))
  add(query_578934, "prettyPrint", newJBool(prettyPrint))
  add(query_578934, "oauth_token", newJString(oauthToken))
  add(query_578934, "alt", newJString(alt))
  add(query_578934, "userIp", newJString(userIp))
  add(query_578934, "quotaUser", newJString(quotaUser))
  add(path_578933, "project", newJString(project))
  if body != nil:
    body_578935 = body
  add(query_578934, "fields", newJString(fields))
  result = call_578932.call(path_578933, query_578934, nil, nil, body_578935)

var sqlInstancesInsert* = Call_SqlInstancesInsert_578919(
    name: "sqlInstancesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{project}/instances",
    validator: validate_SqlInstancesInsert_578920, base: "/sql/v1beta4",
    url: url_SqlInstancesInsert_578921, schemes: {Scheme.Https})
type
  Call_SqlInstancesList_578887 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesList_578889(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesList_578888(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists instances under a given project in the alphabetical order of the instance name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project for which to list Cloud SQL instances.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578904 = path.getOrDefault("project")
  valid_578904 = validateParameter(valid_578904, JString, required = true,
                                 default = nil)
  if valid_578904 != nil:
    section.add "project", valid_578904
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filter: JString
  ##         : An expression for filtering the results of the request, such as by name or label.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results to return per response.
  section = newJObject()
  var valid_578905 = query.getOrDefault("key")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "key", valid_578905
  var valid_578906 = query.getOrDefault("prettyPrint")
  valid_578906 = validateParameter(valid_578906, JBool, required = false,
                                 default = newJBool(true))
  if valid_578906 != nil:
    section.add "prettyPrint", valid_578906
  var valid_578907 = query.getOrDefault("oauth_token")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "oauth_token", valid_578907
  var valid_578908 = query.getOrDefault("alt")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("json"))
  if valid_578908 != nil:
    section.add "alt", valid_578908
  var valid_578909 = query.getOrDefault("userIp")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "userIp", valid_578909
  var valid_578910 = query.getOrDefault("quotaUser")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "quotaUser", valid_578910
  var valid_578911 = query.getOrDefault("filter")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "filter", valid_578911
  var valid_578912 = query.getOrDefault("pageToken")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "pageToken", valid_578912
  var valid_578913 = query.getOrDefault("fields")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "fields", valid_578913
  var valid_578914 = query.getOrDefault("maxResults")
  valid_578914 = validateParameter(valid_578914, JInt, required = false, default = nil)
  if valid_578914 != nil:
    section.add "maxResults", valid_578914
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578915: Call_SqlInstancesList_578887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists instances under a given project in the alphabetical order of the instance name.
  ## 
  let valid = call_578915.validator(path, query, header, formData, body)
  let scheme = call_578915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578915.url(scheme.get, call_578915.host, call_578915.base,
                         call_578915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578915, url, valid)

proc call*(call_578916: Call_SqlInstancesList_578887; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## sqlInstancesList
  ## Lists instances under a given project in the alphabetical order of the instance name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filter: string
  ##         : An expression for filtering the results of the request, such as by name or label.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   project: string (required)
  ##          : Project ID of the project for which to list Cloud SQL instances.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results to return per response.
  var path_578917 = newJObject()
  var query_578918 = newJObject()
  add(query_578918, "key", newJString(key))
  add(query_578918, "prettyPrint", newJBool(prettyPrint))
  add(query_578918, "oauth_token", newJString(oauthToken))
  add(query_578918, "alt", newJString(alt))
  add(query_578918, "userIp", newJString(userIp))
  add(query_578918, "quotaUser", newJString(quotaUser))
  add(query_578918, "filter", newJString(filter))
  add(query_578918, "pageToken", newJString(pageToken))
  add(path_578917, "project", newJString(project))
  add(query_578918, "fields", newJString(fields))
  add(query_578918, "maxResults", newJInt(maxResults))
  result = call_578916.call(path_578917, query_578918, nil, nil, nil)

var sqlInstancesList* = Call_SqlInstancesList_578887(name: "sqlInstancesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances", validator: validate_SqlInstancesList_578888,
    base: "/sql/v1beta4", url: url_SqlInstancesList_578889, schemes: {Scheme.Https})
type
  Call_SqlInstancesUpdate_578952 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesUpdate_578954(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesUpdate_578953(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_578955 = path.getOrDefault("instance")
  valid_578955 = validateParameter(valid_578955, JString, required = true,
                                 default = nil)
  if valid_578955 != nil:
    section.add "instance", valid_578955
  var valid_578956 = path.getOrDefault("project")
  valid_578956 = validateParameter(valid_578956, JString, required = true,
                                 default = nil)
  if valid_578956 != nil:
    section.add "project", valid_578956
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578957 = query.getOrDefault("key")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "key", valid_578957
  var valid_578958 = query.getOrDefault("prettyPrint")
  valid_578958 = validateParameter(valid_578958, JBool, required = false,
                                 default = newJBool(true))
  if valid_578958 != nil:
    section.add "prettyPrint", valid_578958
  var valid_578959 = query.getOrDefault("oauth_token")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "oauth_token", valid_578959
  var valid_578960 = query.getOrDefault("alt")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("json"))
  if valid_578960 != nil:
    section.add "alt", valid_578960
  var valid_578961 = query.getOrDefault("userIp")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "userIp", valid_578961
  var valid_578962 = query.getOrDefault("quotaUser")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "quotaUser", valid_578962
  var valid_578963 = query.getOrDefault("fields")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "fields", valid_578963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578965: Call_SqlInstancesUpdate_578952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.
  ## 
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_SqlInstancesUpdate_578952; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesUpdate
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578967 = newJObject()
  var query_578968 = newJObject()
  var body_578969 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "userIp", newJString(userIp))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(path_578967, "instance", newJString(instance))
  add(path_578967, "project", newJString(project))
  if body != nil:
    body_578969 = body
  add(query_578968, "fields", newJString(fields))
  result = call_578966.call(path_578967, query_578968, nil, nil, body_578969)

var sqlInstancesUpdate* = Call_SqlInstancesUpdate_578952(
    name: "sqlInstancesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesUpdate_578953, base: "/sql/v1beta4",
    url: url_SqlInstancesUpdate_578954, schemes: {Scheme.Https})
type
  Call_SqlInstancesGet_578936 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesGet_578938(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesGet_578937(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves a resource containing information about a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_578939 = path.getOrDefault("instance")
  valid_578939 = validateParameter(valid_578939, JString, required = true,
                                 default = nil)
  if valid_578939 != nil:
    section.add "instance", valid_578939
  var valid_578940 = path.getOrDefault("project")
  valid_578940 = validateParameter(valid_578940, JString, required = true,
                                 default = nil)
  if valid_578940 != nil:
    section.add "project", valid_578940
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578941 = query.getOrDefault("key")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "key", valid_578941
  var valid_578942 = query.getOrDefault("prettyPrint")
  valid_578942 = validateParameter(valid_578942, JBool, required = false,
                                 default = newJBool(true))
  if valid_578942 != nil:
    section.add "prettyPrint", valid_578942
  var valid_578943 = query.getOrDefault("oauth_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "oauth_token", valid_578943
  var valid_578944 = query.getOrDefault("alt")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("json"))
  if valid_578944 != nil:
    section.add "alt", valid_578944
  var valid_578945 = query.getOrDefault("userIp")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "userIp", valid_578945
  var valid_578946 = query.getOrDefault("quotaUser")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "quotaUser", valid_578946
  var valid_578947 = query.getOrDefault("fields")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "fields", valid_578947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578948: Call_SqlInstancesGet_578936; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a Cloud SQL instance.
  ## 
  let valid = call_578948.validator(path, query, header, formData, body)
  let scheme = call_578948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578948.url(scheme.get, call_578948.host, call_578948.base,
                         call_578948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578948, url, valid)

proc call*(call_578949: Call_SqlInstancesGet_578936; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesGet
  ## Retrieves a resource containing information about a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578950 = newJObject()
  var query_578951 = newJObject()
  add(query_578951, "key", newJString(key))
  add(query_578951, "prettyPrint", newJBool(prettyPrint))
  add(query_578951, "oauth_token", newJString(oauthToken))
  add(query_578951, "alt", newJString(alt))
  add(query_578951, "userIp", newJString(userIp))
  add(query_578951, "quotaUser", newJString(quotaUser))
  add(path_578950, "instance", newJString(instance))
  add(path_578950, "project", newJString(project))
  add(query_578951, "fields", newJString(fields))
  result = call_578949.call(path_578950, query_578951, nil, nil, nil)

var sqlInstancesGet* = Call_SqlInstancesGet_578936(name: "sqlInstancesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesGet_578937, base: "/sql/v1beta4",
    url: url_SqlInstancesGet_578938, schemes: {Scheme.Https})
type
  Call_SqlInstancesPatch_578986 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesPatch_578988(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesPatch_578987(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_578989 = path.getOrDefault("instance")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "instance", valid_578989
  var valid_578990 = path.getOrDefault("project")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "project", valid_578990
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578991 = query.getOrDefault("key")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "key", valid_578991
  var valid_578992 = query.getOrDefault("prettyPrint")
  valid_578992 = validateParameter(valid_578992, JBool, required = false,
                                 default = newJBool(true))
  if valid_578992 != nil:
    section.add "prettyPrint", valid_578992
  var valid_578993 = query.getOrDefault("oauth_token")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "oauth_token", valid_578993
  var valid_578994 = query.getOrDefault("alt")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = newJString("json"))
  if valid_578994 != nil:
    section.add "alt", valid_578994
  var valid_578995 = query.getOrDefault("userIp")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "userIp", valid_578995
  var valid_578996 = query.getOrDefault("quotaUser")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "quotaUser", valid_578996
  var valid_578997 = query.getOrDefault("fields")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "fields", valid_578997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578999: Call_SqlInstancesPatch_578986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.. This method supports patch semantics.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_SqlInstancesPatch_578986; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesPatch
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579001 = newJObject()
  var query_579002 = newJObject()
  var body_579003 = newJObject()
  add(query_579002, "key", newJString(key))
  add(query_579002, "prettyPrint", newJBool(prettyPrint))
  add(query_579002, "oauth_token", newJString(oauthToken))
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "userIp", newJString(userIp))
  add(query_579002, "quotaUser", newJString(quotaUser))
  add(path_579001, "instance", newJString(instance))
  add(path_579001, "project", newJString(project))
  if body != nil:
    body_579003 = body
  add(query_579002, "fields", newJString(fields))
  result = call_579000.call(path_579001, query_579002, nil, nil, body_579003)

var sqlInstancesPatch* = Call_SqlInstancesPatch_578986(name: "sqlInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesPatch_578987, base: "/sql/v1beta4",
    url: url_SqlInstancesPatch_578988, schemes: {Scheme.Https})
type
  Call_SqlInstancesDelete_578970 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesDelete_578972(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesDelete_578971(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_578973 = path.getOrDefault("instance")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "instance", valid_578973
  var valid_578974 = path.getOrDefault("project")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "project", valid_578974
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578975 = query.getOrDefault("key")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "key", valid_578975
  var valid_578976 = query.getOrDefault("prettyPrint")
  valid_578976 = validateParameter(valid_578976, JBool, required = false,
                                 default = newJBool(true))
  if valid_578976 != nil:
    section.add "prettyPrint", valid_578976
  var valid_578977 = query.getOrDefault("oauth_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "oauth_token", valid_578977
  var valid_578978 = query.getOrDefault("alt")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("json"))
  if valid_578978 != nil:
    section.add "alt", valid_578978
  var valid_578979 = query.getOrDefault("userIp")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "userIp", valid_578979
  var valid_578980 = query.getOrDefault("quotaUser")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "quotaUser", valid_578980
  var valid_578981 = query.getOrDefault("fields")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "fields", valid_578981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578982: Call_SqlInstancesDelete_578970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cloud SQL instance.
  ## 
  let valid = call_578982.validator(path, query, header, formData, body)
  let scheme = call_578982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578982.url(scheme.get, call_578982.host, call_578982.base,
                         call_578982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578982, url, valid)

proc call*(call_578983: Call_SqlInstancesDelete_578970; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesDelete
  ## Deletes a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578984 = newJObject()
  var query_578985 = newJObject()
  add(query_578985, "key", newJString(key))
  add(query_578985, "prettyPrint", newJBool(prettyPrint))
  add(query_578985, "oauth_token", newJString(oauthToken))
  add(query_578985, "alt", newJString(alt))
  add(query_578985, "userIp", newJString(userIp))
  add(query_578985, "quotaUser", newJString(quotaUser))
  add(path_578984, "instance", newJString(instance))
  add(path_578984, "project", newJString(project))
  add(query_578985, "fields", newJString(fields))
  result = call_578983.call(path_578984, query_578985, nil, nil, nil)

var sqlInstancesDelete* = Call_SqlInstancesDelete_578970(
    name: "sqlInstancesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesDelete_578971, base: "/sql/v1beta4",
    url: url_SqlInstancesDelete_578972, schemes: {Scheme.Https})
type
  Call_SqlInstancesAddServerCa_579004 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesAddServerCa_579006(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/addServerCa")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesAddServerCa_579005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new trusted Certificate Authority (CA) version for the specified instance. Required to prepare for a certificate rotation. If a CA version was previously added but never used in a certificate rotation, this operation replaces that version. There cannot be more than one CA version waiting to be rotated in.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579007 = path.getOrDefault("instance")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "instance", valid_579007
  var valid_579008 = path.getOrDefault("project")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "project", valid_579008
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579009 = query.getOrDefault("key")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "key", valid_579009
  var valid_579010 = query.getOrDefault("prettyPrint")
  valid_579010 = validateParameter(valid_579010, JBool, required = false,
                                 default = newJBool(true))
  if valid_579010 != nil:
    section.add "prettyPrint", valid_579010
  var valid_579011 = query.getOrDefault("oauth_token")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "oauth_token", valid_579011
  var valid_579012 = query.getOrDefault("alt")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("json"))
  if valid_579012 != nil:
    section.add "alt", valid_579012
  var valid_579013 = query.getOrDefault("userIp")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "userIp", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("fields")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "fields", valid_579015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579016: Call_SqlInstancesAddServerCa_579004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new trusted Certificate Authority (CA) version for the specified instance. Required to prepare for a certificate rotation. If a CA version was previously added but never used in a certificate rotation, this operation replaces that version. There cannot be more than one CA version waiting to be rotated in.
  ## 
  let valid = call_579016.validator(path, query, header, formData, body)
  let scheme = call_579016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579016.url(scheme.get, call_579016.host, call_579016.base,
                         call_579016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579016, url, valid)

proc call*(call_579017: Call_SqlInstancesAddServerCa_579004; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesAddServerCa
  ## Add a new trusted Certificate Authority (CA) version for the specified instance. Required to prepare for a certificate rotation. If a CA version was previously added but never used in a certificate rotation, this operation replaces that version. There cannot be more than one CA version waiting to be rotated in.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579018 = newJObject()
  var query_579019 = newJObject()
  add(query_579019, "key", newJString(key))
  add(query_579019, "prettyPrint", newJBool(prettyPrint))
  add(query_579019, "oauth_token", newJString(oauthToken))
  add(query_579019, "alt", newJString(alt))
  add(query_579019, "userIp", newJString(userIp))
  add(query_579019, "quotaUser", newJString(quotaUser))
  add(path_579018, "instance", newJString(instance))
  add(path_579018, "project", newJString(project))
  add(query_579019, "fields", newJString(fields))
  result = call_579017.call(path_579018, query_579019, nil, nil, nil)

var sqlInstancesAddServerCa* = Call_SqlInstancesAddServerCa_579004(
    name: "sqlInstancesAddServerCa", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/addServerCa",
    validator: validate_SqlInstancesAddServerCa_579005, base: "/sql/v1beta4",
    url: url_SqlInstancesAddServerCa_579006, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsInsert_579038 = ref object of OpenApiRestCall_578348
proc url_SqlBackupRunsInsert_579040(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/backupRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlBackupRunsInsert_579039(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new backup run on demand. This method is applicable only to Second Generation instances.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579041 = path.getOrDefault("instance")
  valid_579041 = validateParameter(valid_579041, JString, required = true,
                                 default = nil)
  if valid_579041 != nil:
    section.add "instance", valid_579041
  var valid_579042 = path.getOrDefault("project")
  valid_579042 = validateParameter(valid_579042, JString, required = true,
                                 default = nil)
  if valid_579042 != nil:
    section.add "project", valid_579042
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579043 = query.getOrDefault("key")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "key", valid_579043
  var valid_579044 = query.getOrDefault("prettyPrint")
  valid_579044 = validateParameter(valid_579044, JBool, required = false,
                                 default = newJBool(true))
  if valid_579044 != nil:
    section.add "prettyPrint", valid_579044
  var valid_579045 = query.getOrDefault("oauth_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "oauth_token", valid_579045
  var valid_579046 = query.getOrDefault("alt")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("json"))
  if valid_579046 != nil:
    section.add "alt", valid_579046
  var valid_579047 = query.getOrDefault("userIp")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "userIp", valid_579047
  var valid_579048 = query.getOrDefault("quotaUser")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "quotaUser", valid_579048
  var valid_579049 = query.getOrDefault("fields")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "fields", valid_579049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579051: Call_SqlBackupRunsInsert_579038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new backup run on demand. This method is applicable only to Second Generation instances.
  ## 
  let valid = call_579051.validator(path, query, header, formData, body)
  let scheme = call_579051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579051.url(scheme.get, call_579051.host, call_579051.base,
                         call_579051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579051, url, valid)

proc call*(call_579052: Call_SqlBackupRunsInsert_579038; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlBackupRunsInsert
  ## Creates a new backup run on demand. This method is applicable only to Second Generation instances.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579053 = newJObject()
  var query_579054 = newJObject()
  var body_579055 = newJObject()
  add(query_579054, "key", newJString(key))
  add(query_579054, "prettyPrint", newJBool(prettyPrint))
  add(query_579054, "oauth_token", newJString(oauthToken))
  add(query_579054, "alt", newJString(alt))
  add(query_579054, "userIp", newJString(userIp))
  add(query_579054, "quotaUser", newJString(quotaUser))
  add(path_579053, "instance", newJString(instance))
  add(path_579053, "project", newJString(project))
  if body != nil:
    body_579055 = body
  add(query_579054, "fields", newJString(fields))
  result = call_579052.call(path_579053, query_579054, nil, nil, body_579055)

var sqlBackupRunsInsert* = Call_SqlBackupRunsInsert_579038(
    name: "sqlBackupRunsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsInsert_579039, base: "/sql/v1beta4",
    url: url_SqlBackupRunsInsert_579040, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsList_579020 = ref object of OpenApiRestCall_578348
proc url_SqlBackupRunsList_579022(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/backupRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlBackupRunsList_579021(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all backup runs associated with a given instance and configuration in the reverse chronological order of the backup initiation time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579023 = path.getOrDefault("instance")
  valid_579023 = validateParameter(valid_579023, JString, required = true,
                                 default = nil)
  if valid_579023 != nil:
    section.add "instance", valid_579023
  var valid_579024 = path.getOrDefault("project")
  valid_579024 = validateParameter(valid_579024, JString, required = true,
                                 default = nil)
  if valid_579024 != nil:
    section.add "project", valid_579024
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of backup runs per response.
  section = newJObject()
  var valid_579025 = query.getOrDefault("key")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "key", valid_579025
  var valid_579026 = query.getOrDefault("prettyPrint")
  valid_579026 = validateParameter(valid_579026, JBool, required = false,
                                 default = newJBool(true))
  if valid_579026 != nil:
    section.add "prettyPrint", valid_579026
  var valid_579027 = query.getOrDefault("oauth_token")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "oauth_token", valid_579027
  var valid_579028 = query.getOrDefault("alt")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = newJString("json"))
  if valid_579028 != nil:
    section.add "alt", valid_579028
  var valid_579029 = query.getOrDefault("userIp")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "userIp", valid_579029
  var valid_579030 = query.getOrDefault("quotaUser")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "quotaUser", valid_579030
  var valid_579031 = query.getOrDefault("pageToken")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "pageToken", valid_579031
  var valid_579032 = query.getOrDefault("fields")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "fields", valid_579032
  var valid_579033 = query.getOrDefault("maxResults")
  valid_579033 = validateParameter(valid_579033, JInt, required = false, default = nil)
  if valid_579033 != nil:
    section.add "maxResults", valid_579033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579034: Call_SqlBackupRunsList_579020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all backup runs associated with a given instance and configuration in the reverse chronological order of the backup initiation time.
  ## 
  let valid = call_579034.validator(path, query, header, formData, body)
  let scheme = call_579034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579034.url(scheme.get, call_579034.host, call_579034.base,
                         call_579034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579034, url, valid)

proc call*(call_579035: Call_SqlBackupRunsList_579020; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## sqlBackupRunsList
  ## Lists all backup runs associated with a given instance and configuration in the reverse chronological order of the backup initiation time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of backup runs per response.
  var path_579036 = newJObject()
  var query_579037 = newJObject()
  add(query_579037, "key", newJString(key))
  add(query_579037, "prettyPrint", newJBool(prettyPrint))
  add(query_579037, "oauth_token", newJString(oauthToken))
  add(query_579037, "alt", newJString(alt))
  add(query_579037, "userIp", newJString(userIp))
  add(query_579037, "quotaUser", newJString(quotaUser))
  add(query_579037, "pageToken", newJString(pageToken))
  add(path_579036, "instance", newJString(instance))
  add(path_579036, "project", newJString(project))
  add(query_579037, "fields", newJString(fields))
  add(query_579037, "maxResults", newJInt(maxResults))
  result = call_579035.call(path_579036, query_579037, nil, nil, nil)

var sqlBackupRunsList* = Call_SqlBackupRunsList_579020(name: "sqlBackupRunsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsList_579021, base: "/sql/v1beta4",
    url: url_SqlBackupRunsList_579022, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsGet_579056 = ref object of OpenApiRestCall_578348
proc url_SqlBackupRunsGet_579058(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/backupRuns/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlBackupRunsGet_579057(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves a resource containing information about a backup run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of this Backup Run.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579059 = path.getOrDefault("id")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "id", valid_579059
  var valid_579060 = path.getOrDefault("instance")
  valid_579060 = validateParameter(valid_579060, JString, required = true,
                                 default = nil)
  if valid_579060 != nil:
    section.add "instance", valid_579060
  var valid_579061 = path.getOrDefault("project")
  valid_579061 = validateParameter(valid_579061, JString, required = true,
                                 default = nil)
  if valid_579061 != nil:
    section.add "project", valid_579061
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579062 = query.getOrDefault("key")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "key", valid_579062
  var valid_579063 = query.getOrDefault("prettyPrint")
  valid_579063 = validateParameter(valid_579063, JBool, required = false,
                                 default = newJBool(true))
  if valid_579063 != nil:
    section.add "prettyPrint", valid_579063
  var valid_579064 = query.getOrDefault("oauth_token")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "oauth_token", valid_579064
  var valid_579065 = query.getOrDefault("alt")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = newJString("json"))
  if valid_579065 != nil:
    section.add "alt", valid_579065
  var valid_579066 = query.getOrDefault("userIp")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "userIp", valid_579066
  var valid_579067 = query.getOrDefault("quotaUser")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "quotaUser", valid_579067
  var valid_579068 = query.getOrDefault("fields")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "fields", valid_579068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579069: Call_SqlBackupRunsGet_579056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a backup run.
  ## 
  let valid = call_579069.validator(path, query, header, formData, body)
  let scheme = call_579069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579069.url(scheme.get, call_579069.host, call_579069.base,
                         call_579069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579069, url, valid)

proc call*(call_579070: Call_SqlBackupRunsGet_579056; id: string; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlBackupRunsGet
  ## Retrieves a resource containing information about a backup run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of this Backup Run.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579071 = newJObject()
  var query_579072 = newJObject()
  add(query_579072, "key", newJString(key))
  add(query_579072, "prettyPrint", newJBool(prettyPrint))
  add(query_579072, "oauth_token", newJString(oauthToken))
  add(path_579071, "id", newJString(id))
  add(query_579072, "alt", newJString(alt))
  add(query_579072, "userIp", newJString(userIp))
  add(query_579072, "quotaUser", newJString(quotaUser))
  add(path_579071, "instance", newJString(instance))
  add(path_579071, "project", newJString(project))
  add(query_579072, "fields", newJString(fields))
  result = call_579070.call(path_579071, query_579072, nil, nil, nil)

var sqlBackupRunsGet* = Call_SqlBackupRunsGet_579056(name: "sqlBackupRunsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns/{id}",
    validator: validate_SqlBackupRunsGet_579057, base: "/sql/v1beta4",
    url: url_SqlBackupRunsGet_579058, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsDelete_579073 = ref object of OpenApiRestCall_578348
proc url_SqlBackupRunsDelete_579075(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/backupRuns/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlBackupRunsDelete_579074(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the backup taken by a backup run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the Backup Run to delete. To find a Backup Run ID, use the list method.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_579076 = path.getOrDefault("id")
  valid_579076 = validateParameter(valid_579076, JString, required = true,
                                 default = nil)
  if valid_579076 != nil:
    section.add "id", valid_579076
  var valid_579077 = path.getOrDefault("instance")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "instance", valid_579077
  var valid_579078 = path.getOrDefault("project")
  valid_579078 = validateParameter(valid_579078, JString, required = true,
                                 default = nil)
  if valid_579078 != nil:
    section.add "project", valid_579078
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579079 = query.getOrDefault("key")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "key", valid_579079
  var valid_579080 = query.getOrDefault("prettyPrint")
  valid_579080 = validateParameter(valid_579080, JBool, required = false,
                                 default = newJBool(true))
  if valid_579080 != nil:
    section.add "prettyPrint", valid_579080
  var valid_579081 = query.getOrDefault("oauth_token")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "oauth_token", valid_579081
  var valid_579082 = query.getOrDefault("alt")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("json"))
  if valid_579082 != nil:
    section.add "alt", valid_579082
  var valid_579083 = query.getOrDefault("userIp")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "userIp", valid_579083
  var valid_579084 = query.getOrDefault("quotaUser")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "quotaUser", valid_579084
  var valid_579085 = query.getOrDefault("fields")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "fields", valid_579085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579086: Call_SqlBackupRunsDelete_579073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup taken by a backup run.
  ## 
  let valid = call_579086.validator(path, query, header, formData, body)
  let scheme = call_579086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579086.url(scheme.get, call_579086.host, call_579086.base,
                         call_579086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579086, url, valid)

proc call*(call_579087: Call_SqlBackupRunsDelete_579073; id: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlBackupRunsDelete
  ## Deletes the backup taken by a backup run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   id: string (required)
  ##     : The ID of the Backup Run to delete. To find a Backup Run ID, use the list method.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579088 = newJObject()
  var query_579089 = newJObject()
  add(query_579089, "key", newJString(key))
  add(query_579089, "prettyPrint", newJBool(prettyPrint))
  add(query_579089, "oauth_token", newJString(oauthToken))
  add(path_579088, "id", newJString(id))
  add(query_579089, "alt", newJString(alt))
  add(query_579089, "userIp", newJString(userIp))
  add(query_579089, "quotaUser", newJString(quotaUser))
  add(path_579088, "instance", newJString(instance))
  add(path_579088, "project", newJString(project))
  add(query_579089, "fields", newJString(fields))
  result = call_579087.call(path_579088, query_579089, nil, nil, nil)

var sqlBackupRunsDelete* = Call_SqlBackupRunsDelete_579073(
    name: "sqlBackupRunsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns/{id}",
    validator: validate_SqlBackupRunsDelete_579074, base: "/sql/v1beta4",
    url: url_SqlBackupRunsDelete_579075, schemes: {Scheme.Https})
type
  Call_SqlInstancesClone_579090 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesClone_579092(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/clone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesClone_579091(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a Cloud SQL instance as a clone of the source instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : The ID of the Cloud SQL instance to be cloned (source). This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the source as well as the clone Cloud SQL instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579093 = path.getOrDefault("instance")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "instance", valid_579093
  var valid_579094 = path.getOrDefault("project")
  valid_579094 = validateParameter(valid_579094, JString, required = true,
                                 default = nil)
  if valid_579094 != nil:
    section.add "project", valid_579094
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579095 = query.getOrDefault("key")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "key", valid_579095
  var valid_579096 = query.getOrDefault("prettyPrint")
  valid_579096 = validateParameter(valid_579096, JBool, required = false,
                                 default = newJBool(true))
  if valid_579096 != nil:
    section.add "prettyPrint", valid_579096
  var valid_579097 = query.getOrDefault("oauth_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "oauth_token", valid_579097
  var valid_579098 = query.getOrDefault("alt")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = newJString("json"))
  if valid_579098 != nil:
    section.add "alt", valid_579098
  var valid_579099 = query.getOrDefault("userIp")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "userIp", valid_579099
  var valid_579100 = query.getOrDefault("quotaUser")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "quotaUser", valid_579100
  var valid_579101 = query.getOrDefault("fields")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "fields", valid_579101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579103: Call_SqlInstancesClone_579090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud SQL instance as a clone of the source instance.
  ## 
  let valid = call_579103.validator(path, query, header, formData, body)
  let scheme = call_579103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579103.url(scheme.get, call_579103.host, call_579103.base,
                         call_579103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579103, url, valid)

proc call*(call_579104: Call_SqlInstancesClone_579090; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesClone
  ## Creates a Cloud SQL instance as a clone of the source instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : The ID of the Cloud SQL instance to be cloned (source). This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the source as well as the clone Cloud SQL instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579105 = newJObject()
  var query_579106 = newJObject()
  var body_579107 = newJObject()
  add(query_579106, "key", newJString(key))
  add(query_579106, "prettyPrint", newJBool(prettyPrint))
  add(query_579106, "oauth_token", newJString(oauthToken))
  add(query_579106, "alt", newJString(alt))
  add(query_579106, "userIp", newJString(userIp))
  add(query_579106, "quotaUser", newJString(quotaUser))
  add(path_579105, "instance", newJString(instance))
  add(path_579105, "project", newJString(project))
  if body != nil:
    body_579107 = body
  add(query_579106, "fields", newJString(fields))
  result = call_579104.call(path_579105, query_579106, nil, nil, body_579107)

var sqlInstancesClone* = Call_SqlInstancesClone_579090(name: "sqlInstancesClone",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/clone",
    validator: validate_SqlInstancesClone_579091, base: "/sql/v1beta4",
    url: url_SqlInstancesClone_579092, schemes: {Scheme.Https})
type
  Call_SqlSslCertsCreateEphemeral_579108 = ref object of OpenApiRestCall_578348
proc url_SqlSslCertsCreateEphemeral_579110(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/createEphemeral")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlSslCertsCreateEphemeral_579109(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a short-lived X509 certificate containing the provided public key and signed by a private key specific to the target instance. Users may use the certificate to authenticate as themselves when connecting to the database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the Cloud SQL project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579111 = path.getOrDefault("instance")
  valid_579111 = validateParameter(valid_579111, JString, required = true,
                                 default = nil)
  if valid_579111 != nil:
    section.add "instance", valid_579111
  var valid_579112 = path.getOrDefault("project")
  valid_579112 = validateParameter(valid_579112, JString, required = true,
                                 default = nil)
  if valid_579112 != nil:
    section.add "project", valid_579112
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579113 = query.getOrDefault("key")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "key", valid_579113
  var valid_579114 = query.getOrDefault("prettyPrint")
  valid_579114 = validateParameter(valid_579114, JBool, required = false,
                                 default = newJBool(true))
  if valid_579114 != nil:
    section.add "prettyPrint", valid_579114
  var valid_579115 = query.getOrDefault("oauth_token")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "oauth_token", valid_579115
  var valid_579116 = query.getOrDefault("alt")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = newJString("json"))
  if valid_579116 != nil:
    section.add "alt", valid_579116
  var valid_579117 = query.getOrDefault("userIp")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "userIp", valid_579117
  var valid_579118 = query.getOrDefault("quotaUser")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "quotaUser", valid_579118
  var valid_579119 = query.getOrDefault("fields")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "fields", valid_579119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579121: Call_SqlSslCertsCreateEphemeral_579108; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a short-lived X509 certificate containing the provided public key and signed by a private key specific to the target instance. Users may use the certificate to authenticate as themselves when connecting to the database.
  ## 
  let valid = call_579121.validator(path, query, header, formData, body)
  let scheme = call_579121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579121.url(scheme.get, call_579121.host, call_579121.base,
                         call_579121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579121, url, valid)

proc call*(call_579122: Call_SqlSslCertsCreateEphemeral_579108; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlSslCertsCreateEphemeral
  ## Generates a short-lived X509 certificate containing the provided public key and signed by a private key specific to the target instance. Users may use the certificate to authenticate as themselves when connecting to the database.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the Cloud SQL project.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579123 = newJObject()
  var query_579124 = newJObject()
  var body_579125 = newJObject()
  add(query_579124, "key", newJString(key))
  add(query_579124, "prettyPrint", newJBool(prettyPrint))
  add(query_579124, "oauth_token", newJString(oauthToken))
  add(query_579124, "alt", newJString(alt))
  add(query_579124, "userIp", newJString(userIp))
  add(query_579124, "quotaUser", newJString(quotaUser))
  add(path_579123, "instance", newJString(instance))
  add(path_579123, "project", newJString(project))
  if body != nil:
    body_579125 = body
  add(query_579124, "fields", newJString(fields))
  result = call_579122.call(path_579123, query_579124, nil, nil, body_579125)

var sqlSslCertsCreateEphemeral* = Call_SqlSslCertsCreateEphemeral_579108(
    name: "sqlSslCertsCreateEphemeral", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/createEphemeral",
    validator: validate_SqlSslCertsCreateEphemeral_579109, base: "/sql/v1beta4",
    url: url_SqlSslCertsCreateEphemeral_579110, schemes: {Scheme.Https})
type
  Call_SqlDatabasesInsert_579142 = ref object of OpenApiRestCall_578348
proc url_SqlDatabasesInsert_579144(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlDatabasesInsert_579143(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Inserts a resource containing information about a database inside a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579145 = path.getOrDefault("instance")
  valid_579145 = validateParameter(valid_579145, JString, required = true,
                                 default = nil)
  if valid_579145 != nil:
    section.add "instance", valid_579145
  var valid_579146 = path.getOrDefault("project")
  valid_579146 = validateParameter(valid_579146, JString, required = true,
                                 default = nil)
  if valid_579146 != nil:
    section.add "project", valid_579146
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579147 = query.getOrDefault("key")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "key", valid_579147
  var valid_579148 = query.getOrDefault("prettyPrint")
  valid_579148 = validateParameter(valid_579148, JBool, required = false,
                                 default = newJBool(true))
  if valid_579148 != nil:
    section.add "prettyPrint", valid_579148
  var valid_579149 = query.getOrDefault("oauth_token")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "oauth_token", valid_579149
  var valid_579150 = query.getOrDefault("alt")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = newJString("json"))
  if valid_579150 != nil:
    section.add "alt", valid_579150
  var valid_579151 = query.getOrDefault("userIp")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "userIp", valid_579151
  var valid_579152 = query.getOrDefault("quotaUser")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "quotaUser", valid_579152
  var valid_579153 = query.getOrDefault("fields")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "fields", valid_579153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579155: Call_SqlDatabasesInsert_579142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a resource containing information about a database inside a Cloud SQL instance.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_SqlDatabasesInsert_579142; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlDatabasesInsert
  ## Inserts a resource containing information about a database inside a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  var body_579159 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "userIp", newJString(userIp))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(path_579157, "instance", newJString(instance))
  add(path_579157, "project", newJString(project))
  if body != nil:
    body_579159 = body
  add(query_579158, "fields", newJString(fields))
  result = call_579156.call(path_579157, query_579158, nil, nil, body_579159)

var sqlDatabasesInsert* = Call_SqlDatabasesInsert_579142(
    name: "sqlDatabasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases",
    validator: validate_SqlDatabasesInsert_579143, base: "/sql/v1beta4",
    url: url_SqlDatabasesInsert_579144, schemes: {Scheme.Https})
type
  Call_SqlDatabasesList_579126 = ref object of OpenApiRestCall_578348
proc url_SqlDatabasesList_579128(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlDatabasesList_579127(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists databases in the specified Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579129 = path.getOrDefault("instance")
  valid_579129 = validateParameter(valid_579129, JString, required = true,
                                 default = nil)
  if valid_579129 != nil:
    section.add "instance", valid_579129
  var valid_579130 = path.getOrDefault("project")
  valid_579130 = validateParameter(valid_579130, JString, required = true,
                                 default = nil)
  if valid_579130 != nil:
    section.add "project", valid_579130
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579131 = query.getOrDefault("key")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "key", valid_579131
  var valid_579132 = query.getOrDefault("prettyPrint")
  valid_579132 = validateParameter(valid_579132, JBool, required = false,
                                 default = newJBool(true))
  if valid_579132 != nil:
    section.add "prettyPrint", valid_579132
  var valid_579133 = query.getOrDefault("oauth_token")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "oauth_token", valid_579133
  var valid_579134 = query.getOrDefault("alt")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = newJString("json"))
  if valid_579134 != nil:
    section.add "alt", valid_579134
  var valid_579135 = query.getOrDefault("userIp")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "userIp", valid_579135
  var valid_579136 = query.getOrDefault("quotaUser")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "quotaUser", valid_579136
  var valid_579137 = query.getOrDefault("fields")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "fields", valid_579137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579138: Call_SqlDatabasesList_579126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists databases in the specified Cloud SQL instance.
  ## 
  let valid = call_579138.validator(path, query, header, formData, body)
  let scheme = call_579138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579138.url(scheme.get, call_579138.host, call_579138.base,
                         call_579138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579138, url, valid)

proc call*(call_579139: Call_SqlDatabasesList_579126; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlDatabasesList
  ## Lists databases in the specified Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579140 = newJObject()
  var query_579141 = newJObject()
  add(query_579141, "key", newJString(key))
  add(query_579141, "prettyPrint", newJBool(prettyPrint))
  add(query_579141, "oauth_token", newJString(oauthToken))
  add(query_579141, "alt", newJString(alt))
  add(query_579141, "userIp", newJString(userIp))
  add(query_579141, "quotaUser", newJString(quotaUser))
  add(path_579140, "instance", newJString(instance))
  add(path_579140, "project", newJString(project))
  add(query_579141, "fields", newJString(fields))
  result = call_579139.call(path_579140, query_579141, nil, nil, nil)

var sqlDatabasesList* = Call_SqlDatabasesList_579126(name: "sqlDatabasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases",
    validator: validate_SqlDatabasesList_579127, base: "/sql/v1beta4",
    url: url_SqlDatabasesList_579128, schemes: {Scheme.Https})
type
  Call_SqlDatabasesUpdate_579177 = ref object of OpenApiRestCall_578348
proc url_SqlDatabasesUpdate_579179(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlDatabasesUpdate_579178(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a resource containing information about a database inside a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Name of the database to be updated in the instance.
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_579180 = path.getOrDefault("database")
  valid_579180 = validateParameter(valid_579180, JString, required = true,
                                 default = nil)
  if valid_579180 != nil:
    section.add "database", valid_579180
  var valid_579181 = path.getOrDefault("instance")
  valid_579181 = validateParameter(valid_579181, JString, required = true,
                                 default = nil)
  if valid_579181 != nil:
    section.add "instance", valid_579181
  var valid_579182 = path.getOrDefault("project")
  valid_579182 = validateParameter(valid_579182, JString, required = true,
                                 default = nil)
  if valid_579182 != nil:
    section.add "project", valid_579182
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579183 = query.getOrDefault("key")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "key", valid_579183
  var valid_579184 = query.getOrDefault("prettyPrint")
  valid_579184 = validateParameter(valid_579184, JBool, required = false,
                                 default = newJBool(true))
  if valid_579184 != nil:
    section.add "prettyPrint", valid_579184
  var valid_579185 = query.getOrDefault("oauth_token")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "oauth_token", valid_579185
  var valid_579186 = query.getOrDefault("alt")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = newJString("json"))
  if valid_579186 != nil:
    section.add "alt", valid_579186
  var valid_579187 = query.getOrDefault("userIp")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "userIp", valid_579187
  var valid_579188 = query.getOrDefault("quotaUser")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "quotaUser", valid_579188
  var valid_579189 = query.getOrDefault("fields")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "fields", valid_579189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579191: Call_SqlDatabasesUpdate_579177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource containing information about a database inside a Cloud SQL instance.
  ## 
  let valid = call_579191.validator(path, query, header, formData, body)
  let scheme = call_579191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579191.url(scheme.get, call_579191.host, call_579191.base,
                         call_579191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579191, url, valid)

proc call*(call_579192: Call_SqlDatabasesUpdate_579177; database: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlDatabasesUpdate
  ## Updates a resource containing information about a database inside a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Name of the database to be updated in the instance.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579193 = newJObject()
  var query_579194 = newJObject()
  var body_579195 = newJObject()
  add(query_579194, "key", newJString(key))
  add(query_579194, "prettyPrint", newJBool(prettyPrint))
  add(query_579194, "oauth_token", newJString(oauthToken))
  add(path_579193, "database", newJString(database))
  add(query_579194, "alt", newJString(alt))
  add(query_579194, "userIp", newJString(userIp))
  add(query_579194, "quotaUser", newJString(quotaUser))
  add(path_579193, "instance", newJString(instance))
  add(path_579193, "project", newJString(project))
  if body != nil:
    body_579195 = body
  add(query_579194, "fields", newJString(fields))
  result = call_579192.call(path_579193, query_579194, nil, nil, body_579195)

var sqlDatabasesUpdate* = Call_SqlDatabasesUpdate_579177(
    name: "sqlDatabasesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesUpdate_579178, base: "/sql/v1beta4",
    url: url_SqlDatabasesUpdate_579179, schemes: {Scheme.Https})
type
  Call_SqlDatabasesGet_579160 = ref object of OpenApiRestCall_578348
proc url_SqlDatabasesGet_579162(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlDatabasesGet_579161(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves a resource containing information about a database inside a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Name of the database in the instance.
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_579163 = path.getOrDefault("database")
  valid_579163 = validateParameter(valid_579163, JString, required = true,
                                 default = nil)
  if valid_579163 != nil:
    section.add "database", valid_579163
  var valid_579164 = path.getOrDefault("instance")
  valid_579164 = validateParameter(valid_579164, JString, required = true,
                                 default = nil)
  if valid_579164 != nil:
    section.add "instance", valid_579164
  var valid_579165 = path.getOrDefault("project")
  valid_579165 = validateParameter(valid_579165, JString, required = true,
                                 default = nil)
  if valid_579165 != nil:
    section.add "project", valid_579165
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579166 = query.getOrDefault("key")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "key", valid_579166
  var valid_579167 = query.getOrDefault("prettyPrint")
  valid_579167 = validateParameter(valid_579167, JBool, required = false,
                                 default = newJBool(true))
  if valid_579167 != nil:
    section.add "prettyPrint", valid_579167
  var valid_579168 = query.getOrDefault("oauth_token")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "oauth_token", valid_579168
  var valid_579169 = query.getOrDefault("alt")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = newJString("json"))
  if valid_579169 != nil:
    section.add "alt", valid_579169
  var valid_579170 = query.getOrDefault("userIp")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "userIp", valid_579170
  var valid_579171 = query.getOrDefault("quotaUser")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "quotaUser", valid_579171
  var valid_579172 = query.getOrDefault("fields")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "fields", valid_579172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579173: Call_SqlDatabasesGet_579160; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a database inside a Cloud SQL instance.
  ## 
  let valid = call_579173.validator(path, query, header, formData, body)
  let scheme = call_579173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579173.url(scheme.get, call_579173.host, call_579173.base,
                         call_579173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579173, url, valid)

proc call*(call_579174: Call_SqlDatabasesGet_579160; database: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlDatabasesGet
  ## Retrieves a resource containing information about a database inside a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Name of the database in the instance.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579175 = newJObject()
  var query_579176 = newJObject()
  add(query_579176, "key", newJString(key))
  add(query_579176, "prettyPrint", newJBool(prettyPrint))
  add(query_579176, "oauth_token", newJString(oauthToken))
  add(path_579175, "database", newJString(database))
  add(query_579176, "alt", newJString(alt))
  add(query_579176, "userIp", newJString(userIp))
  add(query_579176, "quotaUser", newJString(quotaUser))
  add(path_579175, "instance", newJString(instance))
  add(path_579175, "project", newJString(project))
  add(query_579176, "fields", newJString(fields))
  result = call_579174.call(path_579175, query_579176, nil, nil, nil)

var sqlDatabasesGet* = Call_SqlDatabasesGet_579160(name: "sqlDatabasesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesGet_579161, base: "/sql/v1beta4",
    url: url_SqlDatabasesGet_579162, schemes: {Scheme.Https})
type
  Call_SqlDatabasesPatch_579213 = ref object of OpenApiRestCall_578348
proc url_SqlDatabasesPatch_579215(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlDatabasesPatch_579214(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates a resource containing information about a database inside a Cloud SQL instance. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Name of the database to be updated in the instance.
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_579216 = path.getOrDefault("database")
  valid_579216 = validateParameter(valid_579216, JString, required = true,
                                 default = nil)
  if valid_579216 != nil:
    section.add "database", valid_579216
  var valid_579217 = path.getOrDefault("instance")
  valid_579217 = validateParameter(valid_579217, JString, required = true,
                                 default = nil)
  if valid_579217 != nil:
    section.add "instance", valid_579217
  var valid_579218 = path.getOrDefault("project")
  valid_579218 = validateParameter(valid_579218, JString, required = true,
                                 default = nil)
  if valid_579218 != nil:
    section.add "project", valid_579218
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579219 = query.getOrDefault("key")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "key", valid_579219
  var valid_579220 = query.getOrDefault("prettyPrint")
  valid_579220 = validateParameter(valid_579220, JBool, required = false,
                                 default = newJBool(true))
  if valid_579220 != nil:
    section.add "prettyPrint", valid_579220
  var valid_579221 = query.getOrDefault("oauth_token")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "oauth_token", valid_579221
  var valid_579222 = query.getOrDefault("alt")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = newJString("json"))
  if valid_579222 != nil:
    section.add "alt", valid_579222
  var valid_579223 = query.getOrDefault("userIp")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "userIp", valid_579223
  var valid_579224 = query.getOrDefault("quotaUser")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "quotaUser", valid_579224
  var valid_579225 = query.getOrDefault("fields")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "fields", valid_579225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579227: Call_SqlDatabasesPatch_579213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource containing information about a database inside a Cloud SQL instance. This method supports patch semantics.
  ## 
  let valid = call_579227.validator(path, query, header, formData, body)
  let scheme = call_579227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579227.url(scheme.get, call_579227.host, call_579227.base,
                         call_579227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579227, url, valid)

proc call*(call_579228: Call_SqlDatabasesPatch_579213; database: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlDatabasesPatch
  ## Updates a resource containing information about a database inside a Cloud SQL instance. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Name of the database to be updated in the instance.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579229 = newJObject()
  var query_579230 = newJObject()
  var body_579231 = newJObject()
  add(query_579230, "key", newJString(key))
  add(query_579230, "prettyPrint", newJBool(prettyPrint))
  add(query_579230, "oauth_token", newJString(oauthToken))
  add(path_579229, "database", newJString(database))
  add(query_579230, "alt", newJString(alt))
  add(query_579230, "userIp", newJString(userIp))
  add(query_579230, "quotaUser", newJString(quotaUser))
  add(path_579229, "instance", newJString(instance))
  add(path_579229, "project", newJString(project))
  if body != nil:
    body_579231 = body
  add(query_579230, "fields", newJString(fields))
  result = call_579228.call(path_579229, query_579230, nil, nil, body_579231)

var sqlDatabasesPatch* = Call_SqlDatabasesPatch_579213(name: "sqlDatabasesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesPatch_579214, base: "/sql/v1beta4",
    url: url_SqlDatabasesPatch_579215, schemes: {Scheme.Https})
type
  Call_SqlDatabasesDelete_579196 = ref object of OpenApiRestCall_578348
proc url_SqlDatabasesDelete_579198(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlDatabasesDelete_579197(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a database from a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Name of the database to be deleted in the instance.
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_579199 = path.getOrDefault("database")
  valid_579199 = validateParameter(valid_579199, JString, required = true,
                                 default = nil)
  if valid_579199 != nil:
    section.add "database", valid_579199
  var valid_579200 = path.getOrDefault("instance")
  valid_579200 = validateParameter(valid_579200, JString, required = true,
                                 default = nil)
  if valid_579200 != nil:
    section.add "instance", valid_579200
  var valid_579201 = path.getOrDefault("project")
  valid_579201 = validateParameter(valid_579201, JString, required = true,
                                 default = nil)
  if valid_579201 != nil:
    section.add "project", valid_579201
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579202 = query.getOrDefault("key")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "key", valid_579202
  var valid_579203 = query.getOrDefault("prettyPrint")
  valid_579203 = validateParameter(valid_579203, JBool, required = false,
                                 default = newJBool(true))
  if valid_579203 != nil:
    section.add "prettyPrint", valid_579203
  var valid_579204 = query.getOrDefault("oauth_token")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "oauth_token", valid_579204
  var valid_579205 = query.getOrDefault("alt")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = newJString("json"))
  if valid_579205 != nil:
    section.add "alt", valid_579205
  var valid_579206 = query.getOrDefault("userIp")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "userIp", valid_579206
  var valid_579207 = query.getOrDefault("quotaUser")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "quotaUser", valid_579207
  var valid_579208 = query.getOrDefault("fields")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "fields", valid_579208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579209: Call_SqlDatabasesDelete_579196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a database from a Cloud SQL instance.
  ## 
  let valid = call_579209.validator(path, query, header, formData, body)
  let scheme = call_579209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579209.url(scheme.get, call_579209.host, call_579209.base,
                         call_579209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579209, url, valid)

proc call*(call_579210: Call_SqlDatabasesDelete_579196; database: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlDatabasesDelete
  ## Deletes a database from a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Name of the database to be deleted in the instance.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579211 = newJObject()
  var query_579212 = newJObject()
  add(query_579212, "key", newJString(key))
  add(query_579212, "prettyPrint", newJBool(prettyPrint))
  add(query_579212, "oauth_token", newJString(oauthToken))
  add(path_579211, "database", newJString(database))
  add(query_579212, "alt", newJString(alt))
  add(query_579212, "userIp", newJString(userIp))
  add(query_579212, "quotaUser", newJString(quotaUser))
  add(path_579211, "instance", newJString(instance))
  add(path_579211, "project", newJString(project))
  add(query_579212, "fields", newJString(fields))
  result = call_579210.call(path_579211, query_579212, nil, nil, nil)

var sqlDatabasesDelete* = Call_SqlDatabasesDelete_579196(
    name: "sqlDatabasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesDelete_579197, base: "/sql/v1beta4",
    url: url_SqlDatabasesDelete_579198, schemes: {Scheme.Https})
type
  Call_SqlInstancesDemoteMaster_579232 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesDemoteMaster_579234(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/demoteMaster")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesDemoteMaster_579233(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Demotes the stand-alone instance to be a Cloud SQL read replica for an external database server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance name.
  ##   project: JString (required)
  ##          : ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579235 = path.getOrDefault("instance")
  valid_579235 = validateParameter(valid_579235, JString, required = true,
                                 default = nil)
  if valid_579235 != nil:
    section.add "instance", valid_579235
  var valid_579236 = path.getOrDefault("project")
  valid_579236 = validateParameter(valid_579236, JString, required = true,
                                 default = nil)
  if valid_579236 != nil:
    section.add "project", valid_579236
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579237 = query.getOrDefault("key")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "key", valid_579237
  var valid_579238 = query.getOrDefault("prettyPrint")
  valid_579238 = validateParameter(valid_579238, JBool, required = false,
                                 default = newJBool(true))
  if valid_579238 != nil:
    section.add "prettyPrint", valid_579238
  var valid_579239 = query.getOrDefault("oauth_token")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "oauth_token", valid_579239
  var valid_579240 = query.getOrDefault("alt")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = newJString("json"))
  if valid_579240 != nil:
    section.add "alt", valid_579240
  var valid_579241 = query.getOrDefault("userIp")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "userIp", valid_579241
  var valid_579242 = query.getOrDefault("quotaUser")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "quotaUser", valid_579242
  var valid_579243 = query.getOrDefault("fields")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "fields", valid_579243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579245: Call_SqlInstancesDemoteMaster_579232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Demotes the stand-alone instance to be a Cloud SQL read replica for an external database server.
  ## 
  let valid = call_579245.validator(path, query, header, formData, body)
  let scheme = call_579245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579245.url(scheme.get, call_579245.host, call_579245.base,
                         call_579245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579245, url, valid)

proc call*(call_579246: Call_SqlInstancesDemoteMaster_579232; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesDemoteMaster
  ## Demotes the stand-alone instance to be a Cloud SQL read replica for an external database server.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579247 = newJObject()
  var query_579248 = newJObject()
  var body_579249 = newJObject()
  add(query_579248, "key", newJString(key))
  add(query_579248, "prettyPrint", newJBool(prettyPrint))
  add(query_579248, "oauth_token", newJString(oauthToken))
  add(query_579248, "alt", newJString(alt))
  add(query_579248, "userIp", newJString(userIp))
  add(query_579248, "quotaUser", newJString(quotaUser))
  add(path_579247, "instance", newJString(instance))
  add(path_579247, "project", newJString(project))
  if body != nil:
    body_579249 = body
  add(query_579248, "fields", newJString(fields))
  result = call_579246.call(path_579247, query_579248, nil, nil, body_579249)

var sqlInstancesDemoteMaster* = Call_SqlInstancesDemoteMaster_579232(
    name: "sqlInstancesDemoteMaster", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/demoteMaster",
    validator: validate_SqlInstancesDemoteMaster_579233, base: "/sql/v1beta4",
    url: url_SqlInstancesDemoteMaster_579234, schemes: {Scheme.Https})
type
  Call_SqlInstancesExport_579250 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesExport_579252(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesExport_579251(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Exports data from a Cloud SQL instance to a Cloud Storage bucket as a SQL dump or CSV file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance to be exported.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579253 = path.getOrDefault("instance")
  valid_579253 = validateParameter(valid_579253, JString, required = true,
                                 default = nil)
  if valid_579253 != nil:
    section.add "instance", valid_579253
  var valid_579254 = path.getOrDefault("project")
  valid_579254 = validateParameter(valid_579254, JString, required = true,
                                 default = nil)
  if valid_579254 != nil:
    section.add "project", valid_579254
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579255 = query.getOrDefault("key")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "key", valid_579255
  var valid_579256 = query.getOrDefault("prettyPrint")
  valid_579256 = validateParameter(valid_579256, JBool, required = false,
                                 default = newJBool(true))
  if valid_579256 != nil:
    section.add "prettyPrint", valid_579256
  var valid_579257 = query.getOrDefault("oauth_token")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "oauth_token", valid_579257
  var valid_579258 = query.getOrDefault("alt")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = newJString("json"))
  if valid_579258 != nil:
    section.add "alt", valid_579258
  var valid_579259 = query.getOrDefault("userIp")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "userIp", valid_579259
  var valid_579260 = query.getOrDefault("quotaUser")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "quotaUser", valid_579260
  var valid_579261 = query.getOrDefault("fields")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "fields", valid_579261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579263: Call_SqlInstancesExport_579250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports data from a Cloud SQL instance to a Cloud Storage bucket as a SQL dump or CSV file.
  ## 
  let valid = call_579263.validator(path, query, header, formData, body)
  let scheme = call_579263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579263.url(scheme.get, call_579263.host, call_579263.base,
                         call_579263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579263, url, valid)

proc call*(call_579264: Call_SqlInstancesExport_579250; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesExport
  ## Exports data from a Cloud SQL instance to a Cloud Storage bucket as a SQL dump or CSV file.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance to be exported.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579265 = newJObject()
  var query_579266 = newJObject()
  var body_579267 = newJObject()
  add(query_579266, "key", newJString(key))
  add(query_579266, "prettyPrint", newJBool(prettyPrint))
  add(query_579266, "oauth_token", newJString(oauthToken))
  add(query_579266, "alt", newJString(alt))
  add(query_579266, "userIp", newJString(userIp))
  add(query_579266, "quotaUser", newJString(quotaUser))
  add(path_579265, "instance", newJString(instance))
  add(path_579265, "project", newJString(project))
  if body != nil:
    body_579267 = body
  add(query_579266, "fields", newJString(fields))
  result = call_579264.call(path_579265, query_579266, nil, nil, body_579267)

var sqlInstancesExport* = Call_SqlInstancesExport_579250(
    name: "sqlInstancesExport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/export",
    validator: validate_SqlInstancesExport_579251, base: "/sql/v1beta4",
    url: url_SqlInstancesExport_579252, schemes: {Scheme.Https})
type
  Call_SqlInstancesFailover_579268 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesFailover_579270(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesFailover_579269(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Failover the instance to its failover replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : ID of the project that contains the read replica.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579271 = path.getOrDefault("instance")
  valid_579271 = validateParameter(valid_579271, JString, required = true,
                                 default = nil)
  if valid_579271 != nil:
    section.add "instance", valid_579271
  var valid_579272 = path.getOrDefault("project")
  valid_579272 = validateParameter(valid_579272, JString, required = true,
                                 default = nil)
  if valid_579272 != nil:
    section.add "project", valid_579272
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579273 = query.getOrDefault("key")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "key", valid_579273
  var valid_579274 = query.getOrDefault("prettyPrint")
  valid_579274 = validateParameter(valid_579274, JBool, required = false,
                                 default = newJBool(true))
  if valid_579274 != nil:
    section.add "prettyPrint", valid_579274
  var valid_579275 = query.getOrDefault("oauth_token")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "oauth_token", valid_579275
  var valid_579276 = query.getOrDefault("alt")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = newJString("json"))
  if valid_579276 != nil:
    section.add "alt", valid_579276
  var valid_579277 = query.getOrDefault("userIp")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "userIp", valid_579277
  var valid_579278 = query.getOrDefault("quotaUser")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "quotaUser", valid_579278
  var valid_579279 = query.getOrDefault("fields")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "fields", valid_579279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579281: Call_SqlInstancesFailover_579268; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Failover the instance to its failover replica instance.
  ## 
  let valid = call_579281.validator(path, query, header, formData, body)
  let scheme = call_579281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579281.url(scheme.get, call_579281.host, call_579281.base,
                         call_579281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579281, url, valid)

proc call*(call_579282: Call_SqlInstancesFailover_579268; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesFailover
  ## Failover the instance to its failover replica instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579283 = newJObject()
  var query_579284 = newJObject()
  var body_579285 = newJObject()
  add(query_579284, "key", newJString(key))
  add(query_579284, "prettyPrint", newJBool(prettyPrint))
  add(query_579284, "oauth_token", newJString(oauthToken))
  add(query_579284, "alt", newJString(alt))
  add(query_579284, "userIp", newJString(userIp))
  add(query_579284, "quotaUser", newJString(quotaUser))
  add(path_579283, "instance", newJString(instance))
  add(path_579283, "project", newJString(project))
  if body != nil:
    body_579285 = body
  add(query_579284, "fields", newJString(fields))
  result = call_579282.call(path_579283, query_579284, nil, nil, body_579285)

var sqlInstancesFailover* = Call_SqlInstancesFailover_579268(
    name: "sqlInstancesFailover", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/failover",
    validator: validate_SqlInstancesFailover_579269, base: "/sql/v1beta4",
    url: url_SqlInstancesFailover_579270, schemes: {Scheme.Https})
type
  Call_SqlInstancesImport_579286 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesImport_579288(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesImport_579287(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Imports data into a Cloud SQL instance from a SQL dump or CSV file in Cloud Storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579289 = path.getOrDefault("instance")
  valid_579289 = validateParameter(valid_579289, JString, required = true,
                                 default = nil)
  if valid_579289 != nil:
    section.add "instance", valid_579289
  var valid_579290 = path.getOrDefault("project")
  valid_579290 = validateParameter(valid_579290, JString, required = true,
                                 default = nil)
  if valid_579290 != nil:
    section.add "project", valid_579290
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579291 = query.getOrDefault("key")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "key", valid_579291
  var valid_579292 = query.getOrDefault("prettyPrint")
  valid_579292 = validateParameter(valid_579292, JBool, required = false,
                                 default = newJBool(true))
  if valid_579292 != nil:
    section.add "prettyPrint", valid_579292
  var valid_579293 = query.getOrDefault("oauth_token")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "oauth_token", valid_579293
  var valid_579294 = query.getOrDefault("alt")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = newJString("json"))
  if valid_579294 != nil:
    section.add "alt", valid_579294
  var valid_579295 = query.getOrDefault("userIp")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "userIp", valid_579295
  var valid_579296 = query.getOrDefault("quotaUser")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "quotaUser", valid_579296
  var valid_579297 = query.getOrDefault("fields")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "fields", valid_579297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579299: Call_SqlInstancesImport_579286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports data into a Cloud SQL instance from a SQL dump or CSV file in Cloud Storage.
  ## 
  let valid = call_579299.validator(path, query, header, formData, body)
  let scheme = call_579299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579299.url(scheme.get, call_579299.host, call_579299.base,
                         call_579299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579299, url, valid)

proc call*(call_579300: Call_SqlInstancesImport_579286; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesImport
  ## Imports data into a Cloud SQL instance from a SQL dump or CSV file in Cloud Storage.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579301 = newJObject()
  var query_579302 = newJObject()
  var body_579303 = newJObject()
  add(query_579302, "key", newJString(key))
  add(query_579302, "prettyPrint", newJBool(prettyPrint))
  add(query_579302, "oauth_token", newJString(oauthToken))
  add(query_579302, "alt", newJString(alt))
  add(query_579302, "userIp", newJString(userIp))
  add(query_579302, "quotaUser", newJString(quotaUser))
  add(path_579301, "instance", newJString(instance))
  add(path_579301, "project", newJString(project))
  if body != nil:
    body_579303 = body
  add(query_579302, "fields", newJString(fields))
  result = call_579300.call(path_579301, query_579302, nil, nil, body_579303)

var sqlInstancesImport* = Call_SqlInstancesImport_579286(
    name: "sqlInstancesImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/import",
    validator: validate_SqlInstancesImport_579287, base: "/sql/v1beta4",
    url: url_SqlInstancesImport_579288, schemes: {Scheme.Https})
type
  Call_SqlInstancesListServerCas_579304 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesListServerCas_579306(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/listServerCas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesListServerCas_579305(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the trusted Certificate Authorities (CAs) for the specified instance. There can be up to three CAs listed: the CA that was used to sign the certificate that is currently in use, a CA that has been added but not yet used to sign a certificate, and a CA used to sign a certificate that has previously rotated out.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579307 = path.getOrDefault("instance")
  valid_579307 = validateParameter(valid_579307, JString, required = true,
                                 default = nil)
  if valid_579307 != nil:
    section.add "instance", valid_579307
  var valid_579308 = path.getOrDefault("project")
  valid_579308 = validateParameter(valid_579308, JString, required = true,
                                 default = nil)
  if valid_579308 != nil:
    section.add "project", valid_579308
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579309 = query.getOrDefault("key")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "key", valid_579309
  var valid_579310 = query.getOrDefault("prettyPrint")
  valid_579310 = validateParameter(valid_579310, JBool, required = false,
                                 default = newJBool(true))
  if valid_579310 != nil:
    section.add "prettyPrint", valid_579310
  var valid_579311 = query.getOrDefault("oauth_token")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "oauth_token", valid_579311
  var valid_579312 = query.getOrDefault("alt")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = newJString("json"))
  if valid_579312 != nil:
    section.add "alt", valid_579312
  var valid_579313 = query.getOrDefault("userIp")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "userIp", valid_579313
  var valid_579314 = query.getOrDefault("quotaUser")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "quotaUser", valid_579314
  var valid_579315 = query.getOrDefault("fields")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "fields", valid_579315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579316: Call_SqlInstancesListServerCas_579304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the trusted Certificate Authorities (CAs) for the specified instance. There can be up to three CAs listed: the CA that was used to sign the certificate that is currently in use, a CA that has been added but not yet used to sign a certificate, and a CA used to sign a certificate that has previously rotated out.
  ## 
  let valid = call_579316.validator(path, query, header, formData, body)
  let scheme = call_579316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579316.url(scheme.get, call_579316.host, call_579316.base,
                         call_579316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579316, url, valid)

proc call*(call_579317: Call_SqlInstancesListServerCas_579304; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesListServerCas
  ## Lists all of the trusted Certificate Authorities (CAs) for the specified instance. There can be up to three CAs listed: the CA that was used to sign the certificate that is currently in use, a CA that has been added but not yet used to sign a certificate, and a CA used to sign a certificate that has previously rotated out.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579318 = newJObject()
  var query_579319 = newJObject()
  add(query_579319, "key", newJString(key))
  add(query_579319, "prettyPrint", newJBool(prettyPrint))
  add(query_579319, "oauth_token", newJString(oauthToken))
  add(query_579319, "alt", newJString(alt))
  add(query_579319, "userIp", newJString(userIp))
  add(query_579319, "quotaUser", newJString(quotaUser))
  add(path_579318, "instance", newJString(instance))
  add(path_579318, "project", newJString(project))
  add(query_579319, "fields", newJString(fields))
  result = call_579317.call(path_579318, query_579319, nil, nil, nil)

var sqlInstancesListServerCas* = Call_SqlInstancesListServerCas_579304(
    name: "sqlInstancesListServerCas", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/listServerCas",
    validator: validate_SqlInstancesListServerCas_579305, base: "/sql/v1beta4",
    url: url_SqlInstancesListServerCas_579306, schemes: {Scheme.Https})
type
  Call_SqlInstancesPromoteReplica_579320 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesPromoteReplica_579322(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/promoteReplica")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesPromoteReplica_579321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: JString (required)
  ##          : ID of the project that contains the read replica.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579323 = path.getOrDefault("instance")
  valid_579323 = validateParameter(valid_579323, JString, required = true,
                                 default = nil)
  if valid_579323 != nil:
    section.add "instance", valid_579323
  var valid_579324 = path.getOrDefault("project")
  valid_579324 = validateParameter(valid_579324, JString, required = true,
                                 default = nil)
  if valid_579324 != nil:
    section.add "project", valid_579324
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579325 = query.getOrDefault("key")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "key", valid_579325
  var valid_579326 = query.getOrDefault("prettyPrint")
  valid_579326 = validateParameter(valid_579326, JBool, required = false,
                                 default = newJBool(true))
  if valid_579326 != nil:
    section.add "prettyPrint", valid_579326
  var valid_579327 = query.getOrDefault("oauth_token")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "oauth_token", valid_579327
  var valid_579328 = query.getOrDefault("alt")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = newJString("json"))
  if valid_579328 != nil:
    section.add "alt", valid_579328
  var valid_579329 = query.getOrDefault("userIp")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "userIp", valid_579329
  var valid_579330 = query.getOrDefault("quotaUser")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "quotaUser", valid_579330
  var valid_579331 = query.getOrDefault("fields")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "fields", valid_579331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579332: Call_SqlInstancesPromoteReplica_579320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ## 
  let valid = call_579332.validator(path, query, header, formData, body)
  let scheme = call_579332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579332.url(scheme.get, call_579332.host, call_579332.base,
                         call_579332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579332, url, valid)

proc call*(call_579333: Call_SqlInstancesPromoteReplica_579320; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesPromoteReplica
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579334 = newJObject()
  var query_579335 = newJObject()
  add(query_579335, "key", newJString(key))
  add(query_579335, "prettyPrint", newJBool(prettyPrint))
  add(query_579335, "oauth_token", newJString(oauthToken))
  add(query_579335, "alt", newJString(alt))
  add(query_579335, "userIp", newJString(userIp))
  add(query_579335, "quotaUser", newJString(quotaUser))
  add(path_579334, "instance", newJString(instance))
  add(path_579334, "project", newJString(project))
  add(query_579335, "fields", newJString(fields))
  result = call_579333.call(path_579334, query_579335, nil, nil, nil)

var sqlInstancesPromoteReplica* = Call_SqlInstancesPromoteReplica_579320(
    name: "sqlInstancesPromoteReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/promoteReplica",
    validator: validate_SqlInstancesPromoteReplica_579321, base: "/sql/v1beta4",
    url: url_SqlInstancesPromoteReplica_579322, schemes: {Scheme.Https})
type
  Call_SqlInstancesResetSslConfig_579336 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesResetSslConfig_579338(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/resetSslConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesResetSslConfig_579337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all client certificates and generates a new server SSL certificate for the instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579339 = path.getOrDefault("instance")
  valid_579339 = validateParameter(valid_579339, JString, required = true,
                                 default = nil)
  if valid_579339 != nil:
    section.add "instance", valid_579339
  var valid_579340 = path.getOrDefault("project")
  valid_579340 = validateParameter(valid_579340, JString, required = true,
                                 default = nil)
  if valid_579340 != nil:
    section.add "project", valid_579340
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579341 = query.getOrDefault("key")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "key", valid_579341
  var valid_579342 = query.getOrDefault("prettyPrint")
  valid_579342 = validateParameter(valid_579342, JBool, required = false,
                                 default = newJBool(true))
  if valid_579342 != nil:
    section.add "prettyPrint", valid_579342
  var valid_579343 = query.getOrDefault("oauth_token")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "oauth_token", valid_579343
  var valid_579344 = query.getOrDefault("alt")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = newJString("json"))
  if valid_579344 != nil:
    section.add "alt", valid_579344
  var valid_579345 = query.getOrDefault("userIp")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "userIp", valid_579345
  var valid_579346 = query.getOrDefault("quotaUser")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "quotaUser", valid_579346
  var valid_579347 = query.getOrDefault("fields")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "fields", valid_579347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579348: Call_SqlInstancesResetSslConfig_579336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all client certificates and generates a new server SSL certificate for the instance.
  ## 
  let valid = call_579348.validator(path, query, header, formData, body)
  let scheme = call_579348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579348.url(scheme.get, call_579348.host, call_579348.base,
                         call_579348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579348, url, valid)

proc call*(call_579349: Call_SqlInstancesResetSslConfig_579336; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesResetSslConfig
  ## Deletes all client certificates and generates a new server SSL certificate for the instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579350 = newJObject()
  var query_579351 = newJObject()
  add(query_579351, "key", newJString(key))
  add(query_579351, "prettyPrint", newJBool(prettyPrint))
  add(query_579351, "oauth_token", newJString(oauthToken))
  add(query_579351, "alt", newJString(alt))
  add(query_579351, "userIp", newJString(userIp))
  add(query_579351, "quotaUser", newJString(quotaUser))
  add(path_579350, "instance", newJString(instance))
  add(path_579350, "project", newJString(project))
  add(query_579351, "fields", newJString(fields))
  result = call_579349.call(path_579350, query_579351, nil, nil, nil)

var sqlInstancesResetSslConfig* = Call_SqlInstancesResetSslConfig_579336(
    name: "sqlInstancesResetSslConfig", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/resetSslConfig",
    validator: validate_SqlInstancesResetSslConfig_579337, base: "/sql/v1beta4",
    url: url_SqlInstancesResetSslConfig_579338, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestart_579352 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesRestart_579354(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesRestart_579353(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Restarts a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance to be restarted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579355 = path.getOrDefault("instance")
  valid_579355 = validateParameter(valid_579355, JString, required = true,
                                 default = nil)
  if valid_579355 != nil:
    section.add "instance", valid_579355
  var valid_579356 = path.getOrDefault("project")
  valid_579356 = validateParameter(valid_579356, JString, required = true,
                                 default = nil)
  if valid_579356 != nil:
    section.add "project", valid_579356
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579357 = query.getOrDefault("key")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "key", valid_579357
  var valid_579358 = query.getOrDefault("prettyPrint")
  valid_579358 = validateParameter(valid_579358, JBool, required = false,
                                 default = newJBool(true))
  if valid_579358 != nil:
    section.add "prettyPrint", valid_579358
  var valid_579359 = query.getOrDefault("oauth_token")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "oauth_token", valid_579359
  var valid_579360 = query.getOrDefault("alt")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = newJString("json"))
  if valid_579360 != nil:
    section.add "alt", valid_579360
  var valid_579361 = query.getOrDefault("userIp")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "userIp", valid_579361
  var valid_579362 = query.getOrDefault("quotaUser")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "quotaUser", valid_579362
  var valid_579363 = query.getOrDefault("fields")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "fields", valid_579363
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579364: Call_SqlInstancesRestart_579352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a Cloud SQL instance.
  ## 
  let valid = call_579364.validator(path, query, header, formData, body)
  let scheme = call_579364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579364.url(scheme.get, call_579364.host, call_579364.base,
                         call_579364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579364, url, valid)

proc call*(call_579365: Call_SqlInstancesRestart_579352; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesRestart
  ## Restarts a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance to be restarted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579366 = newJObject()
  var query_579367 = newJObject()
  add(query_579367, "key", newJString(key))
  add(query_579367, "prettyPrint", newJBool(prettyPrint))
  add(query_579367, "oauth_token", newJString(oauthToken))
  add(query_579367, "alt", newJString(alt))
  add(query_579367, "userIp", newJString(userIp))
  add(query_579367, "quotaUser", newJString(quotaUser))
  add(path_579366, "instance", newJString(instance))
  add(path_579366, "project", newJString(project))
  add(query_579367, "fields", newJString(fields))
  result = call_579365.call(path_579366, query_579367, nil, nil, nil)

var sqlInstancesRestart* = Call_SqlInstancesRestart_579352(
    name: "sqlInstancesRestart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restart",
    validator: validate_SqlInstancesRestart_579353, base: "/sql/v1beta4",
    url: url_SqlInstancesRestart_579354, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestoreBackup_579368 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesRestoreBackup_579370(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/restoreBackup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesRestoreBackup_579369(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores a backup of a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579371 = path.getOrDefault("instance")
  valid_579371 = validateParameter(valid_579371, JString, required = true,
                                 default = nil)
  if valid_579371 != nil:
    section.add "instance", valid_579371
  var valid_579372 = path.getOrDefault("project")
  valid_579372 = validateParameter(valid_579372, JString, required = true,
                                 default = nil)
  if valid_579372 != nil:
    section.add "project", valid_579372
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579373 = query.getOrDefault("key")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "key", valid_579373
  var valid_579374 = query.getOrDefault("prettyPrint")
  valid_579374 = validateParameter(valid_579374, JBool, required = false,
                                 default = newJBool(true))
  if valid_579374 != nil:
    section.add "prettyPrint", valid_579374
  var valid_579375 = query.getOrDefault("oauth_token")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "oauth_token", valid_579375
  var valid_579376 = query.getOrDefault("alt")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = newJString("json"))
  if valid_579376 != nil:
    section.add "alt", valid_579376
  var valid_579377 = query.getOrDefault("userIp")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "userIp", valid_579377
  var valid_579378 = query.getOrDefault("quotaUser")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "quotaUser", valid_579378
  var valid_579379 = query.getOrDefault("fields")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "fields", valid_579379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579381: Call_SqlInstancesRestoreBackup_579368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backup of a Cloud SQL instance.
  ## 
  let valid = call_579381.validator(path, query, header, formData, body)
  let scheme = call_579381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579381.url(scheme.get, call_579381.host, call_579381.base,
                         call_579381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579381, url, valid)

proc call*(call_579382: Call_SqlInstancesRestoreBackup_579368; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesRestoreBackup
  ## Restores a backup of a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579383 = newJObject()
  var query_579384 = newJObject()
  var body_579385 = newJObject()
  add(query_579384, "key", newJString(key))
  add(query_579384, "prettyPrint", newJBool(prettyPrint))
  add(query_579384, "oauth_token", newJString(oauthToken))
  add(query_579384, "alt", newJString(alt))
  add(query_579384, "userIp", newJString(userIp))
  add(query_579384, "quotaUser", newJString(quotaUser))
  add(path_579383, "instance", newJString(instance))
  add(path_579383, "project", newJString(project))
  if body != nil:
    body_579385 = body
  add(query_579384, "fields", newJString(fields))
  result = call_579382.call(path_579383, query_579384, nil, nil, body_579385)

var sqlInstancesRestoreBackup* = Call_SqlInstancesRestoreBackup_579368(
    name: "sqlInstancesRestoreBackup", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restoreBackup",
    validator: validate_SqlInstancesRestoreBackup_579369, base: "/sql/v1beta4",
    url: url_SqlInstancesRestoreBackup_579370, schemes: {Scheme.Https})
type
  Call_SqlInstancesRotateServerCa_579386 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesRotateServerCa_579388(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/rotateServerCa")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesRotateServerCa_579387(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rotates the server certificate to one signed by the Certificate Authority (CA) version previously added with the addServerCA method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579389 = path.getOrDefault("instance")
  valid_579389 = validateParameter(valid_579389, JString, required = true,
                                 default = nil)
  if valid_579389 != nil:
    section.add "instance", valid_579389
  var valid_579390 = path.getOrDefault("project")
  valid_579390 = validateParameter(valid_579390, JString, required = true,
                                 default = nil)
  if valid_579390 != nil:
    section.add "project", valid_579390
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579391 = query.getOrDefault("key")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "key", valid_579391
  var valid_579392 = query.getOrDefault("prettyPrint")
  valid_579392 = validateParameter(valid_579392, JBool, required = false,
                                 default = newJBool(true))
  if valid_579392 != nil:
    section.add "prettyPrint", valid_579392
  var valid_579393 = query.getOrDefault("oauth_token")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "oauth_token", valid_579393
  var valid_579394 = query.getOrDefault("alt")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = newJString("json"))
  if valid_579394 != nil:
    section.add "alt", valid_579394
  var valid_579395 = query.getOrDefault("userIp")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "userIp", valid_579395
  var valid_579396 = query.getOrDefault("quotaUser")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "quotaUser", valid_579396
  var valid_579397 = query.getOrDefault("fields")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "fields", valid_579397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579399: Call_SqlInstancesRotateServerCa_579386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rotates the server certificate to one signed by the Certificate Authority (CA) version previously added with the addServerCA method.
  ## 
  let valid = call_579399.validator(path, query, header, formData, body)
  let scheme = call_579399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579399.url(scheme.get, call_579399.host, call_579399.base,
                         call_579399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579399, url, valid)

proc call*(call_579400: Call_SqlInstancesRotateServerCa_579386; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesRotateServerCa
  ## Rotates the server certificate to one signed by the Certificate Authority (CA) version previously added with the addServerCA method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579401 = newJObject()
  var query_579402 = newJObject()
  var body_579403 = newJObject()
  add(query_579402, "key", newJString(key))
  add(query_579402, "prettyPrint", newJBool(prettyPrint))
  add(query_579402, "oauth_token", newJString(oauthToken))
  add(query_579402, "alt", newJString(alt))
  add(query_579402, "userIp", newJString(userIp))
  add(query_579402, "quotaUser", newJString(quotaUser))
  add(path_579401, "instance", newJString(instance))
  add(path_579401, "project", newJString(project))
  if body != nil:
    body_579403 = body
  add(query_579402, "fields", newJString(fields))
  result = call_579400.call(path_579401, query_579402, nil, nil, body_579403)

var sqlInstancesRotateServerCa* = Call_SqlInstancesRotateServerCa_579386(
    name: "sqlInstancesRotateServerCa", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/rotateServerCa",
    validator: validate_SqlInstancesRotateServerCa_579387, base: "/sql/v1beta4",
    url: url_SqlInstancesRotateServerCa_579388, schemes: {Scheme.Https})
type
  Call_SqlSslCertsInsert_579420 = ref object of OpenApiRestCall_578348
proc url_SqlSslCertsInsert_579422(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/sslCerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlSslCertsInsert_579421(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an SSL certificate and returns it along with the private key and server certificate authority. The new certificate will not be usable until the instance is restarted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579423 = path.getOrDefault("instance")
  valid_579423 = validateParameter(valid_579423, JString, required = true,
                                 default = nil)
  if valid_579423 != nil:
    section.add "instance", valid_579423
  var valid_579424 = path.getOrDefault("project")
  valid_579424 = validateParameter(valid_579424, JString, required = true,
                                 default = nil)
  if valid_579424 != nil:
    section.add "project", valid_579424
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579425 = query.getOrDefault("key")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "key", valid_579425
  var valid_579426 = query.getOrDefault("prettyPrint")
  valid_579426 = validateParameter(valid_579426, JBool, required = false,
                                 default = newJBool(true))
  if valid_579426 != nil:
    section.add "prettyPrint", valid_579426
  var valid_579427 = query.getOrDefault("oauth_token")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "oauth_token", valid_579427
  var valid_579428 = query.getOrDefault("alt")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = newJString("json"))
  if valid_579428 != nil:
    section.add "alt", valid_579428
  var valid_579429 = query.getOrDefault("userIp")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "userIp", valid_579429
  var valid_579430 = query.getOrDefault("quotaUser")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "quotaUser", valid_579430
  var valid_579431 = query.getOrDefault("fields")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "fields", valid_579431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579433: Call_SqlSslCertsInsert_579420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an SSL certificate and returns it along with the private key and server certificate authority. The new certificate will not be usable until the instance is restarted.
  ## 
  let valid = call_579433.validator(path, query, header, formData, body)
  let scheme = call_579433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579433.url(scheme.get, call_579433.host, call_579433.base,
                         call_579433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579433, url, valid)

proc call*(call_579434: Call_SqlSslCertsInsert_579420; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlSslCertsInsert
  ## Creates an SSL certificate and returns it along with the private key and server certificate authority. The new certificate will not be usable until the instance is restarted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579435 = newJObject()
  var query_579436 = newJObject()
  var body_579437 = newJObject()
  add(query_579436, "key", newJString(key))
  add(query_579436, "prettyPrint", newJBool(prettyPrint))
  add(query_579436, "oauth_token", newJString(oauthToken))
  add(query_579436, "alt", newJString(alt))
  add(query_579436, "userIp", newJString(userIp))
  add(query_579436, "quotaUser", newJString(quotaUser))
  add(path_579435, "instance", newJString(instance))
  add(path_579435, "project", newJString(project))
  if body != nil:
    body_579437 = body
  add(query_579436, "fields", newJString(fields))
  result = call_579434.call(path_579435, query_579436, nil, nil, body_579437)

var sqlSslCertsInsert* = Call_SqlSslCertsInsert_579420(name: "sqlSslCertsInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsInsert_579421, base: "/sql/v1beta4",
    url: url_SqlSslCertsInsert_579422, schemes: {Scheme.Https})
type
  Call_SqlSslCertsList_579404 = ref object of OpenApiRestCall_578348
proc url_SqlSslCertsList_579406(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/sslCerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlSslCertsList_579405(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all of the current SSL certificates for the instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579407 = path.getOrDefault("instance")
  valid_579407 = validateParameter(valid_579407, JString, required = true,
                                 default = nil)
  if valid_579407 != nil:
    section.add "instance", valid_579407
  var valid_579408 = path.getOrDefault("project")
  valid_579408 = validateParameter(valid_579408, JString, required = true,
                                 default = nil)
  if valid_579408 != nil:
    section.add "project", valid_579408
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579409 = query.getOrDefault("key")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "key", valid_579409
  var valid_579410 = query.getOrDefault("prettyPrint")
  valid_579410 = validateParameter(valid_579410, JBool, required = false,
                                 default = newJBool(true))
  if valid_579410 != nil:
    section.add "prettyPrint", valid_579410
  var valid_579411 = query.getOrDefault("oauth_token")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "oauth_token", valid_579411
  var valid_579412 = query.getOrDefault("alt")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = newJString("json"))
  if valid_579412 != nil:
    section.add "alt", valid_579412
  var valid_579413 = query.getOrDefault("userIp")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = nil)
  if valid_579413 != nil:
    section.add "userIp", valid_579413
  var valid_579414 = query.getOrDefault("quotaUser")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "quotaUser", valid_579414
  var valid_579415 = query.getOrDefault("fields")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "fields", valid_579415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579416: Call_SqlSslCertsList_579404; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the current SSL certificates for the instance.
  ## 
  let valid = call_579416.validator(path, query, header, formData, body)
  let scheme = call_579416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579416.url(scheme.get, call_579416.host, call_579416.base,
                         call_579416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579416, url, valid)

proc call*(call_579417: Call_SqlSslCertsList_579404; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlSslCertsList
  ## Lists all of the current SSL certificates for the instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579418 = newJObject()
  var query_579419 = newJObject()
  add(query_579419, "key", newJString(key))
  add(query_579419, "prettyPrint", newJBool(prettyPrint))
  add(query_579419, "oauth_token", newJString(oauthToken))
  add(query_579419, "alt", newJString(alt))
  add(query_579419, "userIp", newJString(userIp))
  add(query_579419, "quotaUser", newJString(quotaUser))
  add(path_579418, "instance", newJString(instance))
  add(path_579418, "project", newJString(project))
  add(query_579419, "fields", newJString(fields))
  result = call_579417.call(path_579418, query_579419, nil, nil, nil)

var sqlSslCertsList* = Call_SqlSslCertsList_579404(name: "sqlSslCertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsList_579405, base: "/sql/v1beta4",
    url: url_SqlSslCertsList_579406, schemes: {Scheme.Https})
type
  Call_SqlSslCertsGet_579438 = ref object of OpenApiRestCall_578348
proc url_SqlSslCertsGet_579440(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "sha1Fingerprint" in path, "`sha1Fingerprint` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/sslCerts/"),
               (kind: VariableSegment, value: "sha1Fingerprint")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlSslCertsGet_579439(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves a particular SSL certificate. Does not include the private key (required for usage). The private key must be saved from the response to initial creation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sha1Fingerprint: JString (required)
  ##                  : Sha1 FingerPrint.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sha1Fingerprint` field"
  var valid_579441 = path.getOrDefault("sha1Fingerprint")
  valid_579441 = validateParameter(valid_579441, JString, required = true,
                                 default = nil)
  if valid_579441 != nil:
    section.add "sha1Fingerprint", valid_579441
  var valid_579442 = path.getOrDefault("instance")
  valid_579442 = validateParameter(valid_579442, JString, required = true,
                                 default = nil)
  if valid_579442 != nil:
    section.add "instance", valid_579442
  var valid_579443 = path.getOrDefault("project")
  valid_579443 = validateParameter(valid_579443, JString, required = true,
                                 default = nil)
  if valid_579443 != nil:
    section.add "project", valid_579443
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579444 = query.getOrDefault("key")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "key", valid_579444
  var valid_579445 = query.getOrDefault("prettyPrint")
  valid_579445 = validateParameter(valid_579445, JBool, required = false,
                                 default = newJBool(true))
  if valid_579445 != nil:
    section.add "prettyPrint", valid_579445
  var valid_579446 = query.getOrDefault("oauth_token")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "oauth_token", valid_579446
  var valid_579447 = query.getOrDefault("alt")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = newJString("json"))
  if valid_579447 != nil:
    section.add "alt", valid_579447
  var valid_579448 = query.getOrDefault("userIp")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "userIp", valid_579448
  var valid_579449 = query.getOrDefault("quotaUser")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "quotaUser", valid_579449
  var valid_579450 = query.getOrDefault("fields")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "fields", valid_579450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579451: Call_SqlSslCertsGet_579438; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a particular SSL certificate. Does not include the private key (required for usage). The private key must be saved from the response to initial creation.
  ## 
  let valid = call_579451.validator(path, query, header, formData, body)
  let scheme = call_579451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579451.url(scheme.get, call_579451.host, call_579451.base,
                         call_579451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579451, url, valid)

proc call*(call_579452: Call_SqlSslCertsGet_579438; sha1Fingerprint: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlSslCertsGet
  ## Retrieves a particular SSL certificate. Does not include the private key (required for usage). The private key must be saved from the response to initial creation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sha1Fingerprint: string (required)
  ##                  : Sha1 FingerPrint.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579453 = newJObject()
  var query_579454 = newJObject()
  add(query_579454, "key", newJString(key))
  add(query_579454, "prettyPrint", newJBool(prettyPrint))
  add(query_579454, "oauth_token", newJString(oauthToken))
  add(query_579454, "alt", newJString(alt))
  add(query_579454, "userIp", newJString(userIp))
  add(query_579454, "quotaUser", newJString(quotaUser))
  add(path_579453, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(path_579453, "instance", newJString(instance))
  add(path_579453, "project", newJString(project))
  add(query_579454, "fields", newJString(fields))
  result = call_579452.call(path_579453, query_579454, nil, nil, nil)

var sqlSslCertsGet* = Call_SqlSslCertsGet_579438(name: "sqlSslCertsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsGet_579439, base: "/sql/v1beta4",
    url: url_SqlSslCertsGet_579440, schemes: {Scheme.Https})
type
  Call_SqlSslCertsDelete_579455 = ref object of OpenApiRestCall_578348
proc url_SqlSslCertsDelete_579457(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "sha1Fingerprint" in path, "`sha1Fingerprint` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/sslCerts/"),
               (kind: VariableSegment, value: "sha1Fingerprint")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlSslCertsDelete_579456(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the SSL certificate. For First Generation instances, the certificate remains valid until the instance is restarted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sha1Fingerprint: JString (required)
  ##                  : Sha1 FingerPrint.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sha1Fingerprint` field"
  var valid_579458 = path.getOrDefault("sha1Fingerprint")
  valid_579458 = validateParameter(valid_579458, JString, required = true,
                                 default = nil)
  if valid_579458 != nil:
    section.add "sha1Fingerprint", valid_579458
  var valid_579459 = path.getOrDefault("instance")
  valid_579459 = validateParameter(valid_579459, JString, required = true,
                                 default = nil)
  if valid_579459 != nil:
    section.add "instance", valid_579459
  var valid_579460 = path.getOrDefault("project")
  valid_579460 = validateParameter(valid_579460, JString, required = true,
                                 default = nil)
  if valid_579460 != nil:
    section.add "project", valid_579460
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579461 = query.getOrDefault("key")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "key", valid_579461
  var valid_579462 = query.getOrDefault("prettyPrint")
  valid_579462 = validateParameter(valid_579462, JBool, required = false,
                                 default = newJBool(true))
  if valid_579462 != nil:
    section.add "prettyPrint", valid_579462
  var valid_579463 = query.getOrDefault("oauth_token")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "oauth_token", valid_579463
  var valid_579464 = query.getOrDefault("alt")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = newJString("json"))
  if valid_579464 != nil:
    section.add "alt", valid_579464
  var valid_579465 = query.getOrDefault("userIp")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "userIp", valid_579465
  var valid_579466 = query.getOrDefault("quotaUser")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "quotaUser", valid_579466
  var valid_579467 = query.getOrDefault("fields")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "fields", valid_579467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579468: Call_SqlSslCertsDelete_579455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the SSL certificate. For First Generation instances, the certificate remains valid until the instance is restarted.
  ## 
  let valid = call_579468.validator(path, query, header, formData, body)
  let scheme = call_579468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579468.url(scheme.get, call_579468.host, call_579468.base,
                         call_579468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579468, url, valid)

proc call*(call_579469: Call_SqlSslCertsDelete_579455; sha1Fingerprint: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlSslCertsDelete
  ## Deletes the SSL certificate. For First Generation instances, the certificate remains valid until the instance is restarted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sha1Fingerprint: string (required)
  ##                  : Sha1 FingerPrint.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579470 = newJObject()
  var query_579471 = newJObject()
  add(query_579471, "key", newJString(key))
  add(query_579471, "prettyPrint", newJBool(prettyPrint))
  add(query_579471, "oauth_token", newJString(oauthToken))
  add(query_579471, "alt", newJString(alt))
  add(query_579471, "userIp", newJString(userIp))
  add(query_579471, "quotaUser", newJString(quotaUser))
  add(path_579470, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(path_579470, "instance", newJString(instance))
  add(path_579470, "project", newJString(project))
  add(query_579471, "fields", newJString(fields))
  result = call_579469.call(path_579470, query_579471, nil, nil, nil)

var sqlSslCertsDelete* = Call_SqlSslCertsDelete_579455(name: "sqlSslCertsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsDelete_579456, base: "/sql/v1beta4",
    url: url_SqlSslCertsDelete_579457, schemes: {Scheme.Https})
type
  Call_SqlInstancesStartReplica_579472 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesStartReplica_579474(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/startReplica")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesStartReplica_579473(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts the replication in the read replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: JString (required)
  ##          : ID of the project that contains the read replica.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579475 = path.getOrDefault("instance")
  valid_579475 = validateParameter(valid_579475, JString, required = true,
                                 default = nil)
  if valid_579475 != nil:
    section.add "instance", valid_579475
  var valid_579476 = path.getOrDefault("project")
  valid_579476 = validateParameter(valid_579476, JString, required = true,
                                 default = nil)
  if valid_579476 != nil:
    section.add "project", valid_579476
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579477 = query.getOrDefault("key")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "key", valid_579477
  var valid_579478 = query.getOrDefault("prettyPrint")
  valid_579478 = validateParameter(valid_579478, JBool, required = false,
                                 default = newJBool(true))
  if valid_579478 != nil:
    section.add "prettyPrint", valid_579478
  var valid_579479 = query.getOrDefault("oauth_token")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "oauth_token", valid_579479
  var valid_579480 = query.getOrDefault("alt")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = newJString("json"))
  if valid_579480 != nil:
    section.add "alt", valid_579480
  var valid_579481 = query.getOrDefault("userIp")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "userIp", valid_579481
  var valid_579482 = query.getOrDefault("quotaUser")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "quotaUser", valid_579482
  var valid_579483 = query.getOrDefault("fields")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "fields", valid_579483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579484: Call_SqlInstancesStartReplica_579472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts the replication in the read replica instance.
  ## 
  let valid = call_579484.validator(path, query, header, formData, body)
  let scheme = call_579484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579484.url(scheme.get, call_579484.host, call_579484.base,
                         call_579484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579484, url, valid)

proc call*(call_579485: Call_SqlInstancesStartReplica_579472; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesStartReplica
  ## Starts the replication in the read replica instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579486 = newJObject()
  var query_579487 = newJObject()
  add(query_579487, "key", newJString(key))
  add(query_579487, "prettyPrint", newJBool(prettyPrint))
  add(query_579487, "oauth_token", newJString(oauthToken))
  add(query_579487, "alt", newJString(alt))
  add(query_579487, "userIp", newJString(userIp))
  add(query_579487, "quotaUser", newJString(quotaUser))
  add(path_579486, "instance", newJString(instance))
  add(path_579486, "project", newJString(project))
  add(query_579487, "fields", newJString(fields))
  result = call_579485.call(path_579486, query_579487, nil, nil, nil)

var sqlInstancesStartReplica* = Call_SqlInstancesStartReplica_579472(
    name: "sqlInstancesStartReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/startReplica",
    validator: validate_SqlInstancesStartReplica_579473, base: "/sql/v1beta4",
    url: url_SqlInstancesStartReplica_579474, schemes: {Scheme.Https})
type
  Call_SqlInstancesStopReplica_579488 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesStopReplica_579490(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/stopReplica")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesStopReplica_579489(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops the replication in the read replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: JString (required)
  ##          : ID of the project that contains the read replica.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579491 = path.getOrDefault("instance")
  valid_579491 = validateParameter(valid_579491, JString, required = true,
                                 default = nil)
  if valid_579491 != nil:
    section.add "instance", valid_579491
  var valid_579492 = path.getOrDefault("project")
  valid_579492 = validateParameter(valid_579492, JString, required = true,
                                 default = nil)
  if valid_579492 != nil:
    section.add "project", valid_579492
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579493 = query.getOrDefault("key")
  valid_579493 = validateParameter(valid_579493, JString, required = false,
                                 default = nil)
  if valid_579493 != nil:
    section.add "key", valid_579493
  var valid_579494 = query.getOrDefault("prettyPrint")
  valid_579494 = validateParameter(valid_579494, JBool, required = false,
                                 default = newJBool(true))
  if valid_579494 != nil:
    section.add "prettyPrint", valid_579494
  var valid_579495 = query.getOrDefault("oauth_token")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = nil)
  if valid_579495 != nil:
    section.add "oauth_token", valid_579495
  var valid_579496 = query.getOrDefault("alt")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = newJString("json"))
  if valid_579496 != nil:
    section.add "alt", valid_579496
  var valid_579497 = query.getOrDefault("userIp")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "userIp", valid_579497
  var valid_579498 = query.getOrDefault("quotaUser")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "quotaUser", valid_579498
  var valid_579499 = query.getOrDefault("fields")
  valid_579499 = validateParameter(valid_579499, JString, required = false,
                                 default = nil)
  if valid_579499 != nil:
    section.add "fields", valid_579499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579500: Call_SqlInstancesStopReplica_579488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops the replication in the read replica instance.
  ## 
  let valid = call_579500.validator(path, query, header, formData, body)
  let scheme = call_579500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579500.url(scheme.get, call_579500.host, call_579500.base,
                         call_579500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579500, url, valid)

proc call*(call_579501: Call_SqlInstancesStopReplica_579488; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesStopReplica
  ## Stops the replication in the read replica instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579502 = newJObject()
  var query_579503 = newJObject()
  add(query_579503, "key", newJString(key))
  add(query_579503, "prettyPrint", newJBool(prettyPrint))
  add(query_579503, "oauth_token", newJString(oauthToken))
  add(query_579503, "alt", newJString(alt))
  add(query_579503, "userIp", newJString(userIp))
  add(query_579503, "quotaUser", newJString(quotaUser))
  add(path_579502, "instance", newJString(instance))
  add(path_579502, "project", newJString(project))
  add(query_579503, "fields", newJString(fields))
  result = call_579501.call(path_579502, query_579503, nil, nil, nil)

var sqlInstancesStopReplica* = Call_SqlInstancesStopReplica_579488(
    name: "sqlInstancesStopReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/stopReplica",
    validator: validate_SqlInstancesStopReplica_579489, base: "/sql/v1beta4",
    url: url_SqlInstancesStopReplica_579490, schemes: {Scheme.Https})
type
  Call_SqlInstancesTruncateLog_579504 = ref object of OpenApiRestCall_578348
proc url_SqlInstancesTruncateLog_579506(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/truncateLog")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesTruncateLog_579505(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Truncate MySQL general and slow query log tables
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the Cloud SQL project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579507 = path.getOrDefault("instance")
  valid_579507 = validateParameter(valid_579507, JString, required = true,
                                 default = nil)
  if valid_579507 != nil:
    section.add "instance", valid_579507
  var valid_579508 = path.getOrDefault("project")
  valid_579508 = validateParameter(valid_579508, JString, required = true,
                                 default = nil)
  if valid_579508 != nil:
    section.add "project", valid_579508
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579509 = query.getOrDefault("key")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "key", valid_579509
  var valid_579510 = query.getOrDefault("prettyPrint")
  valid_579510 = validateParameter(valid_579510, JBool, required = false,
                                 default = newJBool(true))
  if valid_579510 != nil:
    section.add "prettyPrint", valid_579510
  var valid_579511 = query.getOrDefault("oauth_token")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "oauth_token", valid_579511
  var valid_579512 = query.getOrDefault("alt")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = newJString("json"))
  if valid_579512 != nil:
    section.add "alt", valid_579512
  var valid_579513 = query.getOrDefault("userIp")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "userIp", valid_579513
  var valid_579514 = query.getOrDefault("quotaUser")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "quotaUser", valid_579514
  var valid_579515 = query.getOrDefault("fields")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "fields", valid_579515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579517: Call_SqlInstancesTruncateLog_579504; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Truncate MySQL general and slow query log tables
  ## 
  let valid = call_579517.validator(path, query, header, formData, body)
  let scheme = call_579517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579517.url(scheme.get, call_579517.host, call_579517.base,
                         call_579517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579517, url, valid)

proc call*(call_579518: Call_SqlInstancesTruncateLog_579504; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesTruncateLog
  ## Truncate MySQL general and slow query log tables
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the Cloud SQL project.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579519 = newJObject()
  var query_579520 = newJObject()
  var body_579521 = newJObject()
  add(query_579520, "key", newJString(key))
  add(query_579520, "prettyPrint", newJBool(prettyPrint))
  add(query_579520, "oauth_token", newJString(oauthToken))
  add(query_579520, "alt", newJString(alt))
  add(query_579520, "userIp", newJString(userIp))
  add(query_579520, "quotaUser", newJString(quotaUser))
  add(path_579519, "instance", newJString(instance))
  add(path_579519, "project", newJString(project))
  if body != nil:
    body_579521 = body
  add(query_579520, "fields", newJString(fields))
  result = call_579518.call(path_579519, query_579520, nil, nil, body_579521)

var sqlInstancesTruncateLog* = Call_SqlInstancesTruncateLog_579504(
    name: "sqlInstancesTruncateLog", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/truncateLog",
    validator: validate_SqlInstancesTruncateLog_579505, base: "/sql/v1beta4",
    url: url_SqlInstancesTruncateLog_579506, schemes: {Scheme.Https})
type
  Call_SqlUsersUpdate_579538 = ref object of OpenApiRestCall_578348
proc url_SqlUsersUpdate_579540(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlUsersUpdate_579539(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing user in a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579541 = path.getOrDefault("instance")
  valid_579541 = validateParameter(valid_579541, JString, required = true,
                                 default = nil)
  if valid_579541 != nil:
    section.add "instance", valid_579541
  var valid_579542 = path.getOrDefault("project")
  valid_579542 = validateParameter(valid_579542, JString, required = true,
                                 default = nil)
  if valid_579542 != nil:
    section.add "project", valid_579542
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString (required)
  ##       : Name of the user in the instance.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   host: JString
  ##       : Host of the user in the instance. For a MySQL instance, it's required; For a PostgreSQL instance, it's optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579543 = query.getOrDefault("key")
  valid_579543 = validateParameter(valid_579543, JString, required = false,
                                 default = nil)
  if valid_579543 != nil:
    section.add "key", valid_579543
  var valid_579544 = query.getOrDefault("prettyPrint")
  valid_579544 = validateParameter(valid_579544, JBool, required = false,
                                 default = newJBool(true))
  if valid_579544 != nil:
    section.add "prettyPrint", valid_579544
  var valid_579545 = query.getOrDefault("oauth_token")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = nil)
  if valid_579545 != nil:
    section.add "oauth_token", valid_579545
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_579546 = query.getOrDefault("name")
  valid_579546 = validateParameter(valid_579546, JString, required = true,
                                 default = nil)
  if valid_579546 != nil:
    section.add "name", valid_579546
  var valid_579547 = query.getOrDefault("alt")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = newJString("json"))
  if valid_579547 != nil:
    section.add "alt", valid_579547
  var valid_579548 = query.getOrDefault("userIp")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "userIp", valid_579548
  var valid_579549 = query.getOrDefault("quotaUser")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "quotaUser", valid_579549
  var valid_579550 = query.getOrDefault("host")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = nil)
  if valid_579550 != nil:
    section.add "host", valid_579550
  var valid_579551 = query.getOrDefault("fields")
  valid_579551 = validateParameter(valid_579551, JString, required = false,
                                 default = nil)
  if valid_579551 != nil:
    section.add "fields", valid_579551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579553: Call_SqlUsersUpdate_579538; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing user in a Cloud SQL instance.
  ## 
  let valid = call_579553.validator(path, query, header, formData, body)
  let scheme = call_579553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579553.url(scheme.get, call_579553.host, call_579553.base,
                         call_579553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579553, url, valid)

proc call*(call_579554: Call_SqlUsersUpdate_579538; name: string; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; host: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## sqlUsersUpdate
  ## Updates an existing user in a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string (required)
  ##       : Name of the user in the instance.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   host: string
  ##       : Host of the user in the instance. For a MySQL instance, it's required; For a PostgreSQL instance, it's optional.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579555 = newJObject()
  var query_579556 = newJObject()
  var body_579557 = newJObject()
  add(query_579556, "key", newJString(key))
  add(query_579556, "prettyPrint", newJBool(prettyPrint))
  add(query_579556, "oauth_token", newJString(oauthToken))
  add(query_579556, "name", newJString(name))
  add(query_579556, "alt", newJString(alt))
  add(query_579556, "userIp", newJString(userIp))
  add(query_579556, "quotaUser", newJString(quotaUser))
  add(path_579555, "instance", newJString(instance))
  add(query_579556, "host", newJString(host))
  add(path_579555, "project", newJString(project))
  if body != nil:
    body_579557 = body
  add(query_579556, "fields", newJString(fields))
  result = call_579554.call(path_579555, query_579556, nil, nil, body_579557)

var sqlUsersUpdate* = Call_SqlUsersUpdate_579538(name: "sqlUsersUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersUpdate_579539, base: "/sql/v1beta4",
    url: url_SqlUsersUpdate_579540, schemes: {Scheme.Https})
type
  Call_SqlUsersInsert_579558 = ref object of OpenApiRestCall_578348
proc url_SqlUsersInsert_579560(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlUsersInsert_579559(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a new user in a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579561 = path.getOrDefault("instance")
  valid_579561 = validateParameter(valid_579561, JString, required = true,
                                 default = nil)
  if valid_579561 != nil:
    section.add "instance", valid_579561
  var valid_579562 = path.getOrDefault("project")
  valid_579562 = validateParameter(valid_579562, JString, required = true,
                                 default = nil)
  if valid_579562 != nil:
    section.add "project", valid_579562
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579563 = query.getOrDefault("key")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "key", valid_579563
  var valid_579564 = query.getOrDefault("prettyPrint")
  valid_579564 = validateParameter(valid_579564, JBool, required = false,
                                 default = newJBool(true))
  if valid_579564 != nil:
    section.add "prettyPrint", valid_579564
  var valid_579565 = query.getOrDefault("oauth_token")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "oauth_token", valid_579565
  var valid_579566 = query.getOrDefault("alt")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = newJString("json"))
  if valid_579566 != nil:
    section.add "alt", valid_579566
  var valid_579567 = query.getOrDefault("userIp")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = nil)
  if valid_579567 != nil:
    section.add "userIp", valid_579567
  var valid_579568 = query.getOrDefault("quotaUser")
  valid_579568 = validateParameter(valid_579568, JString, required = false,
                                 default = nil)
  if valid_579568 != nil:
    section.add "quotaUser", valid_579568
  var valid_579569 = query.getOrDefault("fields")
  valid_579569 = validateParameter(valid_579569, JString, required = false,
                                 default = nil)
  if valid_579569 != nil:
    section.add "fields", valid_579569
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579571: Call_SqlUsersInsert_579558; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new user in a Cloud SQL instance.
  ## 
  let valid = call_579571.validator(path, query, header, formData, body)
  let scheme = call_579571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579571.url(scheme.get, call_579571.host, call_579571.base,
                         call_579571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579571, url, valid)

proc call*(call_579572: Call_SqlUsersInsert_579558; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlUsersInsert
  ## Creates a new user in a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579573 = newJObject()
  var query_579574 = newJObject()
  var body_579575 = newJObject()
  add(query_579574, "key", newJString(key))
  add(query_579574, "prettyPrint", newJBool(prettyPrint))
  add(query_579574, "oauth_token", newJString(oauthToken))
  add(query_579574, "alt", newJString(alt))
  add(query_579574, "userIp", newJString(userIp))
  add(query_579574, "quotaUser", newJString(quotaUser))
  add(path_579573, "instance", newJString(instance))
  add(path_579573, "project", newJString(project))
  if body != nil:
    body_579575 = body
  add(query_579574, "fields", newJString(fields))
  result = call_579572.call(path_579573, query_579574, nil, nil, body_579575)

var sqlUsersInsert* = Call_SqlUsersInsert_579558(name: "sqlUsersInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersInsert_579559, base: "/sql/v1beta4",
    url: url_SqlUsersInsert_579560, schemes: {Scheme.Https})
type
  Call_SqlUsersList_579522 = ref object of OpenApiRestCall_578348
proc url_SqlUsersList_579524(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlUsersList_579523(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists users in the specified Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579525 = path.getOrDefault("instance")
  valid_579525 = validateParameter(valid_579525, JString, required = true,
                                 default = nil)
  if valid_579525 != nil:
    section.add "instance", valid_579525
  var valid_579526 = path.getOrDefault("project")
  valid_579526 = validateParameter(valid_579526, JString, required = true,
                                 default = nil)
  if valid_579526 != nil:
    section.add "project", valid_579526
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579527 = query.getOrDefault("key")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "key", valid_579527
  var valid_579528 = query.getOrDefault("prettyPrint")
  valid_579528 = validateParameter(valid_579528, JBool, required = false,
                                 default = newJBool(true))
  if valid_579528 != nil:
    section.add "prettyPrint", valid_579528
  var valid_579529 = query.getOrDefault("oauth_token")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "oauth_token", valid_579529
  var valid_579530 = query.getOrDefault("alt")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = newJString("json"))
  if valid_579530 != nil:
    section.add "alt", valid_579530
  var valid_579531 = query.getOrDefault("userIp")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "userIp", valid_579531
  var valid_579532 = query.getOrDefault("quotaUser")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "quotaUser", valid_579532
  var valid_579533 = query.getOrDefault("fields")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "fields", valid_579533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579534: Call_SqlUsersList_579522; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists users in the specified Cloud SQL instance.
  ## 
  let valid = call_579534.validator(path, query, header, formData, body)
  let scheme = call_579534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579534.url(scheme.get, call_579534.host, call_579534.base,
                         call_579534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579534, url, valid)

proc call*(call_579535: Call_SqlUsersList_579522; instance: string; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## sqlUsersList
  ## Lists users in the specified Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579536 = newJObject()
  var query_579537 = newJObject()
  add(query_579537, "key", newJString(key))
  add(query_579537, "prettyPrint", newJBool(prettyPrint))
  add(query_579537, "oauth_token", newJString(oauthToken))
  add(query_579537, "alt", newJString(alt))
  add(query_579537, "userIp", newJString(userIp))
  add(query_579537, "quotaUser", newJString(quotaUser))
  add(path_579536, "instance", newJString(instance))
  add(path_579536, "project", newJString(project))
  add(query_579537, "fields", newJString(fields))
  result = call_579535.call(path_579536, query_579537, nil, nil, nil)

var sqlUsersList* = Call_SqlUsersList_579522(name: "sqlUsersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersList_579523, base: "/sql/v1beta4",
    url: url_SqlUsersList_579524, schemes: {Scheme.Https})
type
  Call_SqlUsersDelete_579576 = ref object of OpenApiRestCall_578348
proc url_SqlUsersDelete_579578(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlUsersDelete_579577(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a user from a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579579 = path.getOrDefault("instance")
  valid_579579 = validateParameter(valid_579579, JString, required = true,
                                 default = nil)
  if valid_579579 != nil:
    section.add "instance", valid_579579
  var valid_579580 = path.getOrDefault("project")
  valid_579580 = validateParameter(valid_579580, JString, required = true,
                                 default = nil)
  if valid_579580 != nil:
    section.add "project", valid_579580
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString (required)
  ##       : Name of the user in the instance.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   host: JString (required)
  ##       : Host of the user in the instance.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579581 = query.getOrDefault("key")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "key", valid_579581
  var valid_579582 = query.getOrDefault("prettyPrint")
  valid_579582 = validateParameter(valid_579582, JBool, required = false,
                                 default = newJBool(true))
  if valid_579582 != nil:
    section.add "prettyPrint", valid_579582
  var valid_579583 = query.getOrDefault("oauth_token")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = nil)
  if valid_579583 != nil:
    section.add "oauth_token", valid_579583
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_579584 = query.getOrDefault("name")
  valid_579584 = validateParameter(valid_579584, JString, required = true,
                                 default = nil)
  if valid_579584 != nil:
    section.add "name", valid_579584
  var valid_579585 = query.getOrDefault("alt")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = newJString("json"))
  if valid_579585 != nil:
    section.add "alt", valid_579585
  var valid_579586 = query.getOrDefault("userIp")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = nil)
  if valid_579586 != nil:
    section.add "userIp", valid_579586
  var valid_579587 = query.getOrDefault("quotaUser")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "quotaUser", valid_579587
  var valid_579588 = query.getOrDefault("host")
  valid_579588 = validateParameter(valid_579588, JString, required = true,
                                 default = nil)
  if valid_579588 != nil:
    section.add "host", valid_579588
  var valid_579589 = query.getOrDefault("fields")
  valid_579589 = validateParameter(valid_579589, JString, required = false,
                                 default = nil)
  if valid_579589 != nil:
    section.add "fields", valid_579589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579590: Call_SqlUsersDelete_579576; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a user from a Cloud SQL instance.
  ## 
  let valid = call_579590.validator(path, query, header, formData, body)
  let scheme = call_579590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579590.url(scheme.get, call_579590.host, call_579590.base,
                         call_579590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579590, url, valid)

proc call*(call_579591: Call_SqlUsersDelete_579576; name: string; instance: string;
          host: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlUsersDelete
  ## Deletes a user from a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string (required)
  ##       : Name of the user in the instance.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   host: string (required)
  ##       : Host of the user in the instance.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579592 = newJObject()
  var query_579593 = newJObject()
  add(query_579593, "key", newJString(key))
  add(query_579593, "prettyPrint", newJBool(prettyPrint))
  add(query_579593, "oauth_token", newJString(oauthToken))
  add(query_579593, "name", newJString(name))
  add(query_579593, "alt", newJString(alt))
  add(query_579593, "userIp", newJString(userIp))
  add(query_579593, "quotaUser", newJString(quotaUser))
  add(path_579592, "instance", newJString(instance))
  add(query_579593, "host", newJString(host))
  add(path_579592, "project", newJString(project))
  add(query_579593, "fields", newJString(fields))
  result = call_579591.call(path_579592, query_579593, nil, nil, nil)

var sqlUsersDelete* = Call_SqlUsersDelete_579576(name: "sqlUsersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersDelete_579577, base: "/sql/v1beta4",
    url: url_SqlUsersDelete_579578, schemes: {Scheme.Https})
type
  Call_SqlOperationsList_579594 = ref object of OpenApiRestCall_578348
proc url_SqlOperationsList_579596(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlOperationsList_579595(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all instance operations that have been performed on the given Cloud SQL instance in the reverse chronological order of the start time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579597 = path.getOrDefault("project")
  valid_579597 = validateParameter(valid_579597, JString, required = true,
                                 default = nil)
  if valid_579597 != nil:
    section.add "project", valid_579597
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   maxResults: JInt
  ##             : Maximum number of operations per response.
  section = newJObject()
  var valid_579598 = query.getOrDefault("key")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = nil)
  if valid_579598 != nil:
    section.add "key", valid_579598
  var valid_579599 = query.getOrDefault("prettyPrint")
  valid_579599 = validateParameter(valid_579599, JBool, required = false,
                                 default = newJBool(true))
  if valid_579599 != nil:
    section.add "prettyPrint", valid_579599
  var valid_579600 = query.getOrDefault("oauth_token")
  valid_579600 = validateParameter(valid_579600, JString, required = false,
                                 default = nil)
  if valid_579600 != nil:
    section.add "oauth_token", valid_579600
  var valid_579601 = query.getOrDefault("alt")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = newJString("json"))
  if valid_579601 != nil:
    section.add "alt", valid_579601
  var valid_579602 = query.getOrDefault("userIp")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = nil)
  if valid_579602 != nil:
    section.add "userIp", valid_579602
  var valid_579603 = query.getOrDefault("quotaUser")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "quotaUser", valid_579603
  var valid_579604 = query.getOrDefault("pageToken")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "pageToken", valid_579604
  var valid_579605 = query.getOrDefault("fields")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = nil)
  if valid_579605 != nil:
    section.add "fields", valid_579605
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_579606 = query.getOrDefault("instance")
  valid_579606 = validateParameter(valid_579606, JString, required = true,
                                 default = nil)
  if valid_579606 != nil:
    section.add "instance", valid_579606
  var valid_579607 = query.getOrDefault("maxResults")
  valid_579607 = validateParameter(valid_579607, JInt, required = false, default = nil)
  if valid_579607 != nil:
    section.add "maxResults", valid_579607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579608: Call_SqlOperationsList_579594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all instance operations that have been performed on the given Cloud SQL instance in the reverse chronological order of the start time.
  ## 
  let valid = call_579608.validator(path, query, header, formData, body)
  let scheme = call_579608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579608.url(scheme.get, call_579608.host, call_579608.base,
                         call_579608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579608, url, valid)

proc call*(call_579609: Call_SqlOperationsList_579594; project: string;
          instance: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## sqlOperationsList
  ## Lists all instance operations that have been performed on the given Cloud SQL instance in the reverse chronological order of the start time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   maxResults: int
  ##             : Maximum number of operations per response.
  var path_579610 = newJObject()
  var query_579611 = newJObject()
  add(query_579611, "key", newJString(key))
  add(query_579611, "prettyPrint", newJBool(prettyPrint))
  add(query_579611, "oauth_token", newJString(oauthToken))
  add(query_579611, "alt", newJString(alt))
  add(query_579611, "userIp", newJString(userIp))
  add(query_579611, "quotaUser", newJString(quotaUser))
  add(query_579611, "pageToken", newJString(pageToken))
  add(path_579610, "project", newJString(project))
  add(query_579611, "fields", newJString(fields))
  add(query_579611, "instance", newJString(instance))
  add(query_579611, "maxResults", newJInt(maxResults))
  result = call_579609.call(path_579610, query_579611, nil, nil, nil)

var sqlOperationsList* = Call_SqlOperationsList_579594(name: "sqlOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/operations",
    validator: validate_SqlOperationsList_579595, base: "/sql/v1beta4",
    url: url_SqlOperationsList_579596, schemes: {Scheme.Https})
type
  Call_SqlOperationsGet_579612 = ref object of OpenApiRestCall_578348
proc url_SqlOperationsGet_579614(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlOperationsGet_579613(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves an instance operation that has been performed on an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operation: JString (required)
  ##            : Instance operation ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operation` field"
  var valid_579615 = path.getOrDefault("operation")
  valid_579615 = validateParameter(valid_579615, JString, required = true,
                                 default = nil)
  if valid_579615 != nil:
    section.add "operation", valid_579615
  var valid_579616 = path.getOrDefault("project")
  valid_579616 = validateParameter(valid_579616, JString, required = true,
                                 default = nil)
  if valid_579616 != nil:
    section.add "project", valid_579616
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579617 = query.getOrDefault("key")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "key", valid_579617
  var valid_579618 = query.getOrDefault("prettyPrint")
  valid_579618 = validateParameter(valid_579618, JBool, required = false,
                                 default = newJBool(true))
  if valid_579618 != nil:
    section.add "prettyPrint", valid_579618
  var valid_579619 = query.getOrDefault("oauth_token")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "oauth_token", valid_579619
  var valid_579620 = query.getOrDefault("alt")
  valid_579620 = validateParameter(valid_579620, JString, required = false,
                                 default = newJString("json"))
  if valid_579620 != nil:
    section.add "alt", valid_579620
  var valid_579621 = query.getOrDefault("userIp")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "userIp", valid_579621
  var valid_579622 = query.getOrDefault("quotaUser")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "quotaUser", valid_579622
  var valid_579623 = query.getOrDefault("fields")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = nil)
  if valid_579623 != nil:
    section.add "fields", valid_579623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579624: Call_SqlOperationsGet_579612; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an instance operation that has been performed on an instance.
  ## 
  let valid = call_579624.validator(path, query, header, formData, body)
  let scheme = call_579624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579624.url(scheme.get, call_579624.host, call_579624.base,
                         call_579624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579624, url, valid)

proc call*(call_579625: Call_SqlOperationsGet_579612; operation: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlOperationsGet
  ## Retrieves an instance operation that has been performed on an instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   operation: string (required)
  ##            : Instance operation ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579626 = newJObject()
  var query_579627 = newJObject()
  add(query_579627, "key", newJString(key))
  add(query_579627, "prettyPrint", newJBool(prettyPrint))
  add(query_579627, "oauth_token", newJString(oauthToken))
  add(path_579626, "operation", newJString(operation))
  add(query_579627, "alt", newJString(alt))
  add(query_579627, "userIp", newJString(userIp))
  add(query_579627, "quotaUser", newJString(quotaUser))
  add(path_579626, "project", newJString(project))
  add(query_579627, "fields", newJString(fields))
  result = call_579625.call(path_579626, query_579627, nil, nil, nil)

var sqlOperationsGet* = Call_SqlOperationsGet_579612(name: "sqlOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/operations/{operation}",
    validator: validate_SqlOperationsGet_579613, base: "/sql/v1beta4",
    url: url_SqlOperationsGet_579614, schemes: {Scheme.Https})
type
  Call_SqlTiersList_579628 = ref object of OpenApiRestCall_578348
proc url_SqlTiersList_579630(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/tiers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlTiersList_579629(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1. For related information, see Pricing.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project for which to list tiers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579631 = path.getOrDefault("project")
  valid_579631 = validateParameter(valid_579631, JString, required = true,
                                 default = nil)
  if valid_579631 != nil:
    section.add "project", valid_579631
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579632 = query.getOrDefault("key")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "key", valid_579632
  var valid_579633 = query.getOrDefault("prettyPrint")
  valid_579633 = validateParameter(valid_579633, JBool, required = false,
                                 default = newJBool(true))
  if valid_579633 != nil:
    section.add "prettyPrint", valid_579633
  var valid_579634 = query.getOrDefault("oauth_token")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = nil)
  if valid_579634 != nil:
    section.add "oauth_token", valid_579634
  var valid_579635 = query.getOrDefault("alt")
  valid_579635 = validateParameter(valid_579635, JString, required = false,
                                 default = newJString("json"))
  if valid_579635 != nil:
    section.add "alt", valid_579635
  var valid_579636 = query.getOrDefault("userIp")
  valid_579636 = validateParameter(valid_579636, JString, required = false,
                                 default = nil)
  if valid_579636 != nil:
    section.add "userIp", valid_579636
  var valid_579637 = query.getOrDefault("quotaUser")
  valid_579637 = validateParameter(valid_579637, JString, required = false,
                                 default = nil)
  if valid_579637 != nil:
    section.add "quotaUser", valid_579637
  var valid_579638 = query.getOrDefault("fields")
  valid_579638 = validateParameter(valid_579638, JString, required = false,
                                 default = nil)
  if valid_579638 != nil:
    section.add "fields", valid_579638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579639: Call_SqlTiersList_579628; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1. For related information, see Pricing.
  ## 
  let valid = call_579639.validator(path, query, header, formData, body)
  let scheme = call_579639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579639.url(scheme.get, call_579639.host, call_579639.base,
                         call_579639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579639, url, valid)

proc call*(call_579640: Call_SqlTiersList_579628; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlTiersList
  ## Lists all available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1. For related information, see Pricing.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : Project ID of the project for which to list tiers.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579641 = newJObject()
  var query_579642 = newJObject()
  add(query_579642, "key", newJString(key))
  add(query_579642, "prettyPrint", newJBool(prettyPrint))
  add(query_579642, "oauth_token", newJString(oauthToken))
  add(query_579642, "alt", newJString(alt))
  add(query_579642, "userIp", newJString(userIp))
  add(query_579642, "quotaUser", newJString(quotaUser))
  add(path_579641, "project", newJString(project))
  add(query_579642, "fields", newJString(fields))
  result = call_579640.call(path_579641, query_579642, nil, nil, nil)

var sqlTiersList* = Call_SqlTiersList_579628(name: "sqlTiersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/tiers", validator: validate_SqlTiersList_579629,
    base: "/sql/v1beta4", url: url_SqlTiersList_579630, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
