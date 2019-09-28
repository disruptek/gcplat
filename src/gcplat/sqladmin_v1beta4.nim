
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "sqladmin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SqlFlagsList_579689 = ref object of OpenApiRestCall_579421
proc url_SqlFlagsList_579691(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SqlFlagsList_579690(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## List all available database flags for Cloud SQL instances.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   databaseVersion: JString
  ##                  : Database type and version you want to retrieve flags for. By default, this method returns flags for all database types and versions.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579803 = query.getOrDefault("fields")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "fields", valid_579803
  var valid_579804 = query.getOrDefault("quotaUser")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "quotaUser", valid_579804
  var valid_579818 = query.getOrDefault("alt")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = newJString("json"))
  if valid_579818 != nil:
    section.add "alt", valid_579818
  var valid_579819 = query.getOrDefault("databaseVersion")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "databaseVersion", valid_579819
  var valid_579820 = query.getOrDefault("oauth_token")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "oauth_token", valid_579820
  var valid_579821 = query.getOrDefault("userIp")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "userIp", valid_579821
  var valid_579822 = query.getOrDefault("key")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "key", valid_579822
  var valid_579823 = query.getOrDefault("prettyPrint")
  valid_579823 = validateParameter(valid_579823, JBool, required = false,
                                 default = newJBool(true))
  if valid_579823 != nil:
    section.add "prettyPrint", valid_579823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579846: Call_SqlFlagsList_579689; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all available database flags for Cloud SQL instances.
  ## 
  let valid = call_579846.validator(path, query, header, formData, body)
  let scheme = call_579846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579846.url(scheme.get, call_579846.host, call_579846.base,
                         call_579846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579846, url, valid)

proc call*(call_579917: Call_SqlFlagsList_579689; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; databaseVersion: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## sqlFlagsList
  ## List all available database flags for Cloud SQL instances.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   databaseVersion: string
  ##                  : Database type and version you want to retrieve flags for. By default, this method returns flags for all database types and versions.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579918 = newJObject()
  add(query_579918, "fields", newJString(fields))
  add(query_579918, "quotaUser", newJString(quotaUser))
  add(query_579918, "alt", newJString(alt))
  add(query_579918, "databaseVersion", newJString(databaseVersion))
  add(query_579918, "oauth_token", newJString(oauthToken))
  add(query_579918, "userIp", newJString(userIp))
  add(query_579918, "key", newJString(key))
  add(query_579918, "prettyPrint", newJBool(prettyPrint))
  result = call_579917.call(nil, query_579918, nil, nil, nil)

var sqlFlagsList* = Call_SqlFlagsList_579689(name: "sqlFlagsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/flags",
    validator: validate_SqlFlagsList_579690, base: "/sql/v1beta4",
    url: url_SqlFlagsList_579691, schemes: {Scheme.Https})
type
  Call_SqlInstancesInsert_579990 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesInsert_579992(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesInsert_579991(path: JsonNode; query: JsonNode;
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
  var valid_579993 = path.getOrDefault("project")
  valid_579993 = validateParameter(valid_579993, JString, required = true,
                                 default = nil)
  if valid_579993 != nil:
    section.add "project", valid_579993
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("alt")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("json"))
  if valid_579996 != nil:
    section.add "alt", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("userIp")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "userIp", valid_579998
  var valid_579999 = query.getOrDefault("key")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "key", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
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

proc call*(call_580002: Call_SqlInstancesInsert_579990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Cloud SQL instance.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_SqlInstancesInsert_579990; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesInsert
  ## Creates a new Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID of the project to which the newly created Cloud SQL instances should belong.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  var body_580006 = newJObject()
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(query_580005, "userIp", newJString(userIp))
  add(query_580005, "key", newJString(key))
  add(path_580004, "project", newJString(project))
  if body != nil:
    body_580006 = body
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  result = call_580003.call(path_580004, query_580005, nil, nil, body_580006)

var sqlInstancesInsert* = Call_SqlInstancesInsert_579990(
    name: "sqlInstancesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{project}/instances",
    validator: validate_SqlInstancesInsert_579991, base: "/sql/v1beta4",
    url: url_SqlInstancesInsert_579992, schemes: {Scheme.Https})
type
  Call_SqlInstancesList_579958 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesList_579960(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesList_579959(path: JsonNode; query: JsonNode;
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
  var valid_579975 = path.getOrDefault("project")
  valid_579975 = validateParameter(valid_579975, JString, required = true,
                                 default = nil)
  if valid_579975 != nil:
    section.add "project", valid_579975
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results to return per response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : An expression for filtering the results of the request, such as by name or label.
  section = newJObject()
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  var valid_579977 = query.getOrDefault("pageToken")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "pageToken", valid_579977
  var valid_579978 = query.getOrDefault("quotaUser")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "quotaUser", valid_579978
  var valid_579979 = query.getOrDefault("alt")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("json"))
  if valid_579979 != nil:
    section.add "alt", valid_579979
  var valid_579980 = query.getOrDefault("oauth_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "oauth_token", valid_579980
  var valid_579981 = query.getOrDefault("userIp")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "userIp", valid_579981
  var valid_579982 = query.getOrDefault("maxResults")
  valid_579982 = validateParameter(valid_579982, JInt, required = false, default = nil)
  if valid_579982 != nil:
    section.add "maxResults", valid_579982
  var valid_579983 = query.getOrDefault("key")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "key", valid_579983
  var valid_579984 = query.getOrDefault("prettyPrint")
  valid_579984 = validateParameter(valid_579984, JBool, required = false,
                                 default = newJBool(true))
  if valid_579984 != nil:
    section.add "prettyPrint", valid_579984
  var valid_579985 = query.getOrDefault("filter")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "filter", valid_579985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579986: Call_SqlInstancesList_579958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists instances under a given project in the alphabetical order of the instance name.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_SqlInstancesList_579958; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## sqlInstancesList
  ## Lists instances under a given project in the alphabetical order of the instance name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results to return per response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID of the project for which to list Cloud SQL instances.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : An expression for filtering the results of the request, such as by name or label.
  var path_579988 = newJObject()
  var query_579989 = newJObject()
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "pageToken", newJString(pageToken))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "userIp", newJString(userIp))
  add(query_579989, "maxResults", newJInt(maxResults))
  add(query_579989, "key", newJString(key))
  add(path_579988, "project", newJString(project))
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  add(query_579989, "filter", newJString(filter))
  result = call_579987.call(path_579988, query_579989, nil, nil, nil)

var sqlInstancesList* = Call_SqlInstancesList_579958(name: "sqlInstancesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances", validator: validate_SqlInstancesList_579959,
    base: "/sql/v1beta4", url: url_SqlInstancesList_579960, schemes: {Scheme.Https})
type
  Call_SqlInstancesUpdate_580023 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesUpdate_580025(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesUpdate_580024(path: JsonNode; query: JsonNode;
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
  var valid_580026 = path.getOrDefault("instance")
  valid_580026 = validateParameter(valid_580026, JString, required = true,
                                 default = nil)
  if valid_580026 != nil:
    section.add "instance", valid_580026
  var valid_580027 = path.getOrDefault("project")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "project", valid_580027
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("userIp")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "userIp", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
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

proc call*(call_580036: Call_SqlInstancesUpdate_580023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_SqlInstancesUpdate_580023; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesUpdate
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  var body_580040 = newJObject()
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "userIp", newJString(userIp))
  add(query_580039, "key", newJString(key))
  add(path_580038, "instance", newJString(instance))
  add(path_580038, "project", newJString(project))
  if body != nil:
    body_580040 = body
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  result = call_580037.call(path_580038, query_580039, nil, nil, body_580040)

var sqlInstancesUpdate* = Call_SqlInstancesUpdate_580023(
    name: "sqlInstancesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesUpdate_580024, base: "/sql/v1beta4",
    url: url_SqlInstancesUpdate_580025, schemes: {Scheme.Https})
type
  Call_SqlInstancesGet_580007 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesGet_580009(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesGet_580008(path: JsonNode; query: JsonNode;
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
  var valid_580010 = path.getOrDefault("instance")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "instance", valid_580010
  var valid_580011 = path.getOrDefault("project")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "project", valid_580011
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_SqlInstancesGet_580007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a Cloud SQL instance.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_SqlInstancesGet_580007; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesGet
  ## Retrieves a resource containing information about a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "fields", newJString(fields))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "key", newJString(key))
  add(path_580021, "instance", newJString(instance))
  add(path_580021, "project", newJString(project))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var sqlInstancesGet* = Call_SqlInstancesGet_580007(name: "sqlInstancesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesGet_580008, base: "/sql/v1beta4",
    url: url_SqlInstancesGet_580009, schemes: {Scheme.Https})
type
  Call_SqlInstancesPatch_580057 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesPatch_580059(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesPatch_580058(path: JsonNode; query: JsonNode;
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
  var valid_580060 = path.getOrDefault("instance")
  valid_580060 = validateParameter(valid_580060, JString, required = true,
                                 default = nil)
  if valid_580060 != nil:
    section.add "instance", valid_580060
  var valid_580061 = path.getOrDefault("project")
  valid_580061 = validateParameter(valid_580061, JString, required = true,
                                 default = nil)
  if valid_580061 != nil:
    section.add "project", valid_580061
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580062 = query.getOrDefault("fields")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "fields", valid_580062
  var valid_580063 = query.getOrDefault("quotaUser")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "quotaUser", valid_580063
  var valid_580064 = query.getOrDefault("alt")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("json"))
  if valid_580064 != nil:
    section.add "alt", valid_580064
  var valid_580065 = query.getOrDefault("oauth_token")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "oauth_token", valid_580065
  var valid_580066 = query.getOrDefault("userIp")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "userIp", valid_580066
  var valid_580067 = query.getOrDefault("key")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "key", valid_580067
  var valid_580068 = query.getOrDefault("prettyPrint")
  valid_580068 = validateParameter(valid_580068, JBool, required = false,
                                 default = newJBool(true))
  if valid_580068 != nil:
    section.add "prettyPrint", valid_580068
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

proc call*(call_580070: Call_SqlInstancesPatch_580057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.. This method supports patch semantics.
  ## 
  let valid = call_580070.validator(path, query, header, formData, body)
  let scheme = call_580070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580070.url(scheme.get, call_580070.host, call_580070.base,
                         call_580070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580070, url, valid)

proc call*(call_580071: Call_SqlInstancesPatch_580057; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesPatch
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580072 = newJObject()
  var query_580073 = newJObject()
  var body_580074 = newJObject()
  add(query_580073, "fields", newJString(fields))
  add(query_580073, "quotaUser", newJString(quotaUser))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(query_580073, "userIp", newJString(userIp))
  add(query_580073, "key", newJString(key))
  add(path_580072, "instance", newJString(instance))
  add(path_580072, "project", newJString(project))
  if body != nil:
    body_580074 = body
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  result = call_580071.call(path_580072, query_580073, nil, nil, body_580074)

var sqlInstancesPatch* = Call_SqlInstancesPatch_580057(name: "sqlInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesPatch_580058, base: "/sql/v1beta4",
    url: url_SqlInstancesPatch_580059, schemes: {Scheme.Https})
type
  Call_SqlInstancesDelete_580041 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesDelete_580043(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesDelete_580042(path: JsonNode; query: JsonNode;
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
  var valid_580044 = path.getOrDefault("instance")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "instance", valid_580044
  var valid_580045 = path.getOrDefault("project")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "project", valid_580045
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  var valid_580048 = query.getOrDefault("alt")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("json"))
  if valid_580048 != nil:
    section.add "alt", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("userIp")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "userIp", valid_580050
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("prettyPrint")
  valid_580052 = validateParameter(valid_580052, JBool, required = false,
                                 default = newJBool(true))
  if valid_580052 != nil:
    section.add "prettyPrint", valid_580052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580053: Call_SqlInstancesDelete_580041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cloud SQL instance.
  ## 
  let valid = call_580053.validator(path, query, header, formData, body)
  let scheme = call_580053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580053.url(scheme.get, call_580053.host, call_580053.base,
                         call_580053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580053, url, valid)

proc call*(call_580054: Call_SqlInstancesDelete_580041; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesDelete
  ## Deletes a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance to be deleted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580055 = newJObject()
  var query_580056 = newJObject()
  add(query_580056, "fields", newJString(fields))
  add(query_580056, "quotaUser", newJString(quotaUser))
  add(query_580056, "alt", newJString(alt))
  add(query_580056, "oauth_token", newJString(oauthToken))
  add(query_580056, "userIp", newJString(userIp))
  add(query_580056, "key", newJString(key))
  add(path_580055, "instance", newJString(instance))
  add(path_580055, "project", newJString(project))
  add(query_580056, "prettyPrint", newJBool(prettyPrint))
  result = call_580054.call(path_580055, query_580056, nil, nil, nil)

var sqlInstancesDelete* = Call_SqlInstancesDelete_580041(
    name: "sqlInstancesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesDelete_580042, base: "/sql/v1beta4",
    url: url_SqlInstancesDelete_580043, schemes: {Scheme.Https})
type
  Call_SqlInstancesAddServerCa_580075 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesAddServerCa_580077(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesAddServerCa_580076(path: JsonNode; query: JsonNode;
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
  var valid_580078 = path.getOrDefault("instance")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "instance", valid_580078
  var valid_580079 = path.getOrDefault("project")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "project", valid_580079
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("alt")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("json"))
  if valid_580082 != nil:
    section.add "alt", valid_580082
  var valid_580083 = query.getOrDefault("oauth_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "oauth_token", valid_580083
  var valid_580084 = query.getOrDefault("userIp")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "userIp", valid_580084
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("prettyPrint")
  valid_580086 = validateParameter(valid_580086, JBool, required = false,
                                 default = newJBool(true))
  if valid_580086 != nil:
    section.add "prettyPrint", valid_580086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580087: Call_SqlInstancesAddServerCa_580075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new trusted Certificate Authority (CA) version for the specified instance. Required to prepare for a certificate rotation. If a CA version was previously added but never used in a certificate rotation, this operation replaces that version. There cannot be more than one CA version waiting to be rotated in.
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_SqlInstancesAddServerCa_580075; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesAddServerCa
  ## Add a new trusted Certificate Authority (CA) version for the specified instance. Required to prepare for a certificate rotation. If a CA version was previously added but never used in a certificate rotation, this operation replaces that version. There cannot be more than one CA version waiting to be rotated in.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580089 = newJObject()
  var query_580090 = newJObject()
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "quotaUser", newJString(quotaUser))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(query_580090, "userIp", newJString(userIp))
  add(query_580090, "key", newJString(key))
  add(path_580089, "instance", newJString(instance))
  add(path_580089, "project", newJString(project))
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  result = call_580088.call(path_580089, query_580090, nil, nil, nil)

var sqlInstancesAddServerCa* = Call_SqlInstancesAddServerCa_580075(
    name: "sqlInstancesAddServerCa", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/addServerCa",
    validator: validate_SqlInstancesAddServerCa_580076, base: "/sql/v1beta4",
    url: url_SqlInstancesAddServerCa_580077, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsInsert_580109 = ref object of OpenApiRestCall_579421
proc url_SqlBackupRunsInsert_580111(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsInsert_580110(path: JsonNode; query: JsonNode;
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
  var valid_580112 = path.getOrDefault("instance")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "instance", valid_580112
  var valid_580113 = path.getOrDefault("project")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "project", valid_580113
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("userIp")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "userIp", valid_580118
  var valid_580119 = query.getOrDefault("key")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "key", valid_580119
  var valid_580120 = query.getOrDefault("prettyPrint")
  valid_580120 = validateParameter(valid_580120, JBool, required = false,
                                 default = newJBool(true))
  if valid_580120 != nil:
    section.add "prettyPrint", valid_580120
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

proc call*(call_580122: Call_SqlBackupRunsInsert_580109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new backup run on demand. This method is applicable only to Second Generation instances.
  ## 
  let valid = call_580122.validator(path, query, header, formData, body)
  let scheme = call_580122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580122.url(scheme.get, call_580122.host, call_580122.base,
                         call_580122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580122, url, valid)

proc call*(call_580123: Call_SqlBackupRunsInsert_580109; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlBackupRunsInsert
  ## Creates a new backup run on demand. This method is applicable only to Second Generation instances.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580124 = newJObject()
  var query_580125 = newJObject()
  var body_580126 = newJObject()
  add(query_580125, "fields", newJString(fields))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(query_580125, "userIp", newJString(userIp))
  add(query_580125, "key", newJString(key))
  add(path_580124, "instance", newJString(instance))
  add(path_580124, "project", newJString(project))
  if body != nil:
    body_580126 = body
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  result = call_580123.call(path_580124, query_580125, nil, nil, body_580126)

var sqlBackupRunsInsert* = Call_SqlBackupRunsInsert_580109(
    name: "sqlBackupRunsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsInsert_580110, base: "/sql/v1beta4",
    url: url_SqlBackupRunsInsert_580111, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsList_580091 = ref object of OpenApiRestCall_579421
proc url_SqlBackupRunsList_580093(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsList_580092(path: JsonNode; query: JsonNode;
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
  var valid_580094 = path.getOrDefault("instance")
  valid_580094 = validateParameter(valid_580094, JString, required = true,
                                 default = nil)
  if valid_580094 != nil:
    section.add "instance", valid_580094
  var valid_580095 = path.getOrDefault("project")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "project", valid_580095
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of backup runs per response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580096 = query.getOrDefault("fields")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "fields", valid_580096
  var valid_580097 = query.getOrDefault("pageToken")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "pageToken", valid_580097
  var valid_580098 = query.getOrDefault("quotaUser")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "quotaUser", valid_580098
  var valid_580099 = query.getOrDefault("alt")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("json"))
  if valid_580099 != nil:
    section.add "alt", valid_580099
  var valid_580100 = query.getOrDefault("oauth_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "oauth_token", valid_580100
  var valid_580101 = query.getOrDefault("userIp")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "userIp", valid_580101
  var valid_580102 = query.getOrDefault("maxResults")
  valid_580102 = validateParameter(valid_580102, JInt, required = false, default = nil)
  if valid_580102 != nil:
    section.add "maxResults", valid_580102
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580105: Call_SqlBackupRunsList_580091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all backup runs associated with a given instance and configuration in the reverse chronological order of the backup initiation time.
  ## 
  let valid = call_580105.validator(path, query, header, formData, body)
  let scheme = call_580105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580105.url(scheme.get, call_580105.host, call_580105.base,
                         call_580105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580105, url, valid)

proc call*(call_580106: Call_SqlBackupRunsList_580091; instance: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## sqlBackupRunsList
  ## Lists all backup runs associated with a given instance and configuration in the reverse chronological order of the backup initiation time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of backup runs per response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580107 = newJObject()
  var query_580108 = newJObject()
  add(query_580108, "fields", newJString(fields))
  add(query_580108, "pageToken", newJString(pageToken))
  add(query_580108, "quotaUser", newJString(quotaUser))
  add(query_580108, "alt", newJString(alt))
  add(query_580108, "oauth_token", newJString(oauthToken))
  add(query_580108, "userIp", newJString(userIp))
  add(query_580108, "maxResults", newJInt(maxResults))
  add(query_580108, "key", newJString(key))
  add(path_580107, "instance", newJString(instance))
  add(path_580107, "project", newJString(project))
  add(query_580108, "prettyPrint", newJBool(prettyPrint))
  result = call_580106.call(path_580107, query_580108, nil, nil, nil)

var sqlBackupRunsList* = Call_SqlBackupRunsList_580091(name: "sqlBackupRunsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsList_580092, base: "/sql/v1beta4",
    url: url_SqlBackupRunsList_580093, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsGet_580127 = ref object of OpenApiRestCall_579421
proc url_SqlBackupRunsGet_580129(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsGet_580128(path: JsonNode; query: JsonNode;
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
  var valid_580130 = path.getOrDefault("id")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "id", valid_580130
  var valid_580131 = path.getOrDefault("instance")
  valid_580131 = validateParameter(valid_580131, JString, required = true,
                                 default = nil)
  if valid_580131 != nil:
    section.add "instance", valid_580131
  var valid_580132 = path.getOrDefault("project")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "project", valid_580132
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580133 = query.getOrDefault("fields")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "fields", valid_580133
  var valid_580134 = query.getOrDefault("quotaUser")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "quotaUser", valid_580134
  var valid_580135 = query.getOrDefault("alt")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("json"))
  if valid_580135 != nil:
    section.add "alt", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("userIp")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "userIp", valid_580137
  var valid_580138 = query.getOrDefault("key")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "key", valid_580138
  var valid_580139 = query.getOrDefault("prettyPrint")
  valid_580139 = validateParameter(valid_580139, JBool, required = false,
                                 default = newJBool(true))
  if valid_580139 != nil:
    section.add "prettyPrint", valid_580139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580140: Call_SqlBackupRunsGet_580127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a backup run.
  ## 
  let valid = call_580140.validator(path, query, header, formData, body)
  let scheme = call_580140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580140.url(scheme.get, call_580140.host, call_580140.base,
                         call_580140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580140, url, valid)

proc call*(call_580141: Call_SqlBackupRunsGet_580127; id: string; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlBackupRunsGet
  ## Retrieves a resource containing information about a backup run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   id: string (required)
  ##     : The ID of this Backup Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580142 = newJObject()
  var query_580143 = newJObject()
  add(query_580143, "fields", newJString(fields))
  add(query_580143, "quotaUser", newJString(quotaUser))
  add(query_580143, "alt", newJString(alt))
  add(query_580143, "oauth_token", newJString(oauthToken))
  add(query_580143, "userIp", newJString(userIp))
  add(path_580142, "id", newJString(id))
  add(query_580143, "key", newJString(key))
  add(path_580142, "instance", newJString(instance))
  add(path_580142, "project", newJString(project))
  add(query_580143, "prettyPrint", newJBool(prettyPrint))
  result = call_580141.call(path_580142, query_580143, nil, nil, nil)

var sqlBackupRunsGet* = Call_SqlBackupRunsGet_580127(name: "sqlBackupRunsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns/{id}",
    validator: validate_SqlBackupRunsGet_580128, base: "/sql/v1beta4",
    url: url_SqlBackupRunsGet_580129, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsDelete_580144 = ref object of OpenApiRestCall_579421
proc url_SqlBackupRunsDelete_580146(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsDelete_580145(path: JsonNode; query: JsonNode;
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
  var valid_580147 = path.getOrDefault("id")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "id", valid_580147
  var valid_580148 = path.getOrDefault("instance")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = nil)
  if valid_580148 != nil:
    section.add "instance", valid_580148
  var valid_580149 = path.getOrDefault("project")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "project", valid_580149
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580150 = query.getOrDefault("fields")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "fields", valid_580150
  var valid_580151 = query.getOrDefault("quotaUser")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "quotaUser", valid_580151
  var valid_580152 = query.getOrDefault("alt")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = newJString("json"))
  if valid_580152 != nil:
    section.add "alt", valid_580152
  var valid_580153 = query.getOrDefault("oauth_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "oauth_token", valid_580153
  var valid_580154 = query.getOrDefault("userIp")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "userIp", valid_580154
  var valid_580155 = query.getOrDefault("key")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "key", valid_580155
  var valid_580156 = query.getOrDefault("prettyPrint")
  valid_580156 = validateParameter(valid_580156, JBool, required = false,
                                 default = newJBool(true))
  if valid_580156 != nil:
    section.add "prettyPrint", valid_580156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580157: Call_SqlBackupRunsDelete_580144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup taken by a backup run.
  ## 
  let valid = call_580157.validator(path, query, header, formData, body)
  let scheme = call_580157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580157.url(scheme.get, call_580157.host, call_580157.base,
                         call_580157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580157, url, valid)

proc call*(call_580158: Call_SqlBackupRunsDelete_580144; id: string;
          instance: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlBackupRunsDelete
  ## Deletes the backup taken by a backup run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   id: string (required)
  ##     : The ID of the Backup Run to delete. To find a Backup Run ID, use the list method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580159 = newJObject()
  var query_580160 = newJObject()
  add(query_580160, "fields", newJString(fields))
  add(query_580160, "quotaUser", newJString(quotaUser))
  add(query_580160, "alt", newJString(alt))
  add(query_580160, "oauth_token", newJString(oauthToken))
  add(query_580160, "userIp", newJString(userIp))
  add(path_580159, "id", newJString(id))
  add(query_580160, "key", newJString(key))
  add(path_580159, "instance", newJString(instance))
  add(path_580159, "project", newJString(project))
  add(query_580160, "prettyPrint", newJBool(prettyPrint))
  result = call_580158.call(path_580159, query_580160, nil, nil, nil)

var sqlBackupRunsDelete* = Call_SqlBackupRunsDelete_580144(
    name: "sqlBackupRunsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns/{id}",
    validator: validate_SqlBackupRunsDelete_580145, base: "/sql/v1beta4",
    url: url_SqlBackupRunsDelete_580146, schemes: {Scheme.Https})
type
  Call_SqlInstancesClone_580161 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesClone_580163(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesClone_580162(path: JsonNode; query: JsonNode;
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
  var valid_580164 = path.getOrDefault("instance")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "instance", valid_580164
  var valid_580165 = path.getOrDefault("project")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "project", valid_580165
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580166 = query.getOrDefault("fields")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "fields", valid_580166
  var valid_580167 = query.getOrDefault("quotaUser")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "quotaUser", valid_580167
  var valid_580168 = query.getOrDefault("alt")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("json"))
  if valid_580168 != nil:
    section.add "alt", valid_580168
  var valid_580169 = query.getOrDefault("oauth_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "oauth_token", valid_580169
  var valid_580170 = query.getOrDefault("userIp")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "userIp", valid_580170
  var valid_580171 = query.getOrDefault("key")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "key", valid_580171
  var valid_580172 = query.getOrDefault("prettyPrint")
  valid_580172 = validateParameter(valid_580172, JBool, required = false,
                                 default = newJBool(true))
  if valid_580172 != nil:
    section.add "prettyPrint", valid_580172
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

proc call*(call_580174: Call_SqlInstancesClone_580161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud SQL instance as a clone of the source instance.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_SqlInstancesClone_580161; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesClone
  ## Creates a Cloud SQL instance as a clone of the source instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : The ID of the Cloud SQL instance to be cloned (source). This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the source as well as the clone Cloud SQL instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  var body_580178 = newJObject()
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "userIp", newJString(userIp))
  add(query_580177, "key", newJString(key))
  add(path_580176, "instance", newJString(instance))
  add(path_580176, "project", newJString(project))
  if body != nil:
    body_580178 = body
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  result = call_580175.call(path_580176, query_580177, nil, nil, body_580178)

var sqlInstancesClone* = Call_SqlInstancesClone_580161(name: "sqlInstancesClone",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/clone",
    validator: validate_SqlInstancesClone_580162, base: "/sql/v1beta4",
    url: url_SqlInstancesClone_580163, schemes: {Scheme.Https})
type
  Call_SqlSslCertsCreateEphemeral_580179 = ref object of OpenApiRestCall_579421
proc url_SqlSslCertsCreateEphemeral_580181(protocol: Scheme; host: string;
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

proc validate_SqlSslCertsCreateEphemeral_580180(path: JsonNode; query: JsonNode;
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
  var valid_580182 = path.getOrDefault("instance")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "instance", valid_580182
  var valid_580183 = path.getOrDefault("project")
  valid_580183 = validateParameter(valid_580183, JString, required = true,
                                 default = nil)
  if valid_580183 != nil:
    section.add "project", valid_580183
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580184 = query.getOrDefault("fields")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "fields", valid_580184
  var valid_580185 = query.getOrDefault("quotaUser")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "quotaUser", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("userIp")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "userIp", valid_580188
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
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

proc call*(call_580192: Call_SqlSslCertsCreateEphemeral_580179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a short-lived X509 certificate containing the provided public key and signed by a private key specific to the target instance. Users may use the certificate to authenticate as themselves when connecting to the database.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_SqlSslCertsCreateEphemeral_580179; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlSslCertsCreateEphemeral
  ## Generates a short-lived X509 certificate containing the provided public key and signed by a private key specific to the target instance. Users may use the certificate to authenticate as themselves when connecting to the database.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the Cloud SQL project.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  var body_580196 = newJObject()
  add(query_580195, "fields", newJString(fields))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "key", newJString(key))
  add(path_580194, "instance", newJString(instance))
  add(path_580194, "project", newJString(project))
  if body != nil:
    body_580196 = body
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  result = call_580193.call(path_580194, query_580195, nil, nil, body_580196)

var sqlSslCertsCreateEphemeral* = Call_SqlSslCertsCreateEphemeral_580179(
    name: "sqlSslCertsCreateEphemeral", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/createEphemeral",
    validator: validate_SqlSslCertsCreateEphemeral_580180, base: "/sql/v1beta4",
    url: url_SqlSslCertsCreateEphemeral_580181, schemes: {Scheme.Https})
type
  Call_SqlDatabasesInsert_580213 = ref object of OpenApiRestCall_579421
proc url_SqlDatabasesInsert_580215(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesInsert_580214(path: JsonNode; query: JsonNode;
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
  var valid_580216 = path.getOrDefault("instance")
  valid_580216 = validateParameter(valid_580216, JString, required = true,
                                 default = nil)
  if valid_580216 != nil:
    section.add "instance", valid_580216
  var valid_580217 = path.getOrDefault("project")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "project", valid_580217
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580218 = query.getOrDefault("fields")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "fields", valid_580218
  var valid_580219 = query.getOrDefault("quotaUser")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "quotaUser", valid_580219
  var valid_580220 = query.getOrDefault("alt")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = newJString("json"))
  if valid_580220 != nil:
    section.add "alt", valid_580220
  var valid_580221 = query.getOrDefault("oauth_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "oauth_token", valid_580221
  var valid_580222 = query.getOrDefault("userIp")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "userIp", valid_580222
  var valid_580223 = query.getOrDefault("key")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "key", valid_580223
  var valid_580224 = query.getOrDefault("prettyPrint")
  valid_580224 = validateParameter(valid_580224, JBool, required = false,
                                 default = newJBool(true))
  if valid_580224 != nil:
    section.add "prettyPrint", valid_580224
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

proc call*(call_580226: Call_SqlDatabasesInsert_580213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a resource containing information about a database inside a Cloud SQL instance.
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_SqlDatabasesInsert_580213; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlDatabasesInsert
  ## Inserts a resource containing information about a database inside a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  var body_580230 = newJObject()
  add(query_580229, "fields", newJString(fields))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "userIp", newJString(userIp))
  add(query_580229, "key", newJString(key))
  add(path_580228, "instance", newJString(instance))
  add(path_580228, "project", newJString(project))
  if body != nil:
    body_580230 = body
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  result = call_580227.call(path_580228, query_580229, nil, nil, body_580230)

var sqlDatabasesInsert* = Call_SqlDatabasesInsert_580213(
    name: "sqlDatabasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases",
    validator: validate_SqlDatabasesInsert_580214, base: "/sql/v1beta4",
    url: url_SqlDatabasesInsert_580215, schemes: {Scheme.Https})
type
  Call_SqlDatabasesList_580197 = ref object of OpenApiRestCall_579421
proc url_SqlDatabasesList_580199(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesList_580198(path: JsonNode; query: JsonNode;
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
  var valid_580200 = path.getOrDefault("instance")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "instance", valid_580200
  var valid_580201 = path.getOrDefault("project")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "project", valid_580201
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580202 = query.getOrDefault("fields")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "fields", valid_580202
  var valid_580203 = query.getOrDefault("quotaUser")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "quotaUser", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("oauth_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "oauth_token", valid_580205
  var valid_580206 = query.getOrDefault("userIp")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "userIp", valid_580206
  var valid_580207 = query.getOrDefault("key")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "key", valid_580207
  var valid_580208 = query.getOrDefault("prettyPrint")
  valid_580208 = validateParameter(valid_580208, JBool, required = false,
                                 default = newJBool(true))
  if valid_580208 != nil:
    section.add "prettyPrint", valid_580208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580209: Call_SqlDatabasesList_580197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists databases in the specified Cloud SQL instance.
  ## 
  let valid = call_580209.validator(path, query, header, formData, body)
  let scheme = call_580209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580209.url(scheme.get, call_580209.host, call_580209.base,
                         call_580209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580209, url, valid)

proc call*(call_580210: Call_SqlDatabasesList_580197; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlDatabasesList
  ## Lists databases in the specified Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580211 = newJObject()
  var query_580212 = newJObject()
  add(query_580212, "fields", newJString(fields))
  add(query_580212, "quotaUser", newJString(quotaUser))
  add(query_580212, "alt", newJString(alt))
  add(query_580212, "oauth_token", newJString(oauthToken))
  add(query_580212, "userIp", newJString(userIp))
  add(query_580212, "key", newJString(key))
  add(path_580211, "instance", newJString(instance))
  add(path_580211, "project", newJString(project))
  add(query_580212, "prettyPrint", newJBool(prettyPrint))
  result = call_580210.call(path_580211, query_580212, nil, nil, nil)

var sqlDatabasesList* = Call_SqlDatabasesList_580197(name: "sqlDatabasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases",
    validator: validate_SqlDatabasesList_580198, base: "/sql/v1beta4",
    url: url_SqlDatabasesList_580199, schemes: {Scheme.Https})
type
  Call_SqlDatabasesUpdate_580248 = ref object of OpenApiRestCall_579421
proc url_SqlDatabasesUpdate_580250(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesUpdate_580249(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a resource containing information about a database inside a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   database: JString (required)
  ##           : Name of the database to be updated in the instance.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_580251 = path.getOrDefault("instance")
  valid_580251 = validateParameter(valid_580251, JString, required = true,
                                 default = nil)
  if valid_580251 != nil:
    section.add "instance", valid_580251
  var valid_580252 = path.getOrDefault("database")
  valid_580252 = validateParameter(valid_580252, JString, required = true,
                                 default = nil)
  if valid_580252 != nil:
    section.add "database", valid_580252
  var valid_580253 = path.getOrDefault("project")
  valid_580253 = validateParameter(valid_580253, JString, required = true,
                                 default = nil)
  if valid_580253 != nil:
    section.add "project", valid_580253
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580254 = query.getOrDefault("fields")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "fields", valid_580254
  var valid_580255 = query.getOrDefault("quotaUser")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "quotaUser", valid_580255
  var valid_580256 = query.getOrDefault("alt")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = newJString("json"))
  if valid_580256 != nil:
    section.add "alt", valid_580256
  var valid_580257 = query.getOrDefault("oauth_token")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "oauth_token", valid_580257
  var valid_580258 = query.getOrDefault("userIp")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "userIp", valid_580258
  var valid_580259 = query.getOrDefault("key")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "key", valid_580259
  var valid_580260 = query.getOrDefault("prettyPrint")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(true))
  if valid_580260 != nil:
    section.add "prettyPrint", valid_580260
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

proc call*(call_580262: Call_SqlDatabasesUpdate_580248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource containing information about a database inside a Cloud SQL instance.
  ## 
  let valid = call_580262.validator(path, query, header, formData, body)
  let scheme = call_580262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580262.url(scheme.get, call_580262.host, call_580262.base,
                         call_580262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580262, url, valid)

proc call*(call_580263: Call_SqlDatabasesUpdate_580248; instance: string;
          database: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sqlDatabasesUpdate
  ## Updates a resource containing information about a database inside a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   database: string (required)
  ##           : Name of the database to be updated in the instance.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580264 = newJObject()
  var query_580265 = newJObject()
  var body_580266 = newJObject()
  add(query_580265, "fields", newJString(fields))
  add(query_580265, "quotaUser", newJString(quotaUser))
  add(query_580265, "alt", newJString(alt))
  add(query_580265, "oauth_token", newJString(oauthToken))
  add(query_580265, "userIp", newJString(userIp))
  add(query_580265, "key", newJString(key))
  add(path_580264, "instance", newJString(instance))
  add(path_580264, "database", newJString(database))
  add(path_580264, "project", newJString(project))
  if body != nil:
    body_580266 = body
  add(query_580265, "prettyPrint", newJBool(prettyPrint))
  result = call_580263.call(path_580264, query_580265, nil, nil, body_580266)

var sqlDatabasesUpdate* = Call_SqlDatabasesUpdate_580248(
    name: "sqlDatabasesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesUpdate_580249, base: "/sql/v1beta4",
    url: url_SqlDatabasesUpdate_580250, schemes: {Scheme.Https})
type
  Call_SqlDatabasesGet_580231 = ref object of OpenApiRestCall_579421
proc url_SqlDatabasesGet_580233(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesGet_580232(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves a resource containing information about a database inside a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   database: JString (required)
  ##           : Name of the database in the instance.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_580234 = path.getOrDefault("instance")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "instance", valid_580234
  var valid_580235 = path.getOrDefault("database")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "database", valid_580235
  var valid_580236 = path.getOrDefault("project")
  valid_580236 = validateParameter(valid_580236, JString, required = true,
                                 default = nil)
  if valid_580236 != nil:
    section.add "project", valid_580236
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580237 = query.getOrDefault("fields")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "fields", valid_580237
  var valid_580238 = query.getOrDefault("quotaUser")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "quotaUser", valid_580238
  var valid_580239 = query.getOrDefault("alt")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = newJString("json"))
  if valid_580239 != nil:
    section.add "alt", valid_580239
  var valid_580240 = query.getOrDefault("oauth_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "oauth_token", valid_580240
  var valid_580241 = query.getOrDefault("userIp")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "userIp", valid_580241
  var valid_580242 = query.getOrDefault("key")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "key", valid_580242
  var valid_580243 = query.getOrDefault("prettyPrint")
  valid_580243 = validateParameter(valid_580243, JBool, required = false,
                                 default = newJBool(true))
  if valid_580243 != nil:
    section.add "prettyPrint", valid_580243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580244: Call_SqlDatabasesGet_580231; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a database inside a Cloud SQL instance.
  ## 
  let valid = call_580244.validator(path, query, header, formData, body)
  let scheme = call_580244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580244.url(scheme.get, call_580244.host, call_580244.base,
                         call_580244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580244, url, valid)

proc call*(call_580245: Call_SqlDatabasesGet_580231; instance: string;
          database: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlDatabasesGet
  ## Retrieves a resource containing information about a database inside a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   database: string (required)
  ##           : Name of the database in the instance.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580246 = newJObject()
  var query_580247 = newJObject()
  add(query_580247, "fields", newJString(fields))
  add(query_580247, "quotaUser", newJString(quotaUser))
  add(query_580247, "alt", newJString(alt))
  add(query_580247, "oauth_token", newJString(oauthToken))
  add(query_580247, "userIp", newJString(userIp))
  add(query_580247, "key", newJString(key))
  add(path_580246, "instance", newJString(instance))
  add(path_580246, "database", newJString(database))
  add(path_580246, "project", newJString(project))
  add(query_580247, "prettyPrint", newJBool(prettyPrint))
  result = call_580245.call(path_580246, query_580247, nil, nil, nil)

var sqlDatabasesGet* = Call_SqlDatabasesGet_580231(name: "sqlDatabasesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesGet_580232, base: "/sql/v1beta4",
    url: url_SqlDatabasesGet_580233, schemes: {Scheme.Https})
type
  Call_SqlDatabasesPatch_580284 = ref object of OpenApiRestCall_579421
proc url_SqlDatabasesPatch_580286(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesPatch_580285(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates a resource containing information about a database inside a Cloud SQL instance. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   database: JString (required)
  ##           : Name of the database to be updated in the instance.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_580287 = path.getOrDefault("instance")
  valid_580287 = validateParameter(valid_580287, JString, required = true,
                                 default = nil)
  if valid_580287 != nil:
    section.add "instance", valid_580287
  var valid_580288 = path.getOrDefault("database")
  valid_580288 = validateParameter(valid_580288, JString, required = true,
                                 default = nil)
  if valid_580288 != nil:
    section.add "database", valid_580288
  var valid_580289 = path.getOrDefault("project")
  valid_580289 = validateParameter(valid_580289, JString, required = true,
                                 default = nil)
  if valid_580289 != nil:
    section.add "project", valid_580289
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580290 = query.getOrDefault("fields")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "fields", valid_580290
  var valid_580291 = query.getOrDefault("quotaUser")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "quotaUser", valid_580291
  var valid_580292 = query.getOrDefault("alt")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("json"))
  if valid_580292 != nil:
    section.add "alt", valid_580292
  var valid_580293 = query.getOrDefault("oauth_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "oauth_token", valid_580293
  var valid_580294 = query.getOrDefault("userIp")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "userIp", valid_580294
  var valid_580295 = query.getOrDefault("key")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "key", valid_580295
  var valid_580296 = query.getOrDefault("prettyPrint")
  valid_580296 = validateParameter(valid_580296, JBool, required = false,
                                 default = newJBool(true))
  if valid_580296 != nil:
    section.add "prettyPrint", valid_580296
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

proc call*(call_580298: Call_SqlDatabasesPatch_580284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource containing information about a database inside a Cloud SQL instance. This method supports patch semantics.
  ## 
  let valid = call_580298.validator(path, query, header, formData, body)
  let scheme = call_580298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580298.url(scheme.get, call_580298.host, call_580298.base,
                         call_580298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580298, url, valid)

proc call*(call_580299: Call_SqlDatabasesPatch_580284; instance: string;
          database: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## sqlDatabasesPatch
  ## Updates a resource containing information about a database inside a Cloud SQL instance. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   database: string (required)
  ##           : Name of the database to be updated in the instance.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580300 = newJObject()
  var query_580301 = newJObject()
  var body_580302 = newJObject()
  add(query_580301, "fields", newJString(fields))
  add(query_580301, "quotaUser", newJString(quotaUser))
  add(query_580301, "alt", newJString(alt))
  add(query_580301, "oauth_token", newJString(oauthToken))
  add(query_580301, "userIp", newJString(userIp))
  add(query_580301, "key", newJString(key))
  add(path_580300, "instance", newJString(instance))
  add(path_580300, "database", newJString(database))
  add(path_580300, "project", newJString(project))
  if body != nil:
    body_580302 = body
  add(query_580301, "prettyPrint", newJBool(prettyPrint))
  result = call_580299.call(path_580300, query_580301, nil, nil, body_580302)

var sqlDatabasesPatch* = Call_SqlDatabasesPatch_580284(name: "sqlDatabasesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesPatch_580285, base: "/sql/v1beta4",
    url: url_SqlDatabasesPatch_580286, schemes: {Scheme.Https})
type
  Call_SqlDatabasesDelete_580267 = ref object of OpenApiRestCall_579421
proc url_SqlDatabasesDelete_580269(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesDelete_580268(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes a database from a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   database: JString (required)
  ##           : Name of the database to be deleted in the instance.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_580270 = path.getOrDefault("instance")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "instance", valid_580270
  var valid_580271 = path.getOrDefault("database")
  valid_580271 = validateParameter(valid_580271, JString, required = true,
                                 default = nil)
  if valid_580271 != nil:
    section.add "database", valid_580271
  var valid_580272 = path.getOrDefault("project")
  valid_580272 = validateParameter(valid_580272, JString, required = true,
                                 default = nil)
  if valid_580272 != nil:
    section.add "project", valid_580272
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580273 = query.getOrDefault("fields")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "fields", valid_580273
  var valid_580274 = query.getOrDefault("quotaUser")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "quotaUser", valid_580274
  var valid_580275 = query.getOrDefault("alt")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("json"))
  if valid_580275 != nil:
    section.add "alt", valid_580275
  var valid_580276 = query.getOrDefault("oauth_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "oauth_token", valid_580276
  var valid_580277 = query.getOrDefault("userIp")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "userIp", valid_580277
  var valid_580278 = query.getOrDefault("key")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "key", valid_580278
  var valid_580279 = query.getOrDefault("prettyPrint")
  valid_580279 = validateParameter(valid_580279, JBool, required = false,
                                 default = newJBool(true))
  if valid_580279 != nil:
    section.add "prettyPrint", valid_580279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580280: Call_SqlDatabasesDelete_580267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a database from a Cloud SQL instance.
  ## 
  let valid = call_580280.validator(path, query, header, formData, body)
  let scheme = call_580280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580280.url(scheme.get, call_580280.host, call_580280.base,
                         call_580280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580280, url, valid)

proc call*(call_580281: Call_SqlDatabasesDelete_580267; instance: string;
          database: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlDatabasesDelete
  ## Deletes a database from a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   database: string (required)
  ##           : Name of the database to be deleted in the instance.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580282 = newJObject()
  var query_580283 = newJObject()
  add(query_580283, "fields", newJString(fields))
  add(query_580283, "quotaUser", newJString(quotaUser))
  add(query_580283, "alt", newJString(alt))
  add(query_580283, "oauth_token", newJString(oauthToken))
  add(query_580283, "userIp", newJString(userIp))
  add(query_580283, "key", newJString(key))
  add(path_580282, "instance", newJString(instance))
  add(path_580282, "database", newJString(database))
  add(path_580282, "project", newJString(project))
  add(query_580283, "prettyPrint", newJBool(prettyPrint))
  result = call_580281.call(path_580282, query_580283, nil, nil, nil)

var sqlDatabasesDelete* = Call_SqlDatabasesDelete_580267(
    name: "sqlDatabasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesDelete_580268, base: "/sql/v1beta4",
    url: url_SqlDatabasesDelete_580269, schemes: {Scheme.Https})
type
  Call_SqlInstancesDemoteMaster_580303 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesDemoteMaster_580305(protocol: Scheme; host: string;
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

proc validate_SqlInstancesDemoteMaster_580304(path: JsonNode; query: JsonNode;
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
  var valid_580306 = path.getOrDefault("instance")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "instance", valid_580306
  var valid_580307 = path.getOrDefault("project")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "project", valid_580307
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580308 = query.getOrDefault("fields")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "fields", valid_580308
  var valid_580309 = query.getOrDefault("quotaUser")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "quotaUser", valid_580309
  var valid_580310 = query.getOrDefault("alt")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("json"))
  if valid_580310 != nil:
    section.add "alt", valid_580310
  var valid_580311 = query.getOrDefault("oauth_token")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "oauth_token", valid_580311
  var valid_580312 = query.getOrDefault("userIp")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "userIp", valid_580312
  var valid_580313 = query.getOrDefault("key")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "key", valid_580313
  var valid_580314 = query.getOrDefault("prettyPrint")
  valid_580314 = validateParameter(valid_580314, JBool, required = false,
                                 default = newJBool(true))
  if valid_580314 != nil:
    section.add "prettyPrint", valid_580314
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

proc call*(call_580316: Call_SqlInstancesDemoteMaster_580303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Demotes the stand-alone instance to be a Cloud SQL read replica for an external database server.
  ## 
  let valid = call_580316.validator(path, query, header, formData, body)
  let scheme = call_580316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580316.url(scheme.get, call_580316.host, call_580316.base,
                         call_580316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580316, url, valid)

proc call*(call_580317: Call_SqlInstancesDemoteMaster_580303; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesDemoteMaster
  ## Demotes the stand-alone instance to be a Cloud SQL read replica for an external database server.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580318 = newJObject()
  var query_580319 = newJObject()
  var body_580320 = newJObject()
  add(query_580319, "fields", newJString(fields))
  add(query_580319, "quotaUser", newJString(quotaUser))
  add(query_580319, "alt", newJString(alt))
  add(query_580319, "oauth_token", newJString(oauthToken))
  add(query_580319, "userIp", newJString(userIp))
  add(query_580319, "key", newJString(key))
  add(path_580318, "instance", newJString(instance))
  add(path_580318, "project", newJString(project))
  if body != nil:
    body_580320 = body
  add(query_580319, "prettyPrint", newJBool(prettyPrint))
  result = call_580317.call(path_580318, query_580319, nil, nil, body_580320)

var sqlInstancesDemoteMaster* = Call_SqlInstancesDemoteMaster_580303(
    name: "sqlInstancesDemoteMaster", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/demoteMaster",
    validator: validate_SqlInstancesDemoteMaster_580304, base: "/sql/v1beta4",
    url: url_SqlInstancesDemoteMaster_580305, schemes: {Scheme.Https})
type
  Call_SqlInstancesExport_580321 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesExport_580323(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesExport_580322(path: JsonNode; query: JsonNode;
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
  var valid_580324 = path.getOrDefault("instance")
  valid_580324 = validateParameter(valid_580324, JString, required = true,
                                 default = nil)
  if valid_580324 != nil:
    section.add "instance", valid_580324
  var valid_580325 = path.getOrDefault("project")
  valid_580325 = validateParameter(valid_580325, JString, required = true,
                                 default = nil)
  if valid_580325 != nil:
    section.add "project", valid_580325
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580326 = query.getOrDefault("fields")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "fields", valid_580326
  var valid_580327 = query.getOrDefault("quotaUser")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "quotaUser", valid_580327
  var valid_580328 = query.getOrDefault("alt")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = newJString("json"))
  if valid_580328 != nil:
    section.add "alt", valid_580328
  var valid_580329 = query.getOrDefault("oauth_token")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "oauth_token", valid_580329
  var valid_580330 = query.getOrDefault("userIp")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "userIp", valid_580330
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("prettyPrint")
  valid_580332 = validateParameter(valid_580332, JBool, required = false,
                                 default = newJBool(true))
  if valid_580332 != nil:
    section.add "prettyPrint", valid_580332
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

proc call*(call_580334: Call_SqlInstancesExport_580321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports data from a Cloud SQL instance to a Cloud Storage bucket as a SQL dump or CSV file.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_SqlInstancesExport_580321; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesExport
  ## Exports data from a Cloud SQL instance to a Cloud Storage bucket as a SQL dump or CSV file.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance to be exported.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580336 = newJObject()
  var query_580337 = newJObject()
  var body_580338 = newJObject()
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "quotaUser", newJString(quotaUser))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(query_580337, "userIp", newJString(userIp))
  add(query_580337, "key", newJString(key))
  add(path_580336, "instance", newJString(instance))
  add(path_580336, "project", newJString(project))
  if body != nil:
    body_580338 = body
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  result = call_580335.call(path_580336, query_580337, nil, nil, body_580338)

var sqlInstancesExport* = Call_SqlInstancesExport_580321(
    name: "sqlInstancesExport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/export",
    validator: validate_SqlInstancesExport_580322, base: "/sql/v1beta4",
    url: url_SqlInstancesExport_580323, schemes: {Scheme.Https})
type
  Call_SqlInstancesFailover_580339 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesFailover_580341(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesFailover_580340(path: JsonNode; query: JsonNode;
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
  var valid_580342 = path.getOrDefault("instance")
  valid_580342 = validateParameter(valid_580342, JString, required = true,
                                 default = nil)
  if valid_580342 != nil:
    section.add "instance", valid_580342
  var valid_580343 = path.getOrDefault("project")
  valid_580343 = validateParameter(valid_580343, JString, required = true,
                                 default = nil)
  if valid_580343 != nil:
    section.add "project", valid_580343
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580344 = query.getOrDefault("fields")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "fields", valid_580344
  var valid_580345 = query.getOrDefault("quotaUser")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "quotaUser", valid_580345
  var valid_580346 = query.getOrDefault("alt")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = newJString("json"))
  if valid_580346 != nil:
    section.add "alt", valid_580346
  var valid_580347 = query.getOrDefault("oauth_token")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "oauth_token", valid_580347
  var valid_580348 = query.getOrDefault("userIp")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "userIp", valid_580348
  var valid_580349 = query.getOrDefault("key")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "key", valid_580349
  var valid_580350 = query.getOrDefault("prettyPrint")
  valid_580350 = validateParameter(valid_580350, JBool, required = false,
                                 default = newJBool(true))
  if valid_580350 != nil:
    section.add "prettyPrint", valid_580350
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

proc call*(call_580352: Call_SqlInstancesFailover_580339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Failover the instance to its failover replica instance.
  ## 
  let valid = call_580352.validator(path, query, header, formData, body)
  let scheme = call_580352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580352.url(scheme.get, call_580352.host, call_580352.base,
                         call_580352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580352, url, valid)

proc call*(call_580353: Call_SqlInstancesFailover_580339; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesFailover
  ## Failover the instance to its failover replica instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580354 = newJObject()
  var query_580355 = newJObject()
  var body_580356 = newJObject()
  add(query_580355, "fields", newJString(fields))
  add(query_580355, "quotaUser", newJString(quotaUser))
  add(query_580355, "alt", newJString(alt))
  add(query_580355, "oauth_token", newJString(oauthToken))
  add(query_580355, "userIp", newJString(userIp))
  add(query_580355, "key", newJString(key))
  add(path_580354, "instance", newJString(instance))
  add(path_580354, "project", newJString(project))
  if body != nil:
    body_580356 = body
  add(query_580355, "prettyPrint", newJBool(prettyPrint))
  result = call_580353.call(path_580354, query_580355, nil, nil, body_580356)

var sqlInstancesFailover* = Call_SqlInstancesFailover_580339(
    name: "sqlInstancesFailover", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/failover",
    validator: validate_SqlInstancesFailover_580340, base: "/sql/v1beta4",
    url: url_SqlInstancesFailover_580341, schemes: {Scheme.Https})
type
  Call_SqlInstancesImport_580357 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesImport_580359(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesImport_580358(path: JsonNode; query: JsonNode;
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
  var valid_580360 = path.getOrDefault("instance")
  valid_580360 = validateParameter(valid_580360, JString, required = true,
                                 default = nil)
  if valid_580360 != nil:
    section.add "instance", valid_580360
  var valid_580361 = path.getOrDefault("project")
  valid_580361 = validateParameter(valid_580361, JString, required = true,
                                 default = nil)
  if valid_580361 != nil:
    section.add "project", valid_580361
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580362 = query.getOrDefault("fields")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "fields", valid_580362
  var valid_580363 = query.getOrDefault("quotaUser")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "quotaUser", valid_580363
  var valid_580364 = query.getOrDefault("alt")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = newJString("json"))
  if valid_580364 != nil:
    section.add "alt", valid_580364
  var valid_580365 = query.getOrDefault("oauth_token")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "oauth_token", valid_580365
  var valid_580366 = query.getOrDefault("userIp")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "userIp", valid_580366
  var valid_580367 = query.getOrDefault("key")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "key", valid_580367
  var valid_580368 = query.getOrDefault("prettyPrint")
  valid_580368 = validateParameter(valid_580368, JBool, required = false,
                                 default = newJBool(true))
  if valid_580368 != nil:
    section.add "prettyPrint", valid_580368
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

proc call*(call_580370: Call_SqlInstancesImport_580357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports data into a Cloud SQL instance from a SQL dump or CSV file in Cloud Storage.
  ## 
  let valid = call_580370.validator(path, query, header, formData, body)
  let scheme = call_580370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580370.url(scheme.get, call_580370.host, call_580370.base,
                         call_580370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580370, url, valid)

proc call*(call_580371: Call_SqlInstancesImport_580357; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesImport
  ## Imports data into a Cloud SQL instance from a SQL dump or CSV file in Cloud Storage.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580372 = newJObject()
  var query_580373 = newJObject()
  var body_580374 = newJObject()
  add(query_580373, "fields", newJString(fields))
  add(query_580373, "quotaUser", newJString(quotaUser))
  add(query_580373, "alt", newJString(alt))
  add(query_580373, "oauth_token", newJString(oauthToken))
  add(query_580373, "userIp", newJString(userIp))
  add(query_580373, "key", newJString(key))
  add(path_580372, "instance", newJString(instance))
  add(path_580372, "project", newJString(project))
  if body != nil:
    body_580374 = body
  add(query_580373, "prettyPrint", newJBool(prettyPrint))
  result = call_580371.call(path_580372, query_580373, nil, nil, body_580374)

var sqlInstancesImport* = Call_SqlInstancesImport_580357(
    name: "sqlInstancesImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/import",
    validator: validate_SqlInstancesImport_580358, base: "/sql/v1beta4",
    url: url_SqlInstancesImport_580359, schemes: {Scheme.Https})
type
  Call_SqlInstancesListServerCas_580375 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesListServerCas_580377(protocol: Scheme; host: string;
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

proc validate_SqlInstancesListServerCas_580376(path: JsonNode; query: JsonNode;
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
  var valid_580378 = path.getOrDefault("instance")
  valid_580378 = validateParameter(valid_580378, JString, required = true,
                                 default = nil)
  if valid_580378 != nil:
    section.add "instance", valid_580378
  var valid_580379 = path.getOrDefault("project")
  valid_580379 = validateParameter(valid_580379, JString, required = true,
                                 default = nil)
  if valid_580379 != nil:
    section.add "project", valid_580379
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580380 = query.getOrDefault("fields")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "fields", valid_580380
  var valid_580381 = query.getOrDefault("quotaUser")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "quotaUser", valid_580381
  var valid_580382 = query.getOrDefault("alt")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = newJString("json"))
  if valid_580382 != nil:
    section.add "alt", valid_580382
  var valid_580383 = query.getOrDefault("oauth_token")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "oauth_token", valid_580383
  var valid_580384 = query.getOrDefault("userIp")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "userIp", valid_580384
  var valid_580385 = query.getOrDefault("key")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "key", valid_580385
  var valid_580386 = query.getOrDefault("prettyPrint")
  valid_580386 = validateParameter(valid_580386, JBool, required = false,
                                 default = newJBool(true))
  if valid_580386 != nil:
    section.add "prettyPrint", valid_580386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580387: Call_SqlInstancesListServerCas_580375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the trusted Certificate Authorities (CAs) for the specified instance. There can be up to three CAs listed: the CA that was used to sign the certificate that is currently in use, a CA that has been added but not yet used to sign a certificate, and a CA used to sign a certificate that has previously rotated out.
  ## 
  let valid = call_580387.validator(path, query, header, formData, body)
  let scheme = call_580387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580387.url(scheme.get, call_580387.host, call_580387.base,
                         call_580387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580387, url, valid)

proc call*(call_580388: Call_SqlInstancesListServerCas_580375; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesListServerCas
  ## Lists all of the trusted Certificate Authorities (CAs) for the specified instance. There can be up to three CAs listed: the CA that was used to sign the certificate that is currently in use, a CA that has been added but not yet used to sign a certificate, and a CA used to sign a certificate that has previously rotated out.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580389 = newJObject()
  var query_580390 = newJObject()
  add(query_580390, "fields", newJString(fields))
  add(query_580390, "quotaUser", newJString(quotaUser))
  add(query_580390, "alt", newJString(alt))
  add(query_580390, "oauth_token", newJString(oauthToken))
  add(query_580390, "userIp", newJString(userIp))
  add(query_580390, "key", newJString(key))
  add(path_580389, "instance", newJString(instance))
  add(path_580389, "project", newJString(project))
  add(query_580390, "prettyPrint", newJBool(prettyPrint))
  result = call_580388.call(path_580389, query_580390, nil, nil, nil)

var sqlInstancesListServerCas* = Call_SqlInstancesListServerCas_580375(
    name: "sqlInstancesListServerCas", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/listServerCas",
    validator: validate_SqlInstancesListServerCas_580376, base: "/sql/v1beta4",
    url: url_SqlInstancesListServerCas_580377, schemes: {Scheme.Https})
type
  Call_SqlInstancesPromoteReplica_580391 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesPromoteReplica_580393(protocol: Scheme; host: string;
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

proc validate_SqlInstancesPromoteReplica_580392(path: JsonNode; query: JsonNode;
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
  var valid_580394 = path.getOrDefault("instance")
  valid_580394 = validateParameter(valid_580394, JString, required = true,
                                 default = nil)
  if valid_580394 != nil:
    section.add "instance", valid_580394
  var valid_580395 = path.getOrDefault("project")
  valid_580395 = validateParameter(valid_580395, JString, required = true,
                                 default = nil)
  if valid_580395 != nil:
    section.add "project", valid_580395
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580396 = query.getOrDefault("fields")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "fields", valid_580396
  var valid_580397 = query.getOrDefault("quotaUser")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "quotaUser", valid_580397
  var valid_580398 = query.getOrDefault("alt")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = newJString("json"))
  if valid_580398 != nil:
    section.add "alt", valid_580398
  var valid_580399 = query.getOrDefault("oauth_token")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "oauth_token", valid_580399
  var valid_580400 = query.getOrDefault("userIp")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "userIp", valid_580400
  var valid_580401 = query.getOrDefault("key")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "key", valid_580401
  var valid_580402 = query.getOrDefault("prettyPrint")
  valid_580402 = validateParameter(valid_580402, JBool, required = false,
                                 default = newJBool(true))
  if valid_580402 != nil:
    section.add "prettyPrint", valid_580402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580403: Call_SqlInstancesPromoteReplica_580391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ## 
  let valid = call_580403.validator(path, query, header, formData, body)
  let scheme = call_580403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580403.url(scheme.get, call_580403.host, call_580403.base,
                         call_580403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580403, url, valid)

proc call*(call_580404: Call_SqlInstancesPromoteReplica_580391; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesPromoteReplica
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580405 = newJObject()
  var query_580406 = newJObject()
  add(query_580406, "fields", newJString(fields))
  add(query_580406, "quotaUser", newJString(quotaUser))
  add(query_580406, "alt", newJString(alt))
  add(query_580406, "oauth_token", newJString(oauthToken))
  add(query_580406, "userIp", newJString(userIp))
  add(query_580406, "key", newJString(key))
  add(path_580405, "instance", newJString(instance))
  add(path_580405, "project", newJString(project))
  add(query_580406, "prettyPrint", newJBool(prettyPrint))
  result = call_580404.call(path_580405, query_580406, nil, nil, nil)

var sqlInstancesPromoteReplica* = Call_SqlInstancesPromoteReplica_580391(
    name: "sqlInstancesPromoteReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/promoteReplica",
    validator: validate_SqlInstancesPromoteReplica_580392, base: "/sql/v1beta4",
    url: url_SqlInstancesPromoteReplica_580393, schemes: {Scheme.Https})
type
  Call_SqlInstancesResetSslConfig_580407 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesResetSslConfig_580409(protocol: Scheme; host: string;
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

proc validate_SqlInstancesResetSslConfig_580408(path: JsonNode; query: JsonNode;
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
  var valid_580410 = path.getOrDefault("instance")
  valid_580410 = validateParameter(valid_580410, JString, required = true,
                                 default = nil)
  if valid_580410 != nil:
    section.add "instance", valid_580410
  var valid_580411 = path.getOrDefault("project")
  valid_580411 = validateParameter(valid_580411, JString, required = true,
                                 default = nil)
  if valid_580411 != nil:
    section.add "project", valid_580411
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580412 = query.getOrDefault("fields")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "fields", valid_580412
  var valid_580413 = query.getOrDefault("quotaUser")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "quotaUser", valid_580413
  var valid_580414 = query.getOrDefault("alt")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = newJString("json"))
  if valid_580414 != nil:
    section.add "alt", valid_580414
  var valid_580415 = query.getOrDefault("oauth_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "oauth_token", valid_580415
  var valid_580416 = query.getOrDefault("userIp")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "userIp", valid_580416
  var valid_580417 = query.getOrDefault("key")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "key", valid_580417
  var valid_580418 = query.getOrDefault("prettyPrint")
  valid_580418 = validateParameter(valid_580418, JBool, required = false,
                                 default = newJBool(true))
  if valid_580418 != nil:
    section.add "prettyPrint", valid_580418
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580419: Call_SqlInstancesResetSslConfig_580407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all client certificates and generates a new server SSL certificate for the instance.
  ## 
  let valid = call_580419.validator(path, query, header, formData, body)
  let scheme = call_580419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580419.url(scheme.get, call_580419.host, call_580419.base,
                         call_580419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580419, url, valid)

proc call*(call_580420: Call_SqlInstancesResetSslConfig_580407; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesResetSslConfig
  ## Deletes all client certificates and generates a new server SSL certificate for the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580421 = newJObject()
  var query_580422 = newJObject()
  add(query_580422, "fields", newJString(fields))
  add(query_580422, "quotaUser", newJString(quotaUser))
  add(query_580422, "alt", newJString(alt))
  add(query_580422, "oauth_token", newJString(oauthToken))
  add(query_580422, "userIp", newJString(userIp))
  add(query_580422, "key", newJString(key))
  add(path_580421, "instance", newJString(instance))
  add(path_580421, "project", newJString(project))
  add(query_580422, "prettyPrint", newJBool(prettyPrint))
  result = call_580420.call(path_580421, query_580422, nil, nil, nil)

var sqlInstancesResetSslConfig* = Call_SqlInstancesResetSslConfig_580407(
    name: "sqlInstancesResetSslConfig", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/resetSslConfig",
    validator: validate_SqlInstancesResetSslConfig_580408, base: "/sql/v1beta4",
    url: url_SqlInstancesResetSslConfig_580409, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestart_580423 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesRestart_580425(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesRestart_580424(path: JsonNode; query: JsonNode;
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
  var valid_580426 = path.getOrDefault("instance")
  valid_580426 = validateParameter(valid_580426, JString, required = true,
                                 default = nil)
  if valid_580426 != nil:
    section.add "instance", valid_580426
  var valid_580427 = path.getOrDefault("project")
  valid_580427 = validateParameter(valid_580427, JString, required = true,
                                 default = nil)
  if valid_580427 != nil:
    section.add "project", valid_580427
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580428 = query.getOrDefault("fields")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "fields", valid_580428
  var valid_580429 = query.getOrDefault("quotaUser")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "quotaUser", valid_580429
  var valid_580430 = query.getOrDefault("alt")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = newJString("json"))
  if valid_580430 != nil:
    section.add "alt", valid_580430
  var valid_580431 = query.getOrDefault("oauth_token")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "oauth_token", valid_580431
  var valid_580432 = query.getOrDefault("userIp")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "userIp", valid_580432
  var valid_580433 = query.getOrDefault("key")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "key", valid_580433
  var valid_580434 = query.getOrDefault("prettyPrint")
  valid_580434 = validateParameter(valid_580434, JBool, required = false,
                                 default = newJBool(true))
  if valid_580434 != nil:
    section.add "prettyPrint", valid_580434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580435: Call_SqlInstancesRestart_580423; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a Cloud SQL instance.
  ## 
  let valid = call_580435.validator(path, query, header, formData, body)
  let scheme = call_580435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580435.url(scheme.get, call_580435.host, call_580435.base,
                         call_580435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580435, url, valid)

proc call*(call_580436: Call_SqlInstancesRestart_580423; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesRestart
  ## Restarts a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance to be restarted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580437 = newJObject()
  var query_580438 = newJObject()
  add(query_580438, "fields", newJString(fields))
  add(query_580438, "quotaUser", newJString(quotaUser))
  add(query_580438, "alt", newJString(alt))
  add(query_580438, "oauth_token", newJString(oauthToken))
  add(query_580438, "userIp", newJString(userIp))
  add(query_580438, "key", newJString(key))
  add(path_580437, "instance", newJString(instance))
  add(path_580437, "project", newJString(project))
  add(query_580438, "prettyPrint", newJBool(prettyPrint))
  result = call_580436.call(path_580437, query_580438, nil, nil, nil)

var sqlInstancesRestart* = Call_SqlInstancesRestart_580423(
    name: "sqlInstancesRestart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restart",
    validator: validate_SqlInstancesRestart_580424, base: "/sql/v1beta4",
    url: url_SqlInstancesRestart_580425, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestoreBackup_580439 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesRestoreBackup_580441(protocol: Scheme; host: string;
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

proc validate_SqlInstancesRestoreBackup_580440(path: JsonNode; query: JsonNode;
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
  var valid_580442 = path.getOrDefault("instance")
  valid_580442 = validateParameter(valid_580442, JString, required = true,
                                 default = nil)
  if valid_580442 != nil:
    section.add "instance", valid_580442
  var valid_580443 = path.getOrDefault("project")
  valid_580443 = validateParameter(valid_580443, JString, required = true,
                                 default = nil)
  if valid_580443 != nil:
    section.add "project", valid_580443
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580444 = query.getOrDefault("fields")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "fields", valid_580444
  var valid_580445 = query.getOrDefault("quotaUser")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "quotaUser", valid_580445
  var valid_580446 = query.getOrDefault("alt")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = newJString("json"))
  if valid_580446 != nil:
    section.add "alt", valid_580446
  var valid_580447 = query.getOrDefault("oauth_token")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "oauth_token", valid_580447
  var valid_580448 = query.getOrDefault("userIp")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "userIp", valid_580448
  var valid_580449 = query.getOrDefault("key")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "key", valid_580449
  var valid_580450 = query.getOrDefault("prettyPrint")
  valid_580450 = validateParameter(valid_580450, JBool, required = false,
                                 default = newJBool(true))
  if valid_580450 != nil:
    section.add "prettyPrint", valid_580450
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

proc call*(call_580452: Call_SqlInstancesRestoreBackup_580439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backup of a Cloud SQL instance.
  ## 
  let valid = call_580452.validator(path, query, header, formData, body)
  let scheme = call_580452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580452.url(scheme.get, call_580452.host, call_580452.base,
                         call_580452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580452, url, valid)

proc call*(call_580453: Call_SqlInstancesRestoreBackup_580439; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesRestoreBackup
  ## Restores a backup of a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580454 = newJObject()
  var query_580455 = newJObject()
  var body_580456 = newJObject()
  add(query_580455, "fields", newJString(fields))
  add(query_580455, "quotaUser", newJString(quotaUser))
  add(query_580455, "alt", newJString(alt))
  add(query_580455, "oauth_token", newJString(oauthToken))
  add(query_580455, "userIp", newJString(userIp))
  add(query_580455, "key", newJString(key))
  add(path_580454, "instance", newJString(instance))
  add(path_580454, "project", newJString(project))
  if body != nil:
    body_580456 = body
  add(query_580455, "prettyPrint", newJBool(prettyPrint))
  result = call_580453.call(path_580454, query_580455, nil, nil, body_580456)

var sqlInstancesRestoreBackup* = Call_SqlInstancesRestoreBackup_580439(
    name: "sqlInstancesRestoreBackup", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restoreBackup",
    validator: validate_SqlInstancesRestoreBackup_580440, base: "/sql/v1beta4",
    url: url_SqlInstancesRestoreBackup_580441, schemes: {Scheme.Https})
type
  Call_SqlInstancesRotateServerCa_580457 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesRotateServerCa_580459(protocol: Scheme; host: string;
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

proc validate_SqlInstancesRotateServerCa_580458(path: JsonNode; query: JsonNode;
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
  var valid_580460 = path.getOrDefault("instance")
  valid_580460 = validateParameter(valid_580460, JString, required = true,
                                 default = nil)
  if valid_580460 != nil:
    section.add "instance", valid_580460
  var valid_580461 = path.getOrDefault("project")
  valid_580461 = validateParameter(valid_580461, JString, required = true,
                                 default = nil)
  if valid_580461 != nil:
    section.add "project", valid_580461
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580462 = query.getOrDefault("fields")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "fields", valid_580462
  var valid_580463 = query.getOrDefault("quotaUser")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "quotaUser", valid_580463
  var valid_580464 = query.getOrDefault("alt")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = newJString("json"))
  if valid_580464 != nil:
    section.add "alt", valid_580464
  var valid_580465 = query.getOrDefault("oauth_token")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "oauth_token", valid_580465
  var valid_580466 = query.getOrDefault("userIp")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "userIp", valid_580466
  var valid_580467 = query.getOrDefault("key")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "key", valid_580467
  var valid_580468 = query.getOrDefault("prettyPrint")
  valid_580468 = validateParameter(valid_580468, JBool, required = false,
                                 default = newJBool(true))
  if valid_580468 != nil:
    section.add "prettyPrint", valid_580468
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

proc call*(call_580470: Call_SqlInstancesRotateServerCa_580457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rotates the server certificate to one signed by the Certificate Authority (CA) version previously added with the addServerCA method.
  ## 
  let valid = call_580470.validator(path, query, header, formData, body)
  let scheme = call_580470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580470.url(scheme.get, call_580470.host, call_580470.base,
                         call_580470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580470, url, valid)

proc call*(call_580471: Call_SqlInstancesRotateServerCa_580457; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesRotateServerCa
  ## Rotates the server certificate to one signed by the Certificate Authority (CA) version previously added with the addServerCA method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580472 = newJObject()
  var query_580473 = newJObject()
  var body_580474 = newJObject()
  add(query_580473, "fields", newJString(fields))
  add(query_580473, "quotaUser", newJString(quotaUser))
  add(query_580473, "alt", newJString(alt))
  add(query_580473, "oauth_token", newJString(oauthToken))
  add(query_580473, "userIp", newJString(userIp))
  add(query_580473, "key", newJString(key))
  add(path_580472, "instance", newJString(instance))
  add(path_580472, "project", newJString(project))
  if body != nil:
    body_580474 = body
  add(query_580473, "prettyPrint", newJBool(prettyPrint))
  result = call_580471.call(path_580472, query_580473, nil, nil, body_580474)

var sqlInstancesRotateServerCa* = Call_SqlInstancesRotateServerCa_580457(
    name: "sqlInstancesRotateServerCa", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/rotateServerCa",
    validator: validate_SqlInstancesRotateServerCa_580458, base: "/sql/v1beta4",
    url: url_SqlInstancesRotateServerCa_580459, schemes: {Scheme.Https})
type
  Call_SqlSslCertsInsert_580491 = ref object of OpenApiRestCall_579421
proc url_SqlSslCertsInsert_580493(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsInsert_580492(path: JsonNode; query: JsonNode;
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
  var valid_580494 = path.getOrDefault("instance")
  valid_580494 = validateParameter(valid_580494, JString, required = true,
                                 default = nil)
  if valid_580494 != nil:
    section.add "instance", valid_580494
  var valid_580495 = path.getOrDefault("project")
  valid_580495 = validateParameter(valid_580495, JString, required = true,
                                 default = nil)
  if valid_580495 != nil:
    section.add "project", valid_580495
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580496 = query.getOrDefault("fields")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "fields", valid_580496
  var valid_580497 = query.getOrDefault("quotaUser")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "quotaUser", valid_580497
  var valid_580498 = query.getOrDefault("alt")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = newJString("json"))
  if valid_580498 != nil:
    section.add "alt", valid_580498
  var valid_580499 = query.getOrDefault("oauth_token")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "oauth_token", valid_580499
  var valid_580500 = query.getOrDefault("userIp")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "userIp", valid_580500
  var valid_580501 = query.getOrDefault("key")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "key", valid_580501
  var valid_580502 = query.getOrDefault("prettyPrint")
  valid_580502 = validateParameter(valid_580502, JBool, required = false,
                                 default = newJBool(true))
  if valid_580502 != nil:
    section.add "prettyPrint", valid_580502
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

proc call*(call_580504: Call_SqlSslCertsInsert_580491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an SSL certificate and returns it along with the private key and server certificate authority. The new certificate will not be usable until the instance is restarted.
  ## 
  let valid = call_580504.validator(path, query, header, formData, body)
  let scheme = call_580504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580504.url(scheme.get, call_580504.host, call_580504.base,
                         call_580504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580504, url, valid)

proc call*(call_580505: Call_SqlSslCertsInsert_580491; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlSslCertsInsert
  ## Creates an SSL certificate and returns it along with the private key and server certificate authority. The new certificate will not be usable until the instance is restarted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580506 = newJObject()
  var query_580507 = newJObject()
  var body_580508 = newJObject()
  add(query_580507, "fields", newJString(fields))
  add(query_580507, "quotaUser", newJString(quotaUser))
  add(query_580507, "alt", newJString(alt))
  add(query_580507, "oauth_token", newJString(oauthToken))
  add(query_580507, "userIp", newJString(userIp))
  add(query_580507, "key", newJString(key))
  add(path_580506, "instance", newJString(instance))
  add(path_580506, "project", newJString(project))
  if body != nil:
    body_580508 = body
  add(query_580507, "prettyPrint", newJBool(prettyPrint))
  result = call_580505.call(path_580506, query_580507, nil, nil, body_580508)

var sqlSslCertsInsert* = Call_SqlSslCertsInsert_580491(name: "sqlSslCertsInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsInsert_580492, base: "/sql/v1beta4",
    url: url_SqlSslCertsInsert_580493, schemes: {Scheme.Https})
type
  Call_SqlSslCertsList_580475 = ref object of OpenApiRestCall_579421
proc url_SqlSslCertsList_580477(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsList_580476(path: JsonNode; query: JsonNode;
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
  var valid_580478 = path.getOrDefault("instance")
  valid_580478 = validateParameter(valid_580478, JString, required = true,
                                 default = nil)
  if valid_580478 != nil:
    section.add "instance", valid_580478
  var valid_580479 = path.getOrDefault("project")
  valid_580479 = validateParameter(valid_580479, JString, required = true,
                                 default = nil)
  if valid_580479 != nil:
    section.add "project", valid_580479
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580480 = query.getOrDefault("fields")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "fields", valid_580480
  var valid_580481 = query.getOrDefault("quotaUser")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "quotaUser", valid_580481
  var valid_580482 = query.getOrDefault("alt")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = newJString("json"))
  if valid_580482 != nil:
    section.add "alt", valid_580482
  var valid_580483 = query.getOrDefault("oauth_token")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "oauth_token", valid_580483
  var valid_580484 = query.getOrDefault("userIp")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "userIp", valid_580484
  var valid_580485 = query.getOrDefault("key")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "key", valid_580485
  var valid_580486 = query.getOrDefault("prettyPrint")
  valid_580486 = validateParameter(valid_580486, JBool, required = false,
                                 default = newJBool(true))
  if valid_580486 != nil:
    section.add "prettyPrint", valid_580486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580487: Call_SqlSslCertsList_580475; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the current SSL certificates for the instance.
  ## 
  let valid = call_580487.validator(path, query, header, formData, body)
  let scheme = call_580487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580487.url(scheme.get, call_580487.host, call_580487.base,
                         call_580487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580487, url, valid)

proc call*(call_580488: Call_SqlSslCertsList_580475; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlSslCertsList
  ## Lists all of the current SSL certificates for the instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580489 = newJObject()
  var query_580490 = newJObject()
  add(query_580490, "fields", newJString(fields))
  add(query_580490, "quotaUser", newJString(quotaUser))
  add(query_580490, "alt", newJString(alt))
  add(query_580490, "oauth_token", newJString(oauthToken))
  add(query_580490, "userIp", newJString(userIp))
  add(query_580490, "key", newJString(key))
  add(path_580489, "instance", newJString(instance))
  add(path_580489, "project", newJString(project))
  add(query_580490, "prettyPrint", newJBool(prettyPrint))
  result = call_580488.call(path_580489, query_580490, nil, nil, nil)

var sqlSslCertsList* = Call_SqlSslCertsList_580475(name: "sqlSslCertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsList_580476, base: "/sql/v1beta4",
    url: url_SqlSslCertsList_580477, schemes: {Scheme.Https})
type
  Call_SqlSslCertsGet_580509 = ref object of OpenApiRestCall_579421
proc url_SqlSslCertsGet_580511(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsGet_580510(path: JsonNode; query: JsonNode;
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
  var valid_580512 = path.getOrDefault("sha1Fingerprint")
  valid_580512 = validateParameter(valid_580512, JString, required = true,
                                 default = nil)
  if valid_580512 != nil:
    section.add "sha1Fingerprint", valid_580512
  var valid_580513 = path.getOrDefault("instance")
  valid_580513 = validateParameter(valid_580513, JString, required = true,
                                 default = nil)
  if valid_580513 != nil:
    section.add "instance", valid_580513
  var valid_580514 = path.getOrDefault("project")
  valid_580514 = validateParameter(valid_580514, JString, required = true,
                                 default = nil)
  if valid_580514 != nil:
    section.add "project", valid_580514
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580515 = query.getOrDefault("fields")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "fields", valid_580515
  var valid_580516 = query.getOrDefault("quotaUser")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "quotaUser", valid_580516
  var valid_580517 = query.getOrDefault("alt")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = newJString("json"))
  if valid_580517 != nil:
    section.add "alt", valid_580517
  var valid_580518 = query.getOrDefault("oauth_token")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "oauth_token", valid_580518
  var valid_580519 = query.getOrDefault("userIp")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "userIp", valid_580519
  var valid_580520 = query.getOrDefault("key")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "key", valid_580520
  var valid_580521 = query.getOrDefault("prettyPrint")
  valid_580521 = validateParameter(valid_580521, JBool, required = false,
                                 default = newJBool(true))
  if valid_580521 != nil:
    section.add "prettyPrint", valid_580521
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580522: Call_SqlSslCertsGet_580509; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a particular SSL certificate. Does not include the private key (required for usage). The private key must be saved from the response to initial creation.
  ## 
  let valid = call_580522.validator(path, query, header, formData, body)
  let scheme = call_580522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580522.url(scheme.get, call_580522.host, call_580522.base,
                         call_580522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580522, url, valid)

proc call*(call_580523: Call_SqlSslCertsGet_580509; sha1Fingerprint: string;
          instance: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlSslCertsGet
  ## Retrieves a particular SSL certificate. Does not include the private key (required for usage). The private key must be saved from the response to initial creation.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sha1Fingerprint: string (required)
  ##                  : Sha1 FingerPrint.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580524 = newJObject()
  var query_580525 = newJObject()
  add(query_580525, "fields", newJString(fields))
  add(query_580525, "quotaUser", newJString(quotaUser))
  add(query_580525, "alt", newJString(alt))
  add(query_580525, "oauth_token", newJString(oauthToken))
  add(query_580525, "userIp", newJString(userIp))
  add(path_580524, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(query_580525, "key", newJString(key))
  add(path_580524, "instance", newJString(instance))
  add(path_580524, "project", newJString(project))
  add(query_580525, "prettyPrint", newJBool(prettyPrint))
  result = call_580523.call(path_580524, query_580525, nil, nil, nil)

var sqlSslCertsGet* = Call_SqlSslCertsGet_580509(name: "sqlSslCertsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsGet_580510, base: "/sql/v1beta4",
    url: url_SqlSslCertsGet_580511, schemes: {Scheme.Https})
type
  Call_SqlSslCertsDelete_580526 = ref object of OpenApiRestCall_579421
proc url_SqlSslCertsDelete_580528(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsDelete_580527(path: JsonNode; query: JsonNode;
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
  var valid_580529 = path.getOrDefault("sha1Fingerprint")
  valid_580529 = validateParameter(valid_580529, JString, required = true,
                                 default = nil)
  if valid_580529 != nil:
    section.add "sha1Fingerprint", valid_580529
  var valid_580530 = path.getOrDefault("instance")
  valid_580530 = validateParameter(valid_580530, JString, required = true,
                                 default = nil)
  if valid_580530 != nil:
    section.add "instance", valid_580530
  var valid_580531 = path.getOrDefault("project")
  valid_580531 = validateParameter(valid_580531, JString, required = true,
                                 default = nil)
  if valid_580531 != nil:
    section.add "project", valid_580531
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580532 = query.getOrDefault("fields")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "fields", valid_580532
  var valid_580533 = query.getOrDefault("quotaUser")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "quotaUser", valid_580533
  var valid_580534 = query.getOrDefault("alt")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = newJString("json"))
  if valid_580534 != nil:
    section.add "alt", valid_580534
  var valid_580535 = query.getOrDefault("oauth_token")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "oauth_token", valid_580535
  var valid_580536 = query.getOrDefault("userIp")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "userIp", valid_580536
  var valid_580537 = query.getOrDefault("key")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "key", valid_580537
  var valid_580538 = query.getOrDefault("prettyPrint")
  valid_580538 = validateParameter(valid_580538, JBool, required = false,
                                 default = newJBool(true))
  if valid_580538 != nil:
    section.add "prettyPrint", valid_580538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580539: Call_SqlSslCertsDelete_580526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the SSL certificate. For First Generation instances, the certificate remains valid until the instance is restarted.
  ## 
  let valid = call_580539.validator(path, query, header, formData, body)
  let scheme = call_580539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580539.url(scheme.get, call_580539.host, call_580539.base,
                         call_580539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580539, url, valid)

proc call*(call_580540: Call_SqlSslCertsDelete_580526; sha1Fingerprint: string;
          instance: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlSslCertsDelete
  ## Deletes the SSL certificate. For First Generation instances, the certificate remains valid until the instance is restarted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   sha1Fingerprint: string (required)
  ##                  : Sha1 FingerPrint.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580541 = newJObject()
  var query_580542 = newJObject()
  add(query_580542, "fields", newJString(fields))
  add(query_580542, "quotaUser", newJString(quotaUser))
  add(query_580542, "alt", newJString(alt))
  add(query_580542, "oauth_token", newJString(oauthToken))
  add(query_580542, "userIp", newJString(userIp))
  add(path_580541, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(query_580542, "key", newJString(key))
  add(path_580541, "instance", newJString(instance))
  add(path_580541, "project", newJString(project))
  add(query_580542, "prettyPrint", newJBool(prettyPrint))
  result = call_580540.call(path_580541, query_580542, nil, nil, nil)

var sqlSslCertsDelete* = Call_SqlSslCertsDelete_580526(name: "sqlSslCertsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsDelete_580527, base: "/sql/v1beta4",
    url: url_SqlSslCertsDelete_580528, schemes: {Scheme.Https})
type
  Call_SqlInstancesStartReplica_580543 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesStartReplica_580545(protocol: Scheme; host: string;
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

proc validate_SqlInstancesStartReplica_580544(path: JsonNode; query: JsonNode;
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
  var valid_580546 = path.getOrDefault("instance")
  valid_580546 = validateParameter(valid_580546, JString, required = true,
                                 default = nil)
  if valid_580546 != nil:
    section.add "instance", valid_580546
  var valid_580547 = path.getOrDefault("project")
  valid_580547 = validateParameter(valid_580547, JString, required = true,
                                 default = nil)
  if valid_580547 != nil:
    section.add "project", valid_580547
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580548 = query.getOrDefault("fields")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "fields", valid_580548
  var valid_580549 = query.getOrDefault("quotaUser")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "quotaUser", valid_580549
  var valid_580550 = query.getOrDefault("alt")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = newJString("json"))
  if valid_580550 != nil:
    section.add "alt", valid_580550
  var valid_580551 = query.getOrDefault("oauth_token")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "oauth_token", valid_580551
  var valid_580552 = query.getOrDefault("userIp")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "userIp", valid_580552
  var valid_580553 = query.getOrDefault("key")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "key", valid_580553
  var valid_580554 = query.getOrDefault("prettyPrint")
  valid_580554 = validateParameter(valid_580554, JBool, required = false,
                                 default = newJBool(true))
  if valid_580554 != nil:
    section.add "prettyPrint", valid_580554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580555: Call_SqlInstancesStartReplica_580543; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts the replication in the read replica instance.
  ## 
  let valid = call_580555.validator(path, query, header, formData, body)
  let scheme = call_580555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580555.url(scheme.get, call_580555.host, call_580555.base,
                         call_580555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580555, url, valid)

proc call*(call_580556: Call_SqlInstancesStartReplica_580543; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesStartReplica
  ## Starts the replication in the read replica instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580557 = newJObject()
  var query_580558 = newJObject()
  add(query_580558, "fields", newJString(fields))
  add(query_580558, "quotaUser", newJString(quotaUser))
  add(query_580558, "alt", newJString(alt))
  add(query_580558, "oauth_token", newJString(oauthToken))
  add(query_580558, "userIp", newJString(userIp))
  add(query_580558, "key", newJString(key))
  add(path_580557, "instance", newJString(instance))
  add(path_580557, "project", newJString(project))
  add(query_580558, "prettyPrint", newJBool(prettyPrint))
  result = call_580556.call(path_580557, query_580558, nil, nil, nil)

var sqlInstancesStartReplica* = Call_SqlInstancesStartReplica_580543(
    name: "sqlInstancesStartReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/startReplica",
    validator: validate_SqlInstancesStartReplica_580544, base: "/sql/v1beta4",
    url: url_SqlInstancesStartReplica_580545, schemes: {Scheme.Https})
type
  Call_SqlInstancesStopReplica_580559 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesStopReplica_580561(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesStopReplica_580560(path: JsonNode; query: JsonNode;
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
  var valid_580562 = path.getOrDefault("instance")
  valid_580562 = validateParameter(valid_580562, JString, required = true,
                                 default = nil)
  if valid_580562 != nil:
    section.add "instance", valid_580562
  var valid_580563 = path.getOrDefault("project")
  valid_580563 = validateParameter(valid_580563, JString, required = true,
                                 default = nil)
  if valid_580563 != nil:
    section.add "project", valid_580563
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580564 = query.getOrDefault("fields")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "fields", valid_580564
  var valid_580565 = query.getOrDefault("quotaUser")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "quotaUser", valid_580565
  var valid_580566 = query.getOrDefault("alt")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = newJString("json"))
  if valid_580566 != nil:
    section.add "alt", valid_580566
  var valid_580567 = query.getOrDefault("oauth_token")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "oauth_token", valid_580567
  var valid_580568 = query.getOrDefault("userIp")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "userIp", valid_580568
  var valid_580569 = query.getOrDefault("key")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "key", valid_580569
  var valid_580570 = query.getOrDefault("prettyPrint")
  valid_580570 = validateParameter(valid_580570, JBool, required = false,
                                 default = newJBool(true))
  if valid_580570 != nil:
    section.add "prettyPrint", valid_580570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580571: Call_SqlInstancesStopReplica_580559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops the replication in the read replica instance.
  ## 
  let valid = call_580571.validator(path, query, header, formData, body)
  let scheme = call_580571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580571.url(scheme.get, call_580571.host, call_580571.base,
                         call_580571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580571, url, valid)

proc call*(call_580572: Call_SqlInstancesStopReplica_580559; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesStopReplica
  ## Stops the replication in the read replica instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580573 = newJObject()
  var query_580574 = newJObject()
  add(query_580574, "fields", newJString(fields))
  add(query_580574, "quotaUser", newJString(quotaUser))
  add(query_580574, "alt", newJString(alt))
  add(query_580574, "oauth_token", newJString(oauthToken))
  add(query_580574, "userIp", newJString(userIp))
  add(query_580574, "key", newJString(key))
  add(path_580573, "instance", newJString(instance))
  add(path_580573, "project", newJString(project))
  add(query_580574, "prettyPrint", newJBool(prettyPrint))
  result = call_580572.call(path_580573, query_580574, nil, nil, nil)

var sqlInstancesStopReplica* = Call_SqlInstancesStopReplica_580559(
    name: "sqlInstancesStopReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/stopReplica",
    validator: validate_SqlInstancesStopReplica_580560, base: "/sql/v1beta4",
    url: url_SqlInstancesStopReplica_580561, schemes: {Scheme.Https})
type
  Call_SqlInstancesTruncateLog_580575 = ref object of OpenApiRestCall_579421
proc url_SqlInstancesTruncateLog_580577(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesTruncateLog_580576(path: JsonNode; query: JsonNode;
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
  var valid_580578 = path.getOrDefault("instance")
  valid_580578 = validateParameter(valid_580578, JString, required = true,
                                 default = nil)
  if valid_580578 != nil:
    section.add "instance", valid_580578
  var valid_580579 = path.getOrDefault("project")
  valid_580579 = validateParameter(valid_580579, JString, required = true,
                                 default = nil)
  if valid_580579 != nil:
    section.add "project", valid_580579
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580580 = query.getOrDefault("fields")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "fields", valid_580580
  var valid_580581 = query.getOrDefault("quotaUser")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "quotaUser", valid_580581
  var valid_580582 = query.getOrDefault("alt")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = newJString("json"))
  if valid_580582 != nil:
    section.add "alt", valid_580582
  var valid_580583 = query.getOrDefault("oauth_token")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "oauth_token", valid_580583
  var valid_580584 = query.getOrDefault("userIp")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "userIp", valid_580584
  var valid_580585 = query.getOrDefault("key")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "key", valid_580585
  var valid_580586 = query.getOrDefault("prettyPrint")
  valid_580586 = validateParameter(valid_580586, JBool, required = false,
                                 default = newJBool(true))
  if valid_580586 != nil:
    section.add "prettyPrint", valid_580586
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

proc call*(call_580588: Call_SqlInstancesTruncateLog_580575; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Truncate MySQL general and slow query log tables
  ## 
  let valid = call_580588.validator(path, query, header, formData, body)
  let scheme = call_580588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580588.url(scheme.get, call_580588.host, call_580588.base,
                         call_580588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580588, url, valid)

proc call*(call_580589: Call_SqlInstancesTruncateLog_580575; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesTruncateLog
  ## Truncate MySQL general and slow query log tables
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the Cloud SQL project.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580590 = newJObject()
  var query_580591 = newJObject()
  var body_580592 = newJObject()
  add(query_580591, "fields", newJString(fields))
  add(query_580591, "quotaUser", newJString(quotaUser))
  add(query_580591, "alt", newJString(alt))
  add(query_580591, "oauth_token", newJString(oauthToken))
  add(query_580591, "userIp", newJString(userIp))
  add(query_580591, "key", newJString(key))
  add(path_580590, "instance", newJString(instance))
  add(path_580590, "project", newJString(project))
  if body != nil:
    body_580592 = body
  add(query_580591, "prettyPrint", newJBool(prettyPrint))
  result = call_580589.call(path_580590, query_580591, nil, nil, body_580592)

var sqlInstancesTruncateLog* = Call_SqlInstancesTruncateLog_580575(
    name: "sqlInstancesTruncateLog", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/truncateLog",
    validator: validate_SqlInstancesTruncateLog_580576, base: "/sql/v1beta4",
    url: url_SqlInstancesTruncateLog_580577, schemes: {Scheme.Https})
type
  Call_SqlUsersUpdate_580609 = ref object of OpenApiRestCall_579421
proc url_SqlUsersUpdate_580611(protocol: Scheme; host: string; base: string;
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

proc validate_SqlUsersUpdate_580610(path: JsonNode; query: JsonNode;
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
  var valid_580612 = path.getOrDefault("instance")
  valid_580612 = validateParameter(valid_580612, JString, required = true,
                                 default = nil)
  if valid_580612 != nil:
    section.add "instance", valid_580612
  var valid_580613 = path.getOrDefault("project")
  valid_580613 = validateParameter(valid_580613, JString, required = true,
                                 default = nil)
  if valid_580613 != nil:
    section.add "project", valid_580613
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString (required)
  ##       : Name of the user in the instance.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   host: JString
  ##       : Host of the user in the instance. For a MySQL instance, it's required; For a PostgreSQL instance, it's optional.
  section = newJObject()
  var valid_580614 = query.getOrDefault("fields")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "fields", valid_580614
  var valid_580615 = query.getOrDefault("quotaUser")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "quotaUser", valid_580615
  var valid_580616 = query.getOrDefault("alt")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = newJString("json"))
  if valid_580616 != nil:
    section.add "alt", valid_580616
  var valid_580617 = query.getOrDefault("oauth_token")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "oauth_token", valid_580617
  var valid_580618 = query.getOrDefault("userIp")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "userIp", valid_580618
  var valid_580619 = query.getOrDefault("key")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "key", valid_580619
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_580620 = query.getOrDefault("name")
  valid_580620 = validateParameter(valid_580620, JString, required = true,
                                 default = nil)
  if valid_580620 != nil:
    section.add "name", valid_580620
  var valid_580621 = query.getOrDefault("prettyPrint")
  valid_580621 = validateParameter(valid_580621, JBool, required = false,
                                 default = newJBool(true))
  if valid_580621 != nil:
    section.add "prettyPrint", valid_580621
  var valid_580622 = query.getOrDefault("host")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "host", valid_580622
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

proc call*(call_580624: Call_SqlUsersUpdate_580609; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing user in a Cloud SQL instance.
  ## 
  let valid = call_580624.validator(path, query, header, formData, body)
  let scheme = call_580624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580624.url(scheme.get, call_580624.host, call_580624.base,
                         call_580624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580624, url, valid)

proc call*(call_580625: Call_SqlUsersUpdate_580609; name: string; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          host: string = ""): Recallable =
  ## sqlUsersUpdate
  ## Updates an existing user in a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string (required)
  ##       : Name of the user in the instance.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   host: string
  ##       : Host of the user in the instance. For a MySQL instance, it's required; For a PostgreSQL instance, it's optional.
  var path_580626 = newJObject()
  var query_580627 = newJObject()
  var body_580628 = newJObject()
  add(query_580627, "fields", newJString(fields))
  add(query_580627, "quotaUser", newJString(quotaUser))
  add(query_580627, "alt", newJString(alt))
  add(query_580627, "oauth_token", newJString(oauthToken))
  add(query_580627, "userIp", newJString(userIp))
  add(query_580627, "key", newJString(key))
  add(query_580627, "name", newJString(name))
  add(path_580626, "instance", newJString(instance))
  add(path_580626, "project", newJString(project))
  if body != nil:
    body_580628 = body
  add(query_580627, "prettyPrint", newJBool(prettyPrint))
  add(query_580627, "host", newJString(host))
  result = call_580625.call(path_580626, query_580627, nil, nil, body_580628)

var sqlUsersUpdate* = Call_SqlUsersUpdate_580609(name: "sqlUsersUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersUpdate_580610, base: "/sql/v1beta4",
    url: url_SqlUsersUpdate_580611, schemes: {Scheme.Https})
type
  Call_SqlUsersInsert_580629 = ref object of OpenApiRestCall_579421
proc url_SqlUsersInsert_580631(protocol: Scheme; host: string; base: string;
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

proc validate_SqlUsersInsert_580630(path: JsonNode; query: JsonNode;
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
  var valid_580632 = path.getOrDefault("instance")
  valid_580632 = validateParameter(valid_580632, JString, required = true,
                                 default = nil)
  if valid_580632 != nil:
    section.add "instance", valid_580632
  var valid_580633 = path.getOrDefault("project")
  valid_580633 = validateParameter(valid_580633, JString, required = true,
                                 default = nil)
  if valid_580633 != nil:
    section.add "project", valid_580633
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580634 = query.getOrDefault("fields")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "fields", valid_580634
  var valid_580635 = query.getOrDefault("quotaUser")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "quotaUser", valid_580635
  var valid_580636 = query.getOrDefault("alt")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = newJString("json"))
  if valid_580636 != nil:
    section.add "alt", valid_580636
  var valid_580637 = query.getOrDefault("oauth_token")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "oauth_token", valid_580637
  var valid_580638 = query.getOrDefault("userIp")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = nil)
  if valid_580638 != nil:
    section.add "userIp", valid_580638
  var valid_580639 = query.getOrDefault("key")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "key", valid_580639
  var valid_580640 = query.getOrDefault("prettyPrint")
  valid_580640 = validateParameter(valid_580640, JBool, required = false,
                                 default = newJBool(true))
  if valid_580640 != nil:
    section.add "prettyPrint", valid_580640
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

proc call*(call_580642: Call_SqlUsersInsert_580629; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new user in a Cloud SQL instance.
  ## 
  let valid = call_580642.validator(path, query, header, formData, body)
  let scheme = call_580642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580642.url(scheme.get, call_580642.host, call_580642.base,
                         call_580642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580642, url, valid)

proc call*(call_580643: Call_SqlUsersInsert_580629; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlUsersInsert
  ## Creates a new user in a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580644 = newJObject()
  var query_580645 = newJObject()
  var body_580646 = newJObject()
  add(query_580645, "fields", newJString(fields))
  add(query_580645, "quotaUser", newJString(quotaUser))
  add(query_580645, "alt", newJString(alt))
  add(query_580645, "oauth_token", newJString(oauthToken))
  add(query_580645, "userIp", newJString(userIp))
  add(query_580645, "key", newJString(key))
  add(path_580644, "instance", newJString(instance))
  add(path_580644, "project", newJString(project))
  if body != nil:
    body_580646 = body
  add(query_580645, "prettyPrint", newJBool(prettyPrint))
  result = call_580643.call(path_580644, query_580645, nil, nil, body_580646)

var sqlUsersInsert* = Call_SqlUsersInsert_580629(name: "sqlUsersInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersInsert_580630, base: "/sql/v1beta4",
    url: url_SqlUsersInsert_580631, schemes: {Scheme.Https})
type
  Call_SqlUsersList_580593 = ref object of OpenApiRestCall_579421
proc url_SqlUsersList_580595(protocol: Scheme; host: string; base: string;
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

proc validate_SqlUsersList_580594(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580596 = path.getOrDefault("instance")
  valid_580596 = validateParameter(valid_580596, JString, required = true,
                                 default = nil)
  if valid_580596 != nil:
    section.add "instance", valid_580596
  var valid_580597 = path.getOrDefault("project")
  valid_580597 = validateParameter(valid_580597, JString, required = true,
                                 default = nil)
  if valid_580597 != nil:
    section.add "project", valid_580597
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580598 = query.getOrDefault("fields")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "fields", valid_580598
  var valid_580599 = query.getOrDefault("quotaUser")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "quotaUser", valid_580599
  var valid_580600 = query.getOrDefault("alt")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = newJString("json"))
  if valid_580600 != nil:
    section.add "alt", valid_580600
  var valid_580601 = query.getOrDefault("oauth_token")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "oauth_token", valid_580601
  var valid_580602 = query.getOrDefault("userIp")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = nil)
  if valid_580602 != nil:
    section.add "userIp", valid_580602
  var valid_580603 = query.getOrDefault("key")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "key", valid_580603
  var valid_580604 = query.getOrDefault("prettyPrint")
  valid_580604 = validateParameter(valid_580604, JBool, required = false,
                                 default = newJBool(true))
  if valid_580604 != nil:
    section.add "prettyPrint", valid_580604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580605: Call_SqlUsersList_580593; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists users in the specified Cloud SQL instance.
  ## 
  let valid = call_580605.validator(path, query, header, formData, body)
  let scheme = call_580605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580605.url(scheme.get, call_580605.host, call_580605.base,
                         call_580605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580605, url, valid)

proc call*(call_580606: Call_SqlUsersList_580593; instance: string; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## sqlUsersList
  ## Lists users in the specified Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580607 = newJObject()
  var query_580608 = newJObject()
  add(query_580608, "fields", newJString(fields))
  add(query_580608, "quotaUser", newJString(quotaUser))
  add(query_580608, "alt", newJString(alt))
  add(query_580608, "oauth_token", newJString(oauthToken))
  add(query_580608, "userIp", newJString(userIp))
  add(query_580608, "key", newJString(key))
  add(path_580607, "instance", newJString(instance))
  add(path_580607, "project", newJString(project))
  add(query_580608, "prettyPrint", newJBool(prettyPrint))
  result = call_580606.call(path_580607, query_580608, nil, nil, nil)

var sqlUsersList* = Call_SqlUsersList_580593(name: "sqlUsersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersList_580594, base: "/sql/v1beta4",
    url: url_SqlUsersList_580595, schemes: {Scheme.Https})
type
  Call_SqlUsersDelete_580647 = ref object of OpenApiRestCall_579421
proc url_SqlUsersDelete_580649(protocol: Scheme; host: string; base: string;
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

proc validate_SqlUsersDelete_580648(path: JsonNode; query: JsonNode;
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
  var valid_580650 = path.getOrDefault("instance")
  valid_580650 = validateParameter(valid_580650, JString, required = true,
                                 default = nil)
  if valid_580650 != nil:
    section.add "instance", valid_580650
  var valid_580651 = path.getOrDefault("project")
  valid_580651 = validateParameter(valid_580651, JString, required = true,
                                 default = nil)
  if valid_580651 != nil:
    section.add "project", valid_580651
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString (required)
  ##       : Name of the user in the instance.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   host: JString (required)
  ##       : Host of the user in the instance.
  section = newJObject()
  var valid_580652 = query.getOrDefault("fields")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "fields", valid_580652
  var valid_580653 = query.getOrDefault("quotaUser")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "quotaUser", valid_580653
  var valid_580654 = query.getOrDefault("alt")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = newJString("json"))
  if valid_580654 != nil:
    section.add "alt", valid_580654
  var valid_580655 = query.getOrDefault("oauth_token")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "oauth_token", valid_580655
  var valid_580656 = query.getOrDefault("userIp")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "userIp", valid_580656
  var valid_580657 = query.getOrDefault("key")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "key", valid_580657
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_580658 = query.getOrDefault("name")
  valid_580658 = validateParameter(valid_580658, JString, required = true,
                                 default = nil)
  if valid_580658 != nil:
    section.add "name", valid_580658
  var valid_580659 = query.getOrDefault("prettyPrint")
  valid_580659 = validateParameter(valid_580659, JBool, required = false,
                                 default = newJBool(true))
  if valid_580659 != nil:
    section.add "prettyPrint", valid_580659
  var valid_580660 = query.getOrDefault("host")
  valid_580660 = validateParameter(valid_580660, JString, required = true,
                                 default = nil)
  if valid_580660 != nil:
    section.add "host", valid_580660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580661: Call_SqlUsersDelete_580647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a user from a Cloud SQL instance.
  ## 
  let valid = call_580661.validator(path, query, header, formData, body)
  let scheme = call_580661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580661.url(scheme.get, call_580661.host, call_580661.base,
                         call_580661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580661, url, valid)

proc call*(call_580662: Call_SqlUsersDelete_580647; name: string; instance: string;
          project: string; host: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlUsersDelete
  ## Deletes a user from a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string (required)
  ##       : Name of the user in the instance.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   host: string (required)
  ##       : Host of the user in the instance.
  var path_580663 = newJObject()
  var query_580664 = newJObject()
  add(query_580664, "fields", newJString(fields))
  add(query_580664, "quotaUser", newJString(quotaUser))
  add(query_580664, "alt", newJString(alt))
  add(query_580664, "oauth_token", newJString(oauthToken))
  add(query_580664, "userIp", newJString(userIp))
  add(query_580664, "key", newJString(key))
  add(query_580664, "name", newJString(name))
  add(path_580663, "instance", newJString(instance))
  add(path_580663, "project", newJString(project))
  add(query_580664, "prettyPrint", newJBool(prettyPrint))
  add(query_580664, "host", newJString(host))
  result = call_580662.call(path_580663, query_580664, nil, nil, nil)

var sqlUsersDelete* = Call_SqlUsersDelete_580647(name: "sqlUsersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersDelete_580648, base: "/sql/v1beta4",
    url: url_SqlUsersDelete_580649, schemes: {Scheme.Https})
type
  Call_SqlOperationsList_580665 = ref object of OpenApiRestCall_579421
proc url_SqlOperationsList_580667(protocol: Scheme; host: string; base: string;
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

proc validate_SqlOperationsList_580666(path: JsonNode; query: JsonNode;
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
  var valid_580668 = path.getOrDefault("project")
  valid_580668 = validateParameter(valid_580668, JString, required = true,
                                 default = nil)
  if valid_580668 != nil:
    section.add "project", valid_580668
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of operations per response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580669 = query.getOrDefault("fields")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "fields", valid_580669
  var valid_580670 = query.getOrDefault("pageToken")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "pageToken", valid_580670
  var valid_580671 = query.getOrDefault("quotaUser")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "quotaUser", valid_580671
  var valid_580672 = query.getOrDefault("alt")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = newJString("json"))
  if valid_580672 != nil:
    section.add "alt", valid_580672
  var valid_580673 = query.getOrDefault("oauth_token")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "oauth_token", valid_580673
  var valid_580674 = query.getOrDefault("userIp")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "userIp", valid_580674
  var valid_580675 = query.getOrDefault("maxResults")
  valid_580675 = validateParameter(valid_580675, JInt, required = false, default = nil)
  if valid_580675 != nil:
    section.add "maxResults", valid_580675
  var valid_580676 = query.getOrDefault("key")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "key", valid_580676
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_580677 = query.getOrDefault("instance")
  valid_580677 = validateParameter(valid_580677, JString, required = true,
                                 default = nil)
  if valid_580677 != nil:
    section.add "instance", valid_580677
  var valid_580678 = query.getOrDefault("prettyPrint")
  valid_580678 = validateParameter(valid_580678, JBool, required = false,
                                 default = newJBool(true))
  if valid_580678 != nil:
    section.add "prettyPrint", valid_580678
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580679: Call_SqlOperationsList_580665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all instance operations that have been performed on the given Cloud SQL instance in the reverse chronological order of the start time.
  ## 
  let valid = call_580679.validator(path, query, header, formData, body)
  let scheme = call_580679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580679.url(scheme.get, call_580679.host, call_580679.base,
                         call_580679.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580679, url, valid)

proc call*(call_580680: Call_SqlOperationsList_580665; instance: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## sqlOperationsList
  ## Lists all instance operations that have been performed on the given Cloud SQL instance in the reverse chronological order of the start time.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of operations per response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580681 = newJObject()
  var query_580682 = newJObject()
  add(query_580682, "fields", newJString(fields))
  add(query_580682, "pageToken", newJString(pageToken))
  add(query_580682, "quotaUser", newJString(quotaUser))
  add(query_580682, "alt", newJString(alt))
  add(query_580682, "oauth_token", newJString(oauthToken))
  add(query_580682, "userIp", newJString(userIp))
  add(query_580682, "maxResults", newJInt(maxResults))
  add(query_580682, "key", newJString(key))
  add(query_580682, "instance", newJString(instance))
  add(path_580681, "project", newJString(project))
  add(query_580682, "prettyPrint", newJBool(prettyPrint))
  result = call_580680.call(path_580681, query_580682, nil, nil, nil)

var sqlOperationsList* = Call_SqlOperationsList_580665(name: "sqlOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/operations",
    validator: validate_SqlOperationsList_580666, base: "/sql/v1beta4",
    url: url_SqlOperationsList_580667, schemes: {Scheme.Https})
type
  Call_SqlOperationsGet_580683 = ref object of OpenApiRestCall_579421
proc url_SqlOperationsGet_580685(protocol: Scheme; host: string; base: string;
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

proc validate_SqlOperationsGet_580684(path: JsonNode; query: JsonNode;
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
  var valid_580686 = path.getOrDefault("operation")
  valid_580686 = validateParameter(valid_580686, JString, required = true,
                                 default = nil)
  if valid_580686 != nil:
    section.add "operation", valid_580686
  var valid_580687 = path.getOrDefault("project")
  valid_580687 = validateParameter(valid_580687, JString, required = true,
                                 default = nil)
  if valid_580687 != nil:
    section.add "project", valid_580687
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580688 = query.getOrDefault("fields")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "fields", valid_580688
  var valid_580689 = query.getOrDefault("quotaUser")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "quotaUser", valid_580689
  var valid_580690 = query.getOrDefault("alt")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = newJString("json"))
  if valid_580690 != nil:
    section.add "alt", valid_580690
  var valid_580691 = query.getOrDefault("oauth_token")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "oauth_token", valid_580691
  var valid_580692 = query.getOrDefault("userIp")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "userIp", valid_580692
  var valid_580693 = query.getOrDefault("key")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "key", valid_580693
  var valid_580694 = query.getOrDefault("prettyPrint")
  valid_580694 = validateParameter(valid_580694, JBool, required = false,
                                 default = newJBool(true))
  if valid_580694 != nil:
    section.add "prettyPrint", valid_580694
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580695: Call_SqlOperationsGet_580683; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an instance operation that has been performed on an instance.
  ## 
  let valid = call_580695.validator(path, query, header, formData, body)
  let scheme = call_580695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580695.url(scheme.get, call_580695.host, call_580695.base,
                         call_580695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580695, url, valid)

proc call*(call_580696: Call_SqlOperationsGet_580683; operation: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlOperationsGet
  ## Retrieves an instance operation that has been performed on an instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : Instance operation ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580697 = newJObject()
  var query_580698 = newJObject()
  add(query_580698, "fields", newJString(fields))
  add(query_580698, "quotaUser", newJString(quotaUser))
  add(query_580698, "alt", newJString(alt))
  add(path_580697, "operation", newJString(operation))
  add(query_580698, "oauth_token", newJString(oauthToken))
  add(query_580698, "userIp", newJString(userIp))
  add(query_580698, "key", newJString(key))
  add(path_580697, "project", newJString(project))
  add(query_580698, "prettyPrint", newJBool(prettyPrint))
  result = call_580696.call(path_580697, query_580698, nil, nil, nil)

var sqlOperationsGet* = Call_SqlOperationsGet_580683(name: "sqlOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/operations/{operation}",
    validator: validate_SqlOperationsGet_580684, base: "/sql/v1beta4",
    url: url_SqlOperationsGet_580685, schemes: {Scheme.Https})
type
  Call_SqlTiersList_580699 = ref object of OpenApiRestCall_579421
proc url_SqlTiersList_580701(protocol: Scheme; host: string; base: string;
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

proc validate_SqlTiersList_580700(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580702 = path.getOrDefault("project")
  valid_580702 = validateParameter(valid_580702, JString, required = true,
                                 default = nil)
  if valid_580702 != nil:
    section.add "project", valid_580702
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580703 = query.getOrDefault("fields")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "fields", valid_580703
  var valid_580704 = query.getOrDefault("quotaUser")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = nil)
  if valid_580704 != nil:
    section.add "quotaUser", valid_580704
  var valid_580705 = query.getOrDefault("alt")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = newJString("json"))
  if valid_580705 != nil:
    section.add "alt", valid_580705
  var valid_580706 = query.getOrDefault("oauth_token")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "oauth_token", valid_580706
  var valid_580707 = query.getOrDefault("userIp")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "userIp", valid_580707
  var valid_580708 = query.getOrDefault("key")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "key", valid_580708
  var valid_580709 = query.getOrDefault("prettyPrint")
  valid_580709 = validateParameter(valid_580709, JBool, required = false,
                                 default = newJBool(true))
  if valid_580709 != nil:
    section.add "prettyPrint", valid_580709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580710: Call_SqlTiersList_580699; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1. For related information, see Pricing.
  ## 
  let valid = call_580710.validator(path, query, header, formData, body)
  let scheme = call_580710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580710.url(scheme.get, call_580710.host, call_580710.base,
                         call_580710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580710, url, valid)

proc call*(call_580711: Call_SqlTiersList_580699; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## sqlTiersList
  ## Lists all available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1. For related information, see Pricing.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Project ID of the project for which to list tiers.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580712 = newJObject()
  var query_580713 = newJObject()
  add(query_580713, "fields", newJString(fields))
  add(query_580713, "quotaUser", newJString(quotaUser))
  add(query_580713, "alt", newJString(alt))
  add(query_580713, "oauth_token", newJString(oauthToken))
  add(query_580713, "userIp", newJString(userIp))
  add(query_580713, "key", newJString(key))
  add(path_580712, "project", newJString(project))
  add(query_580713, "prettyPrint", newJBool(prettyPrint))
  result = call_580711.call(path_580712, query_580713, nil, nil, nil)

var sqlTiersList* = Call_SqlTiersList_580699(name: "sqlTiersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/tiers", validator: validate_SqlTiersList_580700,
    base: "/sql/v1beta4", url: url_SqlTiersList_580701, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
