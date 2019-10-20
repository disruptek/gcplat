
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud SQL Administration
## version: v1beta3
## termsOfService: (not provided)
## license: (not provided)
## 
## Creates and configures Cloud SQL instances, which provide fully-managed MySQL databases.
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  Call_SqlFlagsList_578609 = ref object of OpenApiRestCall_578339
proc url_SqlFlagsList_578611(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SqlFlagsList_578610(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all database flags that can be set for Google Cloud SQL instances.
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
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578723 = query.getOrDefault("key")
  valid_578723 = validateParameter(valid_578723, JString, required = false,
                                 default = nil)
  if valid_578723 != nil:
    section.add "key", valid_578723
  var valid_578737 = query.getOrDefault("prettyPrint")
  valid_578737 = validateParameter(valid_578737, JBool, required = false,
                                 default = newJBool(true))
  if valid_578737 != nil:
    section.add "prettyPrint", valid_578737
  var valid_578738 = query.getOrDefault("oauth_token")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "oauth_token", valid_578738
  var valid_578739 = query.getOrDefault("alt")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = newJString("json"))
  if valid_578739 != nil:
    section.add "alt", valid_578739
  var valid_578740 = query.getOrDefault("userIp")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "userIp", valid_578740
  var valid_578741 = query.getOrDefault("quotaUser")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "quotaUser", valid_578741
  var valid_578742 = query.getOrDefault("fields")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "fields", valid_578742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578765: Call_SqlFlagsList_578609; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all database flags that can be set for Google Cloud SQL instances.
  ## 
  let valid = call_578765.validator(path, query, header, formData, body)
  let scheme = call_578765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578765.url(scheme.get, call_578765.host, call_578765.base,
                         call_578765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578765, url, valid)

proc call*(call_578836: Call_SqlFlagsList_578609; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlFlagsList
  ## Lists all database flags that can be set for Google Cloud SQL instances.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578837 = newJObject()
  add(query_578837, "key", newJString(key))
  add(query_578837, "prettyPrint", newJBool(prettyPrint))
  add(query_578837, "oauth_token", newJString(oauthToken))
  add(query_578837, "alt", newJString(alt))
  add(query_578837, "userIp", newJString(userIp))
  add(query_578837, "quotaUser", newJString(quotaUser))
  add(query_578837, "fields", newJString(fields))
  result = call_578836.call(nil, query_578837, nil, nil, nil)

var sqlFlagsList* = Call_SqlFlagsList_578609(name: "sqlFlagsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/flags",
    validator: validate_SqlFlagsList_578610, base: "/sql/v1beta3",
    url: url_SqlFlagsList_578611, schemes: {Scheme.Https})
type
  Call_SqlInstancesInsert_578908 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesInsert_578910(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesInsert_578909(path: JsonNode; query: JsonNode;
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
  var valid_578911 = path.getOrDefault("project")
  valid_578911 = validateParameter(valid_578911, JString, required = true,
                                 default = nil)
  if valid_578911 != nil:
    section.add "project", valid_578911
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
  var valid_578912 = query.getOrDefault("key")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "key", valid_578912
  var valid_578913 = query.getOrDefault("prettyPrint")
  valid_578913 = validateParameter(valid_578913, JBool, required = false,
                                 default = newJBool(true))
  if valid_578913 != nil:
    section.add "prettyPrint", valid_578913
  var valid_578914 = query.getOrDefault("oauth_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "oauth_token", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("userIp")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "userIp", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("fields")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "fields", valid_578918
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

proc call*(call_578920: Call_SqlInstancesInsert_578908; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Cloud SQL instance.
  ## 
  let valid = call_578920.validator(path, query, header, formData, body)
  let scheme = call_578920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578920.url(scheme.get, call_578920.host, call_578920.base,
                         call_578920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578920, url, valid)

proc call*(call_578921: Call_SqlInstancesInsert_578908; project: string;
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
  var path_578922 = newJObject()
  var query_578923 = newJObject()
  var body_578924 = newJObject()
  add(query_578923, "key", newJString(key))
  add(query_578923, "prettyPrint", newJBool(prettyPrint))
  add(query_578923, "oauth_token", newJString(oauthToken))
  add(query_578923, "alt", newJString(alt))
  add(query_578923, "userIp", newJString(userIp))
  add(query_578923, "quotaUser", newJString(quotaUser))
  add(path_578922, "project", newJString(project))
  if body != nil:
    body_578924 = body
  add(query_578923, "fields", newJString(fields))
  result = call_578921.call(path_578922, query_578923, nil, nil, body_578924)

var sqlInstancesInsert* = Call_SqlInstancesInsert_578908(
    name: "sqlInstancesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{project}/instances",
    validator: validate_SqlInstancesInsert_578909, base: "/sql/v1beta3",
    url: url_SqlInstancesInsert_578910, schemes: {Scheme.Https})
type
  Call_SqlInstancesList_578877 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesList_578879(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesList_578878(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists instances for a given project, in alphabetical order by instance name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project for which to list Cloud SQL instances.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578894 = path.getOrDefault("project")
  valid_578894 = validateParameter(valid_578894, JString, required = true,
                                 default = nil)
  if valid_578894 != nil:
    section.add "project", valid_578894
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
  ##             : The maximum number of results to return per response.
  section = newJObject()
  var valid_578895 = query.getOrDefault("key")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "key", valid_578895
  var valid_578896 = query.getOrDefault("prettyPrint")
  valid_578896 = validateParameter(valid_578896, JBool, required = false,
                                 default = newJBool(true))
  if valid_578896 != nil:
    section.add "prettyPrint", valid_578896
  var valid_578897 = query.getOrDefault("oauth_token")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "oauth_token", valid_578897
  var valid_578898 = query.getOrDefault("alt")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = newJString("json"))
  if valid_578898 != nil:
    section.add "alt", valid_578898
  var valid_578899 = query.getOrDefault("userIp")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "userIp", valid_578899
  var valid_578900 = query.getOrDefault("quotaUser")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "quotaUser", valid_578900
  var valid_578901 = query.getOrDefault("pageToken")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "pageToken", valid_578901
  var valid_578902 = query.getOrDefault("fields")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "fields", valid_578902
  var valid_578903 = query.getOrDefault("maxResults")
  valid_578903 = validateParameter(valid_578903, JInt, required = false, default = nil)
  if valid_578903 != nil:
    section.add "maxResults", valid_578903
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578904: Call_SqlInstancesList_578877; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists instances for a given project, in alphabetical order by instance name.
  ## 
  let valid = call_578904.validator(path, query, header, formData, body)
  let scheme = call_578904.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578904.url(scheme.get, call_578904.host, call_578904.base,
                         call_578904.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578904, url, valid)

proc call*(call_578905: Call_SqlInstancesList_578877; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## sqlInstancesList
  ## Lists instances for a given project, in alphabetical order by instance name.
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
  ##          : Project ID of the project for which to list Cloud SQL instances.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results to return per response.
  var path_578906 = newJObject()
  var query_578907 = newJObject()
  add(query_578907, "key", newJString(key))
  add(query_578907, "prettyPrint", newJBool(prettyPrint))
  add(query_578907, "oauth_token", newJString(oauthToken))
  add(query_578907, "alt", newJString(alt))
  add(query_578907, "userIp", newJString(userIp))
  add(query_578907, "quotaUser", newJString(quotaUser))
  add(query_578907, "pageToken", newJString(pageToken))
  add(path_578906, "project", newJString(project))
  add(query_578907, "fields", newJString(fields))
  add(query_578907, "maxResults", newJInt(maxResults))
  result = call_578905.call(path_578906, query_578907, nil, nil, nil)

var sqlInstancesList* = Call_SqlInstancesList_578877(name: "sqlInstancesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances", validator: validate_SqlInstancesList_578878,
    base: "/sql/v1beta3", url: url_SqlInstancesList_578879, schemes: {Scheme.Https})
type
  Call_SqlInstancesClone_578925 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesClone_578927(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/clone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesClone_578926(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a Cloud SQL instance as a clone of a source instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the source as well as the clone Cloud SQL instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578928 = path.getOrDefault("project")
  valid_578928 = validateParameter(valid_578928, JString, required = true,
                                 default = nil)
  if valid_578928 != nil:
    section.add "project", valid_578928
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
  var valid_578929 = query.getOrDefault("key")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "key", valid_578929
  var valid_578930 = query.getOrDefault("prettyPrint")
  valid_578930 = validateParameter(valid_578930, JBool, required = false,
                                 default = newJBool(true))
  if valid_578930 != nil:
    section.add "prettyPrint", valid_578930
  var valid_578931 = query.getOrDefault("oauth_token")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "oauth_token", valid_578931
  var valid_578932 = query.getOrDefault("alt")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = newJString("json"))
  if valid_578932 != nil:
    section.add "alt", valid_578932
  var valid_578933 = query.getOrDefault("userIp")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "userIp", valid_578933
  var valid_578934 = query.getOrDefault("quotaUser")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "quotaUser", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
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

proc call*(call_578937: Call_SqlInstancesClone_578925; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud SQL instance as a clone of a source instance.
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_SqlInstancesClone_578925; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesClone
  ## Creates a Cloud SQL instance as a clone of a source instance.
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
  ##          : Project ID of the source as well as the clone Cloud SQL instance.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578939 = newJObject()
  var query_578940 = newJObject()
  var body_578941 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "userIp", newJString(userIp))
  add(query_578940, "quotaUser", newJString(quotaUser))
  add(path_578939, "project", newJString(project))
  if body != nil:
    body_578941 = body
  add(query_578940, "fields", newJString(fields))
  result = call_578938.call(path_578939, query_578940, nil, nil, body_578941)

var sqlInstancesClone* = Call_SqlInstancesClone_578925(name: "sqlInstancesClone",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/clone",
    validator: validate_SqlInstancesClone_578926, base: "/sql/v1beta3",
    url: url_SqlInstancesClone_578927, schemes: {Scheme.Https})
type
  Call_SqlInstancesUpdate_578958 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesUpdate_578960(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesUpdate_578959(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the settings of a Cloud SQL instance.
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
  var valid_578961 = path.getOrDefault("instance")
  valid_578961 = validateParameter(valid_578961, JString, required = true,
                                 default = nil)
  if valid_578961 != nil:
    section.add "instance", valid_578961
  var valid_578962 = path.getOrDefault("project")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "project", valid_578962
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
  var valid_578963 = query.getOrDefault("key")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "key", valid_578963
  var valid_578964 = query.getOrDefault("prettyPrint")
  valid_578964 = validateParameter(valid_578964, JBool, required = false,
                                 default = newJBool(true))
  if valid_578964 != nil:
    section.add "prettyPrint", valid_578964
  var valid_578965 = query.getOrDefault("oauth_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "oauth_token", valid_578965
  var valid_578966 = query.getOrDefault("alt")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("json"))
  if valid_578966 != nil:
    section.add "alt", valid_578966
  var valid_578967 = query.getOrDefault("userIp")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "userIp", valid_578967
  var valid_578968 = query.getOrDefault("quotaUser")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "quotaUser", valid_578968
  var valid_578969 = query.getOrDefault("fields")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "fields", valid_578969
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

proc call*(call_578971: Call_SqlInstancesUpdate_578958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the settings of a Cloud SQL instance.
  ## 
  let valid = call_578971.validator(path, query, header, formData, body)
  let scheme = call_578971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578971.url(scheme.get, call_578971.host, call_578971.base,
                         call_578971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578971, url, valid)

proc call*(call_578972: Call_SqlInstancesUpdate_578958; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesUpdate
  ## Updates the settings of a Cloud SQL instance.
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
  var path_578973 = newJObject()
  var query_578974 = newJObject()
  var body_578975 = newJObject()
  add(query_578974, "key", newJString(key))
  add(query_578974, "prettyPrint", newJBool(prettyPrint))
  add(query_578974, "oauth_token", newJString(oauthToken))
  add(query_578974, "alt", newJString(alt))
  add(query_578974, "userIp", newJString(userIp))
  add(query_578974, "quotaUser", newJString(quotaUser))
  add(path_578973, "instance", newJString(instance))
  add(path_578973, "project", newJString(project))
  if body != nil:
    body_578975 = body
  add(query_578974, "fields", newJString(fields))
  result = call_578972.call(path_578973, query_578974, nil, nil, body_578975)

var sqlInstancesUpdate* = Call_SqlInstancesUpdate_578958(
    name: "sqlInstancesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesUpdate_578959, base: "/sql/v1beta3",
    url: url_SqlInstancesUpdate_578960, schemes: {Scheme.Https})
type
  Call_SqlInstancesGet_578942 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesGet_578944(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesGet_578943(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves information about a Cloud SQL instance.
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
  var valid_578945 = path.getOrDefault("instance")
  valid_578945 = validateParameter(valid_578945, JString, required = true,
                                 default = nil)
  if valid_578945 != nil:
    section.add "instance", valid_578945
  var valid_578946 = path.getOrDefault("project")
  valid_578946 = validateParameter(valid_578946, JString, required = true,
                                 default = nil)
  if valid_578946 != nil:
    section.add "project", valid_578946
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
  var valid_578947 = query.getOrDefault("key")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "key", valid_578947
  var valid_578948 = query.getOrDefault("prettyPrint")
  valid_578948 = validateParameter(valid_578948, JBool, required = false,
                                 default = newJBool(true))
  if valid_578948 != nil:
    section.add "prettyPrint", valid_578948
  var valid_578949 = query.getOrDefault("oauth_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "oauth_token", valid_578949
  var valid_578950 = query.getOrDefault("alt")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("json"))
  if valid_578950 != nil:
    section.add "alt", valid_578950
  var valid_578951 = query.getOrDefault("userIp")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "userIp", valid_578951
  var valid_578952 = query.getOrDefault("quotaUser")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "quotaUser", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578954: Call_SqlInstancesGet_578942; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a Cloud SQL instance.
  ## 
  let valid = call_578954.validator(path, query, header, formData, body)
  let scheme = call_578954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578954.url(scheme.get, call_578954.host, call_578954.base,
                         call_578954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578954, url, valid)

proc call*(call_578955: Call_SqlInstancesGet_578942; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesGet
  ## Retrieves information about a Cloud SQL instance.
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
  var path_578956 = newJObject()
  var query_578957 = newJObject()
  add(query_578957, "key", newJString(key))
  add(query_578957, "prettyPrint", newJBool(prettyPrint))
  add(query_578957, "oauth_token", newJString(oauthToken))
  add(query_578957, "alt", newJString(alt))
  add(query_578957, "userIp", newJString(userIp))
  add(query_578957, "quotaUser", newJString(quotaUser))
  add(path_578956, "instance", newJString(instance))
  add(path_578956, "project", newJString(project))
  add(query_578957, "fields", newJString(fields))
  result = call_578955.call(path_578956, query_578957, nil, nil, nil)

var sqlInstancesGet* = Call_SqlInstancesGet_578942(name: "sqlInstancesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesGet_578943, base: "/sql/v1beta3",
    url: url_SqlInstancesGet_578944, schemes: {Scheme.Https})
type
  Call_SqlInstancesPatch_578992 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesPatch_578994(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesPatch_578993(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the settings of a Cloud SQL instance. This method supports patch semantics.
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
  var valid_578995 = path.getOrDefault("instance")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "instance", valid_578995
  var valid_578996 = path.getOrDefault("project")
  valid_578996 = validateParameter(valid_578996, JString, required = true,
                                 default = nil)
  if valid_578996 != nil:
    section.add "project", valid_578996
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
  var valid_578997 = query.getOrDefault("key")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "key", valid_578997
  var valid_578998 = query.getOrDefault("prettyPrint")
  valid_578998 = validateParameter(valid_578998, JBool, required = false,
                                 default = newJBool(true))
  if valid_578998 != nil:
    section.add "prettyPrint", valid_578998
  var valid_578999 = query.getOrDefault("oauth_token")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "oauth_token", valid_578999
  var valid_579000 = query.getOrDefault("alt")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("json"))
  if valid_579000 != nil:
    section.add "alt", valid_579000
  var valid_579001 = query.getOrDefault("userIp")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "userIp", valid_579001
  var valid_579002 = query.getOrDefault("quotaUser")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "quotaUser", valid_579002
  var valid_579003 = query.getOrDefault("fields")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "fields", valid_579003
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

proc call*(call_579005: Call_SqlInstancesPatch_578992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the settings of a Cloud SQL instance. This method supports patch semantics.
  ## 
  let valid = call_579005.validator(path, query, header, formData, body)
  let scheme = call_579005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579005.url(scheme.get, call_579005.host, call_579005.base,
                         call_579005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579005, url, valid)

proc call*(call_579006: Call_SqlInstancesPatch_578992; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesPatch
  ## Updates the settings of a Cloud SQL instance. This method supports patch semantics.
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
  var path_579007 = newJObject()
  var query_579008 = newJObject()
  var body_579009 = newJObject()
  add(query_579008, "key", newJString(key))
  add(query_579008, "prettyPrint", newJBool(prettyPrint))
  add(query_579008, "oauth_token", newJString(oauthToken))
  add(query_579008, "alt", newJString(alt))
  add(query_579008, "userIp", newJString(userIp))
  add(query_579008, "quotaUser", newJString(quotaUser))
  add(path_579007, "instance", newJString(instance))
  add(path_579007, "project", newJString(project))
  if body != nil:
    body_579009 = body
  add(query_579008, "fields", newJString(fields))
  result = call_579006.call(path_579007, query_579008, nil, nil, body_579009)

var sqlInstancesPatch* = Call_SqlInstancesPatch_578992(name: "sqlInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesPatch_578993, base: "/sql/v1beta3",
    url: url_SqlInstancesPatch_578994, schemes: {Scheme.Https})
type
  Call_SqlInstancesDelete_578976 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesDelete_578978(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesDelete_578977(path: JsonNode; query: JsonNode;
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
  var valid_578979 = path.getOrDefault("instance")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "instance", valid_578979
  var valid_578980 = path.getOrDefault("project")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "project", valid_578980
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
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("alt")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("json"))
  if valid_578984 != nil:
    section.add "alt", valid_578984
  var valid_578985 = query.getOrDefault("userIp")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "userIp", valid_578985
  var valid_578986 = query.getOrDefault("quotaUser")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "quotaUser", valid_578986
  var valid_578987 = query.getOrDefault("fields")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "fields", valid_578987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578988: Call_SqlInstancesDelete_578976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cloud SQL instance.
  ## 
  let valid = call_578988.validator(path, query, header, formData, body)
  let scheme = call_578988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578988.url(scheme.get, call_578988.host, call_578988.base,
                         call_578988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578988, url, valid)

proc call*(call_578989: Call_SqlInstancesDelete_578976; instance: string;
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
  var path_578990 = newJObject()
  var query_578991 = newJObject()
  add(query_578991, "key", newJString(key))
  add(query_578991, "prettyPrint", newJBool(prettyPrint))
  add(query_578991, "oauth_token", newJString(oauthToken))
  add(query_578991, "alt", newJString(alt))
  add(query_578991, "userIp", newJString(userIp))
  add(query_578991, "quotaUser", newJString(quotaUser))
  add(path_578990, "instance", newJString(instance))
  add(path_578990, "project", newJString(project))
  add(query_578991, "fields", newJString(fields))
  result = call_578989.call(path_578990, query_578991, nil, nil, nil)

var sqlInstancesDelete* = Call_SqlInstancesDelete_578976(
    name: "sqlInstancesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesDelete_578977, base: "/sql/v1beta3",
    url: url_SqlInstancesDelete_578978, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsList_579010 = ref object of OpenApiRestCall_578339
proc url_SqlBackupRunsList_579012(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsList_579011(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all backup runs associated with a Cloud SQL instance.
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
  var valid_579013 = path.getOrDefault("instance")
  valid_579013 = validateParameter(valid_579013, JString, required = true,
                                 default = nil)
  if valid_579013 != nil:
    section.add "instance", valid_579013
  var valid_579014 = path.getOrDefault("project")
  valid_579014 = validateParameter(valid_579014, JString, required = true,
                                 default = nil)
  if valid_579014 != nil:
    section.add "project", valid_579014
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
  ##   backupConfiguration: JString (required)
  ##                      : Identifier for the backup configuration. This gets generated automatically when a backup configuration is created.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of backup runs per response.
  section = newJObject()
  var valid_579015 = query.getOrDefault("key")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "key", valid_579015
  var valid_579016 = query.getOrDefault("prettyPrint")
  valid_579016 = validateParameter(valid_579016, JBool, required = false,
                                 default = newJBool(true))
  if valid_579016 != nil:
    section.add "prettyPrint", valid_579016
  var valid_579017 = query.getOrDefault("oauth_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "oauth_token", valid_579017
  var valid_579018 = query.getOrDefault("alt")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("json"))
  if valid_579018 != nil:
    section.add "alt", valid_579018
  var valid_579019 = query.getOrDefault("userIp")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "userIp", valid_579019
  var valid_579020 = query.getOrDefault("quotaUser")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "quotaUser", valid_579020
  assert query != nil, "query argument is necessary due to required `backupConfiguration` field"
  var valid_579021 = query.getOrDefault("backupConfiguration")
  valid_579021 = validateParameter(valid_579021, JString, required = true,
                                 default = nil)
  if valid_579021 != nil:
    section.add "backupConfiguration", valid_579021
  var valid_579022 = query.getOrDefault("pageToken")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "pageToken", valid_579022
  var valid_579023 = query.getOrDefault("fields")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "fields", valid_579023
  var valid_579024 = query.getOrDefault("maxResults")
  valid_579024 = validateParameter(valid_579024, JInt, required = false, default = nil)
  if valid_579024 != nil:
    section.add "maxResults", valid_579024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579025: Call_SqlBackupRunsList_579010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all backup runs associated with a Cloud SQL instance.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_SqlBackupRunsList_579010; backupConfiguration: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## sqlBackupRunsList
  ## Lists all backup runs associated with a Cloud SQL instance.
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
  ##   backupConfiguration: string (required)
  ##                      : Identifier for the backup configuration. This gets generated automatically when a backup configuration is created.
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
  var path_579027 = newJObject()
  var query_579028 = newJObject()
  add(query_579028, "key", newJString(key))
  add(query_579028, "prettyPrint", newJBool(prettyPrint))
  add(query_579028, "oauth_token", newJString(oauthToken))
  add(query_579028, "alt", newJString(alt))
  add(query_579028, "userIp", newJString(userIp))
  add(query_579028, "quotaUser", newJString(quotaUser))
  add(query_579028, "backupConfiguration", newJString(backupConfiguration))
  add(query_579028, "pageToken", newJString(pageToken))
  add(path_579027, "instance", newJString(instance))
  add(path_579027, "project", newJString(project))
  add(query_579028, "fields", newJString(fields))
  add(query_579028, "maxResults", newJInt(maxResults))
  result = call_579026.call(path_579027, query_579028, nil, nil, nil)

var sqlBackupRunsList* = Call_SqlBackupRunsList_579010(name: "sqlBackupRunsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsList_579011, base: "/sql/v1beta3",
    url: url_SqlBackupRunsList_579012, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsGet_579029 = ref object of OpenApiRestCall_578339
proc url_SqlBackupRunsGet_579031(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "backupConfiguration" in path,
        "`backupConfiguration` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/backupRuns/"),
               (kind: VariableSegment, value: "backupConfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlBackupRunsGet_579030(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves information about a specified backup run for a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  ##   backupConfiguration: JString (required)
  ##                      : Identifier for the backup configuration. This gets generated automatically when a backup configuration is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579032 = path.getOrDefault("instance")
  valid_579032 = validateParameter(valid_579032, JString, required = true,
                                 default = nil)
  if valid_579032 != nil:
    section.add "instance", valid_579032
  var valid_579033 = path.getOrDefault("project")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "project", valid_579033
  var valid_579034 = path.getOrDefault("backupConfiguration")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "backupConfiguration", valid_579034
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
  ##   dueTime: JString (required)
  ##          : The start time of the four-hour backup window. The backup can occur any time in the window. The time is in RFC 3339 format, for example 2012-11-15T16:19:00.094Z.
  section = newJObject()
  var valid_579035 = query.getOrDefault("key")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "key", valid_579035
  var valid_579036 = query.getOrDefault("prettyPrint")
  valid_579036 = validateParameter(valid_579036, JBool, required = false,
                                 default = newJBool(true))
  if valid_579036 != nil:
    section.add "prettyPrint", valid_579036
  var valid_579037 = query.getOrDefault("oauth_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "oauth_token", valid_579037
  var valid_579038 = query.getOrDefault("alt")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("json"))
  if valid_579038 != nil:
    section.add "alt", valid_579038
  var valid_579039 = query.getOrDefault("userIp")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "userIp", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("fields")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "fields", valid_579041
  assert query != nil, "query argument is necessary due to required `dueTime` field"
  var valid_579042 = query.getOrDefault("dueTime")
  valid_579042 = validateParameter(valid_579042, JString, required = true,
                                 default = nil)
  if valid_579042 != nil:
    section.add "dueTime", valid_579042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579043: Call_SqlBackupRunsGet_579029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a specified backup run for a Cloud SQL instance.
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_SqlBackupRunsGet_579029; instance: string;
          project: string; dueTime: string; backupConfiguration: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## sqlBackupRunsGet
  ## Retrieves information about a specified backup run for a Cloud SQL instance.
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
  ##   dueTime: string (required)
  ##          : The start time of the four-hour backup window. The backup can occur any time in the window. The time is in RFC 3339 format, for example 2012-11-15T16:19:00.094Z.
  ##   backupConfiguration: string (required)
  ##                      : Identifier for the backup configuration. This gets generated automatically when a backup configuration is created.
  var path_579045 = newJObject()
  var query_579046 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "userIp", newJString(userIp))
  add(query_579046, "quotaUser", newJString(quotaUser))
  add(path_579045, "instance", newJString(instance))
  add(path_579045, "project", newJString(project))
  add(query_579046, "fields", newJString(fields))
  add(query_579046, "dueTime", newJString(dueTime))
  add(path_579045, "backupConfiguration", newJString(backupConfiguration))
  result = call_579044.call(path_579045, query_579046, nil, nil, nil)

var sqlBackupRunsGet* = Call_SqlBackupRunsGet_579029(name: "sqlBackupRunsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/backupRuns/{backupConfiguration}",
    validator: validate_SqlBackupRunsGet_579030, base: "/sql/v1beta3",
    url: url_SqlBackupRunsGet_579031, schemes: {Scheme.Https})
type
  Call_SqlInstancesExport_579047 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesExport_579049(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesExport_579048(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Exports data from a Cloud SQL instance to a Google Cloud Storage bucket as a MySQL dump file.
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
  var valid_579050 = path.getOrDefault("instance")
  valid_579050 = validateParameter(valid_579050, JString, required = true,
                                 default = nil)
  if valid_579050 != nil:
    section.add "instance", valid_579050
  var valid_579051 = path.getOrDefault("project")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "project", valid_579051
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
  var valid_579052 = query.getOrDefault("key")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "key", valid_579052
  var valid_579053 = query.getOrDefault("prettyPrint")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(true))
  if valid_579053 != nil:
    section.add "prettyPrint", valid_579053
  var valid_579054 = query.getOrDefault("oauth_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "oauth_token", valid_579054
  var valid_579055 = query.getOrDefault("alt")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("json"))
  if valid_579055 != nil:
    section.add "alt", valid_579055
  var valid_579056 = query.getOrDefault("userIp")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "userIp", valid_579056
  var valid_579057 = query.getOrDefault("quotaUser")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "quotaUser", valid_579057
  var valid_579058 = query.getOrDefault("fields")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "fields", valid_579058
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

proc call*(call_579060: Call_SqlInstancesExport_579047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports data from a Cloud SQL instance to a Google Cloud Storage bucket as a MySQL dump file.
  ## 
  let valid = call_579060.validator(path, query, header, formData, body)
  let scheme = call_579060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579060.url(scheme.get, call_579060.host, call_579060.base,
                         call_579060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579060, url, valid)

proc call*(call_579061: Call_SqlInstancesExport_579047; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesExport
  ## Exports data from a Cloud SQL instance to a Google Cloud Storage bucket as a MySQL dump file.
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
  var path_579062 = newJObject()
  var query_579063 = newJObject()
  var body_579064 = newJObject()
  add(query_579063, "key", newJString(key))
  add(query_579063, "prettyPrint", newJBool(prettyPrint))
  add(query_579063, "oauth_token", newJString(oauthToken))
  add(query_579063, "alt", newJString(alt))
  add(query_579063, "userIp", newJString(userIp))
  add(query_579063, "quotaUser", newJString(quotaUser))
  add(path_579062, "instance", newJString(instance))
  add(path_579062, "project", newJString(project))
  if body != nil:
    body_579064 = body
  add(query_579063, "fields", newJString(fields))
  result = call_579061.call(path_579062, query_579063, nil, nil, body_579064)

var sqlInstancesExport* = Call_SqlInstancesExport_579047(
    name: "sqlInstancesExport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/export",
    validator: validate_SqlInstancesExport_579048, base: "/sql/v1beta3",
    url: url_SqlInstancesExport_579049, schemes: {Scheme.Https})
type
  Call_SqlInstancesImport_579065 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesImport_579067(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesImport_579066(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Imports data into a Cloud SQL instance from a MySQL dump file stored in a Google Cloud Storage bucket.
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
  var valid_579068 = path.getOrDefault("instance")
  valid_579068 = validateParameter(valid_579068, JString, required = true,
                                 default = nil)
  if valid_579068 != nil:
    section.add "instance", valid_579068
  var valid_579069 = path.getOrDefault("project")
  valid_579069 = validateParameter(valid_579069, JString, required = true,
                                 default = nil)
  if valid_579069 != nil:
    section.add "project", valid_579069
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
  var valid_579070 = query.getOrDefault("key")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "key", valid_579070
  var valid_579071 = query.getOrDefault("prettyPrint")
  valid_579071 = validateParameter(valid_579071, JBool, required = false,
                                 default = newJBool(true))
  if valid_579071 != nil:
    section.add "prettyPrint", valid_579071
  var valid_579072 = query.getOrDefault("oauth_token")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "oauth_token", valid_579072
  var valid_579073 = query.getOrDefault("alt")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("json"))
  if valid_579073 != nil:
    section.add "alt", valid_579073
  var valid_579074 = query.getOrDefault("userIp")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "userIp", valid_579074
  var valid_579075 = query.getOrDefault("quotaUser")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "quotaUser", valid_579075
  var valid_579076 = query.getOrDefault("fields")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "fields", valid_579076
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

proc call*(call_579078: Call_SqlInstancesImport_579065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports data into a Cloud SQL instance from a MySQL dump file stored in a Google Cloud Storage bucket.
  ## 
  let valid = call_579078.validator(path, query, header, formData, body)
  let scheme = call_579078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579078.url(scheme.get, call_579078.host, call_579078.base,
                         call_579078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579078, url, valid)

proc call*(call_579079: Call_SqlInstancesImport_579065; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesImport
  ## Imports data into a Cloud SQL instance from a MySQL dump file stored in a Google Cloud Storage bucket.
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
  var path_579080 = newJObject()
  var query_579081 = newJObject()
  var body_579082 = newJObject()
  add(query_579081, "key", newJString(key))
  add(query_579081, "prettyPrint", newJBool(prettyPrint))
  add(query_579081, "oauth_token", newJString(oauthToken))
  add(query_579081, "alt", newJString(alt))
  add(query_579081, "userIp", newJString(userIp))
  add(query_579081, "quotaUser", newJString(quotaUser))
  add(path_579080, "instance", newJString(instance))
  add(path_579080, "project", newJString(project))
  if body != nil:
    body_579082 = body
  add(query_579081, "fields", newJString(fields))
  result = call_579079.call(path_579080, query_579081, nil, nil, body_579082)

var sqlInstancesImport* = Call_SqlInstancesImport_579065(
    name: "sqlInstancesImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/import",
    validator: validate_SqlInstancesImport_579066, base: "/sql/v1beta3",
    url: url_SqlInstancesImport_579067, schemes: {Scheme.Https})
type
  Call_SqlOperationsList_579083 = ref object of OpenApiRestCall_578339
proc url_SqlOperationsList_579085(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlOperationsList_579084(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all operations that have been performed on a Cloud SQL instance.
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
  var valid_579086 = path.getOrDefault("instance")
  valid_579086 = validateParameter(valid_579086, JString, required = true,
                                 default = nil)
  if valid_579086 != nil:
    section.add "instance", valid_579086
  var valid_579087 = path.getOrDefault("project")
  valid_579087 = validateParameter(valid_579087, JString, required = true,
                                 default = nil)
  if valid_579087 != nil:
    section.add "project", valid_579087
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
  ##             : Maximum number of operations per response.
  section = newJObject()
  var valid_579088 = query.getOrDefault("key")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "key", valid_579088
  var valid_579089 = query.getOrDefault("prettyPrint")
  valid_579089 = validateParameter(valid_579089, JBool, required = false,
                                 default = newJBool(true))
  if valid_579089 != nil:
    section.add "prettyPrint", valid_579089
  var valid_579090 = query.getOrDefault("oauth_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "oauth_token", valid_579090
  var valid_579091 = query.getOrDefault("alt")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("json"))
  if valid_579091 != nil:
    section.add "alt", valid_579091
  var valid_579092 = query.getOrDefault("userIp")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "userIp", valid_579092
  var valid_579093 = query.getOrDefault("quotaUser")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "quotaUser", valid_579093
  var valid_579094 = query.getOrDefault("pageToken")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "pageToken", valid_579094
  var valid_579095 = query.getOrDefault("fields")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "fields", valid_579095
  var valid_579096 = query.getOrDefault("maxResults")
  valid_579096 = validateParameter(valid_579096, JInt, required = false, default = nil)
  if valid_579096 != nil:
    section.add "maxResults", valid_579096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579097: Call_SqlOperationsList_579083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all operations that have been performed on a Cloud SQL instance.
  ## 
  let valid = call_579097.validator(path, query, header, formData, body)
  let scheme = call_579097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579097.url(scheme.get, call_579097.host, call_579097.base,
                         call_579097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579097, url, valid)

proc call*(call_579098: Call_SqlOperationsList_579083; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## sqlOperationsList
  ## Lists all operations that have been performed on a Cloud SQL instance.
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
  ##             : Maximum number of operations per response.
  var path_579099 = newJObject()
  var query_579100 = newJObject()
  add(query_579100, "key", newJString(key))
  add(query_579100, "prettyPrint", newJBool(prettyPrint))
  add(query_579100, "oauth_token", newJString(oauthToken))
  add(query_579100, "alt", newJString(alt))
  add(query_579100, "userIp", newJString(userIp))
  add(query_579100, "quotaUser", newJString(quotaUser))
  add(query_579100, "pageToken", newJString(pageToken))
  add(path_579099, "instance", newJString(instance))
  add(path_579099, "project", newJString(project))
  add(query_579100, "fields", newJString(fields))
  add(query_579100, "maxResults", newJInt(maxResults))
  result = call_579098.call(path_579099, query_579100, nil, nil, nil)

var sqlOperationsList* = Call_SqlOperationsList_579083(name: "sqlOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/operations",
    validator: validate_SqlOperationsList_579084, base: "/sql/v1beta3",
    url: url_SqlOperationsList_579085, schemes: {Scheme.Https})
type
  Call_SqlOperationsGet_579101 = ref object of OpenApiRestCall_578339
proc url_SqlOperationsGet_579103(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlOperationsGet_579102(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves information about a specific operation that was performed on a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operation: JString (required)
  ##            : Instance operation ID.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operation` field"
  var valid_579104 = path.getOrDefault("operation")
  valid_579104 = validateParameter(valid_579104, JString, required = true,
                                 default = nil)
  if valid_579104 != nil:
    section.add "operation", valid_579104
  var valid_579105 = path.getOrDefault("instance")
  valid_579105 = validateParameter(valid_579105, JString, required = true,
                                 default = nil)
  if valid_579105 != nil:
    section.add "instance", valid_579105
  var valid_579106 = path.getOrDefault("project")
  valid_579106 = validateParameter(valid_579106, JString, required = true,
                                 default = nil)
  if valid_579106 != nil:
    section.add "project", valid_579106
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
  var valid_579107 = query.getOrDefault("key")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "key", valid_579107
  var valid_579108 = query.getOrDefault("prettyPrint")
  valid_579108 = validateParameter(valid_579108, JBool, required = false,
                                 default = newJBool(true))
  if valid_579108 != nil:
    section.add "prettyPrint", valid_579108
  var valid_579109 = query.getOrDefault("oauth_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "oauth_token", valid_579109
  var valid_579110 = query.getOrDefault("alt")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("json"))
  if valid_579110 != nil:
    section.add "alt", valid_579110
  var valid_579111 = query.getOrDefault("userIp")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "userIp", valid_579111
  var valid_579112 = query.getOrDefault("quotaUser")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "quotaUser", valid_579112
  var valid_579113 = query.getOrDefault("fields")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "fields", valid_579113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579114: Call_SqlOperationsGet_579101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a specific operation that was performed on a Cloud SQL instance.
  ## 
  let valid = call_579114.validator(path, query, header, formData, body)
  let scheme = call_579114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579114.url(scheme.get, call_579114.host, call_579114.base,
                         call_579114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579114, url, valid)

proc call*(call_579115: Call_SqlOperationsGet_579101; operation: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlOperationsGet
  ## Retrieves information about a specific operation that was performed on a Cloud SQL instance.
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
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579116 = newJObject()
  var query_579117 = newJObject()
  add(query_579117, "key", newJString(key))
  add(query_579117, "prettyPrint", newJBool(prettyPrint))
  add(query_579117, "oauth_token", newJString(oauthToken))
  add(path_579116, "operation", newJString(operation))
  add(query_579117, "alt", newJString(alt))
  add(query_579117, "userIp", newJString(userIp))
  add(query_579117, "quotaUser", newJString(quotaUser))
  add(path_579116, "instance", newJString(instance))
  add(path_579116, "project", newJString(project))
  add(query_579117, "fields", newJString(fields))
  result = call_579115.call(path_579116, query_579117, nil, nil, nil)

var sqlOperationsGet* = Call_SqlOperationsGet_579101(name: "sqlOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/operations/{operation}",
    validator: validate_SqlOperationsGet_579102, base: "/sql/v1beta3",
    url: url_SqlOperationsGet_579103, schemes: {Scheme.Https})
type
  Call_SqlInstancesPromoteReplica_579118 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesPromoteReplica_579120(protocol: Scheme; host: string;
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

proc validate_SqlInstancesPromoteReplica_579119(path: JsonNode; query: JsonNode;
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
  var valid_579121 = path.getOrDefault("instance")
  valid_579121 = validateParameter(valid_579121, JString, required = true,
                                 default = nil)
  if valid_579121 != nil:
    section.add "instance", valid_579121
  var valid_579122 = path.getOrDefault("project")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "project", valid_579122
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
  var valid_579123 = query.getOrDefault("key")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "key", valid_579123
  var valid_579124 = query.getOrDefault("prettyPrint")
  valid_579124 = validateParameter(valid_579124, JBool, required = false,
                                 default = newJBool(true))
  if valid_579124 != nil:
    section.add "prettyPrint", valid_579124
  var valid_579125 = query.getOrDefault("oauth_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "oauth_token", valid_579125
  var valid_579126 = query.getOrDefault("alt")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("json"))
  if valid_579126 != nil:
    section.add "alt", valid_579126
  var valid_579127 = query.getOrDefault("userIp")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "userIp", valid_579127
  var valid_579128 = query.getOrDefault("quotaUser")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "quotaUser", valid_579128
  var valid_579129 = query.getOrDefault("fields")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "fields", valid_579129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579130: Call_SqlInstancesPromoteReplica_579118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ## 
  let valid = call_579130.validator(path, query, header, formData, body)
  let scheme = call_579130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579130.url(scheme.get, call_579130.host, call_579130.base,
                         call_579130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579130, url, valid)

proc call*(call_579131: Call_SqlInstancesPromoteReplica_579118; instance: string;
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
  var path_579132 = newJObject()
  var query_579133 = newJObject()
  add(query_579133, "key", newJString(key))
  add(query_579133, "prettyPrint", newJBool(prettyPrint))
  add(query_579133, "oauth_token", newJString(oauthToken))
  add(query_579133, "alt", newJString(alt))
  add(query_579133, "userIp", newJString(userIp))
  add(query_579133, "quotaUser", newJString(quotaUser))
  add(path_579132, "instance", newJString(instance))
  add(path_579132, "project", newJString(project))
  add(query_579133, "fields", newJString(fields))
  result = call_579131.call(path_579132, query_579133, nil, nil, nil)

var sqlInstancesPromoteReplica* = Call_SqlInstancesPromoteReplica_579118(
    name: "sqlInstancesPromoteReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/promoteReplica",
    validator: validate_SqlInstancesPromoteReplica_579119, base: "/sql/v1beta3",
    url: url_SqlInstancesPromoteReplica_579120, schemes: {Scheme.Https})
type
  Call_SqlInstancesResetSslConfig_579134 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesResetSslConfig_579136(protocol: Scheme; host: string;
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

proc validate_SqlInstancesResetSslConfig_579135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all client certificates and generates a new server SSL certificate for a Cloud SQL instance.
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
  var valid_579137 = path.getOrDefault("instance")
  valid_579137 = validateParameter(valid_579137, JString, required = true,
                                 default = nil)
  if valid_579137 != nil:
    section.add "instance", valid_579137
  var valid_579138 = path.getOrDefault("project")
  valid_579138 = validateParameter(valid_579138, JString, required = true,
                                 default = nil)
  if valid_579138 != nil:
    section.add "project", valid_579138
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
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("prettyPrint")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "prettyPrint", valid_579140
  var valid_579141 = query.getOrDefault("oauth_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "oauth_token", valid_579141
  var valid_579142 = query.getOrDefault("alt")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = newJString("json"))
  if valid_579142 != nil:
    section.add "alt", valid_579142
  var valid_579143 = query.getOrDefault("userIp")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "userIp", valid_579143
  var valid_579144 = query.getOrDefault("quotaUser")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "quotaUser", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579146: Call_SqlInstancesResetSslConfig_579134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all client certificates and generates a new server SSL certificate for a Cloud SQL instance.
  ## 
  let valid = call_579146.validator(path, query, header, formData, body)
  let scheme = call_579146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579146.url(scheme.get, call_579146.host, call_579146.base,
                         call_579146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579146, url, valid)

proc call*(call_579147: Call_SqlInstancesResetSslConfig_579134; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlInstancesResetSslConfig
  ## Deletes all client certificates and generates a new server SSL certificate for a Cloud SQL instance.
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
  var path_579148 = newJObject()
  var query_579149 = newJObject()
  add(query_579149, "key", newJString(key))
  add(query_579149, "prettyPrint", newJBool(prettyPrint))
  add(query_579149, "oauth_token", newJString(oauthToken))
  add(query_579149, "alt", newJString(alt))
  add(query_579149, "userIp", newJString(userIp))
  add(query_579149, "quotaUser", newJString(quotaUser))
  add(path_579148, "instance", newJString(instance))
  add(path_579148, "project", newJString(project))
  add(query_579149, "fields", newJString(fields))
  result = call_579147.call(path_579148, query_579149, nil, nil, nil)

var sqlInstancesResetSslConfig* = Call_SqlInstancesResetSslConfig_579134(
    name: "sqlInstancesResetSslConfig", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/resetSslConfig",
    validator: validate_SqlInstancesResetSslConfig_579135, base: "/sql/v1beta3",
    url: url_SqlInstancesResetSslConfig_579136, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestart_579150 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesRestart_579152(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesRestart_579151(path: JsonNode; query: JsonNode;
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
  var valid_579153 = path.getOrDefault("instance")
  valid_579153 = validateParameter(valid_579153, JString, required = true,
                                 default = nil)
  if valid_579153 != nil:
    section.add "instance", valid_579153
  var valid_579154 = path.getOrDefault("project")
  valid_579154 = validateParameter(valid_579154, JString, required = true,
                                 default = nil)
  if valid_579154 != nil:
    section.add "project", valid_579154
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
  var valid_579155 = query.getOrDefault("key")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "key", valid_579155
  var valid_579156 = query.getOrDefault("prettyPrint")
  valid_579156 = validateParameter(valid_579156, JBool, required = false,
                                 default = newJBool(true))
  if valid_579156 != nil:
    section.add "prettyPrint", valid_579156
  var valid_579157 = query.getOrDefault("oauth_token")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "oauth_token", valid_579157
  var valid_579158 = query.getOrDefault("alt")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = newJString("json"))
  if valid_579158 != nil:
    section.add "alt", valid_579158
  var valid_579159 = query.getOrDefault("userIp")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "userIp", valid_579159
  var valid_579160 = query.getOrDefault("quotaUser")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "quotaUser", valid_579160
  var valid_579161 = query.getOrDefault("fields")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "fields", valid_579161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579162: Call_SqlInstancesRestart_579150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a Cloud SQL instance.
  ## 
  let valid = call_579162.validator(path, query, header, formData, body)
  let scheme = call_579162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579162.url(scheme.get, call_579162.host, call_579162.base,
                         call_579162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579162, url, valid)

proc call*(call_579163: Call_SqlInstancesRestart_579150; instance: string;
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
  var path_579164 = newJObject()
  var query_579165 = newJObject()
  add(query_579165, "key", newJString(key))
  add(query_579165, "prettyPrint", newJBool(prettyPrint))
  add(query_579165, "oauth_token", newJString(oauthToken))
  add(query_579165, "alt", newJString(alt))
  add(query_579165, "userIp", newJString(userIp))
  add(query_579165, "quotaUser", newJString(quotaUser))
  add(path_579164, "instance", newJString(instance))
  add(path_579164, "project", newJString(project))
  add(query_579165, "fields", newJString(fields))
  result = call_579163.call(path_579164, query_579165, nil, nil, nil)

var sqlInstancesRestart* = Call_SqlInstancesRestart_579150(
    name: "sqlInstancesRestart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restart",
    validator: validate_SqlInstancesRestart_579151, base: "/sql/v1beta3",
    url: url_SqlInstancesRestart_579152, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestoreBackup_579166 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesRestoreBackup_579168(protocol: Scheme; host: string;
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

proc validate_SqlInstancesRestoreBackup_579167(path: JsonNode; query: JsonNode;
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
  var valid_579169 = path.getOrDefault("instance")
  valid_579169 = validateParameter(valid_579169, JString, required = true,
                                 default = nil)
  if valid_579169 != nil:
    section.add "instance", valid_579169
  var valid_579170 = path.getOrDefault("project")
  valid_579170 = validateParameter(valid_579170, JString, required = true,
                                 default = nil)
  if valid_579170 != nil:
    section.add "project", valid_579170
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
  ##   backupConfiguration: JString (required)
  ##                      : The identifier of the backup configuration. This gets generated automatically when a backup configuration is created.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   dueTime: JString (required)
  ##          : The start time of the four-hour backup window. The backup can occur any time in the window. The time is in RFC 3339 format, for example 2012-11-15T16:19:00.094Z.
  section = newJObject()
  var valid_579171 = query.getOrDefault("key")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "key", valid_579171
  var valid_579172 = query.getOrDefault("prettyPrint")
  valid_579172 = validateParameter(valid_579172, JBool, required = false,
                                 default = newJBool(true))
  if valid_579172 != nil:
    section.add "prettyPrint", valid_579172
  var valid_579173 = query.getOrDefault("oauth_token")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "oauth_token", valid_579173
  var valid_579174 = query.getOrDefault("alt")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = newJString("json"))
  if valid_579174 != nil:
    section.add "alt", valid_579174
  var valid_579175 = query.getOrDefault("userIp")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "userIp", valid_579175
  var valid_579176 = query.getOrDefault("quotaUser")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "quotaUser", valid_579176
  assert query != nil, "query argument is necessary due to required `backupConfiguration` field"
  var valid_579177 = query.getOrDefault("backupConfiguration")
  valid_579177 = validateParameter(valid_579177, JString, required = true,
                                 default = nil)
  if valid_579177 != nil:
    section.add "backupConfiguration", valid_579177
  var valid_579178 = query.getOrDefault("fields")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "fields", valid_579178
  var valid_579179 = query.getOrDefault("dueTime")
  valid_579179 = validateParameter(valid_579179, JString, required = true,
                                 default = nil)
  if valid_579179 != nil:
    section.add "dueTime", valid_579179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579180: Call_SqlInstancesRestoreBackup_579166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backup of a Cloud SQL instance.
  ## 
  let valid = call_579180.validator(path, query, header, formData, body)
  let scheme = call_579180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579180.url(scheme.get, call_579180.host, call_579180.base,
                         call_579180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579180, url, valid)

proc call*(call_579181: Call_SqlInstancesRestoreBackup_579166;
          backupConfiguration: string; instance: string; project: string;
          dueTime: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
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
  ##   backupConfiguration: string (required)
  ##                      : The identifier of the backup configuration. This gets generated automatically when a backup configuration is created.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   dueTime: string (required)
  ##          : The start time of the four-hour backup window. The backup can occur any time in the window. The time is in RFC 3339 format, for example 2012-11-15T16:19:00.094Z.
  var path_579182 = newJObject()
  var query_579183 = newJObject()
  add(query_579183, "key", newJString(key))
  add(query_579183, "prettyPrint", newJBool(prettyPrint))
  add(query_579183, "oauth_token", newJString(oauthToken))
  add(query_579183, "alt", newJString(alt))
  add(query_579183, "userIp", newJString(userIp))
  add(query_579183, "quotaUser", newJString(quotaUser))
  add(query_579183, "backupConfiguration", newJString(backupConfiguration))
  add(path_579182, "instance", newJString(instance))
  add(path_579182, "project", newJString(project))
  add(query_579183, "fields", newJString(fields))
  add(query_579183, "dueTime", newJString(dueTime))
  result = call_579181.call(path_579182, query_579183, nil, nil, nil)

var sqlInstancesRestoreBackup* = Call_SqlInstancesRestoreBackup_579166(
    name: "sqlInstancesRestoreBackup", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restoreBackup",
    validator: validate_SqlInstancesRestoreBackup_579167, base: "/sql/v1beta3",
    url: url_SqlInstancesRestoreBackup_579168, schemes: {Scheme.Https})
type
  Call_SqlInstancesSetRootPassword_579184 = ref object of OpenApiRestCall_578339
proc url_SqlInstancesSetRootPassword_579186(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/setRootPassword")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SqlInstancesSetRootPassword_579185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the password for the root user of the specified Cloud SQL instance.
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
  var valid_579187 = path.getOrDefault("instance")
  valid_579187 = validateParameter(valid_579187, JString, required = true,
                                 default = nil)
  if valid_579187 != nil:
    section.add "instance", valid_579187
  var valid_579188 = path.getOrDefault("project")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "project", valid_579188
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
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
  var valid_579192 = query.getOrDefault("alt")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("json"))
  if valid_579192 != nil:
    section.add "alt", valid_579192
  var valid_579193 = query.getOrDefault("userIp")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "userIp", valid_579193
  var valid_579194 = query.getOrDefault("quotaUser")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "quotaUser", valid_579194
  var valid_579195 = query.getOrDefault("fields")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "fields", valid_579195
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

proc call*(call_579197: Call_SqlInstancesSetRootPassword_579184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the password for the root user of the specified Cloud SQL instance.
  ## 
  let valid = call_579197.validator(path, query, header, formData, body)
  let scheme = call_579197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579197.url(scheme.get, call_579197.host, call_579197.base,
                         call_579197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579197, url, valid)

proc call*(call_579198: Call_SqlInstancesSetRootPassword_579184; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlInstancesSetRootPassword
  ## Sets the password for the root user of the specified Cloud SQL instance.
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
  var path_579199 = newJObject()
  var query_579200 = newJObject()
  var body_579201 = newJObject()
  add(query_579200, "key", newJString(key))
  add(query_579200, "prettyPrint", newJBool(prettyPrint))
  add(query_579200, "oauth_token", newJString(oauthToken))
  add(query_579200, "alt", newJString(alt))
  add(query_579200, "userIp", newJString(userIp))
  add(query_579200, "quotaUser", newJString(quotaUser))
  add(path_579199, "instance", newJString(instance))
  add(path_579199, "project", newJString(project))
  if body != nil:
    body_579201 = body
  add(query_579200, "fields", newJString(fields))
  result = call_579198.call(path_579199, query_579200, nil, nil, body_579201)

var sqlInstancesSetRootPassword* = Call_SqlInstancesSetRootPassword_579184(
    name: "sqlInstancesSetRootPassword", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/setRootPassword",
    validator: validate_SqlInstancesSetRootPassword_579185, base: "/sql/v1beta3",
    url: url_SqlInstancesSetRootPassword_579186, schemes: {Scheme.Https})
type
  Call_SqlSslCertsInsert_579218 = ref object of OpenApiRestCall_578339
proc url_SqlSslCertsInsert_579220(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsInsert_579219(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an SSL certificate and returns the certificate, the associated private key, and the server certificate authority.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project to which the newly created Cloud SQL instances should belong.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579221 = path.getOrDefault("instance")
  valid_579221 = validateParameter(valid_579221, JString, required = true,
                                 default = nil)
  if valid_579221 != nil:
    section.add "instance", valid_579221
  var valid_579222 = path.getOrDefault("project")
  valid_579222 = validateParameter(valid_579222, JString, required = true,
                                 default = nil)
  if valid_579222 != nil:
    section.add "project", valid_579222
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
  var valid_579223 = query.getOrDefault("key")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "key", valid_579223
  var valid_579224 = query.getOrDefault("prettyPrint")
  valid_579224 = validateParameter(valid_579224, JBool, required = false,
                                 default = newJBool(true))
  if valid_579224 != nil:
    section.add "prettyPrint", valid_579224
  var valid_579225 = query.getOrDefault("oauth_token")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "oauth_token", valid_579225
  var valid_579226 = query.getOrDefault("alt")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = newJString("json"))
  if valid_579226 != nil:
    section.add "alt", valid_579226
  var valid_579227 = query.getOrDefault("userIp")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "userIp", valid_579227
  var valid_579228 = query.getOrDefault("quotaUser")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "quotaUser", valid_579228
  var valid_579229 = query.getOrDefault("fields")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "fields", valid_579229
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

proc call*(call_579231: Call_SqlSslCertsInsert_579218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an SSL certificate and returns the certificate, the associated private key, and the server certificate authority.
  ## 
  let valid = call_579231.validator(path, query, header, formData, body)
  let scheme = call_579231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579231.url(scheme.get, call_579231.host, call_579231.base,
                         call_579231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579231, url, valid)

proc call*(call_579232: Call_SqlSslCertsInsert_579218; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## sqlSslCertsInsert
  ## Creates an SSL certificate and returns the certificate, the associated private key, and the server certificate authority.
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
  ##          : Project ID of the project to which the newly created Cloud SQL instances should belong.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579233 = newJObject()
  var query_579234 = newJObject()
  var body_579235 = newJObject()
  add(query_579234, "key", newJString(key))
  add(query_579234, "prettyPrint", newJBool(prettyPrint))
  add(query_579234, "oauth_token", newJString(oauthToken))
  add(query_579234, "alt", newJString(alt))
  add(query_579234, "userIp", newJString(userIp))
  add(query_579234, "quotaUser", newJString(quotaUser))
  add(path_579233, "instance", newJString(instance))
  add(path_579233, "project", newJString(project))
  if body != nil:
    body_579235 = body
  add(query_579234, "fields", newJString(fields))
  result = call_579232.call(path_579233, query_579234, nil, nil, body_579235)

var sqlSslCertsInsert* = Call_SqlSslCertsInsert_579218(name: "sqlSslCertsInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsInsert_579219, base: "/sql/v1beta3",
    url: url_SqlSslCertsInsert_579220, schemes: {Scheme.Https})
type
  Call_SqlSslCertsList_579202 = ref object of OpenApiRestCall_578339
proc url_SqlSslCertsList_579204(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsList_579203(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all of the current SSL certificates defined for a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project for which to list Cloud SQL instances.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_579205 = path.getOrDefault("instance")
  valid_579205 = validateParameter(valid_579205, JString, required = true,
                                 default = nil)
  if valid_579205 != nil:
    section.add "instance", valid_579205
  var valid_579206 = path.getOrDefault("project")
  valid_579206 = validateParameter(valid_579206, JString, required = true,
                                 default = nil)
  if valid_579206 != nil:
    section.add "project", valid_579206
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
  var valid_579207 = query.getOrDefault("key")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "key", valid_579207
  var valid_579208 = query.getOrDefault("prettyPrint")
  valid_579208 = validateParameter(valid_579208, JBool, required = false,
                                 default = newJBool(true))
  if valid_579208 != nil:
    section.add "prettyPrint", valid_579208
  var valid_579209 = query.getOrDefault("oauth_token")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "oauth_token", valid_579209
  var valid_579210 = query.getOrDefault("alt")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = newJString("json"))
  if valid_579210 != nil:
    section.add "alt", valid_579210
  var valid_579211 = query.getOrDefault("userIp")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "userIp", valid_579211
  var valid_579212 = query.getOrDefault("quotaUser")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "quotaUser", valid_579212
  var valid_579213 = query.getOrDefault("fields")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "fields", valid_579213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579214: Call_SqlSslCertsList_579202; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the current SSL certificates defined for a Cloud SQL instance.
  ## 
  let valid = call_579214.validator(path, query, header, formData, body)
  let scheme = call_579214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579214.url(scheme.get, call_579214.host, call_579214.base,
                         call_579214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579214, url, valid)

proc call*(call_579215: Call_SqlSslCertsList_579202; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlSslCertsList
  ## Lists all of the current SSL certificates defined for a Cloud SQL instance.
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
  ##          : Project ID of the project for which to list Cloud SQL instances.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579216 = newJObject()
  var query_579217 = newJObject()
  add(query_579217, "key", newJString(key))
  add(query_579217, "prettyPrint", newJBool(prettyPrint))
  add(query_579217, "oauth_token", newJString(oauthToken))
  add(query_579217, "alt", newJString(alt))
  add(query_579217, "userIp", newJString(userIp))
  add(query_579217, "quotaUser", newJString(quotaUser))
  add(path_579216, "instance", newJString(instance))
  add(path_579216, "project", newJString(project))
  add(query_579217, "fields", newJString(fields))
  result = call_579215.call(path_579216, query_579217, nil, nil, nil)

var sqlSslCertsList* = Call_SqlSslCertsList_579202(name: "sqlSslCertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsList_579203, base: "/sql/v1beta3",
    url: url_SqlSslCertsList_579204, schemes: {Scheme.Https})
type
  Call_SqlSslCertsGet_579236 = ref object of OpenApiRestCall_578339
proc url_SqlSslCertsGet_579238(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsGet_579237(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves an SSL certificate as specified by its SHA-1 fingerprint.
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
  var valid_579239 = path.getOrDefault("sha1Fingerprint")
  valid_579239 = validateParameter(valid_579239, JString, required = true,
                                 default = nil)
  if valid_579239 != nil:
    section.add "sha1Fingerprint", valid_579239
  var valid_579240 = path.getOrDefault("instance")
  valid_579240 = validateParameter(valid_579240, JString, required = true,
                                 default = nil)
  if valid_579240 != nil:
    section.add "instance", valid_579240
  var valid_579241 = path.getOrDefault("project")
  valid_579241 = validateParameter(valid_579241, JString, required = true,
                                 default = nil)
  if valid_579241 != nil:
    section.add "project", valid_579241
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
  var valid_579242 = query.getOrDefault("key")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "key", valid_579242
  var valid_579243 = query.getOrDefault("prettyPrint")
  valid_579243 = validateParameter(valid_579243, JBool, required = false,
                                 default = newJBool(true))
  if valid_579243 != nil:
    section.add "prettyPrint", valid_579243
  var valid_579244 = query.getOrDefault("oauth_token")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "oauth_token", valid_579244
  var valid_579245 = query.getOrDefault("alt")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = newJString("json"))
  if valid_579245 != nil:
    section.add "alt", valid_579245
  var valid_579246 = query.getOrDefault("userIp")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "userIp", valid_579246
  var valid_579247 = query.getOrDefault("quotaUser")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "quotaUser", valid_579247
  var valid_579248 = query.getOrDefault("fields")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "fields", valid_579248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579249: Call_SqlSslCertsGet_579236; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an SSL certificate as specified by its SHA-1 fingerprint.
  ## 
  let valid = call_579249.validator(path, query, header, formData, body)
  let scheme = call_579249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579249.url(scheme.get, call_579249.host, call_579249.base,
                         call_579249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579249, url, valid)

proc call*(call_579250: Call_SqlSslCertsGet_579236; sha1Fingerprint: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlSslCertsGet
  ## Retrieves an SSL certificate as specified by its SHA-1 fingerprint.
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
  var path_579251 = newJObject()
  var query_579252 = newJObject()
  add(query_579252, "key", newJString(key))
  add(query_579252, "prettyPrint", newJBool(prettyPrint))
  add(query_579252, "oauth_token", newJString(oauthToken))
  add(query_579252, "alt", newJString(alt))
  add(query_579252, "userIp", newJString(userIp))
  add(query_579252, "quotaUser", newJString(quotaUser))
  add(path_579251, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(path_579251, "instance", newJString(instance))
  add(path_579251, "project", newJString(project))
  add(query_579252, "fields", newJString(fields))
  result = call_579250.call(path_579251, query_579252, nil, nil, nil)

var sqlSslCertsGet* = Call_SqlSslCertsGet_579236(name: "sqlSslCertsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsGet_579237, base: "/sql/v1beta3",
    url: url_SqlSslCertsGet_579238, schemes: {Scheme.Https})
type
  Call_SqlSslCertsDelete_579253 = ref object of OpenApiRestCall_578339
proc url_SqlSslCertsDelete_579255(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsDelete_579254(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an SSL certificate from a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sha1Fingerprint: JString (required)
  ##                  : Sha1 FingerPrint.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance to be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `sha1Fingerprint` field"
  var valid_579256 = path.getOrDefault("sha1Fingerprint")
  valid_579256 = validateParameter(valid_579256, JString, required = true,
                                 default = nil)
  if valid_579256 != nil:
    section.add "sha1Fingerprint", valid_579256
  var valid_579257 = path.getOrDefault("instance")
  valid_579257 = validateParameter(valid_579257, JString, required = true,
                                 default = nil)
  if valid_579257 != nil:
    section.add "instance", valid_579257
  var valid_579258 = path.getOrDefault("project")
  valid_579258 = validateParameter(valid_579258, JString, required = true,
                                 default = nil)
  if valid_579258 != nil:
    section.add "project", valid_579258
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
  var valid_579259 = query.getOrDefault("key")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "key", valid_579259
  var valid_579260 = query.getOrDefault("prettyPrint")
  valid_579260 = validateParameter(valid_579260, JBool, required = false,
                                 default = newJBool(true))
  if valid_579260 != nil:
    section.add "prettyPrint", valid_579260
  var valid_579261 = query.getOrDefault("oauth_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "oauth_token", valid_579261
  var valid_579262 = query.getOrDefault("alt")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = newJString("json"))
  if valid_579262 != nil:
    section.add "alt", valid_579262
  var valid_579263 = query.getOrDefault("userIp")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "userIp", valid_579263
  var valid_579264 = query.getOrDefault("quotaUser")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "quotaUser", valid_579264
  var valid_579265 = query.getOrDefault("fields")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "fields", valid_579265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579266: Call_SqlSslCertsDelete_579253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an SSL certificate from a Cloud SQL instance.
  ## 
  let valid = call_579266.validator(path, query, header, formData, body)
  let scheme = call_579266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579266.url(scheme.get, call_579266.host, call_579266.base,
                         call_579266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579266, url, valid)

proc call*(call_579267: Call_SqlSslCertsDelete_579253; sha1Fingerprint: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlSslCertsDelete
  ## Deletes an SSL certificate from a Cloud SQL instance.
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
  ##          : Project ID of the project that contains the instance to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579268 = newJObject()
  var query_579269 = newJObject()
  add(query_579269, "key", newJString(key))
  add(query_579269, "prettyPrint", newJBool(prettyPrint))
  add(query_579269, "oauth_token", newJString(oauthToken))
  add(query_579269, "alt", newJString(alt))
  add(query_579269, "userIp", newJString(userIp))
  add(query_579269, "quotaUser", newJString(quotaUser))
  add(path_579268, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(path_579268, "instance", newJString(instance))
  add(path_579268, "project", newJString(project))
  add(query_579269, "fields", newJString(fields))
  result = call_579267.call(path_579268, query_579269, nil, nil, nil)

var sqlSslCertsDelete* = Call_SqlSslCertsDelete_579253(name: "sqlSslCertsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsDelete_579254, base: "/sql/v1beta3",
    url: url_SqlSslCertsDelete_579255, schemes: {Scheme.Https})
type
  Call_SqlTiersList_579270 = ref object of OpenApiRestCall_578339
proc url_SqlTiersList_579272(protocol: Scheme; host: string; base: string;
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

proc validate_SqlTiersList_579271(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists service tiers that can be used to create Google Cloud SQL instances.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project for which to list tiers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579273 = path.getOrDefault("project")
  valid_579273 = validateParameter(valid_579273, JString, required = true,
                                 default = nil)
  if valid_579273 != nil:
    section.add "project", valid_579273
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
  var valid_579274 = query.getOrDefault("key")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "key", valid_579274
  var valid_579275 = query.getOrDefault("prettyPrint")
  valid_579275 = validateParameter(valid_579275, JBool, required = false,
                                 default = newJBool(true))
  if valid_579275 != nil:
    section.add "prettyPrint", valid_579275
  var valid_579276 = query.getOrDefault("oauth_token")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "oauth_token", valid_579276
  var valid_579277 = query.getOrDefault("alt")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = newJString("json"))
  if valid_579277 != nil:
    section.add "alt", valid_579277
  var valid_579278 = query.getOrDefault("userIp")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "userIp", valid_579278
  var valid_579279 = query.getOrDefault("quotaUser")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "quotaUser", valid_579279
  var valid_579280 = query.getOrDefault("fields")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "fields", valid_579280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579281: Call_SqlTiersList_579270; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists service tiers that can be used to create Google Cloud SQL instances.
  ## 
  let valid = call_579281.validator(path, query, header, formData, body)
  let scheme = call_579281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579281.url(scheme.get, call_579281.host, call_579281.base,
                         call_579281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579281, url, valid)

proc call*(call_579282: Call_SqlTiersList_579270; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## sqlTiersList
  ## Lists service tiers that can be used to create Google Cloud SQL instances.
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
  var path_579283 = newJObject()
  var query_579284 = newJObject()
  add(query_579284, "key", newJString(key))
  add(query_579284, "prettyPrint", newJBool(prettyPrint))
  add(query_579284, "oauth_token", newJString(oauthToken))
  add(query_579284, "alt", newJString(alt))
  add(query_579284, "userIp", newJString(userIp))
  add(query_579284, "quotaUser", newJString(quotaUser))
  add(path_579283, "project", newJString(project))
  add(query_579284, "fields", newJString(fields))
  result = call_579282.call(path_579283, query_579284, nil, nil, nil)

var sqlTiersList* = Call_SqlTiersList_579270(name: "sqlTiersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/tiers", validator: validate_SqlTiersList_579271,
    base: "/sql/v1beta3", url: url_SqlTiersList_579272, schemes: {Scheme.Https})
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
