
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  Call_SqlFlagsList_588718 = ref object of OpenApiRestCall_588450
proc url_SqlFlagsList_588720(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SqlFlagsList_588719(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_588832 = query.getOrDefault("fields")
  valid_588832 = validateParameter(valid_588832, JString, required = false,
                                 default = nil)
  if valid_588832 != nil:
    section.add "fields", valid_588832
  var valid_588833 = query.getOrDefault("quotaUser")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "quotaUser", valid_588833
  var valid_588847 = query.getOrDefault("alt")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = newJString("json"))
  if valid_588847 != nil:
    section.add "alt", valid_588847
  var valid_588848 = query.getOrDefault("databaseVersion")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "databaseVersion", valid_588848
  var valid_588849 = query.getOrDefault("oauth_token")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "oauth_token", valid_588849
  var valid_588850 = query.getOrDefault("userIp")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "userIp", valid_588850
  var valid_588851 = query.getOrDefault("key")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "key", valid_588851
  var valid_588852 = query.getOrDefault("prettyPrint")
  valid_588852 = validateParameter(valid_588852, JBool, required = false,
                                 default = newJBool(true))
  if valid_588852 != nil:
    section.add "prettyPrint", valid_588852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588875: Call_SqlFlagsList_588718; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all available database flags for Cloud SQL instances.
  ## 
  let valid = call_588875.validator(path, query, header, formData, body)
  let scheme = call_588875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588875.url(scheme.get, call_588875.host, call_588875.base,
                         call_588875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588875, url, valid)

proc call*(call_588946: Call_SqlFlagsList_588718; fields: string = "";
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
  var query_588947 = newJObject()
  add(query_588947, "fields", newJString(fields))
  add(query_588947, "quotaUser", newJString(quotaUser))
  add(query_588947, "alt", newJString(alt))
  add(query_588947, "databaseVersion", newJString(databaseVersion))
  add(query_588947, "oauth_token", newJString(oauthToken))
  add(query_588947, "userIp", newJString(userIp))
  add(query_588947, "key", newJString(key))
  add(query_588947, "prettyPrint", newJBool(prettyPrint))
  result = call_588946.call(nil, query_588947, nil, nil, nil)

var sqlFlagsList* = Call_SqlFlagsList_588718(name: "sqlFlagsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/flags",
    validator: validate_SqlFlagsList_588719, base: "/sql/v1beta4",
    url: url_SqlFlagsList_588720, schemes: {Scheme.Https})
type
  Call_SqlInstancesInsert_589019 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesInsert_589021(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesInsert_589020(path: JsonNode; query: JsonNode;
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
  var valid_589022 = path.getOrDefault("project")
  valid_589022 = validateParameter(valid_589022, JString, required = true,
                                 default = nil)
  if valid_589022 != nil:
    section.add "project", valid_589022
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
  var valid_589023 = query.getOrDefault("fields")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "fields", valid_589023
  var valid_589024 = query.getOrDefault("quotaUser")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "quotaUser", valid_589024
  var valid_589025 = query.getOrDefault("alt")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("json"))
  if valid_589025 != nil:
    section.add "alt", valid_589025
  var valid_589026 = query.getOrDefault("oauth_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "oauth_token", valid_589026
  var valid_589027 = query.getOrDefault("userIp")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "userIp", valid_589027
  var valid_589028 = query.getOrDefault("key")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "key", valid_589028
  var valid_589029 = query.getOrDefault("prettyPrint")
  valid_589029 = validateParameter(valid_589029, JBool, required = false,
                                 default = newJBool(true))
  if valid_589029 != nil:
    section.add "prettyPrint", valid_589029
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

proc call*(call_589031: Call_SqlInstancesInsert_589019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Cloud SQL instance.
  ## 
  let valid = call_589031.validator(path, query, header, formData, body)
  let scheme = call_589031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589031.url(scheme.get, call_589031.host, call_589031.base,
                         call_589031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589031, url, valid)

proc call*(call_589032: Call_SqlInstancesInsert_589019; project: string;
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
  var path_589033 = newJObject()
  var query_589034 = newJObject()
  var body_589035 = newJObject()
  add(query_589034, "fields", newJString(fields))
  add(query_589034, "quotaUser", newJString(quotaUser))
  add(query_589034, "alt", newJString(alt))
  add(query_589034, "oauth_token", newJString(oauthToken))
  add(query_589034, "userIp", newJString(userIp))
  add(query_589034, "key", newJString(key))
  add(path_589033, "project", newJString(project))
  if body != nil:
    body_589035 = body
  add(query_589034, "prettyPrint", newJBool(prettyPrint))
  result = call_589032.call(path_589033, query_589034, nil, nil, body_589035)

var sqlInstancesInsert* = Call_SqlInstancesInsert_589019(
    name: "sqlInstancesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{project}/instances",
    validator: validate_SqlInstancesInsert_589020, base: "/sql/v1beta4",
    url: url_SqlInstancesInsert_589021, schemes: {Scheme.Https})
type
  Call_SqlInstancesList_588987 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesList_588989(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesList_588988(path: JsonNode; query: JsonNode;
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
  var valid_589004 = path.getOrDefault("project")
  valid_589004 = validateParameter(valid_589004, JString, required = true,
                                 default = nil)
  if valid_589004 != nil:
    section.add "project", valid_589004
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
  var valid_589005 = query.getOrDefault("fields")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "fields", valid_589005
  var valid_589006 = query.getOrDefault("pageToken")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "pageToken", valid_589006
  var valid_589007 = query.getOrDefault("quotaUser")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "quotaUser", valid_589007
  var valid_589008 = query.getOrDefault("alt")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = newJString("json"))
  if valid_589008 != nil:
    section.add "alt", valid_589008
  var valid_589009 = query.getOrDefault("oauth_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "oauth_token", valid_589009
  var valid_589010 = query.getOrDefault("userIp")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "userIp", valid_589010
  var valid_589011 = query.getOrDefault("maxResults")
  valid_589011 = validateParameter(valid_589011, JInt, required = false, default = nil)
  if valid_589011 != nil:
    section.add "maxResults", valid_589011
  var valid_589012 = query.getOrDefault("key")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "key", valid_589012
  var valid_589013 = query.getOrDefault("prettyPrint")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "prettyPrint", valid_589013
  var valid_589014 = query.getOrDefault("filter")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "filter", valid_589014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589015: Call_SqlInstancesList_588987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists instances under a given project in the alphabetical order of the instance name.
  ## 
  let valid = call_589015.validator(path, query, header, formData, body)
  let scheme = call_589015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589015.url(scheme.get, call_589015.host, call_589015.base,
                         call_589015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589015, url, valid)

proc call*(call_589016: Call_SqlInstancesList_588987; project: string;
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
  var path_589017 = newJObject()
  var query_589018 = newJObject()
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "pageToken", newJString(pageToken))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(query_589018, "alt", newJString(alt))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "userIp", newJString(userIp))
  add(query_589018, "maxResults", newJInt(maxResults))
  add(query_589018, "key", newJString(key))
  add(path_589017, "project", newJString(project))
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  add(query_589018, "filter", newJString(filter))
  result = call_589016.call(path_589017, query_589018, nil, nil, nil)

var sqlInstancesList* = Call_SqlInstancesList_588987(name: "sqlInstancesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances", validator: validate_SqlInstancesList_588988,
    base: "/sql/v1beta4", url: url_SqlInstancesList_588989, schemes: {Scheme.Https})
type
  Call_SqlInstancesUpdate_589052 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesUpdate_589054(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesUpdate_589053(path: JsonNode; query: JsonNode;
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
  var valid_589055 = path.getOrDefault("instance")
  valid_589055 = validateParameter(valid_589055, JString, required = true,
                                 default = nil)
  if valid_589055 != nil:
    section.add "instance", valid_589055
  var valid_589056 = path.getOrDefault("project")
  valid_589056 = validateParameter(valid_589056, JString, required = true,
                                 default = nil)
  if valid_589056 != nil:
    section.add "project", valid_589056
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
  var valid_589057 = query.getOrDefault("fields")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "fields", valid_589057
  var valid_589058 = query.getOrDefault("quotaUser")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "quotaUser", valid_589058
  var valid_589059 = query.getOrDefault("alt")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = newJString("json"))
  if valid_589059 != nil:
    section.add "alt", valid_589059
  var valid_589060 = query.getOrDefault("oauth_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "oauth_token", valid_589060
  var valid_589061 = query.getOrDefault("userIp")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "userIp", valid_589061
  var valid_589062 = query.getOrDefault("key")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "key", valid_589062
  var valid_589063 = query.getOrDefault("prettyPrint")
  valid_589063 = validateParameter(valid_589063, JBool, required = false,
                                 default = newJBool(true))
  if valid_589063 != nil:
    section.add "prettyPrint", valid_589063
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

proc call*(call_589065: Call_SqlInstancesUpdate_589052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.
  ## 
  let valid = call_589065.validator(path, query, header, formData, body)
  let scheme = call_589065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589065.url(scheme.get, call_589065.host, call_589065.base,
                         call_589065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589065, url, valid)

proc call*(call_589066: Call_SqlInstancesUpdate_589052; instance: string;
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
  var path_589067 = newJObject()
  var query_589068 = newJObject()
  var body_589069 = newJObject()
  add(query_589068, "fields", newJString(fields))
  add(query_589068, "quotaUser", newJString(quotaUser))
  add(query_589068, "alt", newJString(alt))
  add(query_589068, "oauth_token", newJString(oauthToken))
  add(query_589068, "userIp", newJString(userIp))
  add(query_589068, "key", newJString(key))
  add(path_589067, "instance", newJString(instance))
  add(path_589067, "project", newJString(project))
  if body != nil:
    body_589069 = body
  add(query_589068, "prettyPrint", newJBool(prettyPrint))
  result = call_589066.call(path_589067, query_589068, nil, nil, body_589069)

var sqlInstancesUpdate* = Call_SqlInstancesUpdate_589052(
    name: "sqlInstancesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesUpdate_589053, base: "/sql/v1beta4",
    url: url_SqlInstancesUpdate_589054, schemes: {Scheme.Https})
type
  Call_SqlInstancesGet_589036 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesGet_589038(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesGet_589037(path: JsonNode; query: JsonNode;
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
  var valid_589039 = path.getOrDefault("instance")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "instance", valid_589039
  var valid_589040 = path.getOrDefault("project")
  valid_589040 = validateParameter(valid_589040, JString, required = true,
                                 default = nil)
  if valid_589040 != nil:
    section.add "project", valid_589040
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
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  var valid_589042 = query.getOrDefault("quotaUser")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "quotaUser", valid_589042
  var valid_589043 = query.getOrDefault("alt")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("json"))
  if valid_589043 != nil:
    section.add "alt", valid_589043
  var valid_589044 = query.getOrDefault("oauth_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "oauth_token", valid_589044
  var valid_589045 = query.getOrDefault("userIp")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "userIp", valid_589045
  var valid_589046 = query.getOrDefault("key")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "key", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589048: Call_SqlInstancesGet_589036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a Cloud SQL instance.
  ## 
  let valid = call_589048.validator(path, query, header, formData, body)
  let scheme = call_589048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589048.url(scheme.get, call_589048.host, call_589048.base,
                         call_589048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589048, url, valid)

proc call*(call_589049: Call_SqlInstancesGet_589036; instance: string;
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
  var path_589050 = newJObject()
  var query_589051 = newJObject()
  add(query_589051, "fields", newJString(fields))
  add(query_589051, "quotaUser", newJString(quotaUser))
  add(query_589051, "alt", newJString(alt))
  add(query_589051, "oauth_token", newJString(oauthToken))
  add(query_589051, "userIp", newJString(userIp))
  add(query_589051, "key", newJString(key))
  add(path_589050, "instance", newJString(instance))
  add(path_589050, "project", newJString(project))
  add(query_589051, "prettyPrint", newJBool(prettyPrint))
  result = call_589049.call(path_589050, query_589051, nil, nil, nil)

var sqlInstancesGet* = Call_SqlInstancesGet_589036(name: "sqlInstancesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesGet_589037, base: "/sql/v1beta4",
    url: url_SqlInstancesGet_589038, schemes: {Scheme.Https})
type
  Call_SqlInstancesPatch_589086 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesPatch_589088(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesPatch_589087(path: JsonNode; query: JsonNode;
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
  var valid_589089 = path.getOrDefault("instance")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "instance", valid_589089
  var valid_589090 = path.getOrDefault("project")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = nil)
  if valid_589090 != nil:
    section.add "project", valid_589090
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
  var valid_589091 = query.getOrDefault("fields")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "fields", valid_589091
  var valid_589092 = query.getOrDefault("quotaUser")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "quotaUser", valid_589092
  var valid_589093 = query.getOrDefault("alt")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("json"))
  if valid_589093 != nil:
    section.add "alt", valid_589093
  var valid_589094 = query.getOrDefault("oauth_token")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "oauth_token", valid_589094
  var valid_589095 = query.getOrDefault("userIp")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "userIp", valid_589095
  var valid_589096 = query.getOrDefault("key")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "key", valid_589096
  var valid_589097 = query.getOrDefault("prettyPrint")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(true))
  if valid_589097 != nil:
    section.add "prettyPrint", valid_589097
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

proc call*(call_589099: Call_SqlInstancesPatch_589086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings of a Cloud SQL instance. Caution: This is not a partial update, so you must include values for all the settings that you want to retain. For partial updates, use patch.. This method supports patch semantics.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_SqlInstancesPatch_589086; instance: string;
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
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  var body_589103 = newJObject()
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "userIp", newJString(userIp))
  add(query_589102, "key", newJString(key))
  add(path_589101, "instance", newJString(instance))
  add(path_589101, "project", newJString(project))
  if body != nil:
    body_589103 = body
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  result = call_589100.call(path_589101, query_589102, nil, nil, body_589103)

var sqlInstancesPatch* = Call_SqlInstancesPatch_589086(name: "sqlInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesPatch_589087, base: "/sql/v1beta4",
    url: url_SqlInstancesPatch_589088, schemes: {Scheme.Https})
type
  Call_SqlInstancesDelete_589070 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesDelete_589072(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesDelete_589071(path: JsonNode; query: JsonNode;
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
  var valid_589073 = path.getOrDefault("instance")
  valid_589073 = validateParameter(valid_589073, JString, required = true,
                                 default = nil)
  if valid_589073 != nil:
    section.add "instance", valid_589073
  var valid_589074 = path.getOrDefault("project")
  valid_589074 = validateParameter(valid_589074, JString, required = true,
                                 default = nil)
  if valid_589074 != nil:
    section.add "project", valid_589074
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
  var valid_589075 = query.getOrDefault("fields")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "fields", valid_589075
  var valid_589076 = query.getOrDefault("quotaUser")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "quotaUser", valid_589076
  var valid_589077 = query.getOrDefault("alt")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("json"))
  if valid_589077 != nil:
    section.add "alt", valid_589077
  var valid_589078 = query.getOrDefault("oauth_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "oauth_token", valid_589078
  var valid_589079 = query.getOrDefault("userIp")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "userIp", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("prettyPrint")
  valid_589081 = validateParameter(valid_589081, JBool, required = false,
                                 default = newJBool(true))
  if valid_589081 != nil:
    section.add "prettyPrint", valid_589081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589082: Call_SqlInstancesDelete_589070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cloud SQL instance.
  ## 
  let valid = call_589082.validator(path, query, header, formData, body)
  let scheme = call_589082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589082.url(scheme.get, call_589082.host, call_589082.base,
                         call_589082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589082, url, valid)

proc call*(call_589083: Call_SqlInstancesDelete_589070; instance: string;
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
  var path_589084 = newJObject()
  var query_589085 = newJObject()
  add(query_589085, "fields", newJString(fields))
  add(query_589085, "quotaUser", newJString(quotaUser))
  add(query_589085, "alt", newJString(alt))
  add(query_589085, "oauth_token", newJString(oauthToken))
  add(query_589085, "userIp", newJString(userIp))
  add(query_589085, "key", newJString(key))
  add(path_589084, "instance", newJString(instance))
  add(path_589084, "project", newJString(project))
  add(query_589085, "prettyPrint", newJBool(prettyPrint))
  result = call_589083.call(path_589084, query_589085, nil, nil, nil)

var sqlInstancesDelete* = Call_SqlInstancesDelete_589070(
    name: "sqlInstancesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesDelete_589071, base: "/sql/v1beta4",
    url: url_SqlInstancesDelete_589072, schemes: {Scheme.Https})
type
  Call_SqlInstancesAddServerCa_589104 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesAddServerCa_589106(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesAddServerCa_589105(path: JsonNode; query: JsonNode;
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
  var valid_589107 = path.getOrDefault("instance")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "instance", valid_589107
  var valid_589108 = path.getOrDefault("project")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "project", valid_589108
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
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("quotaUser")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "quotaUser", valid_589110
  var valid_589111 = query.getOrDefault("alt")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("json"))
  if valid_589111 != nil:
    section.add "alt", valid_589111
  var valid_589112 = query.getOrDefault("oauth_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "oauth_token", valid_589112
  var valid_589113 = query.getOrDefault("userIp")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "userIp", valid_589113
  var valid_589114 = query.getOrDefault("key")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "key", valid_589114
  var valid_589115 = query.getOrDefault("prettyPrint")
  valid_589115 = validateParameter(valid_589115, JBool, required = false,
                                 default = newJBool(true))
  if valid_589115 != nil:
    section.add "prettyPrint", valid_589115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589116: Call_SqlInstancesAddServerCa_589104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new trusted Certificate Authority (CA) version for the specified instance. Required to prepare for a certificate rotation. If a CA version was previously added but never used in a certificate rotation, this operation replaces that version. There cannot be more than one CA version waiting to be rotated in.
  ## 
  let valid = call_589116.validator(path, query, header, formData, body)
  let scheme = call_589116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589116.url(scheme.get, call_589116.host, call_589116.base,
                         call_589116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589116, url, valid)

proc call*(call_589117: Call_SqlInstancesAddServerCa_589104; instance: string;
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
  var path_589118 = newJObject()
  var query_589119 = newJObject()
  add(query_589119, "fields", newJString(fields))
  add(query_589119, "quotaUser", newJString(quotaUser))
  add(query_589119, "alt", newJString(alt))
  add(query_589119, "oauth_token", newJString(oauthToken))
  add(query_589119, "userIp", newJString(userIp))
  add(query_589119, "key", newJString(key))
  add(path_589118, "instance", newJString(instance))
  add(path_589118, "project", newJString(project))
  add(query_589119, "prettyPrint", newJBool(prettyPrint))
  result = call_589117.call(path_589118, query_589119, nil, nil, nil)

var sqlInstancesAddServerCa* = Call_SqlInstancesAddServerCa_589104(
    name: "sqlInstancesAddServerCa", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/addServerCa",
    validator: validate_SqlInstancesAddServerCa_589105, base: "/sql/v1beta4",
    url: url_SqlInstancesAddServerCa_589106, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsInsert_589138 = ref object of OpenApiRestCall_588450
proc url_SqlBackupRunsInsert_589140(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsInsert_589139(path: JsonNode; query: JsonNode;
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
  var valid_589141 = path.getOrDefault("instance")
  valid_589141 = validateParameter(valid_589141, JString, required = true,
                                 default = nil)
  if valid_589141 != nil:
    section.add "instance", valid_589141
  var valid_589142 = path.getOrDefault("project")
  valid_589142 = validateParameter(valid_589142, JString, required = true,
                                 default = nil)
  if valid_589142 != nil:
    section.add "project", valid_589142
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
  var valid_589143 = query.getOrDefault("fields")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "fields", valid_589143
  var valid_589144 = query.getOrDefault("quotaUser")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "quotaUser", valid_589144
  var valid_589145 = query.getOrDefault("alt")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("json"))
  if valid_589145 != nil:
    section.add "alt", valid_589145
  var valid_589146 = query.getOrDefault("oauth_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "oauth_token", valid_589146
  var valid_589147 = query.getOrDefault("userIp")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "userIp", valid_589147
  var valid_589148 = query.getOrDefault("key")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "key", valid_589148
  var valid_589149 = query.getOrDefault("prettyPrint")
  valid_589149 = validateParameter(valid_589149, JBool, required = false,
                                 default = newJBool(true))
  if valid_589149 != nil:
    section.add "prettyPrint", valid_589149
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

proc call*(call_589151: Call_SqlBackupRunsInsert_589138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new backup run on demand. This method is applicable only to Second Generation instances.
  ## 
  let valid = call_589151.validator(path, query, header, formData, body)
  let scheme = call_589151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589151.url(scheme.get, call_589151.host, call_589151.base,
                         call_589151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589151, url, valid)

proc call*(call_589152: Call_SqlBackupRunsInsert_589138; instance: string;
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
  var path_589153 = newJObject()
  var query_589154 = newJObject()
  var body_589155 = newJObject()
  add(query_589154, "fields", newJString(fields))
  add(query_589154, "quotaUser", newJString(quotaUser))
  add(query_589154, "alt", newJString(alt))
  add(query_589154, "oauth_token", newJString(oauthToken))
  add(query_589154, "userIp", newJString(userIp))
  add(query_589154, "key", newJString(key))
  add(path_589153, "instance", newJString(instance))
  add(path_589153, "project", newJString(project))
  if body != nil:
    body_589155 = body
  add(query_589154, "prettyPrint", newJBool(prettyPrint))
  result = call_589152.call(path_589153, query_589154, nil, nil, body_589155)

var sqlBackupRunsInsert* = Call_SqlBackupRunsInsert_589138(
    name: "sqlBackupRunsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsInsert_589139, base: "/sql/v1beta4",
    url: url_SqlBackupRunsInsert_589140, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsList_589120 = ref object of OpenApiRestCall_588450
proc url_SqlBackupRunsList_589122(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsList_589121(path: JsonNode; query: JsonNode;
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
  var valid_589123 = path.getOrDefault("instance")
  valid_589123 = validateParameter(valid_589123, JString, required = true,
                                 default = nil)
  if valid_589123 != nil:
    section.add "instance", valid_589123
  var valid_589124 = path.getOrDefault("project")
  valid_589124 = validateParameter(valid_589124, JString, required = true,
                                 default = nil)
  if valid_589124 != nil:
    section.add "project", valid_589124
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
  var valid_589125 = query.getOrDefault("fields")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "fields", valid_589125
  var valid_589126 = query.getOrDefault("pageToken")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "pageToken", valid_589126
  var valid_589127 = query.getOrDefault("quotaUser")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "quotaUser", valid_589127
  var valid_589128 = query.getOrDefault("alt")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = newJString("json"))
  if valid_589128 != nil:
    section.add "alt", valid_589128
  var valid_589129 = query.getOrDefault("oauth_token")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "oauth_token", valid_589129
  var valid_589130 = query.getOrDefault("userIp")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "userIp", valid_589130
  var valid_589131 = query.getOrDefault("maxResults")
  valid_589131 = validateParameter(valid_589131, JInt, required = false, default = nil)
  if valid_589131 != nil:
    section.add "maxResults", valid_589131
  var valid_589132 = query.getOrDefault("key")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "key", valid_589132
  var valid_589133 = query.getOrDefault("prettyPrint")
  valid_589133 = validateParameter(valid_589133, JBool, required = false,
                                 default = newJBool(true))
  if valid_589133 != nil:
    section.add "prettyPrint", valid_589133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589134: Call_SqlBackupRunsList_589120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all backup runs associated with a given instance and configuration in the reverse chronological order of the backup initiation time.
  ## 
  let valid = call_589134.validator(path, query, header, formData, body)
  let scheme = call_589134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589134.url(scheme.get, call_589134.host, call_589134.base,
                         call_589134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589134, url, valid)

proc call*(call_589135: Call_SqlBackupRunsList_589120; instance: string;
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
  var path_589136 = newJObject()
  var query_589137 = newJObject()
  add(query_589137, "fields", newJString(fields))
  add(query_589137, "pageToken", newJString(pageToken))
  add(query_589137, "quotaUser", newJString(quotaUser))
  add(query_589137, "alt", newJString(alt))
  add(query_589137, "oauth_token", newJString(oauthToken))
  add(query_589137, "userIp", newJString(userIp))
  add(query_589137, "maxResults", newJInt(maxResults))
  add(query_589137, "key", newJString(key))
  add(path_589136, "instance", newJString(instance))
  add(path_589136, "project", newJString(project))
  add(query_589137, "prettyPrint", newJBool(prettyPrint))
  result = call_589135.call(path_589136, query_589137, nil, nil, nil)

var sqlBackupRunsList* = Call_SqlBackupRunsList_589120(name: "sqlBackupRunsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsList_589121, base: "/sql/v1beta4",
    url: url_SqlBackupRunsList_589122, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsGet_589156 = ref object of OpenApiRestCall_588450
proc url_SqlBackupRunsGet_589158(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsGet_589157(path: JsonNode; query: JsonNode;
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
  var valid_589159 = path.getOrDefault("id")
  valid_589159 = validateParameter(valid_589159, JString, required = true,
                                 default = nil)
  if valid_589159 != nil:
    section.add "id", valid_589159
  var valid_589160 = path.getOrDefault("instance")
  valid_589160 = validateParameter(valid_589160, JString, required = true,
                                 default = nil)
  if valid_589160 != nil:
    section.add "instance", valid_589160
  var valid_589161 = path.getOrDefault("project")
  valid_589161 = validateParameter(valid_589161, JString, required = true,
                                 default = nil)
  if valid_589161 != nil:
    section.add "project", valid_589161
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
  var valid_589162 = query.getOrDefault("fields")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "fields", valid_589162
  var valid_589163 = query.getOrDefault("quotaUser")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "quotaUser", valid_589163
  var valid_589164 = query.getOrDefault("alt")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = newJString("json"))
  if valid_589164 != nil:
    section.add "alt", valid_589164
  var valid_589165 = query.getOrDefault("oauth_token")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "oauth_token", valid_589165
  var valid_589166 = query.getOrDefault("userIp")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "userIp", valid_589166
  var valid_589167 = query.getOrDefault("key")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "key", valid_589167
  var valid_589168 = query.getOrDefault("prettyPrint")
  valid_589168 = validateParameter(valid_589168, JBool, required = false,
                                 default = newJBool(true))
  if valid_589168 != nil:
    section.add "prettyPrint", valid_589168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589169: Call_SqlBackupRunsGet_589156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a backup run.
  ## 
  let valid = call_589169.validator(path, query, header, formData, body)
  let scheme = call_589169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589169.url(scheme.get, call_589169.host, call_589169.base,
                         call_589169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589169, url, valid)

proc call*(call_589170: Call_SqlBackupRunsGet_589156; id: string; instance: string;
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
  var path_589171 = newJObject()
  var query_589172 = newJObject()
  add(query_589172, "fields", newJString(fields))
  add(query_589172, "quotaUser", newJString(quotaUser))
  add(query_589172, "alt", newJString(alt))
  add(query_589172, "oauth_token", newJString(oauthToken))
  add(query_589172, "userIp", newJString(userIp))
  add(path_589171, "id", newJString(id))
  add(query_589172, "key", newJString(key))
  add(path_589171, "instance", newJString(instance))
  add(path_589171, "project", newJString(project))
  add(query_589172, "prettyPrint", newJBool(prettyPrint))
  result = call_589170.call(path_589171, query_589172, nil, nil, nil)

var sqlBackupRunsGet* = Call_SqlBackupRunsGet_589156(name: "sqlBackupRunsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns/{id}",
    validator: validate_SqlBackupRunsGet_589157, base: "/sql/v1beta4",
    url: url_SqlBackupRunsGet_589158, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsDelete_589173 = ref object of OpenApiRestCall_588450
proc url_SqlBackupRunsDelete_589175(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsDelete_589174(path: JsonNode; query: JsonNode;
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
  var valid_589176 = path.getOrDefault("id")
  valid_589176 = validateParameter(valid_589176, JString, required = true,
                                 default = nil)
  if valid_589176 != nil:
    section.add "id", valid_589176
  var valid_589177 = path.getOrDefault("instance")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "instance", valid_589177
  var valid_589178 = path.getOrDefault("project")
  valid_589178 = validateParameter(valid_589178, JString, required = true,
                                 default = nil)
  if valid_589178 != nil:
    section.add "project", valid_589178
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
  var valid_589179 = query.getOrDefault("fields")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "fields", valid_589179
  var valid_589180 = query.getOrDefault("quotaUser")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "quotaUser", valid_589180
  var valid_589181 = query.getOrDefault("alt")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = newJString("json"))
  if valid_589181 != nil:
    section.add "alt", valid_589181
  var valid_589182 = query.getOrDefault("oauth_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "oauth_token", valid_589182
  var valid_589183 = query.getOrDefault("userIp")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "userIp", valid_589183
  var valid_589184 = query.getOrDefault("key")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "key", valid_589184
  var valid_589185 = query.getOrDefault("prettyPrint")
  valid_589185 = validateParameter(valid_589185, JBool, required = false,
                                 default = newJBool(true))
  if valid_589185 != nil:
    section.add "prettyPrint", valid_589185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589186: Call_SqlBackupRunsDelete_589173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup taken by a backup run.
  ## 
  let valid = call_589186.validator(path, query, header, formData, body)
  let scheme = call_589186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589186.url(scheme.get, call_589186.host, call_589186.base,
                         call_589186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589186, url, valid)

proc call*(call_589187: Call_SqlBackupRunsDelete_589173; id: string;
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
  var path_589188 = newJObject()
  var query_589189 = newJObject()
  add(query_589189, "fields", newJString(fields))
  add(query_589189, "quotaUser", newJString(quotaUser))
  add(query_589189, "alt", newJString(alt))
  add(query_589189, "oauth_token", newJString(oauthToken))
  add(query_589189, "userIp", newJString(userIp))
  add(path_589188, "id", newJString(id))
  add(query_589189, "key", newJString(key))
  add(path_589188, "instance", newJString(instance))
  add(path_589188, "project", newJString(project))
  add(query_589189, "prettyPrint", newJBool(prettyPrint))
  result = call_589187.call(path_589188, query_589189, nil, nil, nil)

var sqlBackupRunsDelete* = Call_SqlBackupRunsDelete_589173(
    name: "sqlBackupRunsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns/{id}",
    validator: validate_SqlBackupRunsDelete_589174, base: "/sql/v1beta4",
    url: url_SqlBackupRunsDelete_589175, schemes: {Scheme.Https})
type
  Call_SqlInstancesClone_589190 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesClone_589192(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesClone_589191(path: JsonNode; query: JsonNode;
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
  var valid_589193 = path.getOrDefault("instance")
  valid_589193 = validateParameter(valid_589193, JString, required = true,
                                 default = nil)
  if valid_589193 != nil:
    section.add "instance", valid_589193
  var valid_589194 = path.getOrDefault("project")
  valid_589194 = validateParameter(valid_589194, JString, required = true,
                                 default = nil)
  if valid_589194 != nil:
    section.add "project", valid_589194
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
  var valid_589195 = query.getOrDefault("fields")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "fields", valid_589195
  var valid_589196 = query.getOrDefault("quotaUser")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "quotaUser", valid_589196
  var valid_589197 = query.getOrDefault("alt")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = newJString("json"))
  if valid_589197 != nil:
    section.add "alt", valid_589197
  var valid_589198 = query.getOrDefault("oauth_token")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "oauth_token", valid_589198
  var valid_589199 = query.getOrDefault("userIp")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "userIp", valid_589199
  var valid_589200 = query.getOrDefault("key")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "key", valid_589200
  var valid_589201 = query.getOrDefault("prettyPrint")
  valid_589201 = validateParameter(valid_589201, JBool, required = false,
                                 default = newJBool(true))
  if valid_589201 != nil:
    section.add "prettyPrint", valid_589201
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

proc call*(call_589203: Call_SqlInstancesClone_589190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud SQL instance as a clone of the source instance.
  ## 
  let valid = call_589203.validator(path, query, header, formData, body)
  let scheme = call_589203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589203.url(scheme.get, call_589203.host, call_589203.base,
                         call_589203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589203, url, valid)

proc call*(call_589204: Call_SqlInstancesClone_589190; instance: string;
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
  var path_589205 = newJObject()
  var query_589206 = newJObject()
  var body_589207 = newJObject()
  add(query_589206, "fields", newJString(fields))
  add(query_589206, "quotaUser", newJString(quotaUser))
  add(query_589206, "alt", newJString(alt))
  add(query_589206, "oauth_token", newJString(oauthToken))
  add(query_589206, "userIp", newJString(userIp))
  add(query_589206, "key", newJString(key))
  add(path_589205, "instance", newJString(instance))
  add(path_589205, "project", newJString(project))
  if body != nil:
    body_589207 = body
  add(query_589206, "prettyPrint", newJBool(prettyPrint))
  result = call_589204.call(path_589205, query_589206, nil, nil, body_589207)

var sqlInstancesClone* = Call_SqlInstancesClone_589190(name: "sqlInstancesClone",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/clone",
    validator: validate_SqlInstancesClone_589191, base: "/sql/v1beta4",
    url: url_SqlInstancesClone_589192, schemes: {Scheme.Https})
type
  Call_SqlSslCertsCreateEphemeral_589208 = ref object of OpenApiRestCall_588450
proc url_SqlSslCertsCreateEphemeral_589210(protocol: Scheme; host: string;
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

proc validate_SqlSslCertsCreateEphemeral_589209(path: JsonNode; query: JsonNode;
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
  var valid_589211 = path.getOrDefault("instance")
  valid_589211 = validateParameter(valid_589211, JString, required = true,
                                 default = nil)
  if valid_589211 != nil:
    section.add "instance", valid_589211
  var valid_589212 = path.getOrDefault("project")
  valid_589212 = validateParameter(valid_589212, JString, required = true,
                                 default = nil)
  if valid_589212 != nil:
    section.add "project", valid_589212
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
  var valid_589213 = query.getOrDefault("fields")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "fields", valid_589213
  var valid_589214 = query.getOrDefault("quotaUser")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "quotaUser", valid_589214
  var valid_589215 = query.getOrDefault("alt")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = newJString("json"))
  if valid_589215 != nil:
    section.add "alt", valid_589215
  var valid_589216 = query.getOrDefault("oauth_token")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "oauth_token", valid_589216
  var valid_589217 = query.getOrDefault("userIp")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "userIp", valid_589217
  var valid_589218 = query.getOrDefault("key")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "key", valid_589218
  var valid_589219 = query.getOrDefault("prettyPrint")
  valid_589219 = validateParameter(valid_589219, JBool, required = false,
                                 default = newJBool(true))
  if valid_589219 != nil:
    section.add "prettyPrint", valid_589219
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

proc call*(call_589221: Call_SqlSslCertsCreateEphemeral_589208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a short-lived X509 certificate containing the provided public key and signed by a private key specific to the target instance. Users may use the certificate to authenticate as themselves when connecting to the database.
  ## 
  let valid = call_589221.validator(path, query, header, formData, body)
  let scheme = call_589221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589221.url(scheme.get, call_589221.host, call_589221.base,
                         call_589221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589221, url, valid)

proc call*(call_589222: Call_SqlSslCertsCreateEphemeral_589208; instance: string;
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
  var path_589223 = newJObject()
  var query_589224 = newJObject()
  var body_589225 = newJObject()
  add(query_589224, "fields", newJString(fields))
  add(query_589224, "quotaUser", newJString(quotaUser))
  add(query_589224, "alt", newJString(alt))
  add(query_589224, "oauth_token", newJString(oauthToken))
  add(query_589224, "userIp", newJString(userIp))
  add(query_589224, "key", newJString(key))
  add(path_589223, "instance", newJString(instance))
  add(path_589223, "project", newJString(project))
  if body != nil:
    body_589225 = body
  add(query_589224, "prettyPrint", newJBool(prettyPrint))
  result = call_589222.call(path_589223, query_589224, nil, nil, body_589225)

var sqlSslCertsCreateEphemeral* = Call_SqlSslCertsCreateEphemeral_589208(
    name: "sqlSslCertsCreateEphemeral", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/createEphemeral",
    validator: validate_SqlSslCertsCreateEphemeral_589209, base: "/sql/v1beta4",
    url: url_SqlSslCertsCreateEphemeral_589210, schemes: {Scheme.Https})
type
  Call_SqlDatabasesInsert_589242 = ref object of OpenApiRestCall_588450
proc url_SqlDatabasesInsert_589244(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesInsert_589243(path: JsonNode; query: JsonNode;
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
  var valid_589245 = path.getOrDefault("instance")
  valid_589245 = validateParameter(valid_589245, JString, required = true,
                                 default = nil)
  if valid_589245 != nil:
    section.add "instance", valid_589245
  var valid_589246 = path.getOrDefault("project")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "project", valid_589246
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
  var valid_589247 = query.getOrDefault("fields")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "fields", valid_589247
  var valid_589248 = query.getOrDefault("quotaUser")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "quotaUser", valid_589248
  var valid_589249 = query.getOrDefault("alt")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = newJString("json"))
  if valid_589249 != nil:
    section.add "alt", valid_589249
  var valid_589250 = query.getOrDefault("oauth_token")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "oauth_token", valid_589250
  var valid_589251 = query.getOrDefault("userIp")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "userIp", valid_589251
  var valid_589252 = query.getOrDefault("key")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "key", valid_589252
  var valid_589253 = query.getOrDefault("prettyPrint")
  valid_589253 = validateParameter(valid_589253, JBool, required = false,
                                 default = newJBool(true))
  if valid_589253 != nil:
    section.add "prettyPrint", valid_589253
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

proc call*(call_589255: Call_SqlDatabasesInsert_589242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a resource containing information about a database inside a Cloud SQL instance.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_SqlDatabasesInsert_589242; instance: string;
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
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  var body_589259 = newJObject()
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "userIp", newJString(userIp))
  add(query_589258, "key", newJString(key))
  add(path_589257, "instance", newJString(instance))
  add(path_589257, "project", newJString(project))
  if body != nil:
    body_589259 = body
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  result = call_589256.call(path_589257, query_589258, nil, nil, body_589259)

var sqlDatabasesInsert* = Call_SqlDatabasesInsert_589242(
    name: "sqlDatabasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases",
    validator: validate_SqlDatabasesInsert_589243, base: "/sql/v1beta4",
    url: url_SqlDatabasesInsert_589244, schemes: {Scheme.Https})
type
  Call_SqlDatabasesList_589226 = ref object of OpenApiRestCall_588450
proc url_SqlDatabasesList_589228(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesList_589227(path: JsonNode; query: JsonNode;
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
  var valid_589229 = path.getOrDefault("instance")
  valid_589229 = validateParameter(valid_589229, JString, required = true,
                                 default = nil)
  if valid_589229 != nil:
    section.add "instance", valid_589229
  var valid_589230 = path.getOrDefault("project")
  valid_589230 = validateParameter(valid_589230, JString, required = true,
                                 default = nil)
  if valid_589230 != nil:
    section.add "project", valid_589230
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
  var valid_589231 = query.getOrDefault("fields")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "fields", valid_589231
  var valid_589232 = query.getOrDefault("quotaUser")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "quotaUser", valid_589232
  var valid_589233 = query.getOrDefault("alt")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("json"))
  if valid_589233 != nil:
    section.add "alt", valid_589233
  var valid_589234 = query.getOrDefault("oauth_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "oauth_token", valid_589234
  var valid_589235 = query.getOrDefault("userIp")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "userIp", valid_589235
  var valid_589236 = query.getOrDefault("key")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "key", valid_589236
  var valid_589237 = query.getOrDefault("prettyPrint")
  valid_589237 = validateParameter(valid_589237, JBool, required = false,
                                 default = newJBool(true))
  if valid_589237 != nil:
    section.add "prettyPrint", valid_589237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589238: Call_SqlDatabasesList_589226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists databases in the specified Cloud SQL instance.
  ## 
  let valid = call_589238.validator(path, query, header, formData, body)
  let scheme = call_589238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589238.url(scheme.get, call_589238.host, call_589238.base,
                         call_589238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589238, url, valid)

proc call*(call_589239: Call_SqlDatabasesList_589226; instance: string;
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
  var path_589240 = newJObject()
  var query_589241 = newJObject()
  add(query_589241, "fields", newJString(fields))
  add(query_589241, "quotaUser", newJString(quotaUser))
  add(query_589241, "alt", newJString(alt))
  add(query_589241, "oauth_token", newJString(oauthToken))
  add(query_589241, "userIp", newJString(userIp))
  add(query_589241, "key", newJString(key))
  add(path_589240, "instance", newJString(instance))
  add(path_589240, "project", newJString(project))
  add(query_589241, "prettyPrint", newJBool(prettyPrint))
  result = call_589239.call(path_589240, query_589241, nil, nil, nil)

var sqlDatabasesList* = Call_SqlDatabasesList_589226(name: "sqlDatabasesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases",
    validator: validate_SqlDatabasesList_589227, base: "/sql/v1beta4",
    url: url_SqlDatabasesList_589228, schemes: {Scheme.Https})
type
  Call_SqlDatabasesUpdate_589277 = ref object of OpenApiRestCall_588450
proc url_SqlDatabasesUpdate_589279(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesUpdate_589278(path: JsonNode; query: JsonNode;
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
  var valid_589280 = path.getOrDefault("instance")
  valid_589280 = validateParameter(valid_589280, JString, required = true,
                                 default = nil)
  if valid_589280 != nil:
    section.add "instance", valid_589280
  var valid_589281 = path.getOrDefault("database")
  valid_589281 = validateParameter(valid_589281, JString, required = true,
                                 default = nil)
  if valid_589281 != nil:
    section.add "database", valid_589281
  var valid_589282 = path.getOrDefault("project")
  valid_589282 = validateParameter(valid_589282, JString, required = true,
                                 default = nil)
  if valid_589282 != nil:
    section.add "project", valid_589282
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
  var valid_589283 = query.getOrDefault("fields")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "fields", valid_589283
  var valid_589284 = query.getOrDefault("quotaUser")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "quotaUser", valid_589284
  var valid_589285 = query.getOrDefault("alt")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = newJString("json"))
  if valid_589285 != nil:
    section.add "alt", valid_589285
  var valid_589286 = query.getOrDefault("oauth_token")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "oauth_token", valid_589286
  var valid_589287 = query.getOrDefault("userIp")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "userIp", valid_589287
  var valid_589288 = query.getOrDefault("key")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "key", valid_589288
  var valid_589289 = query.getOrDefault("prettyPrint")
  valid_589289 = validateParameter(valid_589289, JBool, required = false,
                                 default = newJBool(true))
  if valid_589289 != nil:
    section.add "prettyPrint", valid_589289
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

proc call*(call_589291: Call_SqlDatabasesUpdate_589277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource containing information about a database inside a Cloud SQL instance.
  ## 
  let valid = call_589291.validator(path, query, header, formData, body)
  let scheme = call_589291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589291.url(scheme.get, call_589291.host, call_589291.base,
                         call_589291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589291, url, valid)

proc call*(call_589292: Call_SqlDatabasesUpdate_589277; instance: string;
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
  var path_589293 = newJObject()
  var query_589294 = newJObject()
  var body_589295 = newJObject()
  add(query_589294, "fields", newJString(fields))
  add(query_589294, "quotaUser", newJString(quotaUser))
  add(query_589294, "alt", newJString(alt))
  add(query_589294, "oauth_token", newJString(oauthToken))
  add(query_589294, "userIp", newJString(userIp))
  add(query_589294, "key", newJString(key))
  add(path_589293, "instance", newJString(instance))
  add(path_589293, "database", newJString(database))
  add(path_589293, "project", newJString(project))
  if body != nil:
    body_589295 = body
  add(query_589294, "prettyPrint", newJBool(prettyPrint))
  result = call_589292.call(path_589293, query_589294, nil, nil, body_589295)

var sqlDatabasesUpdate* = Call_SqlDatabasesUpdate_589277(
    name: "sqlDatabasesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesUpdate_589278, base: "/sql/v1beta4",
    url: url_SqlDatabasesUpdate_589279, schemes: {Scheme.Https})
type
  Call_SqlDatabasesGet_589260 = ref object of OpenApiRestCall_588450
proc url_SqlDatabasesGet_589262(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesGet_589261(path: JsonNode; query: JsonNode;
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
  var valid_589263 = path.getOrDefault("instance")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "instance", valid_589263
  var valid_589264 = path.getOrDefault("database")
  valid_589264 = validateParameter(valid_589264, JString, required = true,
                                 default = nil)
  if valid_589264 != nil:
    section.add "database", valid_589264
  var valid_589265 = path.getOrDefault("project")
  valid_589265 = validateParameter(valid_589265, JString, required = true,
                                 default = nil)
  if valid_589265 != nil:
    section.add "project", valid_589265
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
  var valid_589266 = query.getOrDefault("fields")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "fields", valid_589266
  var valid_589267 = query.getOrDefault("quotaUser")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "quotaUser", valid_589267
  var valid_589268 = query.getOrDefault("alt")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = newJString("json"))
  if valid_589268 != nil:
    section.add "alt", valid_589268
  var valid_589269 = query.getOrDefault("oauth_token")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "oauth_token", valid_589269
  var valid_589270 = query.getOrDefault("userIp")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "userIp", valid_589270
  var valid_589271 = query.getOrDefault("key")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "key", valid_589271
  var valid_589272 = query.getOrDefault("prettyPrint")
  valid_589272 = validateParameter(valid_589272, JBool, required = false,
                                 default = newJBool(true))
  if valid_589272 != nil:
    section.add "prettyPrint", valid_589272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589273: Call_SqlDatabasesGet_589260; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a database inside a Cloud SQL instance.
  ## 
  let valid = call_589273.validator(path, query, header, formData, body)
  let scheme = call_589273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589273.url(scheme.get, call_589273.host, call_589273.base,
                         call_589273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589273, url, valid)

proc call*(call_589274: Call_SqlDatabasesGet_589260; instance: string;
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
  var path_589275 = newJObject()
  var query_589276 = newJObject()
  add(query_589276, "fields", newJString(fields))
  add(query_589276, "quotaUser", newJString(quotaUser))
  add(query_589276, "alt", newJString(alt))
  add(query_589276, "oauth_token", newJString(oauthToken))
  add(query_589276, "userIp", newJString(userIp))
  add(query_589276, "key", newJString(key))
  add(path_589275, "instance", newJString(instance))
  add(path_589275, "database", newJString(database))
  add(path_589275, "project", newJString(project))
  add(query_589276, "prettyPrint", newJBool(prettyPrint))
  result = call_589274.call(path_589275, query_589276, nil, nil, nil)

var sqlDatabasesGet* = Call_SqlDatabasesGet_589260(name: "sqlDatabasesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesGet_589261, base: "/sql/v1beta4",
    url: url_SqlDatabasesGet_589262, schemes: {Scheme.Https})
type
  Call_SqlDatabasesPatch_589313 = ref object of OpenApiRestCall_588450
proc url_SqlDatabasesPatch_589315(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesPatch_589314(path: JsonNode; query: JsonNode;
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
  var valid_589316 = path.getOrDefault("instance")
  valid_589316 = validateParameter(valid_589316, JString, required = true,
                                 default = nil)
  if valid_589316 != nil:
    section.add "instance", valid_589316
  var valid_589317 = path.getOrDefault("database")
  valid_589317 = validateParameter(valid_589317, JString, required = true,
                                 default = nil)
  if valid_589317 != nil:
    section.add "database", valid_589317
  var valid_589318 = path.getOrDefault("project")
  valid_589318 = validateParameter(valid_589318, JString, required = true,
                                 default = nil)
  if valid_589318 != nil:
    section.add "project", valid_589318
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
  var valid_589319 = query.getOrDefault("fields")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "fields", valid_589319
  var valid_589320 = query.getOrDefault("quotaUser")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "quotaUser", valid_589320
  var valid_589321 = query.getOrDefault("alt")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("json"))
  if valid_589321 != nil:
    section.add "alt", valid_589321
  var valid_589322 = query.getOrDefault("oauth_token")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "oauth_token", valid_589322
  var valid_589323 = query.getOrDefault("userIp")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "userIp", valid_589323
  var valid_589324 = query.getOrDefault("key")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "key", valid_589324
  var valid_589325 = query.getOrDefault("prettyPrint")
  valid_589325 = validateParameter(valid_589325, JBool, required = false,
                                 default = newJBool(true))
  if valid_589325 != nil:
    section.add "prettyPrint", valid_589325
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

proc call*(call_589327: Call_SqlDatabasesPatch_589313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource containing information about a database inside a Cloud SQL instance. This method supports patch semantics.
  ## 
  let valid = call_589327.validator(path, query, header, formData, body)
  let scheme = call_589327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589327.url(scheme.get, call_589327.host, call_589327.base,
                         call_589327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589327, url, valid)

proc call*(call_589328: Call_SqlDatabasesPatch_589313; instance: string;
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
  var path_589329 = newJObject()
  var query_589330 = newJObject()
  var body_589331 = newJObject()
  add(query_589330, "fields", newJString(fields))
  add(query_589330, "quotaUser", newJString(quotaUser))
  add(query_589330, "alt", newJString(alt))
  add(query_589330, "oauth_token", newJString(oauthToken))
  add(query_589330, "userIp", newJString(userIp))
  add(query_589330, "key", newJString(key))
  add(path_589329, "instance", newJString(instance))
  add(path_589329, "database", newJString(database))
  add(path_589329, "project", newJString(project))
  if body != nil:
    body_589331 = body
  add(query_589330, "prettyPrint", newJBool(prettyPrint))
  result = call_589328.call(path_589329, query_589330, nil, nil, body_589331)

var sqlDatabasesPatch* = Call_SqlDatabasesPatch_589313(name: "sqlDatabasesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesPatch_589314, base: "/sql/v1beta4",
    url: url_SqlDatabasesPatch_589315, schemes: {Scheme.Https})
type
  Call_SqlDatabasesDelete_589296 = ref object of OpenApiRestCall_588450
proc url_SqlDatabasesDelete_589298(protocol: Scheme; host: string; base: string;
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

proc validate_SqlDatabasesDelete_589297(path: JsonNode; query: JsonNode;
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
  var valid_589299 = path.getOrDefault("instance")
  valid_589299 = validateParameter(valid_589299, JString, required = true,
                                 default = nil)
  if valid_589299 != nil:
    section.add "instance", valid_589299
  var valid_589300 = path.getOrDefault("database")
  valid_589300 = validateParameter(valid_589300, JString, required = true,
                                 default = nil)
  if valid_589300 != nil:
    section.add "database", valid_589300
  var valid_589301 = path.getOrDefault("project")
  valid_589301 = validateParameter(valid_589301, JString, required = true,
                                 default = nil)
  if valid_589301 != nil:
    section.add "project", valid_589301
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
  var valid_589302 = query.getOrDefault("fields")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "fields", valid_589302
  var valid_589303 = query.getOrDefault("quotaUser")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "quotaUser", valid_589303
  var valid_589304 = query.getOrDefault("alt")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("json"))
  if valid_589304 != nil:
    section.add "alt", valid_589304
  var valid_589305 = query.getOrDefault("oauth_token")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "oauth_token", valid_589305
  var valid_589306 = query.getOrDefault("userIp")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "userIp", valid_589306
  var valid_589307 = query.getOrDefault("key")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "key", valid_589307
  var valid_589308 = query.getOrDefault("prettyPrint")
  valid_589308 = validateParameter(valid_589308, JBool, required = false,
                                 default = newJBool(true))
  if valid_589308 != nil:
    section.add "prettyPrint", valid_589308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589309: Call_SqlDatabasesDelete_589296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a database from a Cloud SQL instance.
  ## 
  let valid = call_589309.validator(path, query, header, formData, body)
  let scheme = call_589309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589309.url(scheme.get, call_589309.host, call_589309.base,
                         call_589309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589309, url, valid)

proc call*(call_589310: Call_SqlDatabasesDelete_589296; instance: string;
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
  var path_589311 = newJObject()
  var query_589312 = newJObject()
  add(query_589312, "fields", newJString(fields))
  add(query_589312, "quotaUser", newJString(quotaUser))
  add(query_589312, "alt", newJString(alt))
  add(query_589312, "oauth_token", newJString(oauthToken))
  add(query_589312, "userIp", newJString(userIp))
  add(query_589312, "key", newJString(key))
  add(path_589311, "instance", newJString(instance))
  add(path_589311, "database", newJString(database))
  add(path_589311, "project", newJString(project))
  add(query_589312, "prettyPrint", newJBool(prettyPrint))
  result = call_589310.call(path_589311, query_589312, nil, nil, nil)

var sqlDatabasesDelete* = Call_SqlDatabasesDelete_589296(
    name: "sqlDatabasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesDelete_589297, base: "/sql/v1beta4",
    url: url_SqlDatabasesDelete_589298, schemes: {Scheme.Https})
type
  Call_SqlInstancesDemoteMaster_589332 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesDemoteMaster_589334(protocol: Scheme; host: string;
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

proc validate_SqlInstancesDemoteMaster_589333(path: JsonNode; query: JsonNode;
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
  var valid_589335 = path.getOrDefault("instance")
  valid_589335 = validateParameter(valid_589335, JString, required = true,
                                 default = nil)
  if valid_589335 != nil:
    section.add "instance", valid_589335
  var valid_589336 = path.getOrDefault("project")
  valid_589336 = validateParameter(valid_589336, JString, required = true,
                                 default = nil)
  if valid_589336 != nil:
    section.add "project", valid_589336
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
  var valid_589337 = query.getOrDefault("fields")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "fields", valid_589337
  var valid_589338 = query.getOrDefault("quotaUser")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "quotaUser", valid_589338
  var valid_589339 = query.getOrDefault("alt")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = newJString("json"))
  if valid_589339 != nil:
    section.add "alt", valid_589339
  var valid_589340 = query.getOrDefault("oauth_token")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "oauth_token", valid_589340
  var valid_589341 = query.getOrDefault("userIp")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "userIp", valid_589341
  var valid_589342 = query.getOrDefault("key")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "key", valid_589342
  var valid_589343 = query.getOrDefault("prettyPrint")
  valid_589343 = validateParameter(valid_589343, JBool, required = false,
                                 default = newJBool(true))
  if valid_589343 != nil:
    section.add "prettyPrint", valid_589343
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

proc call*(call_589345: Call_SqlInstancesDemoteMaster_589332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Demotes the stand-alone instance to be a Cloud SQL read replica for an external database server.
  ## 
  let valid = call_589345.validator(path, query, header, formData, body)
  let scheme = call_589345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589345.url(scheme.get, call_589345.host, call_589345.base,
                         call_589345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589345, url, valid)

proc call*(call_589346: Call_SqlInstancesDemoteMaster_589332; instance: string;
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
  var path_589347 = newJObject()
  var query_589348 = newJObject()
  var body_589349 = newJObject()
  add(query_589348, "fields", newJString(fields))
  add(query_589348, "quotaUser", newJString(quotaUser))
  add(query_589348, "alt", newJString(alt))
  add(query_589348, "oauth_token", newJString(oauthToken))
  add(query_589348, "userIp", newJString(userIp))
  add(query_589348, "key", newJString(key))
  add(path_589347, "instance", newJString(instance))
  add(path_589347, "project", newJString(project))
  if body != nil:
    body_589349 = body
  add(query_589348, "prettyPrint", newJBool(prettyPrint))
  result = call_589346.call(path_589347, query_589348, nil, nil, body_589349)

var sqlInstancesDemoteMaster* = Call_SqlInstancesDemoteMaster_589332(
    name: "sqlInstancesDemoteMaster", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/demoteMaster",
    validator: validate_SqlInstancesDemoteMaster_589333, base: "/sql/v1beta4",
    url: url_SqlInstancesDemoteMaster_589334, schemes: {Scheme.Https})
type
  Call_SqlInstancesExport_589350 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesExport_589352(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesExport_589351(path: JsonNode; query: JsonNode;
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
  var valid_589353 = path.getOrDefault("instance")
  valid_589353 = validateParameter(valid_589353, JString, required = true,
                                 default = nil)
  if valid_589353 != nil:
    section.add "instance", valid_589353
  var valid_589354 = path.getOrDefault("project")
  valid_589354 = validateParameter(valid_589354, JString, required = true,
                                 default = nil)
  if valid_589354 != nil:
    section.add "project", valid_589354
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
  var valid_589355 = query.getOrDefault("fields")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "fields", valid_589355
  var valid_589356 = query.getOrDefault("quotaUser")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "quotaUser", valid_589356
  var valid_589357 = query.getOrDefault("alt")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = newJString("json"))
  if valid_589357 != nil:
    section.add "alt", valid_589357
  var valid_589358 = query.getOrDefault("oauth_token")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "oauth_token", valid_589358
  var valid_589359 = query.getOrDefault("userIp")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "userIp", valid_589359
  var valid_589360 = query.getOrDefault("key")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "key", valid_589360
  var valid_589361 = query.getOrDefault("prettyPrint")
  valid_589361 = validateParameter(valid_589361, JBool, required = false,
                                 default = newJBool(true))
  if valid_589361 != nil:
    section.add "prettyPrint", valid_589361
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

proc call*(call_589363: Call_SqlInstancesExport_589350; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports data from a Cloud SQL instance to a Cloud Storage bucket as a SQL dump or CSV file.
  ## 
  let valid = call_589363.validator(path, query, header, formData, body)
  let scheme = call_589363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589363.url(scheme.get, call_589363.host, call_589363.base,
                         call_589363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589363, url, valid)

proc call*(call_589364: Call_SqlInstancesExport_589350; instance: string;
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
  var path_589365 = newJObject()
  var query_589366 = newJObject()
  var body_589367 = newJObject()
  add(query_589366, "fields", newJString(fields))
  add(query_589366, "quotaUser", newJString(quotaUser))
  add(query_589366, "alt", newJString(alt))
  add(query_589366, "oauth_token", newJString(oauthToken))
  add(query_589366, "userIp", newJString(userIp))
  add(query_589366, "key", newJString(key))
  add(path_589365, "instance", newJString(instance))
  add(path_589365, "project", newJString(project))
  if body != nil:
    body_589367 = body
  add(query_589366, "prettyPrint", newJBool(prettyPrint))
  result = call_589364.call(path_589365, query_589366, nil, nil, body_589367)

var sqlInstancesExport* = Call_SqlInstancesExport_589350(
    name: "sqlInstancesExport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/export",
    validator: validate_SqlInstancesExport_589351, base: "/sql/v1beta4",
    url: url_SqlInstancesExport_589352, schemes: {Scheme.Https})
type
  Call_SqlInstancesFailover_589368 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesFailover_589370(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesFailover_589369(path: JsonNode; query: JsonNode;
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
  var valid_589371 = path.getOrDefault("instance")
  valid_589371 = validateParameter(valid_589371, JString, required = true,
                                 default = nil)
  if valid_589371 != nil:
    section.add "instance", valid_589371
  var valid_589372 = path.getOrDefault("project")
  valid_589372 = validateParameter(valid_589372, JString, required = true,
                                 default = nil)
  if valid_589372 != nil:
    section.add "project", valid_589372
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
  var valid_589373 = query.getOrDefault("fields")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "fields", valid_589373
  var valid_589374 = query.getOrDefault("quotaUser")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "quotaUser", valid_589374
  var valid_589375 = query.getOrDefault("alt")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = newJString("json"))
  if valid_589375 != nil:
    section.add "alt", valid_589375
  var valid_589376 = query.getOrDefault("oauth_token")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "oauth_token", valid_589376
  var valid_589377 = query.getOrDefault("userIp")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "userIp", valid_589377
  var valid_589378 = query.getOrDefault("key")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "key", valid_589378
  var valid_589379 = query.getOrDefault("prettyPrint")
  valid_589379 = validateParameter(valid_589379, JBool, required = false,
                                 default = newJBool(true))
  if valid_589379 != nil:
    section.add "prettyPrint", valid_589379
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

proc call*(call_589381: Call_SqlInstancesFailover_589368; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Failover the instance to its failover replica instance.
  ## 
  let valid = call_589381.validator(path, query, header, formData, body)
  let scheme = call_589381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589381.url(scheme.get, call_589381.host, call_589381.base,
                         call_589381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589381, url, valid)

proc call*(call_589382: Call_SqlInstancesFailover_589368; instance: string;
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
  var path_589383 = newJObject()
  var query_589384 = newJObject()
  var body_589385 = newJObject()
  add(query_589384, "fields", newJString(fields))
  add(query_589384, "quotaUser", newJString(quotaUser))
  add(query_589384, "alt", newJString(alt))
  add(query_589384, "oauth_token", newJString(oauthToken))
  add(query_589384, "userIp", newJString(userIp))
  add(query_589384, "key", newJString(key))
  add(path_589383, "instance", newJString(instance))
  add(path_589383, "project", newJString(project))
  if body != nil:
    body_589385 = body
  add(query_589384, "prettyPrint", newJBool(prettyPrint))
  result = call_589382.call(path_589383, query_589384, nil, nil, body_589385)

var sqlInstancesFailover* = Call_SqlInstancesFailover_589368(
    name: "sqlInstancesFailover", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/failover",
    validator: validate_SqlInstancesFailover_589369, base: "/sql/v1beta4",
    url: url_SqlInstancesFailover_589370, schemes: {Scheme.Https})
type
  Call_SqlInstancesImport_589386 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesImport_589388(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesImport_589387(path: JsonNode; query: JsonNode;
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
  var valid_589389 = path.getOrDefault("instance")
  valid_589389 = validateParameter(valid_589389, JString, required = true,
                                 default = nil)
  if valid_589389 != nil:
    section.add "instance", valid_589389
  var valid_589390 = path.getOrDefault("project")
  valid_589390 = validateParameter(valid_589390, JString, required = true,
                                 default = nil)
  if valid_589390 != nil:
    section.add "project", valid_589390
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
  var valid_589391 = query.getOrDefault("fields")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "fields", valid_589391
  var valid_589392 = query.getOrDefault("quotaUser")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "quotaUser", valid_589392
  var valid_589393 = query.getOrDefault("alt")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = newJString("json"))
  if valid_589393 != nil:
    section.add "alt", valid_589393
  var valid_589394 = query.getOrDefault("oauth_token")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "oauth_token", valid_589394
  var valid_589395 = query.getOrDefault("userIp")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "userIp", valid_589395
  var valid_589396 = query.getOrDefault("key")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "key", valid_589396
  var valid_589397 = query.getOrDefault("prettyPrint")
  valid_589397 = validateParameter(valid_589397, JBool, required = false,
                                 default = newJBool(true))
  if valid_589397 != nil:
    section.add "prettyPrint", valid_589397
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

proc call*(call_589399: Call_SqlInstancesImport_589386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports data into a Cloud SQL instance from a SQL dump or CSV file in Cloud Storage.
  ## 
  let valid = call_589399.validator(path, query, header, formData, body)
  let scheme = call_589399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589399.url(scheme.get, call_589399.host, call_589399.base,
                         call_589399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589399, url, valid)

proc call*(call_589400: Call_SqlInstancesImport_589386; instance: string;
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
  var path_589401 = newJObject()
  var query_589402 = newJObject()
  var body_589403 = newJObject()
  add(query_589402, "fields", newJString(fields))
  add(query_589402, "quotaUser", newJString(quotaUser))
  add(query_589402, "alt", newJString(alt))
  add(query_589402, "oauth_token", newJString(oauthToken))
  add(query_589402, "userIp", newJString(userIp))
  add(query_589402, "key", newJString(key))
  add(path_589401, "instance", newJString(instance))
  add(path_589401, "project", newJString(project))
  if body != nil:
    body_589403 = body
  add(query_589402, "prettyPrint", newJBool(prettyPrint))
  result = call_589400.call(path_589401, query_589402, nil, nil, body_589403)

var sqlInstancesImport* = Call_SqlInstancesImport_589386(
    name: "sqlInstancesImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/import",
    validator: validate_SqlInstancesImport_589387, base: "/sql/v1beta4",
    url: url_SqlInstancesImport_589388, schemes: {Scheme.Https})
type
  Call_SqlInstancesListServerCas_589404 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesListServerCas_589406(protocol: Scheme; host: string;
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

proc validate_SqlInstancesListServerCas_589405(path: JsonNode; query: JsonNode;
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
  var valid_589407 = path.getOrDefault("instance")
  valid_589407 = validateParameter(valid_589407, JString, required = true,
                                 default = nil)
  if valid_589407 != nil:
    section.add "instance", valid_589407
  var valid_589408 = path.getOrDefault("project")
  valid_589408 = validateParameter(valid_589408, JString, required = true,
                                 default = nil)
  if valid_589408 != nil:
    section.add "project", valid_589408
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
  var valid_589409 = query.getOrDefault("fields")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "fields", valid_589409
  var valid_589410 = query.getOrDefault("quotaUser")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "quotaUser", valid_589410
  var valid_589411 = query.getOrDefault("alt")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = newJString("json"))
  if valid_589411 != nil:
    section.add "alt", valid_589411
  var valid_589412 = query.getOrDefault("oauth_token")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "oauth_token", valid_589412
  var valid_589413 = query.getOrDefault("userIp")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "userIp", valid_589413
  var valid_589414 = query.getOrDefault("key")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "key", valid_589414
  var valid_589415 = query.getOrDefault("prettyPrint")
  valid_589415 = validateParameter(valid_589415, JBool, required = false,
                                 default = newJBool(true))
  if valid_589415 != nil:
    section.add "prettyPrint", valid_589415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589416: Call_SqlInstancesListServerCas_589404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the trusted Certificate Authorities (CAs) for the specified instance. There can be up to three CAs listed: the CA that was used to sign the certificate that is currently in use, a CA that has been added but not yet used to sign a certificate, and a CA used to sign a certificate that has previously rotated out.
  ## 
  let valid = call_589416.validator(path, query, header, formData, body)
  let scheme = call_589416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589416.url(scheme.get, call_589416.host, call_589416.base,
                         call_589416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589416, url, valid)

proc call*(call_589417: Call_SqlInstancesListServerCas_589404; instance: string;
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
  var path_589418 = newJObject()
  var query_589419 = newJObject()
  add(query_589419, "fields", newJString(fields))
  add(query_589419, "quotaUser", newJString(quotaUser))
  add(query_589419, "alt", newJString(alt))
  add(query_589419, "oauth_token", newJString(oauthToken))
  add(query_589419, "userIp", newJString(userIp))
  add(query_589419, "key", newJString(key))
  add(path_589418, "instance", newJString(instance))
  add(path_589418, "project", newJString(project))
  add(query_589419, "prettyPrint", newJBool(prettyPrint))
  result = call_589417.call(path_589418, query_589419, nil, nil, nil)

var sqlInstancesListServerCas* = Call_SqlInstancesListServerCas_589404(
    name: "sqlInstancesListServerCas", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/listServerCas",
    validator: validate_SqlInstancesListServerCas_589405, base: "/sql/v1beta4",
    url: url_SqlInstancesListServerCas_589406, schemes: {Scheme.Https})
type
  Call_SqlInstancesPromoteReplica_589420 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesPromoteReplica_589422(protocol: Scheme; host: string;
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

proc validate_SqlInstancesPromoteReplica_589421(path: JsonNode; query: JsonNode;
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
  var valid_589423 = path.getOrDefault("instance")
  valid_589423 = validateParameter(valid_589423, JString, required = true,
                                 default = nil)
  if valid_589423 != nil:
    section.add "instance", valid_589423
  var valid_589424 = path.getOrDefault("project")
  valid_589424 = validateParameter(valid_589424, JString, required = true,
                                 default = nil)
  if valid_589424 != nil:
    section.add "project", valid_589424
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
  var valid_589425 = query.getOrDefault("fields")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "fields", valid_589425
  var valid_589426 = query.getOrDefault("quotaUser")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "quotaUser", valid_589426
  var valid_589427 = query.getOrDefault("alt")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = newJString("json"))
  if valid_589427 != nil:
    section.add "alt", valid_589427
  var valid_589428 = query.getOrDefault("oauth_token")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = nil)
  if valid_589428 != nil:
    section.add "oauth_token", valid_589428
  var valid_589429 = query.getOrDefault("userIp")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "userIp", valid_589429
  var valid_589430 = query.getOrDefault("key")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "key", valid_589430
  var valid_589431 = query.getOrDefault("prettyPrint")
  valid_589431 = validateParameter(valid_589431, JBool, required = false,
                                 default = newJBool(true))
  if valid_589431 != nil:
    section.add "prettyPrint", valid_589431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589432: Call_SqlInstancesPromoteReplica_589420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ## 
  let valid = call_589432.validator(path, query, header, formData, body)
  let scheme = call_589432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589432.url(scheme.get, call_589432.host, call_589432.base,
                         call_589432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589432, url, valid)

proc call*(call_589433: Call_SqlInstancesPromoteReplica_589420; instance: string;
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
  var path_589434 = newJObject()
  var query_589435 = newJObject()
  add(query_589435, "fields", newJString(fields))
  add(query_589435, "quotaUser", newJString(quotaUser))
  add(query_589435, "alt", newJString(alt))
  add(query_589435, "oauth_token", newJString(oauthToken))
  add(query_589435, "userIp", newJString(userIp))
  add(query_589435, "key", newJString(key))
  add(path_589434, "instance", newJString(instance))
  add(path_589434, "project", newJString(project))
  add(query_589435, "prettyPrint", newJBool(prettyPrint))
  result = call_589433.call(path_589434, query_589435, nil, nil, nil)

var sqlInstancesPromoteReplica* = Call_SqlInstancesPromoteReplica_589420(
    name: "sqlInstancesPromoteReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/promoteReplica",
    validator: validate_SqlInstancesPromoteReplica_589421, base: "/sql/v1beta4",
    url: url_SqlInstancesPromoteReplica_589422, schemes: {Scheme.Https})
type
  Call_SqlInstancesResetSslConfig_589436 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesResetSslConfig_589438(protocol: Scheme; host: string;
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

proc validate_SqlInstancesResetSslConfig_589437(path: JsonNode; query: JsonNode;
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
  var valid_589439 = path.getOrDefault("instance")
  valid_589439 = validateParameter(valid_589439, JString, required = true,
                                 default = nil)
  if valid_589439 != nil:
    section.add "instance", valid_589439
  var valid_589440 = path.getOrDefault("project")
  valid_589440 = validateParameter(valid_589440, JString, required = true,
                                 default = nil)
  if valid_589440 != nil:
    section.add "project", valid_589440
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
  var valid_589441 = query.getOrDefault("fields")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "fields", valid_589441
  var valid_589442 = query.getOrDefault("quotaUser")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "quotaUser", valid_589442
  var valid_589443 = query.getOrDefault("alt")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = newJString("json"))
  if valid_589443 != nil:
    section.add "alt", valid_589443
  var valid_589444 = query.getOrDefault("oauth_token")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "oauth_token", valid_589444
  var valid_589445 = query.getOrDefault("userIp")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "userIp", valid_589445
  var valid_589446 = query.getOrDefault("key")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "key", valid_589446
  var valid_589447 = query.getOrDefault("prettyPrint")
  valid_589447 = validateParameter(valid_589447, JBool, required = false,
                                 default = newJBool(true))
  if valid_589447 != nil:
    section.add "prettyPrint", valid_589447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589448: Call_SqlInstancesResetSslConfig_589436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all client certificates and generates a new server SSL certificate for the instance.
  ## 
  let valid = call_589448.validator(path, query, header, formData, body)
  let scheme = call_589448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589448.url(scheme.get, call_589448.host, call_589448.base,
                         call_589448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589448, url, valid)

proc call*(call_589449: Call_SqlInstancesResetSslConfig_589436; instance: string;
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
  var path_589450 = newJObject()
  var query_589451 = newJObject()
  add(query_589451, "fields", newJString(fields))
  add(query_589451, "quotaUser", newJString(quotaUser))
  add(query_589451, "alt", newJString(alt))
  add(query_589451, "oauth_token", newJString(oauthToken))
  add(query_589451, "userIp", newJString(userIp))
  add(query_589451, "key", newJString(key))
  add(path_589450, "instance", newJString(instance))
  add(path_589450, "project", newJString(project))
  add(query_589451, "prettyPrint", newJBool(prettyPrint))
  result = call_589449.call(path_589450, query_589451, nil, nil, nil)

var sqlInstancesResetSslConfig* = Call_SqlInstancesResetSslConfig_589436(
    name: "sqlInstancesResetSslConfig", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/resetSslConfig",
    validator: validate_SqlInstancesResetSslConfig_589437, base: "/sql/v1beta4",
    url: url_SqlInstancesResetSslConfig_589438, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestart_589452 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesRestart_589454(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesRestart_589453(path: JsonNode; query: JsonNode;
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
  var valid_589455 = path.getOrDefault("instance")
  valid_589455 = validateParameter(valid_589455, JString, required = true,
                                 default = nil)
  if valid_589455 != nil:
    section.add "instance", valid_589455
  var valid_589456 = path.getOrDefault("project")
  valid_589456 = validateParameter(valid_589456, JString, required = true,
                                 default = nil)
  if valid_589456 != nil:
    section.add "project", valid_589456
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
  var valid_589457 = query.getOrDefault("fields")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "fields", valid_589457
  var valid_589458 = query.getOrDefault("quotaUser")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "quotaUser", valid_589458
  var valid_589459 = query.getOrDefault("alt")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = newJString("json"))
  if valid_589459 != nil:
    section.add "alt", valid_589459
  var valid_589460 = query.getOrDefault("oauth_token")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "oauth_token", valid_589460
  var valid_589461 = query.getOrDefault("userIp")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "userIp", valid_589461
  var valid_589462 = query.getOrDefault("key")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "key", valid_589462
  var valid_589463 = query.getOrDefault("prettyPrint")
  valid_589463 = validateParameter(valid_589463, JBool, required = false,
                                 default = newJBool(true))
  if valid_589463 != nil:
    section.add "prettyPrint", valid_589463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589464: Call_SqlInstancesRestart_589452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a Cloud SQL instance.
  ## 
  let valid = call_589464.validator(path, query, header, formData, body)
  let scheme = call_589464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589464.url(scheme.get, call_589464.host, call_589464.base,
                         call_589464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589464, url, valid)

proc call*(call_589465: Call_SqlInstancesRestart_589452; instance: string;
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
  var path_589466 = newJObject()
  var query_589467 = newJObject()
  add(query_589467, "fields", newJString(fields))
  add(query_589467, "quotaUser", newJString(quotaUser))
  add(query_589467, "alt", newJString(alt))
  add(query_589467, "oauth_token", newJString(oauthToken))
  add(query_589467, "userIp", newJString(userIp))
  add(query_589467, "key", newJString(key))
  add(path_589466, "instance", newJString(instance))
  add(path_589466, "project", newJString(project))
  add(query_589467, "prettyPrint", newJBool(prettyPrint))
  result = call_589465.call(path_589466, query_589467, nil, nil, nil)

var sqlInstancesRestart* = Call_SqlInstancesRestart_589452(
    name: "sqlInstancesRestart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restart",
    validator: validate_SqlInstancesRestart_589453, base: "/sql/v1beta4",
    url: url_SqlInstancesRestart_589454, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestoreBackup_589468 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesRestoreBackup_589470(protocol: Scheme; host: string;
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

proc validate_SqlInstancesRestoreBackup_589469(path: JsonNode; query: JsonNode;
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
  var valid_589471 = path.getOrDefault("instance")
  valid_589471 = validateParameter(valid_589471, JString, required = true,
                                 default = nil)
  if valid_589471 != nil:
    section.add "instance", valid_589471
  var valid_589472 = path.getOrDefault("project")
  valid_589472 = validateParameter(valid_589472, JString, required = true,
                                 default = nil)
  if valid_589472 != nil:
    section.add "project", valid_589472
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
  var valid_589473 = query.getOrDefault("fields")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "fields", valid_589473
  var valid_589474 = query.getOrDefault("quotaUser")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "quotaUser", valid_589474
  var valid_589475 = query.getOrDefault("alt")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = newJString("json"))
  if valid_589475 != nil:
    section.add "alt", valid_589475
  var valid_589476 = query.getOrDefault("oauth_token")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "oauth_token", valid_589476
  var valid_589477 = query.getOrDefault("userIp")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "userIp", valid_589477
  var valid_589478 = query.getOrDefault("key")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "key", valid_589478
  var valid_589479 = query.getOrDefault("prettyPrint")
  valid_589479 = validateParameter(valid_589479, JBool, required = false,
                                 default = newJBool(true))
  if valid_589479 != nil:
    section.add "prettyPrint", valid_589479
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

proc call*(call_589481: Call_SqlInstancesRestoreBackup_589468; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backup of a Cloud SQL instance.
  ## 
  let valid = call_589481.validator(path, query, header, formData, body)
  let scheme = call_589481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589481.url(scheme.get, call_589481.host, call_589481.base,
                         call_589481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589481, url, valid)

proc call*(call_589482: Call_SqlInstancesRestoreBackup_589468; instance: string;
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
  var path_589483 = newJObject()
  var query_589484 = newJObject()
  var body_589485 = newJObject()
  add(query_589484, "fields", newJString(fields))
  add(query_589484, "quotaUser", newJString(quotaUser))
  add(query_589484, "alt", newJString(alt))
  add(query_589484, "oauth_token", newJString(oauthToken))
  add(query_589484, "userIp", newJString(userIp))
  add(query_589484, "key", newJString(key))
  add(path_589483, "instance", newJString(instance))
  add(path_589483, "project", newJString(project))
  if body != nil:
    body_589485 = body
  add(query_589484, "prettyPrint", newJBool(prettyPrint))
  result = call_589482.call(path_589483, query_589484, nil, nil, body_589485)

var sqlInstancesRestoreBackup* = Call_SqlInstancesRestoreBackup_589468(
    name: "sqlInstancesRestoreBackup", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restoreBackup",
    validator: validate_SqlInstancesRestoreBackup_589469, base: "/sql/v1beta4",
    url: url_SqlInstancesRestoreBackup_589470, schemes: {Scheme.Https})
type
  Call_SqlInstancesRotateServerCa_589486 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesRotateServerCa_589488(protocol: Scheme; host: string;
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

proc validate_SqlInstancesRotateServerCa_589487(path: JsonNode; query: JsonNode;
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
  var valid_589489 = path.getOrDefault("instance")
  valid_589489 = validateParameter(valid_589489, JString, required = true,
                                 default = nil)
  if valid_589489 != nil:
    section.add "instance", valid_589489
  var valid_589490 = path.getOrDefault("project")
  valid_589490 = validateParameter(valid_589490, JString, required = true,
                                 default = nil)
  if valid_589490 != nil:
    section.add "project", valid_589490
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
  var valid_589491 = query.getOrDefault("fields")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "fields", valid_589491
  var valid_589492 = query.getOrDefault("quotaUser")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = nil)
  if valid_589492 != nil:
    section.add "quotaUser", valid_589492
  var valid_589493 = query.getOrDefault("alt")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = newJString("json"))
  if valid_589493 != nil:
    section.add "alt", valid_589493
  var valid_589494 = query.getOrDefault("oauth_token")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "oauth_token", valid_589494
  var valid_589495 = query.getOrDefault("userIp")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "userIp", valid_589495
  var valid_589496 = query.getOrDefault("key")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "key", valid_589496
  var valid_589497 = query.getOrDefault("prettyPrint")
  valid_589497 = validateParameter(valid_589497, JBool, required = false,
                                 default = newJBool(true))
  if valid_589497 != nil:
    section.add "prettyPrint", valid_589497
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

proc call*(call_589499: Call_SqlInstancesRotateServerCa_589486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rotates the server certificate to one signed by the Certificate Authority (CA) version previously added with the addServerCA method.
  ## 
  let valid = call_589499.validator(path, query, header, formData, body)
  let scheme = call_589499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589499.url(scheme.get, call_589499.host, call_589499.base,
                         call_589499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589499, url, valid)

proc call*(call_589500: Call_SqlInstancesRotateServerCa_589486; instance: string;
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
  var path_589501 = newJObject()
  var query_589502 = newJObject()
  var body_589503 = newJObject()
  add(query_589502, "fields", newJString(fields))
  add(query_589502, "quotaUser", newJString(quotaUser))
  add(query_589502, "alt", newJString(alt))
  add(query_589502, "oauth_token", newJString(oauthToken))
  add(query_589502, "userIp", newJString(userIp))
  add(query_589502, "key", newJString(key))
  add(path_589501, "instance", newJString(instance))
  add(path_589501, "project", newJString(project))
  if body != nil:
    body_589503 = body
  add(query_589502, "prettyPrint", newJBool(prettyPrint))
  result = call_589500.call(path_589501, query_589502, nil, nil, body_589503)

var sqlInstancesRotateServerCa* = Call_SqlInstancesRotateServerCa_589486(
    name: "sqlInstancesRotateServerCa", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/rotateServerCa",
    validator: validate_SqlInstancesRotateServerCa_589487, base: "/sql/v1beta4",
    url: url_SqlInstancesRotateServerCa_589488, schemes: {Scheme.Https})
type
  Call_SqlSslCertsInsert_589520 = ref object of OpenApiRestCall_588450
proc url_SqlSslCertsInsert_589522(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsInsert_589521(path: JsonNode; query: JsonNode;
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
  var valid_589523 = path.getOrDefault("instance")
  valid_589523 = validateParameter(valid_589523, JString, required = true,
                                 default = nil)
  if valid_589523 != nil:
    section.add "instance", valid_589523
  var valid_589524 = path.getOrDefault("project")
  valid_589524 = validateParameter(valid_589524, JString, required = true,
                                 default = nil)
  if valid_589524 != nil:
    section.add "project", valid_589524
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
  var valid_589525 = query.getOrDefault("fields")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "fields", valid_589525
  var valid_589526 = query.getOrDefault("quotaUser")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "quotaUser", valid_589526
  var valid_589527 = query.getOrDefault("alt")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = newJString("json"))
  if valid_589527 != nil:
    section.add "alt", valid_589527
  var valid_589528 = query.getOrDefault("oauth_token")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "oauth_token", valid_589528
  var valid_589529 = query.getOrDefault("userIp")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "userIp", valid_589529
  var valid_589530 = query.getOrDefault("key")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = nil)
  if valid_589530 != nil:
    section.add "key", valid_589530
  var valid_589531 = query.getOrDefault("prettyPrint")
  valid_589531 = validateParameter(valid_589531, JBool, required = false,
                                 default = newJBool(true))
  if valid_589531 != nil:
    section.add "prettyPrint", valid_589531
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

proc call*(call_589533: Call_SqlSslCertsInsert_589520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an SSL certificate and returns it along with the private key and server certificate authority. The new certificate will not be usable until the instance is restarted.
  ## 
  let valid = call_589533.validator(path, query, header, formData, body)
  let scheme = call_589533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589533.url(scheme.get, call_589533.host, call_589533.base,
                         call_589533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589533, url, valid)

proc call*(call_589534: Call_SqlSslCertsInsert_589520; instance: string;
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
  var path_589535 = newJObject()
  var query_589536 = newJObject()
  var body_589537 = newJObject()
  add(query_589536, "fields", newJString(fields))
  add(query_589536, "quotaUser", newJString(quotaUser))
  add(query_589536, "alt", newJString(alt))
  add(query_589536, "oauth_token", newJString(oauthToken))
  add(query_589536, "userIp", newJString(userIp))
  add(query_589536, "key", newJString(key))
  add(path_589535, "instance", newJString(instance))
  add(path_589535, "project", newJString(project))
  if body != nil:
    body_589537 = body
  add(query_589536, "prettyPrint", newJBool(prettyPrint))
  result = call_589534.call(path_589535, query_589536, nil, nil, body_589537)

var sqlSslCertsInsert* = Call_SqlSslCertsInsert_589520(name: "sqlSslCertsInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsInsert_589521, base: "/sql/v1beta4",
    url: url_SqlSslCertsInsert_589522, schemes: {Scheme.Https})
type
  Call_SqlSslCertsList_589504 = ref object of OpenApiRestCall_588450
proc url_SqlSslCertsList_589506(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsList_589505(path: JsonNode; query: JsonNode;
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
  var valid_589507 = path.getOrDefault("instance")
  valid_589507 = validateParameter(valid_589507, JString, required = true,
                                 default = nil)
  if valid_589507 != nil:
    section.add "instance", valid_589507
  var valid_589508 = path.getOrDefault("project")
  valid_589508 = validateParameter(valid_589508, JString, required = true,
                                 default = nil)
  if valid_589508 != nil:
    section.add "project", valid_589508
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
  var valid_589509 = query.getOrDefault("fields")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "fields", valid_589509
  var valid_589510 = query.getOrDefault("quotaUser")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "quotaUser", valid_589510
  var valid_589511 = query.getOrDefault("alt")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = newJString("json"))
  if valid_589511 != nil:
    section.add "alt", valid_589511
  var valid_589512 = query.getOrDefault("oauth_token")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "oauth_token", valid_589512
  var valid_589513 = query.getOrDefault("userIp")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "userIp", valid_589513
  var valid_589514 = query.getOrDefault("key")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = nil)
  if valid_589514 != nil:
    section.add "key", valid_589514
  var valid_589515 = query.getOrDefault("prettyPrint")
  valid_589515 = validateParameter(valid_589515, JBool, required = false,
                                 default = newJBool(true))
  if valid_589515 != nil:
    section.add "prettyPrint", valid_589515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589516: Call_SqlSslCertsList_589504; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the current SSL certificates for the instance.
  ## 
  let valid = call_589516.validator(path, query, header, formData, body)
  let scheme = call_589516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589516.url(scheme.get, call_589516.host, call_589516.base,
                         call_589516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589516, url, valid)

proc call*(call_589517: Call_SqlSslCertsList_589504; instance: string;
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
  var path_589518 = newJObject()
  var query_589519 = newJObject()
  add(query_589519, "fields", newJString(fields))
  add(query_589519, "quotaUser", newJString(quotaUser))
  add(query_589519, "alt", newJString(alt))
  add(query_589519, "oauth_token", newJString(oauthToken))
  add(query_589519, "userIp", newJString(userIp))
  add(query_589519, "key", newJString(key))
  add(path_589518, "instance", newJString(instance))
  add(path_589518, "project", newJString(project))
  add(query_589519, "prettyPrint", newJBool(prettyPrint))
  result = call_589517.call(path_589518, query_589519, nil, nil, nil)

var sqlSslCertsList* = Call_SqlSslCertsList_589504(name: "sqlSslCertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsList_589505, base: "/sql/v1beta4",
    url: url_SqlSslCertsList_589506, schemes: {Scheme.Https})
type
  Call_SqlSslCertsGet_589538 = ref object of OpenApiRestCall_588450
proc url_SqlSslCertsGet_589540(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsGet_589539(path: JsonNode; query: JsonNode;
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
  var valid_589541 = path.getOrDefault("sha1Fingerprint")
  valid_589541 = validateParameter(valid_589541, JString, required = true,
                                 default = nil)
  if valid_589541 != nil:
    section.add "sha1Fingerprint", valid_589541
  var valid_589542 = path.getOrDefault("instance")
  valid_589542 = validateParameter(valid_589542, JString, required = true,
                                 default = nil)
  if valid_589542 != nil:
    section.add "instance", valid_589542
  var valid_589543 = path.getOrDefault("project")
  valid_589543 = validateParameter(valid_589543, JString, required = true,
                                 default = nil)
  if valid_589543 != nil:
    section.add "project", valid_589543
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
  var valid_589544 = query.getOrDefault("fields")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "fields", valid_589544
  var valid_589545 = query.getOrDefault("quotaUser")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "quotaUser", valid_589545
  var valid_589546 = query.getOrDefault("alt")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = newJString("json"))
  if valid_589546 != nil:
    section.add "alt", valid_589546
  var valid_589547 = query.getOrDefault("oauth_token")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "oauth_token", valid_589547
  var valid_589548 = query.getOrDefault("userIp")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = nil)
  if valid_589548 != nil:
    section.add "userIp", valid_589548
  var valid_589549 = query.getOrDefault("key")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "key", valid_589549
  var valid_589550 = query.getOrDefault("prettyPrint")
  valid_589550 = validateParameter(valid_589550, JBool, required = false,
                                 default = newJBool(true))
  if valid_589550 != nil:
    section.add "prettyPrint", valid_589550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589551: Call_SqlSslCertsGet_589538; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a particular SSL certificate. Does not include the private key (required for usage). The private key must be saved from the response to initial creation.
  ## 
  let valid = call_589551.validator(path, query, header, formData, body)
  let scheme = call_589551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589551.url(scheme.get, call_589551.host, call_589551.base,
                         call_589551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589551, url, valid)

proc call*(call_589552: Call_SqlSslCertsGet_589538; sha1Fingerprint: string;
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
  var path_589553 = newJObject()
  var query_589554 = newJObject()
  add(query_589554, "fields", newJString(fields))
  add(query_589554, "quotaUser", newJString(quotaUser))
  add(query_589554, "alt", newJString(alt))
  add(query_589554, "oauth_token", newJString(oauthToken))
  add(query_589554, "userIp", newJString(userIp))
  add(path_589553, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(query_589554, "key", newJString(key))
  add(path_589553, "instance", newJString(instance))
  add(path_589553, "project", newJString(project))
  add(query_589554, "prettyPrint", newJBool(prettyPrint))
  result = call_589552.call(path_589553, query_589554, nil, nil, nil)

var sqlSslCertsGet* = Call_SqlSslCertsGet_589538(name: "sqlSslCertsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsGet_589539, base: "/sql/v1beta4",
    url: url_SqlSslCertsGet_589540, schemes: {Scheme.Https})
type
  Call_SqlSslCertsDelete_589555 = ref object of OpenApiRestCall_588450
proc url_SqlSslCertsDelete_589557(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsDelete_589556(path: JsonNode; query: JsonNode;
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
  var valid_589558 = path.getOrDefault("sha1Fingerprint")
  valid_589558 = validateParameter(valid_589558, JString, required = true,
                                 default = nil)
  if valid_589558 != nil:
    section.add "sha1Fingerprint", valid_589558
  var valid_589559 = path.getOrDefault("instance")
  valid_589559 = validateParameter(valid_589559, JString, required = true,
                                 default = nil)
  if valid_589559 != nil:
    section.add "instance", valid_589559
  var valid_589560 = path.getOrDefault("project")
  valid_589560 = validateParameter(valid_589560, JString, required = true,
                                 default = nil)
  if valid_589560 != nil:
    section.add "project", valid_589560
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
  var valid_589561 = query.getOrDefault("fields")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "fields", valid_589561
  var valid_589562 = query.getOrDefault("quotaUser")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "quotaUser", valid_589562
  var valid_589563 = query.getOrDefault("alt")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = newJString("json"))
  if valid_589563 != nil:
    section.add "alt", valid_589563
  var valid_589564 = query.getOrDefault("oauth_token")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "oauth_token", valid_589564
  var valid_589565 = query.getOrDefault("userIp")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "userIp", valid_589565
  var valid_589566 = query.getOrDefault("key")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "key", valid_589566
  var valid_589567 = query.getOrDefault("prettyPrint")
  valid_589567 = validateParameter(valid_589567, JBool, required = false,
                                 default = newJBool(true))
  if valid_589567 != nil:
    section.add "prettyPrint", valid_589567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589568: Call_SqlSslCertsDelete_589555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the SSL certificate. For First Generation instances, the certificate remains valid until the instance is restarted.
  ## 
  let valid = call_589568.validator(path, query, header, formData, body)
  let scheme = call_589568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589568.url(scheme.get, call_589568.host, call_589568.base,
                         call_589568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589568, url, valid)

proc call*(call_589569: Call_SqlSslCertsDelete_589555; sha1Fingerprint: string;
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
  var path_589570 = newJObject()
  var query_589571 = newJObject()
  add(query_589571, "fields", newJString(fields))
  add(query_589571, "quotaUser", newJString(quotaUser))
  add(query_589571, "alt", newJString(alt))
  add(query_589571, "oauth_token", newJString(oauthToken))
  add(query_589571, "userIp", newJString(userIp))
  add(path_589570, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(query_589571, "key", newJString(key))
  add(path_589570, "instance", newJString(instance))
  add(path_589570, "project", newJString(project))
  add(query_589571, "prettyPrint", newJBool(prettyPrint))
  result = call_589569.call(path_589570, query_589571, nil, nil, nil)

var sqlSslCertsDelete* = Call_SqlSslCertsDelete_589555(name: "sqlSslCertsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsDelete_589556, base: "/sql/v1beta4",
    url: url_SqlSslCertsDelete_589557, schemes: {Scheme.Https})
type
  Call_SqlInstancesStartReplica_589572 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesStartReplica_589574(protocol: Scheme; host: string;
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

proc validate_SqlInstancesStartReplica_589573(path: JsonNode; query: JsonNode;
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
  var valid_589575 = path.getOrDefault("instance")
  valid_589575 = validateParameter(valid_589575, JString, required = true,
                                 default = nil)
  if valid_589575 != nil:
    section.add "instance", valid_589575
  var valid_589576 = path.getOrDefault("project")
  valid_589576 = validateParameter(valid_589576, JString, required = true,
                                 default = nil)
  if valid_589576 != nil:
    section.add "project", valid_589576
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
  var valid_589577 = query.getOrDefault("fields")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "fields", valid_589577
  var valid_589578 = query.getOrDefault("quotaUser")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "quotaUser", valid_589578
  var valid_589579 = query.getOrDefault("alt")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = newJString("json"))
  if valid_589579 != nil:
    section.add "alt", valid_589579
  var valid_589580 = query.getOrDefault("oauth_token")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "oauth_token", valid_589580
  var valid_589581 = query.getOrDefault("userIp")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = nil)
  if valid_589581 != nil:
    section.add "userIp", valid_589581
  var valid_589582 = query.getOrDefault("key")
  valid_589582 = validateParameter(valid_589582, JString, required = false,
                                 default = nil)
  if valid_589582 != nil:
    section.add "key", valid_589582
  var valid_589583 = query.getOrDefault("prettyPrint")
  valid_589583 = validateParameter(valid_589583, JBool, required = false,
                                 default = newJBool(true))
  if valid_589583 != nil:
    section.add "prettyPrint", valid_589583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589584: Call_SqlInstancesStartReplica_589572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts the replication in the read replica instance.
  ## 
  let valid = call_589584.validator(path, query, header, formData, body)
  let scheme = call_589584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589584.url(scheme.get, call_589584.host, call_589584.base,
                         call_589584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589584, url, valid)

proc call*(call_589585: Call_SqlInstancesStartReplica_589572; instance: string;
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
  var path_589586 = newJObject()
  var query_589587 = newJObject()
  add(query_589587, "fields", newJString(fields))
  add(query_589587, "quotaUser", newJString(quotaUser))
  add(query_589587, "alt", newJString(alt))
  add(query_589587, "oauth_token", newJString(oauthToken))
  add(query_589587, "userIp", newJString(userIp))
  add(query_589587, "key", newJString(key))
  add(path_589586, "instance", newJString(instance))
  add(path_589586, "project", newJString(project))
  add(query_589587, "prettyPrint", newJBool(prettyPrint))
  result = call_589585.call(path_589586, query_589587, nil, nil, nil)

var sqlInstancesStartReplica* = Call_SqlInstancesStartReplica_589572(
    name: "sqlInstancesStartReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/startReplica",
    validator: validate_SqlInstancesStartReplica_589573, base: "/sql/v1beta4",
    url: url_SqlInstancesStartReplica_589574, schemes: {Scheme.Https})
type
  Call_SqlInstancesStopReplica_589588 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesStopReplica_589590(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesStopReplica_589589(path: JsonNode; query: JsonNode;
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
  var valid_589591 = path.getOrDefault("instance")
  valid_589591 = validateParameter(valid_589591, JString, required = true,
                                 default = nil)
  if valid_589591 != nil:
    section.add "instance", valid_589591
  var valid_589592 = path.getOrDefault("project")
  valid_589592 = validateParameter(valid_589592, JString, required = true,
                                 default = nil)
  if valid_589592 != nil:
    section.add "project", valid_589592
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
  var valid_589593 = query.getOrDefault("fields")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "fields", valid_589593
  var valid_589594 = query.getOrDefault("quotaUser")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "quotaUser", valid_589594
  var valid_589595 = query.getOrDefault("alt")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = newJString("json"))
  if valid_589595 != nil:
    section.add "alt", valid_589595
  var valid_589596 = query.getOrDefault("oauth_token")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = nil)
  if valid_589596 != nil:
    section.add "oauth_token", valid_589596
  var valid_589597 = query.getOrDefault("userIp")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "userIp", valid_589597
  var valid_589598 = query.getOrDefault("key")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = nil)
  if valid_589598 != nil:
    section.add "key", valid_589598
  var valid_589599 = query.getOrDefault("prettyPrint")
  valid_589599 = validateParameter(valid_589599, JBool, required = false,
                                 default = newJBool(true))
  if valid_589599 != nil:
    section.add "prettyPrint", valid_589599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589600: Call_SqlInstancesStopReplica_589588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops the replication in the read replica instance.
  ## 
  let valid = call_589600.validator(path, query, header, formData, body)
  let scheme = call_589600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589600.url(scheme.get, call_589600.host, call_589600.base,
                         call_589600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589600, url, valid)

proc call*(call_589601: Call_SqlInstancesStopReplica_589588; instance: string;
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
  var path_589602 = newJObject()
  var query_589603 = newJObject()
  add(query_589603, "fields", newJString(fields))
  add(query_589603, "quotaUser", newJString(quotaUser))
  add(query_589603, "alt", newJString(alt))
  add(query_589603, "oauth_token", newJString(oauthToken))
  add(query_589603, "userIp", newJString(userIp))
  add(query_589603, "key", newJString(key))
  add(path_589602, "instance", newJString(instance))
  add(path_589602, "project", newJString(project))
  add(query_589603, "prettyPrint", newJBool(prettyPrint))
  result = call_589601.call(path_589602, query_589603, nil, nil, nil)

var sqlInstancesStopReplica* = Call_SqlInstancesStopReplica_589588(
    name: "sqlInstancesStopReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/stopReplica",
    validator: validate_SqlInstancesStopReplica_589589, base: "/sql/v1beta4",
    url: url_SqlInstancesStopReplica_589590, schemes: {Scheme.Https})
type
  Call_SqlInstancesTruncateLog_589604 = ref object of OpenApiRestCall_588450
proc url_SqlInstancesTruncateLog_589606(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesTruncateLog_589605(path: JsonNode; query: JsonNode;
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
  var valid_589607 = path.getOrDefault("instance")
  valid_589607 = validateParameter(valid_589607, JString, required = true,
                                 default = nil)
  if valid_589607 != nil:
    section.add "instance", valid_589607
  var valid_589608 = path.getOrDefault("project")
  valid_589608 = validateParameter(valid_589608, JString, required = true,
                                 default = nil)
  if valid_589608 != nil:
    section.add "project", valid_589608
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
  var valid_589609 = query.getOrDefault("fields")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "fields", valid_589609
  var valid_589610 = query.getOrDefault("quotaUser")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = nil)
  if valid_589610 != nil:
    section.add "quotaUser", valid_589610
  var valid_589611 = query.getOrDefault("alt")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = newJString("json"))
  if valid_589611 != nil:
    section.add "alt", valid_589611
  var valid_589612 = query.getOrDefault("oauth_token")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "oauth_token", valid_589612
  var valid_589613 = query.getOrDefault("userIp")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "userIp", valid_589613
  var valid_589614 = query.getOrDefault("key")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "key", valid_589614
  var valid_589615 = query.getOrDefault("prettyPrint")
  valid_589615 = validateParameter(valid_589615, JBool, required = false,
                                 default = newJBool(true))
  if valid_589615 != nil:
    section.add "prettyPrint", valid_589615
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

proc call*(call_589617: Call_SqlInstancesTruncateLog_589604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Truncate MySQL general and slow query log tables
  ## 
  let valid = call_589617.validator(path, query, header, formData, body)
  let scheme = call_589617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589617.url(scheme.get, call_589617.host, call_589617.base,
                         call_589617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589617, url, valid)

proc call*(call_589618: Call_SqlInstancesTruncateLog_589604; instance: string;
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
  var path_589619 = newJObject()
  var query_589620 = newJObject()
  var body_589621 = newJObject()
  add(query_589620, "fields", newJString(fields))
  add(query_589620, "quotaUser", newJString(quotaUser))
  add(query_589620, "alt", newJString(alt))
  add(query_589620, "oauth_token", newJString(oauthToken))
  add(query_589620, "userIp", newJString(userIp))
  add(query_589620, "key", newJString(key))
  add(path_589619, "instance", newJString(instance))
  add(path_589619, "project", newJString(project))
  if body != nil:
    body_589621 = body
  add(query_589620, "prettyPrint", newJBool(prettyPrint))
  result = call_589618.call(path_589619, query_589620, nil, nil, body_589621)

var sqlInstancesTruncateLog* = Call_SqlInstancesTruncateLog_589604(
    name: "sqlInstancesTruncateLog", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/truncateLog",
    validator: validate_SqlInstancesTruncateLog_589605, base: "/sql/v1beta4",
    url: url_SqlInstancesTruncateLog_589606, schemes: {Scheme.Https})
type
  Call_SqlUsersUpdate_589638 = ref object of OpenApiRestCall_588450
proc url_SqlUsersUpdate_589640(protocol: Scheme; host: string; base: string;
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

proc validate_SqlUsersUpdate_589639(path: JsonNode; query: JsonNode;
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
  var valid_589641 = path.getOrDefault("instance")
  valid_589641 = validateParameter(valid_589641, JString, required = true,
                                 default = nil)
  if valid_589641 != nil:
    section.add "instance", valid_589641
  var valid_589642 = path.getOrDefault("project")
  valid_589642 = validateParameter(valid_589642, JString, required = true,
                                 default = nil)
  if valid_589642 != nil:
    section.add "project", valid_589642
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
  var valid_589643 = query.getOrDefault("fields")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "fields", valid_589643
  var valid_589644 = query.getOrDefault("quotaUser")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "quotaUser", valid_589644
  var valid_589645 = query.getOrDefault("alt")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = newJString("json"))
  if valid_589645 != nil:
    section.add "alt", valid_589645
  var valid_589646 = query.getOrDefault("oauth_token")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "oauth_token", valid_589646
  var valid_589647 = query.getOrDefault("userIp")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "userIp", valid_589647
  var valid_589648 = query.getOrDefault("key")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = nil)
  if valid_589648 != nil:
    section.add "key", valid_589648
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_589649 = query.getOrDefault("name")
  valid_589649 = validateParameter(valid_589649, JString, required = true,
                                 default = nil)
  if valid_589649 != nil:
    section.add "name", valid_589649
  var valid_589650 = query.getOrDefault("prettyPrint")
  valid_589650 = validateParameter(valid_589650, JBool, required = false,
                                 default = newJBool(true))
  if valid_589650 != nil:
    section.add "prettyPrint", valid_589650
  var valid_589651 = query.getOrDefault("host")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = nil)
  if valid_589651 != nil:
    section.add "host", valid_589651
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

proc call*(call_589653: Call_SqlUsersUpdate_589638; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing user in a Cloud SQL instance.
  ## 
  let valid = call_589653.validator(path, query, header, formData, body)
  let scheme = call_589653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589653.url(scheme.get, call_589653.host, call_589653.base,
                         call_589653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589653, url, valid)

proc call*(call_589654: Call_SqlUsersUpdate_589638; name: string; instance: string;
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
  var path_589655 = newJObject()
  var query_589656 = newJObject()
  var body_589657 = newJObject()
  add(query_589656, "fields", newJString(fields))
  add(query_589656, "quotaUser", newJString(quotaUser))
  add(query_589656, "alt", newJString(alt))
  add(query_589656, "oauth_token", newJString(oauthToken))
  add(query_589656, "userIp", newJString(userIp))
  add(query_589656, "key", newJString(key))
  add(query_589656, "name", newJString(name))
  add(path_589655, "instance", newJString(instance))
  add(path_589655, "project", newJString(project))
  if body != nil:
    body_589657 = body
  add(query_589656, "prettyPrint", newJBool(prettyPrint))
  add(query_589656, "host", newJString(host))
  result = call_589654.call(path_589655, query_589656, nil, nil, body_589657)

var sqlUsersUpdate* = Call_SqlUsersUpdate_589638(name: "sqlUsersUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersUpdate_589639, base: "/sql/v1beta4",
    url: url_SqlUsersUpdate_589640, schemes: {Scheme.Https})
type
  Call_SqlUsersInsert_589658 = ref object of OpenApiRestCall_588450
proc url_SqlUsersInsert_589660(protocol: Scheme; host: string; base: string;
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

proc validate_SqlUsersInsert_589659(path: JsonNode; query: JsonNode;
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
  var valid_589661 = path.getOrDefault("instance")
  valid_589661 = validateParameter(valid_589661, JString, required = true,
                                 default = nil)
  if valid_589661 != nil:
    section.add "instance", valid_589661
  var valid_589662 = path.getOrDefault("project")
  valid_589662 = validateParameter(valid_589662, JString, required = true,
                                 default = nil)
  if valid_589662 != nil:
    section.add "project", valid_589662
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
  var valid_589663 = query.getOrDefault("fields")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "fields", valid_589663
  var valid_589664 = query.getOrDefault("quotaUser")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "quotaUser", valid_589664
  var valid_589665 = query.getOrDefault("alt")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = newJString("json"))
  if valid_589665 != nil:
    section.add "alt", valid_589665
  var valid_589666 = query.getOrDefault("oauth_token")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "oauth_token", valid_589666
  var valid_589667 = query.getOrDefault("userIp")
  valid_589667 = validateParameter(valid_589667, JString, required = false,
                                 default = nil)
  if valid_589667 != nil:
    section.add "userIp", valid_589667
  var valid_589668 = query.getOrDefault("key")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "key", valid_589668
  var valid_589669 = query.getOrDefault("prettyPrint")
  valid_589669 = validateParameter(valid_589669, JBool, required = false,
                                 default = newJBool(true))
  if valid_589669 != nil:
    section.add "prettyPrint", valid_589669
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

proc call*(call_589671: Call_SqlUsersInsert_589658; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new user in a Cloud SQL instance.
  ## 
  let valid = call_589671.validator(path, query, header, formData, body)
  let scheme = call_589671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589671.url(scheme.get, call_589671.host, call_589671.base,
                         call_589671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589671, url, valid)

proc call*(call_589672: Call_SqlUsersInsert_589658; instance: string;
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
  var path_589673 = newJObject()
  var query_589674 = newJObject()
  var body_589675 = newJObject()
  add(query_589674, "fields", newJString(fields))
  add(query_589674, "quotaUser", newJString(quotaUser))
  add(query_589674, "alt", newJString(alt))
  add(query_589674, "oauth_token", newJString(oauthToken))
  add(query_589674, "userIp", newJString(userIp))
  add(query_589674, "key", newJString(key))
  add(path_589673, "instance", newJString(instance))
  add(path_589673, "project", newJString(project))
  if body != nil:
    body_589675 = body
  add(query_589674, "prettyPrint", newJBool(prettyPrint))
  result = call_589672.call(path_589673, query_589674, nil, nil, body_589675)

var sqlUsersInsert* = Call_SqlUsersInsert_589658(name: "sqlUsersInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersInsert_589659, base: "/sql/v1beta4",
    url: url_SqlUsersInsert_589660, schemes: {Scheme.Https})
type
  Call_SqlUsersList_589622 = ref object of OpenApiRestCall_588450
proc url_SqlUsersList_589624(protocol: Scheme; host: string; base: string;
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

proc validate_SqlUsersList_589623(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589625 = path.getOrDefault("instance")
  valid_589625 = validateParameter(valid_589625, JString, required = true,
                                 default = nil)
  if valid_589625 != nil:
    section.add "instance", valid_589625
  var valid_589626 = path.getOrDefault("project")
  valid_589626 = validateParameter(valid_589626, JString, required = true,
                                 default = nil)
  if valid_589626 != nil:
    section.add "project", valid_589626
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
  var valid_589627 = query.getOrDefault("fields")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "fields", valid_589627
  var valid_589628 = query.getOrDefault("quotaUser")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "quotaUser", valid_589628
  var valid_589629 = query.getOrDefault("alt")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = newJString("json"))
  if valid_589629 != nil:
    section.add "alt", valid_589629
  var valid_589630 = query.getOrDefault("oauth_token")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "oauth_token", valid_589630
  var valid_589631 = query.getOrDefault("userIp")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = nil)
  if valid_589631 != nil:
    section.add "userIp", valid_589631
  var valid_589632 = query.getOrDefault("key")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "key", valid_589632
  var valid_589633 = query.getOrDefault("prettyPrint")
  valid_589633 = validateParameter(valid_589633, JBool, required = false,
                                 default = newJBool(true))
  if valid_589633 != nil:
    section.add "prettyPrint", valid_589633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589634: Call_SqlUsersList_589622; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists users in the specified Cloud SQL instance.
  ## 
  let valid = call_589634.validator(path, query, header, formData, body)
  let scheme = call_589634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589634.url(scheme.get, call_589634.host, call_589634.base,
                         call_589634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589634, url, valid)

proc call*(call_589635: Call_SqlUsersList_589622; instance: string; project: string;
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
  var path_589636 = newJObject()
  var query_589637 = newJObject()
  add(query_589637, "fields", newJString(fields))
  add(query_589637, "quotaUser", newJString(quotaUser))
  add(query_589637, "alt", newJString(alt))
  add(query_589637, "oauth_token", newJString(oauthToken))
  add(query_589637, "userIp", newJString(userIp))
  add(query_589637, "key", newJString(key))
  add(path_589636, "instance", newJString(instance))
  add(path_589636, "project", newJString(project))
  add(query_589637, "prettyPrint", newJBool(prettyPrint))
  result = call_589635.call(path_589636, query_589637, nil, nil, nil)

var sqlUsersList* = Call_SqlUsersList_589622(name: "sqlUsersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersList_589623, base: "/sql/v1beta4",
    url: url_SqlUsersList_589624, schemes: {Scheme.Https})
type
  Call_SqlUsersDelete_589676 = ref object of OpenApiRestCall_588450
proc url_SqlUsersDelete_589678(protocol: Scheme; host: string; base: string;
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

proc validate_SqlUsersDelete_589677(path: JsonNode; query: JsonNode;
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
  var valid_589679 = path.getOrDefault("instance")
  valid_589679 = validateParameter(valid_589679, JString, required = true,
                                 default = nil)
  if valid_589679 != nil:
    section.add "instance", valid_589679
  var valid_589680 = path.getOrDefault("project")
  valid_589680 = validateParameter(valid_589680, JString, required = true,
                                 default = nil)
  if valid_589680 != nil:
    section.add "project", valid_589680
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
  var valid_589681 = query.getOrDefault("fields")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = nil)
  if valid_589681 != nil:
    section.add "fields", valid_589681
  var valid_589682 = query.getOrDefault("quotaUser")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "quotaUser", valid_589682
  var valid_589683 = query.getOrDefault("alt")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = newJString("json"))
  if valid_589683 != nil:
    section.add "alt", valid_589683
  var valid_589684 = query.getOrDefault("oauth_token")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "oauth_token", valid_589684
  var valid_589685 = query.getOrDefault("userIp")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = nil)
  if valid_589685 != nil:
    section.add "userIp", valid_589685
  var valid_589686 = query.getOrDefault("key")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "key", valid_589686
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_589687 = query.getOrDefault("name")
  valid_589687 = validateParameter(valid_589687, JString, required = true,
                                 default = nil)
  if valid_589687 != nil:
    section.add "name", valid_589687
  var valid_589688 = query.getOrDefault("prettyPrint")
  valid_589688 = validateParameter(valid_589688, JBool, required = false,
                                 default = newJBool(true))
  if valid_589688 != nil:
    section.add "prettyPrint", valid_589688
  var valid_589689 = query.getOrDefault("host")
  valid_589689 = validateParameter(valid_589689, JString, required = true,
                                 default = nil)
  if valid_589689 != nil:
    section.add "host", valid_589689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589690: Call_SqlUsersDelete_589676; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a user from a Cloud SQL instance.
  ## 
  let valid = call_589690.validator(path, query, header, formData, body)
  let scheme = call_589690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589690.url(scheme.get, call_589690.host, call_589690.base,
                         call_589690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589690, url, valid)

proc call*(call_589691: Call_SqlUsersDelete_589676; name: string; instance: string;
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
  var path_589692 = newJObject()
  var query_589693 = newJObject()
  add(query_589693, "fields", newJString(fields))
  add(query_589693, "quotaUser", newJString(quotaUser))
  add(query_589693, "alt", newJString(alt))
  add(query_589693, "oauth_token", newJString(oauthToken))
  add(query_589693, "userIp", newJString(userIp))
  add(query_589693, "key", newJString(key))
  add(query_589693, "name", newJString(name))
  add(path_589692, "instance", newJString(instance))
  add(path_589692, "project", newJString(project))
  add(query_589693, "prettyPrint", newJBool(prettyPrint))
  add(query_589693, "host", newJString(host))
  result = call_589691.call(path_589692, query_589693, nil, nil, nil)

var sqlUsersDelete* = Call_SqlUsersDelete_589676(name: "sqlUsersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersDelete_589677, base: "/sql/v1beta4",
    url: url_SqlUsersDelete_589678, schemes: {Scheme.Https})
type
  Call_SqlOperationsList_589694 = ref object of OpenApiRestCall_588450
proc url_SqlOperationsList_589696(protocol: Scheme; host: string; base: string;
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

proc validate_SqlOperationsList_589695(path: JsonNode; query: JsonNode;
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
  var valid_589697 = path.getOrDefault("project")
  valid_589697 = validateParameter(valid_589697, JString, required = true,
                                 default = nil)
  if valid_589697 != nil:
    section.add "project", valid_589697
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
  var valid_589698 = query.getOrDefault("fields")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "fields", valid_589698
  var valid_589699 = query.getOrDefault("pageToken")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = nil)
  if valid_589699 != nil:
    section.add "pageToken", valid_589699
  var valid_589700 = query.getOrDefault("quotaUser")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = nil)
  if valid_589700 != nil:
    section.add "quotaUser", valid_589700
  var valid_589701 = query.getOrDefault("alt")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = newJString("json"))
  if valid_589701 != nil:
    section.add "alt", valid_589701
  var valid_589702 = query.getOrDefault("oauth_token")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "oauth_token", valid_589702
  var valid_589703 = query.getOrDefault("userIp")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "userIp", valid_589703
  var valid_589704 = query.getOrDefault("maxResults")
  valid_589704 = validateParameter(valid_589704, JInt, required = false, default = nil)
  if valid_589704 != nil:
    section.add "maxResults", valid_589704
  var valid_589705 = query.getOrDefault("key")
  valid_589705 = validateParameter(valid_589705, JString, required = false,
                                 default = nil)
  if valid_589705 != nil:
    section.add "key", valid_589705
  assert query != nil,
        "query argument is necessary due to required `instance` field"
  var valid_589706 = query.getOrDefault("instance")
  valid_589706 = validateParameter(valid_589706, JString, required = true,
                                 default = nil)
  if valid_589706 != nil:
    section.add "instance", valid_589706
  var valid_589707 = query.getOrDefault("prettyPrint")
  valid_589707 = validateParameter(valid_589707, JBool, required = false,
                                 default = newJBool(true))
  if valid_589707 != nil:
    section.add "prettyPrint", valid_589707
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589708: Call_SqlOperationsList_589694; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all instance operations that have been performed on the given Cloud SQL instance in the reverse chronological order of the start time.
  ## 
  let valid = call_589708.validator(path, query, header, formData, body)
  let scheme = call_589708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589708.url(scheme.get, call_589708.host, call_589708.base,
                         call_589708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589708, url, valid)

proc call*(call_589709: Call_SqlOperationsList_589694; instance: string;
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
  var path_589710 = newJObject()
  var query_589711 = newJObject()
  add(query_589711, "fields", newJString(fields))
  add(query_589711, "pageToken", newJString(pageToken))
  add(query_589711, "quotaUser", newJString(quotaUser))
  add(query_589711, "alt", newJString(alt))
  add(query_589711, "oauth_token", newJString(oauthToken))
  add(query_589711, "userIp", newJString(userIp))
  add(query_589711, "maxResults", newJInt(maxResults))
  add(query_589711, "key", newJString(key))
  add(query_589711, "instance", newJString(instance))
  add(path_589710, "project", newJString(project))
  add(query_589711, "prettyPrint", newJBool(prettyPrint))
  result = call_589709.call(path_589710, query_589711, nil, nil, nil)

var sqlOperationsList* = Call_SqlOperationsList_589694(name: "sqlOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/operations",
    validator: validate_SqlOperationsList_589695, base: "/sql/v1beta4",
    url: url_SqlOperationsList_589696, schemes: {Scheme.Https})
type
  Call_SqlOperationsGet_589712 = ref object of OpenApiRestCall_588450
proc url_SqlOperationsGet_589714(protocol: Scheme; host: string; base: string;
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

proc validate_SqlOperationsGet_589713(path: JsonNode; query: JsonNode;
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
  var valid_589715 = path.getOrDefault("operation")
  valid_589715 = validateParameter(valid_589715, JString, required = true,
                                 default = nil)
  if valid_589715 != nil:
    section.add "operation", valid_589715
  var valid_589716 = path.getOrDefault("project")
  valid_589716 = validateParameter(valid_589716, JString, required = true,
                                 default = nil)
  if valid_589716 != nil:
    section.add "project", valid_589716
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
  var valid_589717 = query.getOrDefault("fields")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = nil)
  if valid_589717 != nil:
    section.add "fields", valid_589717
  var valid_589718 = query.getOrDefault("quotaUser")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "quotaUser", valid_589718
  var valid_589719 = query.getOrDefault("alt")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = newJString("json"))
  if valid_589719 != nil:
    section.add "alt", valid_589719
  var valid_589720 = query.getOrDefault("oauth_token")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "oauth_token", valid_589720
  var valid_589721 = query.getOrDefault("userIp")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "userIp", valid_589721
  var valid_589722 = query.getOrDefault("key")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "key", valid_589722
  var valid_589723 = query.getOrDefault("prettyPrint")
  valid_589723 = validateParameter(valid_589723, JBool, required = false,
                                 default = newJBool(true))
  if valid_589723 != nil:
    section.add "prettyPrint", valid_589723
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589724: Call_SqlOperationsGet_589712; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an instance operation that has been performed on an instance.
  ## 
  let valid = call_589724.validator(path, query, header, formData, body)
  let scheme = call_589724.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589724.url(scheme.get, call_589724.host, call_589724.base,
                         call_589724.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589724, url, valid)

proc call*(call_589725: Call_SqlOperationsGet_589712; operation: string;
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
  var path_589726 = newJObject()
  var query_589727 = newJObject()
  add(query_589727, "fields", newJString(fields))
  add(query_589727, "quotaUser", newJString(quotaUser))
  add(query_589727, "alt", newJString(alt))
  add(path_589726, "operation", newJString(operation))
  add(query_589727, "oauth_token", newJString(oauthToken))
  add(query_589727, "userIp", newJString(userIp))
  add(query_589727, "key", newJString(key))
  add(path_589726, "project", newJString(project))
  add(query_589727, "prettyPrint", newJBool(prettyPrint))
  result = call_589725.call(path_589726, query_589727, nil, nil, nil)

var sqlOperationsGet* = Call_SqlOperationsGet_589712(name: "sqlOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/operations/{operation}",
    validator: validate_SqlOperationsGet_589713, base: "/sql/v1beta4",
    url: url_SqlOperationsGet_589714, schemes: {Scheme.Https})
type
  Call_SqlTiersList_589728 = ref object of OpenApiRestCall_588450
proc url_SqlTiersList_589730(protocol: Scheme; host: string; base: string;
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

proc validate_SqlTiersList_589729(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589731 = path.getOrDefault("project")
  valid_589731 = validateParameter(valid_589731, JString, required = true,
                                 default = nil)
  if valid_589731 != nil:
    section.add "project", valid_589731
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
  var valid_589732 = query.getOrDefault("fields")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = nil)
  if valid_589732 != nil:
    section.add "fields", valid_589732
  var valid_589733 = query.getOrDefault("quotaUser")
  valid_589733 = validateParameter(valid_589733, JString, required = false,
                                 default = nil)
  if valid_589733 != nil:
    section.add "quotaUser", valid_589733
  var valid_589734 = query.getOrDefault("alt")
  valid_589734 = validateParameter(valid_589734, JString, required = false,
                                 default = newJString("json"))
  if valid_589734 != nil:
    section.add "alt", valid_589734
  var valid_589735 = query.getOrDefault("oauth_token")
  valid_589735 = validateParameter(valid_589735, JString, required = false,
                                 default = nil)
  if valid_589735 != nil:
    section.add "oauth_token", valid_589735
  var valid_589736 = query.getOrDefault("userIp")
  valid_589736 = validateParameter(valid_589736, JString, required = false,
                                 default = nil)
  if valid_589736 != nil:
    section.add "userIp", valid_589736
  var valid_589737 = query.getOrDefault("key")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = nil)
  if valid_589737 != nil:
    section.add "key", valid_589737
  var valid_589738 = query.getOrDefault("prettyPrint")
  valid_589738 = validateParameter(valid_589738, JBool, required = false,
                                 default = newJBool(true))
  if valid_589738 != nil:
    section.add "prettyPrint", valid_589738
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589739: Call_SqlTiersList_589728; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available machine types (tiers) for Cloud SQL, for example, db-n1-standard-1. For related information, see Pricing.
  ## 
  let valid = call_589739.validator(path, query, header, formData, body)
  let scheme = call_589739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589739.url(scheme.get, call_589739.host, call_589739.base,
                         call_589739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589739, url, valid)

proc call*(call_589740: Call_SqlTiersList_589728; project: string;
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
  var path_589741 = newJObject()
  var query_589742 = newJObject()
  add(query_589742, "fields", newJString(fields))
  add(query_589742, "quotaUser", newJString(quotaUser))
  add(query_589742, "alt", newJString(alt))
  add(query_589742, "oauth_token", newJString(oauthToken))
  add(query_589742, "userIp", newJString(userIp))
  add(query_589742, "key", newJString(key))
  add(path_589741, "project", newJString(project))
  add(query_589742, "prettyPrint", newJBool(prettyPrint))
  result = call_589740.call(path_589741, query_589742, nil, nil, nil)

var sqlTiersList* = Call_SqlTiersList_589728(name: "sqlTiersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/tiers", validator: validate_SqlTiersList_589729,
    base: "/sql/v1beta4", url: url_SqlTiersList_589730, schemes: {Scheme.Https})
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
