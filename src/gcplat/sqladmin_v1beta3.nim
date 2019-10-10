
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  Call_SqlFlagsList_588709 = ref object of OpenApiRestCall_588441
proc url_SqlFlagsList_588711(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SqlFlagsList_588710(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all database flags that can be set for Google Cloud SQL instances.
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
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588824 = query.getOrDefault("quotaUser")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "quotaUser", valid_588824
  var valid_588838 = query.getOrDefault("alt")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = newJString("json"))
  if valid_588838 != nil:
    section.add "alt", valid_588838
  var valid_588839 = query.getOrDefault("oauth_token")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "oauth_token", valid_588839
  var valid_588840 = query.getOrDefault("userIp")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "userIp", valid_588840
  var valid_588841 = query.getOrDefault("key")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "key", valid_588841
  var valid_588842 = query.getOrDefault("prettyPrint")
  valid_588842 = validateParameter(valid_588842, JBool, required = false,
                                 default = newJBool(true))
  if valid_588842 != nil:
    section.add "prettyPrint", valid_588842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588865: Call_SqlFlagsList_588709; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all database flags that can be set for Google Cloud SQL instances.
  ## 
  let valid = call_588865.validator(path, query, header, formData, body)
  let scheme = call_588865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588865.url(scheme.get, call_588865.host, call_588865.base,
                         call_588865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588865, url, valid)

proc call*(call_588936: Call_SqlFlagsList_588709; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlFlagsList
  ## Lists all database flags that can be set for Google Cloud SQL instances.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588937 = newJObject()
  add(query_588937, "fields", newJString(fields))
  add(query_588937, "quotaUser", newJString(quotaUser))
  add(query_588937, "alt", newJString(alt))
  add(query_588937, "oauth_token", newJString(oauthToken))
  add(query_588937, "userIp", newJString(userIp))
  add(query_588937, "key", newJString(key))
  add(query_588937, "prettyPrint", newJBool(prettyPrint))
  result = call_588936.call(nil, query_588937, nil, nil, nil)

var sqlFlagsList* = Call_SqlFlagsList_588709(name: "sqlFlagsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/flags",
    validator: validate_SqlFlagsList_588710, base: "/sql/v1beta3",
    url: url_SqlFlagsList_588711, schemes: {Scheme.Https})
type
  Call_SqlInstancesInsert_589008 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesInsert_589010(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesInsert_589009(path: JsonNode; query: JsonNode;
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
  var valid_589011 = path.getOrDefault("project")
  valid_589011 = validateParameter(valid_589011, JString, required = true,
                                 default = nil)
  if valid_589011 != nil:
    section.add "project", valid_589011
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
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("userIp")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "userIp", valid_589016
  var valid_589017 = query.getOrDefault("key")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "key", valid_589017
  var valid_589018 = query.getOrDefault("prettyPrint")
  valid_589018 = validateParameter(valid_589018, JBool, required = false,
                                 default = newJBool(true))
  if valid_589018 != nil:
    section.add "prettyPrint", valid_589018
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

proc call*(call_589020: Call_SqlInstancesInsert_589008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Cloud SQL instance.
  ## 
  let valid = call_589020.validator(path, query, header, formData, body)
  let scheme = call_589020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589020.url(scheme.get, call_589020.host, call_589020.base,
                         call_589020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589020, url, valid)

proc call*(call_589021: Call_SqlInstancesInsert_589008; project: string;
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
  var path_589022 = newJObject()
  var query_589023 = newJObject()
  var body_589024 = newJObject()
  add(query_589023, "fields", newJString(fields))
  add(query_589023, "quotaUser", newJString(quotaUser))
  add(query_589023, "alt", newJString(alt))
  add(query_589023, "oauth_token", newJString(oauthToken))
  add(query_589023, "userIp", newJString(userIp))
  add(query_589023, "key", newJString(key))
  add(path_589022, "project", newJString(project))
  if body != nil:
    body_589024 = body
  add(query_589023, "prettyPrint", newJBool(prettyPrint))
  result = call_589021.call(path_589022, query_589023, nil, nil, body_589024)

var sqlInstancesInsert* = Call_SqlInstancesInsert_589008(
    name: "sqlInstancesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{project}/instances",
    validator: validate_SqlInstancesInsert_589009, base: "/sql/v1beta3",
    url: url_SqlInstancesInsert_589010, schemes: {Scheme.Https})
type
  Call_SqlInstancesList_588977 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesList_588979(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesList_588978(path: JsonNode; query: JsonNode;
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
  var valid_588994 = path.getOrDefault("project")
  valid_588994 = validateParameter(valid_588994, JString, required = true,
                                 default = nil)
  if valid_588994 != nil:
    section.add "project", valid_588994
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
  section = newJObject()
  var valid_588995 = query.getOrDefault("fields")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "fields", valid_588995
  var valid_588996 = query.getOrDefault("pageToken")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "pageToken", valid_588996
  var valid_588997 = query.getOrDefault("quotaUser")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "quotaUser", valid_588997
  var valid_588998 = query.getOrDefault("alt")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = newJString("json"))
  if valid_588998 != nil:
    section.add "alt", valid_588998
  var valid_588999 = query.getOrDefault("oauth_token")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "oauth_token", valid_588999
  var valid_589000 = query.getOrDefault("userIp")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "userIp", valid_589000
  var valid_589001 = query.getOrDefault("maxResults")
  valid_589001 = validateParameter(valid_589001, JInt, required = false, default = nil)
  if valid_589001 != nil:
    section.add "maxResults", valid_589001
  var valid_589002 = query.getOrDefault("key")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "key", valid_589002
  var valid_589003 = query.getOrDefault("prettyPrint")
  valid_589003 = validateParameter(valid_589003, JBool, required = false,
                                 default = newJBool(true))
  if valid_589003 != nil:
    section.add "prettyPrint", valid_589003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589004: Call_SqlInstancesList_588977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists instances for a given project, in alphabetical order by instance name.
  ## 
  let valid = call_589004.validator(path, query, header, formData, body)
  let scheme = call_589004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589004.url(scheme.get, call_589004.host, call_589004.base,
                         call_589004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589004, url, valid)

proc call*(call_589005: Call_SqlInstancesList_588977; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesList
  ## Lists instances for a given project, in alphabetical order by instance name.
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
  var path_589006 = newJObject()
  var query_589007 = newJObject()
  add(query_589007, "fields", newJString(fields))
  add(query_589007, "pageToken", newJString(pageToken))
  add(query_589007, "quotaUser", newJString(quotaUser))
  add(query_589007, "alt", newJString(alt))
  add(query_589007, "oauth_token", newJString(oauthToken))
  add(query_589007, "userIp", newJString(userIp))
  add(query_589007, "maxResults", newJInt(maxResults))
  add(query_589007, "key", newJString(key))
  add(path_589006, "project", newJString(project))
  add(query_589007, "prettyPrint", newJBool(prettyPrint))
  result = call_589005.call(path_589006, query_589007, nil, nil, nil)

var sqlInstancesList* = Call_SqlInstancesList_588977(name: "sqlInstancesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances", validator: validate_SqlInstancesList_588978,
    base: "/sql/v1beta3", url: url_SqlInstancesList_588979, schemes: {Scheme.Https})
type
  Call_SqlInstancesClone_589025 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesClone_589027(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesClone_589026(path: JsonNode; query: JsonNode;
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
  var valid_589028 = path.getOrDefault("project")
  valid_589028 = validateParameter(valid_589028, JString, required = true,
                                 default = nil)
  if valid_589028 != nil:
    section.add "project", valid_589028
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
  var valid_589029 = query.getOrDefault("fields")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "fields", valid_589029
  var valid_589030 = query.getOrDefault("quotaUser")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "quotaUser", valid_589030
  var valid_589031 = query.getOrDefault("alt")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("json"))
  if valid_589031 != nil:
    section.add "alt", valid_589031
  var valid_589032 = query.getOrDefault("oauth_token")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "oauth_token", valid_589032
  var valid_589033 = query.getOrDefault("userIp")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "userIp", valid_589033
  var valid_589034 = query.getOrDefault("key")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "key", valid_589034
  var valid_589035 = query.getOrDefault("prettyPrint")
  valid_589035 = validateParameter(valid_589035, JBool, required = false,
                                 default = newJBool(true))
  if valid_589035 != nil:
    section.add "prettyPrint", valid_589035
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

proc call*(call_589037: Call_SqlInstancesClone_589025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud SQL instance as a clone of a source instance.
  ## 
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_SqlInstancesClone_589025; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesClone
  ## Creates a Cloud SQL instance as a clone of a source instance.
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
  ##          : Project ID of the source as well as the clone Cloud SQL instance.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589039 = newJObject()
  var query_589040 = newJObject()
  var body_589041 = newJObject()
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "userIp", newJString(userIp))
  add(query_589040, "key", newJString(key))
  add(path_589039, "project", newJString(project))
  if body != nil:
    body_589041 = body
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  result = call_589038.call(path_589039, query_589040, nil, nil, body_589041)

var sqlInstancesClone* = Call_SqlInstancesClone_589025(name: "sqlInstancesClone",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/clone",
    validator: validate_SqlInstancesClone_589026, base: "/sql/v1beta3",
    url: url_SqlInstancesClone_589027, schemes: {Scheme.Https})
type
  Call_SqlInstancesUpdate_589058 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesUpdate_589060(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesUpdate_589059(path: JsonNode; query: JsonNode;
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
  var valid_589061 = path.getOrDefault("instance")
  valid_589061 = validateParameter(valid_589061, JString, required = true,
                                 default = nil)
  if valid_589061 != nil:
    section.add "instance", valid_589061
  var valid_589062 = path.getOrDefault("project")
  valid_589062 = validateParameter(valid_589062, JString, required = true,
                                 default = nil)
  if valid_589062 != nil:
    section.add "project", valid_589062
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
  var valid_589063 = query.getOrDefault("fields")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "fields", valid_589063
  var valid_589064 = query.getOrDefault("quotaUser")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "quotaUser", valid_589064
  var valid_589065 = query.getOrDefault("alt")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("json"))
  if valid_589065 != nil:
    section.add "alt", valid_589065
  var valid_589066 = query.getOrDefault("oauth_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "oauth_token", valid_589066
  var valid_589067 = query.getOrDefault("userIp")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "userIp", valid_589067
  var valid_589068 = query.getOrDefault("key")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "key", valid_589068
  var valid_589069 = query.getOrDefault("prettyPrint")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "prettyPrint", valid_589069
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

proc call*(call_589071: Call_SqlInstancesUpdate_589058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the settings of a Cloud SQL instance.
  ## 
  let valid = call_589071.validator(path, query, header, formData, body)
  let scheme = call_589071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589071.url(scheme.get, call_589071.host, call_589071.base,
                         call_589071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589071, url, valid)

proc call*(call_589072: Call_SqlInstancesUpdate_589058; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesUpdate
  ## Updates the settings of a Cloud SQL instance.
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
  var path_589073 = newJObject()
  var query_589074 = newJObject()
  var body_589075 = newJObject()
  add(query_589074, "fields", newJString(fields))
  add(query_589074, "quotaUser", newJString(quotaUser))
  add(query_589074, "alt", newJString(alt))
  add(query_589074, "oauth_token", newJString(oauthToken))
  add(query_589074, "userIp", newJString(userIp))
  add(query_589074, "key", newJString(key))
  add(path_589073, "instance", newJString(instance))
  add(path_589073, "project", newJString(project))
  if body != nil:
    body_589075 = body
  add(query_589074, "prettyPrint", newJBool(prettyPrint))
  result = call_589072.call(path_589073, query_589074, nil, nil, body_589075)

var sqlInstancesUpdate* = Call_SqlInstancesUpdate_589058(
    name: "sqlInstancesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesUpdate_589059, base: "/sql/v1beta3",
    url: url_SqlInstancesUpdate_589060, schemes: {Scheme.Https})
type
  Call_SqlInstancesGet_589042 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesGet_589044(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesGet_589043(path: JsonNode; query: JsonNode;
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
  var valid_589045 = path.getOrDefault("instance")
  valid_589045 = validateParameter(valid_589045, JString, required = true,
                                 default = nil)
  if valid_589045 != nil:
    section.add "instance", valid_589045
  var valid_589046 = path.getOrDefault("project")
  valid_589046 = validateParameter(valid_589046, JString, required = true,
                                 default = nil)
  if valid_589046 != nil:
    section.add "project", valid_589046
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
  var valid_589047 = query.getOrDefault("fields")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "fields", valid_589047
  var valid_589048 = query.getOrDefault("quotaUser")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "quotaUser", valid_589048
  var valid_589049 = query.getOrDefault("alt")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("json"))
  if valid_589049 != nil:
    section.add "alt", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("userIp")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "userIp", valid_589051
  var valid_589052 = query.getOrDefault("key")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "key", valid_589052
  var valid_589053 = query.getOrDefault("prettyPrint")
  valid_589053 = validateParameter(valid_589053, JBool, required = false,
                                 default = newJBool(true))
  if valid_589053 != nil:
    section.add "prettyPrint", valid_589053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589054: Call_SqlInstancesGet_589042; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a Cloud SQL instance.
  ## 
  let valid = call_589054.validator(path, query, header, formData, body)
  let scheme = call_589054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589054.url(scheme.get, call_589054.host, call_589054.base,
                         call_589054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589054, url, valid)

proc call*(call_589055: Call_SqlInstancesGet_589042; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesGet
  ## Retrieves information about a Cloud SQL instance.
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
  var path_589056 = newJObject()
  var query_589057 = newJObject()
  add(query_589057, "fields", newJString(fields))
  add(query_589057, "quotaUser", newJString(quotaUser))
  add(query_589057, "alt", newJString(alt))
  add(query_589057, "oauth_token", newJString(oauthToken))
  add(query_589057, "userIp", newJString(userIp))
  add(query_589057, "key", newJString(key))
  add(path_589056, "instance", newJString(instance))
  add(path_589056, "project", newJString(project))
  add(query_589057, "prettyPrint", newJBool(prettyPrint))
  result = call_589055.call(path_589056, query_589057, nil, nil, nil)

var sqlInstancesGet* = Call_SqlInstancesGet_589042(name: "sqlInstancesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesGet_589043, base: "/sql/v1beta3",
    url: url_SqlInstancesGet_589044, schemes: {Scheme.Https})
type
  Call_SqlInstancesPatch_589092 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesPatch_589094(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesPatch_589093(path: JsonNode; query: JsonNode;
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
  var valid_589095 = path.getOrDefault("instance")
  valid_589095 = validateParameter(valid_589095, JString, required = true,
                                 default = nil)
  if valid_589095 != nil:
    section.add "instance", valid_589095
  var valid_589096 = path.getOrDefault("project")
  valid_589096 = validateParameter(valid_589096, JString, required = true,
                                 default = nil)
  if valid_589096 != nil:
    section.add "project", valid_589096
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
  var valid_589097 = query.getOrDefault("fields")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "fields", valid_589097
  var valid_589098 = query.getOrDefault("quotaUser")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "quotaUser", valid_589098
  var valid_589099 = query.getOrDefault("alt")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = newJString("json"))
  if valid_589099 != nil:
    section.add "alt", valid_589099
  var valid_589100 = query.getOrDefault("oauth_token")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "oauth_token", valid_589100
  var valid_589101 = query.getOrDefault("userIp")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "userIp", valid_589101
  var valid_589102 = query.getOrDefault("key")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "key", valid_589102
  var valid_589103 = query.getOrDefault("prettyPrint")
  valid_589103 = validateParameter(valid_589103, JBool, required = false,
                                 default = newJBool(true))
  if valid_589103 != nil:
    section.add "prettyPrint", valid_589103
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

proc call*(call_589105: Call_SqlInstancesPatch_589092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the settings of a Cloud SQL instance. This method supports patch semantics.
  ## 
  let valid = call_589105.validator(path, query, header, formData, body)
  let scheme = call_589105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589105.url(scheme.get, call_589105.host, call_589105.base,
                         call_589105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589105, url, valid)

proc call*(call_589106: Call_SqlInstancesPatch_589092; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesPatch
  ## Updates the settings of a Cloud SQL instance. This method supports patch semantics.
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
  var path_589107 = newJObject()
  var query_589108 = newJObject()
  var body_589109 = newJObject()
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(query_589108, "alt", newJString(alt))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "userIp", newJString(userIp))
  add(query_589108, "key", newJString(key))
  add(path_589107, "instance", newJString(instance))
  add(path_589107, "project", newJString(project))
  if body != nil:
    body_589109 = body
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589106.call(path_589107, query_589108, nil, nil, body_589109)

var sqlInstancesPatch* = Call_SqlInstancesPatch_589092(name: "sqlInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesPatch_589093, base: "/sql/v1beta3",
    url: url_SqlInstancesPatch_589094, schemes: {Scheme.Https})
type
  Call_SqlInstancesDelete_589076 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesDelete_589078(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesDelete_589077(path: JsonNode; query: JsonNode;
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
  var valid_589079 = path.getOrDefault("instance")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "instance", valid_589079
  var valid_589080 = path.getOrDefault("project")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "project", valid_589080
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
  var valid_589081 = query.getOrDefault("fields")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "fields", valid_589081
  var valid_589082 = query.getOrDefault("quotaUser")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "quotaUser", valid_589082
  var valid_589083 = query.getOrDefault("alt")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = newJString("json"))
  if valid_589083 != nil:
    section.add "alt", valid_589083
  var valid_589084 = query.getOrDefault("oauth_token")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "oauth_token", valid_589084
  var valid_589085 = query.getOrDefault("userIp")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "userIp", valid_589085
  var valid_589086 = query.getOrDefault("key")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "key", valid_589086
  var valid_589087 = query.getOrDefault("prettyPrint")
  valid_589087 = validateParameter(valid_589087, JBool, required = false,
                                 default = newJBool(true))
  if valid_589087 != nil:
    section.add "prettyPrint", valid_589087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589088: Call_SqlInstancesDelete_589076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cloud SQL instance.
  ## 
  let valid = call_589088.validator(path, query, header, formData, body)
  let scheme = call_589088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589088.url(scheme.get, call_589088.host, call_589088.base,
                         call_589088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589088, url, valid)

proc call*(call_589089: Call_SqlInstancesDelete_589076; instance: string;
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
  var path_589090 = newJObject()
  var query_589091 = newJObject()
  add(query_589091, "fields", newJString(fields))
  add(query_589091, "quotaUser", newJString(quotaUser))
  add(query_589091, "alt", newJString(alt))
  add(query_589091, "oauth_token", newJString(oauthToken))
  add(query_589091, "userIp", newJString(userIp))
  add(query_589091, "key", newJString(key))
  add(path_589090, "instance", newJString(instance))
  add(path_589090, "project", newJString(project))
  add(query_589091, "prettyPrint", newJBool(prettyPrint))
  result = call_589089.call(path_589090, query_589091, nil, nil, nil)

var sqlInstancesDelete* = Call_SqlInstancesDelete_589076(
    name: "sqlInstancesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesDelete_589077, base: "/sql/v1beta3",
    url: url_SqlInstancesDelete_589078, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsList_589110 = ref object of OpenApiRestCall_588441
proc url_SqlBackupRunsList_589112(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsList_589111(path: JsonNode; query: JsonNode;
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
  var valid_589113 = path.getOrDefault("instance")
  valid_589113 = validateParameter(valid_589113, JString, required = true,
                                 default = nil)
  if valid_589113 != nil:
    section.add "instance", valid_589113
  var valid_589114 = path.getOrDefault("project")
  valid_589114 = validateParameter(valid_589114, JString, required = true,
                                 default = nil)
  if valid_589114 != nil:
    section.add "project", valid_589114
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
  ##   backupConfiguration: JString (required)
  ##                      : Identifier for the backup configuration. This gets generated automatically when a backup configuration is created.
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
  var valid_589115 = query.getOrDefault("fields")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "fields", valid_589115
  var valid_589116 = query.getOrDefault("pageToken")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "pageToken", valid_589116
  var valid_589117 = query.getOrDefault("quotaUser")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "quotaUser", valid_589117
  var valid_589118 = query.getOrDefault("alt")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = newJString("json"))
  if valid_589118 != nil:
    section.add "alt", valid_589118
  assert query != nil, "query argument is necessary due to required `backupConfiguration` field"
  var valid_589119 = query.getOrDefault("backupConfiguration")
  valid_589119 = validateParameter(valid_589119, JString, required = true,
                                 default = nil)
  if valid_589119 != nil:
    section.add "backupConfiguration", valid_589119
  var valid_589120 = query.getOrDefault("oauth_token")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "oauth_token", valid_589120
  var valid_589121 = query.getOrDefault("userIp")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "userIp", valid_589121
  var valid_589122 = query.getOrDefault("maxResults")
  valid_589122 = validateParameter(valid_589122, JInt, required = false, default = nil)
  if valid_589122 != nil:
    section.add "maxResults", valid_589122
  var valid_589123 = query.getOrDefault("key")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "key", valid_589123
  var valid_589124 = query.getOrDefault("prettyPrint")
  valid_589124 = validateParameter(valid_589124, JBool, required = false,
                                 default = newJBool(true))
  if valid_589124 != nil:
    section.add "prettyPrint", valid_589124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589125: Call_SqlBackupRunsList_589110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all backup runs associated with a Cloud SQL instance.
  ## 
  let valid = call_589125.validator(path, query, header, formData, body)
  let scheme = call_589125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589125.url(scheme.get, call_589125.host, call_589125.base,
                         call_589125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589125, url, valid)

proc call*(call_589126: Call_SqlBackupRunsList_589110; backupConfiguration: string;
          instance: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlBackupRunsList
  ## Lists all backup runs associated with a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   backupConfiguration: string (required)
  ##                      : Identifier for the backup configuration. This gets generated automatically when a backup configuration is created.
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
  var path_589127 = newJObject()
  var query_589128 = newJObject()
  add(query_589128, "fields", newJString(fields))
  add(query_589128, "pageToken", newJString(pageToken))
  add(query_589128, "quotaUser", newJString(quotaUser))
  add(query_589128, "alt", newJString(alt))
  add(query_589128, "backupConfiguration", newJString(backupConfiguration))
  add(query_589128, "oauth_token", newJString(oauthToken))
  add(query_589128, "userIp", newJString(userIp))
  add(query_589128, "maxResults", newJInt(maxResults))
  add(query_589128, "key", newJString(key))
  add(path_589127, "instance", newJString(instance))
  add(path_589127, "project", newJString(project))
  add(query_589128, "prettyPrint", newJBool(prettyPrint))
  result = call_589126.call(path_589127, query_589128, nil, nil, nil)

var sqlBackupRunsList* = Call_SqlBackupRunsList_589110(name: "sqlBackupRunsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsList_589111, base: "/sql/v1beta3",
    url: url_SqlBackupRunsList_589112, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsGet_589129 = ref object of OpenApiRestCall_588441
proc url_SqlBackupRunsGet_589131(protocol: Scheme; host: string; base: string;
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

proc validate_SqlBackupRunsGet_589130(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves information about a specified backup run for a Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   backupConfiguration: JString (required)
  ##                      : Identifier for the backup configuration. This gets generated automatically when a backup configuration is created.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `backupConfiguration` field"
  var valid_589132 = path.getOrDefault("backupConfiguration")
  valid_589132 = validateParameter(valid_589132, JString, required = true,
                                 default = nil)
  if valid_589132 != nil:
    section.add "backupConfiguration", valid_589132
  var valid_589133 = path.getOrDefault("instance")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "instance", valid_589133
  var valid_589134 = path.getOrDefault("project")
  valid_589134 = validateParameter(valid_589134, JString, required = true,
                                 default = nil)
  if valid_589134 != nil:
    section.add "project", valid_589134
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
  ##   dueTime: JString (required)
  ##          : The start time of the four-hour backup window. The backup can occur any time in the window. The time is in RFC 3339 format, for example 2012-11-15T16:19:00.094Z.
  section = newJObject()
  var valid_589135 = query.getOrDefault("fields")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "fields", valid_589135
  var valid_589136 = query.getOrDefault("quotaUser")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "quotaUser", valid_589136
  var valid_589137 = query.getOrDefault("alt")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("json"))
  if valid_589137 != nil:
    section.add "alt", valid_589137
  var valid_589138 = query.getOrDefault("oauth_token")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "oauth_token", valid_589138
  var valid_589139 = query.getOrDefault("userIp")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "userIp", valid_589139
  var valid_589140 = query.getOrDefault("key")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "key", valid_589140
  var valid_589141 = query.getOrDefault("prettyPrint")
  valid_589141 = validateParameter(valid_589141, JBool, required = false,
                                 default = newJBool(true))
  if valid_589141 != nil:
    section.add "prettyPrint", valid_589141
  assert query != nil, "query argument is necessary due to required `dueTime` field"
  var valid_589142 = query.getOrDefault("dueTime")
  valid_589142 = validateParameter(valid_589142, JString, required = true,
                                 default = nil)
  if valid_589142 != nil:
    section.add "dueTime", valid_589142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589143: Call_SqlBackupRunsGet_589129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a specified backup run for a Cloud SQL instance.
  ## 
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_SqlBackupRunsGet_589129; backupConfiguration: string;
          instance: string; project: string; dueTime: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlBackupRunsGet
  ## Retrieves information about a specified backup run for a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   backupConfiguration: string (required)
  ##                      : Identifier for the backup configuration. This gets generated automatically when a backup configuration is created.
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
  ##   dueTime: string (required)
  ##          : The start time of the four-hour backup window. The backup can occur any time in the window. The time is in RFC 3339 format, for example 2012-11-15T16:19:00.094Z.
  var path_589145 = newJObject()
  var query_589146 = newJObject()
  add(query_589146, "fields", newJString(fields))
  add(query_589146, "quotaUser", newJString(quotaUser))
  add(query_589146, "alt", newJString(alt))
  add(query_589146, "oauth_token", newJString(oauthToken))
  add(path_589145, "backupConfiguration", newJString(backupConfiguration))
  add(query_589146, "userIp", newJString(userIp))
  add(query_589146, "key", newJString(key))
  add(path_589145, "instance", newJString(instance))
  add(path_589145, "project", newJString(project))
  add(query_589146, "prettyPrint", newJBool(prettyPrint))
  add(query_589146, "dueTime", newJString(dueTime))
  result = call_589144.call(path_589145, query_589146, nil, nil, nil)

var sqlBackupRunsGet* = Call_SqlBackupRunsGet_589129(name: "sqlBackupRunsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/backupRuns/{backupConfiguration}",
    validator: validate_SqlBackupRunsGet_589130, base: "/sql/v1beta3",
    url: url_SqlBackupRunsGet_589131, schemes: {Scheme.Https})
type
  Call_SqlInstancesExport_589147 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesExport_589149(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesExport_589148(path: JsonNode; query: JsonNode;
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
  var valid_589150 = path.getOrDefault("instance")
  valid_589150 = validateParameter(valid_589150, JString, required = true,
                                 default = nil)
  if valid_589150 != nil:
    section.add "instance", valid_589150
  var valid_589151 = path.getOrDefault("project")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "project", valid_589151
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
  var valid_589152 = query.getOrDefault("fields")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "fields", valid_589152
  var valid_589153 = query.getOrDefault("quotaUser")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "quotaUser", valid_589153
  var valid_589154 = query.getOrDefault("alt")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = newJString("json"))
  if valid_589154 != nil:
    section.add "alt", valid_589154
  var valid_589155 = query.getOrDefault("oauth_token")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "oauth_token", valid_589155
  var valid_589156 = query.getOrDefault("userIp")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "userIp", valid_589156
  var valid_589157 = query.getOrDefault("key")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "key", valid_589157
  var valid_589158 = query.getOrDefault("prettyPrint")
  valid_589158 = validateParameter(valid_589158, JBool, required = false,
                                 default = newJBool(true))
  if valid_589158 != nil:
    section.add "prettyPrint", valid_589158
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

proc call*(call_589160: Call_SqlInstancesExport_589147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports data from a Cloud SQL instance to a Google Cloud Storage bucket as a MySQL dump file.
  ## 
  let valid = call_589160.validator(path, query, header, formData, body)
  let scheme = call_589160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589160.url(scheme.get, call_589160.host, call_589160.base,
                         call_589160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589160, url, valid)

proc call*(call_589161: Call_SqlInstancesExport_589147; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesExport
  ## Exports data from a Cloud SQL instance to a Google Cloud Storage bucket as a MySQL dump file.
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
  var path_589162 = newJObject()
  var query_589163 = newJObject()
  var body_589164 = newJObject()
  add(query_589163, "fields", newJString(fields))
  add(query_589163, "quotaUser", newJString(quotaUser))
  add(query_589163, "alt", newJString(alt))
  add(query_589163, "oauth_token", newJString(oauthToken))
  add(query_589163, "userIp", newJString(userIp))
  add(query_589163, "key", newJString(key))
  add(path_589162, "instance", newJString(instance))
  add(path_589162, "project", newJString(project))
  if body != nil:
    body_589164 = body
  add(query_589163, "prettyPrint", newJBool(prettyPrint))
  result = call_589161.call(path_589162, query_589163, nil, nil, body_589164)

var sqlInstancesExport* = Call_SqlInstancesExport_589147(
    name: "sqlInstancesExport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/export",
    validator: validate_SqlInstancesExport_589148, base: "/sql/v1beta3",
    url: url_SqlInstancesExport_589149, schemes: {Scheme.Https})
type
  Call_SqlInstancesImport_589165 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesImport_589167(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesImport_589166(path: JsonNode; query: JsonNode;
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
  var valid_589168 = path.getOrDefault("instance")
  valid_589168 = validateParameter(valid_589168, JString, required = true,
                                 default = nil)
  if valid_589168 != nil:
    section.add "instance", valid_589168
  var valid_589169 = path.getOrDefault("project")
  valid_589169 = validateParameter(valid_589169, JString, required = true,
                                 default = nil)
  if valid_589169 != nil:
    section.add "project", valid_589169
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
  var valid_589170 = query.getOrDefault("fields")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "fields", valid_589170
  var valid_589171 = query.getOrDefault("quotaUser")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "quotaUser", valid_589171
  var valid_589172 = query.getOrDefault("alt")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = newJString("json"))
  if valid_589172 != nil:
    section.add "alt", valid_589172
  var valid_589173 = query.getOrDefault("oauth_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "oauth_token", valid_589173
  var valid_589174 = query.getOrDefault("userIp")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "userIp", valid_589174
  var valid_589175 = query.getOrDefault("key")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "key", valid_589175
  var valid_589176 = query.getOrDefault("prettyPrint")
  valid_589176 = validateParameter(valid_589176, JBool, required = false,
                                 default = newJBool(true))
  if valid_589176 != nil:
    section.add "prettyPrint", valid_589176
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

proc call*(call_589178: Call_SqlInstancesImport_589165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports data into a Cloud SQL instance from a MySQL dump file stored in a Google Cloud Storage bucket.
  ## 
  let valid = call_589178.validator(path, query, header, formData, body)
  let scheme = call_589178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589178.url(scheme.get, call_589178.host, call_589178.base,
                         call_589178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589178, url, valid)

proc call*(call_589179: Call_SqlInstancesImport_589165; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesImport
  ## Imports data into a Cloud SQL instance from a MySQL dump file stored in a Google Cloud Storage bucket.
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
  var path_589180 = newJObject()
  var query_589181 = newJObject()
  var body_589182 = newJObject()
  add(query_589181, "fields", newJString(fields))
  add(query_589181, "quotaUser", newJString(quotaUser))
  add(query_589181, "alt", newJString(alt))
  add(query_589181, "oauth_token", newJString(oauthToken))
  add(query_589181, "userIp", newJString(userIp))
  add(query_589181, "key", newJString(key))
  add(path_589180, "instance", newJString(instance))
  add(path_589180, "project", newJString(project))
  if body != nil:
    body_589182 = body
  add(query_589181, "prettyPrint", newJBool(prettyPrint))
  result = call_589179.call(path_589180, query_589181, nil, nil, body_589182)

var sqlInstancesImport* = Call_SqlInstancesImport_589165(
    name: "sqlInstancesImport", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/import",
    validator: validate_SqlInstancesImport_589166, base: "/sql/v1beta3",
    url: url_SqlInstancesImport_589167, schemes: {Scheme.Https})
type
  Call_SqlOperationsList_589183 = ref object of OpenApiRestCall_588441
proc url_SqlOperationsList_589185(protocol: Scheme; host: string; base: string;
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

proc validate_SqlOperationsList_589184(path: JsonNode; query: JsonNode;
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
  var valid_589186 = path.getOrDefault("instance")
  valid_589186 = validateParameter(valid_589186, JString, required = true,
                                 default = nil)
  if valid_589186 != nil:
    section.add "instance", valid_589186
  var valid_589187 = path.getOrDefault("project")
  valid_589187 = validateParameter(valid_589187, JString, required = true,
                                 default = nil)
  if valid_589187 != nil:
    section.add "project", valid_589187
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589188 = query.getOrDefault("fields")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "fields", valid_589188
  var valid_589189 = query.getOrDefault("pageToken")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "pageToken", valid_589189
  var valid_589190 = query.getOrDefault("quotaUser")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "quotaUser", valid_589190
  var valid_589191 = query.getOrDefault("alt")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = newJString("json"))
  if valid_589191 != nil:
    section.add "alt", valid_589191
  var valid_589192 = query.getOrDefault("oauth_token")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "oauth_token", valid_589192
  var valid_589193 = query.getOrDefault("userIp")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "userIp", valid_589193
  var valid_589194 = query.getOrDefault("maxResults")
  valid_589194 = validateParameter(valid_589194, JInt, required = false, default = nil)
  if valid_589194 != nil:
    section.add "maxResults", valid_589194
  var valid_589195 = query.getOrDefault("key")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "key", valid_589195
  var valid_589196 = query.getOrDefault("prettyPrint")
  valid_589196 = validateParameter(valid_589196, JBool, required = false,
                                 default = newJBool(true))
  if valid_589196 != nil:
    section.add "prettyPrint", valid_589196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589197: Call_SqlOperationsList_589183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all operations that have been performed on a Cloud SQL instance.
  ## 
  let valid = call_589197.validator(path, query, header, formData, body)
  let scheme = call_589197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589197.url(scheme.get, call_589197.host, call_589197.base,
                         call_589197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589197, url, valid)

proc call*(call_589198: Call_SqlOperationsList_589183; instance: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## sqlOperationsList
  ## Lists all operations that have been performed on a Cloud SQL instance.
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
  var path_589199 = newJObject()
  var query_589200 = newJObject()
  add(query_589200, "fields", newJString(fields))
  add(query_589200, "pageToken", newJString(pageToken))
  add(query_589200, "quotaUser", newJString(quotaUser))
  add(query_589200, "alt", newJString(alt))
  add(query_589200, "oauth_token", newJString(oauthToken))
  add(query_589200, "userIp", newJString(userIp))
  add(query_589200, "maxResults", newJInt(maxResults))
  add(query_589200, "key", newJString(key))
  add(path_589199, "instance", newJString(instance))
  add(path_589199, "project", newJString(project))
  add(query_589200, "prettyPrint", newJBool(prettyPrint))
  result = call_589198.call(path_589199, query_589200, nil, nil, nil)

var sqlOperationsList* = Call_SqlOperationsList_589183(name: "sqlOperationsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/operations",
    validator: validate_SqlOperationsList_589184, base: "/sql/v1beta3",
    url: url_SqlOperationsList_589185, schemes: {Scheme.Https})
type
  Call_SqlOperationsGet_589201 = ref object of OpenApiRestCall_588441
proc url_SqlOperationsGet_589203(protocol: Scheme; host: string; base: string;
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

proc validate_SqlOperationsGet_589202(path: JsonNode; query: JsonNode;
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
  var valid_589204 = path.getOrDefault("operation")
  valid_589204 = validateParameter(valid_589204, JString, required = true,
                                 default = nil)
  if valid_589204 != nil:
    section.add "operation", valid_589204
  var valid_589205 = path.getOrDefault("instance")
  valid_589205 = validateParameter(valid_589205, JString, required = true,
                                 default = nil)
  if valid_589205 != nil:
    section.add "instance", valid_589205
  var valid_589206 = path.getOrDefault("project")
  valid_589206 = validateParameter(valid_589206, JString, required = true,
                                 default = nil)
  if valid_589206 != nil:
    section.add "project", valid_589206
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
  var valid_589207 = query.getOrDefault("fields")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "fields", valid_589207
  var valid_589208 = query.getOrDefault("quotaUser")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "quotaUser", valid_589208
  var valid_589209 = query.getOrDefault("alt")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("json"))
  if valid_589209 != nil:
    section.add "alt", valid_589209
  var valid_589210 = query.getOrDefault("oauth_token")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "oauth_token", valid_589210
  var valid_589211 = query.getOrDefault("userIp")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "userIp", valid_589211
  var valid_589212 = query.getOrDefault("key")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "key", valid_589212
  var valid_589213 = query.getOrDefault("prettyPrint")
  valid_589213 = validateParameter(valid_589213, JBool, required = false,
                                 default = newJBool(true))
  if valid_589213 != nil:
    section.add "prettyPrint", valid_589213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589214: Call_SqlOperationsGet_589201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a specific operation that was performed on a Cloud SQL instance.
  ## 
  let valid = call_589214.validator(path, query, header, formData, body)
  let scheme = call_589214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589214.url(scheme.get, call_589214.host, call_589214.base,
                         call_589214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589214, url, valid)

proc call*(call_589215: Call_SqlOperationsGet_589201; operation: string;
          instance: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlOperationsGet
  ## Retrieves information about a specific operation that was performed on a Cloud SQL instance.
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
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589216 = newJObject()
  var query_589217 = newJObject()
  add(query_589217, "fields", newJString(fields))
  add(query_589217, "quotaUser", newJString(quotaUser))
  add(query_589217, "alt", newJString(alt))
  add(path_589216, "operation", newJString(operation))
  add(query_589217, "oauth_token", newJString(oauthToken))
  add(query_589217, "userIp", newJString(userIp))
  add(query_589217, "key", newJString(key))
  add(path_589216, "instance", newJString(instance))
  add(path_589216, "project", newJString(project))
  add(query_589217, "prettyPrint", newJBool(prettyPrint))
  result = call_589215.call(path_589216, query_589217, nil, nil, nil)

var sqlOperationsGet* = Call_SqlOperationsGet_589201(name: "sqlOperationsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/operations/{operation}",
    validator: validate_SqlOperationsGet_589202, base: "/sql/v1beta3",
    url: url_SqlOperationsGet_589203, schemes: {Scheme.Https})
type
  Call_SqlInstancesPromoteReplica_589218 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesPromoteReplica_589220(protocol: Scheme; host: string;
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

proc validate_SqlInstancesPromoteReplica_589219(path: JsonNode; query: JsonNode;
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
  var valid_589221 = path.getOrDefault("instance")
  valid_589221 = validateParameter(valid_589221, JString, required = true,
                                 default = nil)
  if valid_589221 != nil:
    section.add "instance", valid_589221
  var valid_589222 = path.getOrDefault("project")
  valid_589222 = validateParameter(valid_589222, JString, required = true,
                                 default = nil)
  if valid_589222 != nil:
    section.add "project", valid_589222
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
  var valid_589223 = query.getOrDefault("fields")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "fields", valid_589223
  var valid_589224 = query.getOrDefault("quotaUser")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "quotaUser", valid_589224
  var valid_589225 = query.getOrDefault("alt")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = newJString("json"))
  if valid_589225 != nil:
    section.add "alt", valid_589225
  var valid_589226 = query.getOrDefault("oauth_token")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "oauth_token", valid_589226
  var valid_589227 = query.getOrDefault("userIp")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "userIp", valid_589227
  var valid_589228 = query.getOrDefault("key")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "key", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589230: Call_SqlInstancesPromoteReplica_589218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ## 
  let valid = call_589230.validator(path, query, header, formData, body)
  let scheme = call_589230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589230.url(scheme.get, call_589230.host, call_589230.base,
                         call_589230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589230, url, valid)

proc call*(call_589231: Call_SqlInstancesPromoteReplica_589218; instance: string;
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
  var path_589232 = newJObject()
  var query_589233 = newJObject()
  add(query_589233, "fields", newJString(fields))
  add(query_589233, "quotaUser", newJString(quotaUser))
  add(query_589233, "alt", newJString(alt))
  add(query_589233, "oauth_token", newJString(oauthToken))
  add(query_589233, "userIp", newJString(userIp))
  add(query_589233, "key", newJString(key))
  add(path_589232, "instance", newJString(instance))
  add(path_589232, "project", newJString(project))
  add(query_589233, "prettyPrint", newJBool(prettyPrint))
  result = call_589231.call(path_589232, query_589233, nil, nil, nil)

var sqlInstancesPromoteReplica* = Call_SqlInstancesPromoteReplica_589218(
    name: "sqlInstancesPromoteReplica", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/promoteReplica",
    validator: validate_SqlInstancesPromoteReplica_589219, base: "/sql/v1beta3",
    url: url_SqlInstancesPromoteReplica_589220, schemes: {Scheme.Https})
type
  Call_SqlInstancesResetSslConfig_589234 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesResetSslConfig_589236(protocol: Scheme; host: string;
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

proc validate_SqlInstancesResetSslConfig_589235(path: JsonNode; query: JsonNode;
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
  var valid_589237 = path.getOrDefault("instance")
  valid_589237 = validateParameter(valid_589237, JString, required = true,
                                 default = nil)
  if valid_589237 != nil:
    section.add "instance", valid_589237
  var valid_589238 = path.getOrDefault("project")
  valid_589238 = validateParameter(valid_589238, JString, required = true,
                                 default = nil)
  if valid_589238 != nil:
    section.add "project", valid_589238
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
  var valid_589239 = query.getOrDefault("fields")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "fields", valid_589239
  var valid_589240 = query.getOrDefault("quotaUser")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "quotaUser", valid_589240
  var valid_589241 = query.getOrDefault("alt")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = newJString("json"))
  if valid_589241 != nil:
    section.add "alt", valid_589241
  var valid_589242 = query.getOrDefault("oauth_token")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "oauth_token", valid_589242
  var valid_589243 = query.getOrDefault("userIp")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "userIp", valid_589243
  var valid_589244 = query.getOrDefault("key")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "key", valid_589244
  var valid_589245 = query.getOrDefault("prettyPrint")
  valid_589245 = validateParameter(valid_589245, JBool, required = false,
                                 default = newJBool(true))
  if valid_589245 != nil:
    section.add "prettyPrint", valid_589245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589246: Call_SqlInstancesResetSslConfig_589234; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all client certificates and generates a new server SSL certificate for a Cloud SQL instance.
  ## 
  let valid = call_589246.validator(path, query, header, formData, body)
  let scheme = call_589246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589246.url(scheme.get, call_589246.host, call_589246.base,
                         call_589246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589246, url, valid)

proc call*(call_589247: Call_SqlInstancesResetSslConfig_589234; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesResetSslConfig
  ## Deletes all client certificates and generates a new server SSL certificate for a Cloud SQL instance.
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
  var path_589248 = newJObject()
  var query_589249 = newJObject()
  add(query_589249, "fields", newJString(fields))
  add(query_589249, "quotaUser", newJString(quotaUser))
  add(query_589249, "alt", newJString(alt))
  add(query_589249, "oauth_token", newJString(oauthToken))
  add(query_589249, "userIp", newJString(userIp))
  add(query_589249, "key", newJString(key))
  add(path_589248, "instance", newJString(instance))
  add(path_589248, "project", newJString(project))
  add(query_589249, "prettyPrint", newJBool(prettyPrint))
  result = call_589247.call(path_589248, query_589249, nil, nil, nil)

var sqlInstancesResetSslConfig* = Call_SqlInstancesResetSslConfig_589234(
    name: "sqlInstancesResetSslConfig", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/resetSslConfig",
    validator: validate_SqlInstancesResetSslConfig_589235, base: "/sql/v1beta3",
    url: url_SqlInstancesResetSslConfig_589236, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestart_589250 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesRestart_589252(protocol: Scheme; host: string; base: string;
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

proc validate_SqlInstancesRestart_589251(path: JsonNode; query: JsonNode;
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
  var valid_589253 = path.getOrDefault("instance")
  valid_589253 = validateParameter(valid_589253, JString, required = true,
                                 default = nil)
  if valid_589253 != nil:
    section.add "instance", valid_589253
  var valid_589254 = path.getOrDefault("project")
  valid_589254 = validateParameter(valid_589254, JString, required = true,
                                 default = nil)
  if valid_589254 != nil:
    section.add "project", valid_589254
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
  var valid_589255 = query.getOrDefault("fields")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "fields", valid_589255
  var valid_589256 = query.getOrDefault("quotaUser")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "quotaUser", valid_589256
  var valid_589257 = query.getOrDefault("alt")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("json"))
  if valid_589257 != nil:
    section.add "alt", valid_589257
  var valid_589258 = query.getOrDefault("oauth_token")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "oauth_token", valid_589258
  var valid_589259 = query.getOrDefault("userIp")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "userIp", valid_589259
  var valid_589260 = query.getOrDefault("key")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "key", valid_589260
  var valid_589261 = query.getOrDefault("prettyPrint")
  valid_589261 = validateParameter(valid_589261, JBool, required = false,
                                 default = newJBool(true))
  if valid_589261 != nil:
    section.add "prettyPrint", valid_589261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589262: Call_SqlInstancesRestart_589250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a Cloud SQL instance.
  ## 
  let valid = call_589262.validator(path, query, header, formData, body)
  let scheme = call_589262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589262.url(scheme.get, call_589262.host, call_589262.base,
                         call_589262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589262, url, valid)

proc call*(call_589263: Call_SqlInstancesRestart_589250; instance: string;
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
  var path_589264 = newJObject()
  var query_589265 = newJObject()
  add(query_589265, "fields", newJString(fields))
  add(query_589265, "quotaUser", newJString(quotaUser))
  add(query_589265, "alt", newJString(alt))
  add(query_589265, "oauth_token", newJString(oauthToken))
  add(query_589265, "userIp", newJString(userIp))
  add(query_589265, "key", newJString(key))
  add(path_589264, "instance", newJString(instance))
  add(path_589264, "project", newJString(project))
  add(query_589265, "prettyPrint", newJBool(prettyPrint))
  result = call_589263.call(path_589264, query_589265, nil, nil, nil)

var sqlInstancesRestart* = Call_SqlInstancesRestart_589250(
    name: "sqlInstancesRestart", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restart",
    validator: validate_SqlInstancesRestart_589251, base: "/sql/v1beta3",
    url: url_SqlInstancesRestart_589252, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestoreBackup_589266 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesRestoreBackup_589268(protocol: Scheme; host: string;
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

proc validate_SqlInstancesRestoreBackup_589267(path: JsonNode; query: JsonNode;
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
  var valid_589269 = path.getOrDefault("instance")
  valid_589269 = validateParameter(valid_589269, JString, required = true,
                                 default = nil)
  if valid_589269 != nil:
    section.add "instance", valid_589269
  var valid_589270 = path.getOrDefault("project")
  valid_589270 = validateParameter(valid_589270, JString, required = true,
                                 default = nil)
  if valid_589270 != nil:
    section.add "project", valid_589270
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   backupConfiguration: JString (required)
  ##                      : The identifier of the backup configuration. This gets generated automatically when a backup configuration is created.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   dueTime: JString (required)
  ##          : The start time of the four-hour backup window. The backup can occur any time in the window. The time is in RFC 3339 format, for example 2012-11-15T16:19:00.094Z.
  section = newJObject()
  var valid_589271 = query.getOrDefault("fields")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "fields", valid_589271
  var valid_589272 = query.getOrDefault("quotaUser")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "quotaUser", valid_589272
  var valid_589273 = query.getOrDefault("alt")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = newJString("json"))
  if valid_589273 != nil:
    section.add "alt", valid_589273
  assert query != nil, "query argument is necessary due to required `backupConfiguration` field"
  var valid_589274 = query.getOrDefault("backupConfiguration")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "backupConfiguration", valid_589274
  var valid_589275 = query.getOrDefault("oauth_token")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "oauth_token", valid_589275
  var valid_589276 = query.getOrDefault("userIp")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "userIp", valid_589276
  var valid_589277 = query.getOrDefault("key")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "key", valid_589277
  var valid_589278 = query.getOrDefault("prettyPrint")
  valid_589278 = validateParameter(valid_589278, JBool, required = false,
                                 default = newJBool(true))
  if valid_589278 != nil:
    section.add "prettyPrint", valid_589278
  var valid_589279 = query.getOrDefault("dueTime")
  valid_589279 = validateParameter(valid_589279, JString, required = true,
                                 default = nil)
  if valid_589279 != nil:
    section.add "dueTime", valid_589279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589280: Call_SqlInstancesRestoreBackup_589266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backup of a Cloud SQL instance.
  ## 
  let valid = call_589280.validator(path, query, header, formData, body)
  let scheme = call_589280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589280.url(scheme.get, call_589280.host, call_589280.base,
                         call_589280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589280, url, valid)

proc call*(call_589281: Call_SqlInstancesRestoreBackup_589266;
          backupConfiguration: string; instance: string; project: string;
          dueTime: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlInstancesRestoreBackup
  ## Restores a backup of a Cloud SQL instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   backupConfiguration: string (required)
  ##                      : The identifier of the backup configuration. This gets generated automatically when a backup configuration is created.
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
  ##   dueTime: string (required)
  ##          : The start time of the four-hour backup window. The backup can occur any time in the window. The time is in RFC 3339 format, for example 2012-11-15T16:19:00.094Z.
  var path_589282 = newJObject()
  var query_589283 = newJObject()
  add(query_589283, "fields", newJString(fields))
  add(query_589283, "quotaUser", newJString(quotaUser))
  add(query_589283, "alt", newJString(alt))
  add(query_589283, "backupConfiguration", newJString(backupConfiguration))
  add(query_589283, "oauth_token", newJString(oauthToken))
  add(query_589283, "userIp", newJString(userIp))
  add(query_589283, "key", newJString(key))
  add(path_589282, "instance", newJString(instance))
  add(path_589282, "project", newJString(project))
  add(query_589283, "prettyPrint", newJBool(prettyPrint))
  add(query_589283, "dueTime", newJString(dueTime))
  result = call_589281.call(path_589282, query_589283, nil, nil, nil)

var sqlInstancesRestoreBackup* = Call_SqlInstancesRestoreBackup_589266(
    name: "sqlInstancesRestoreBackup", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/restoreBackup",
    validator: validate_SqlInstancesRestoreBackup_589267, base: "/sql/v1beta3",
    url: url_SqlInstancesRestoreBackup_589268, schemes: {Scheme.Https})
type
  Call_SqlInstancesSetRootPassword_589284 = ref object of OpenApiRestCall_588441
proc url_SqlInstancesSetRootPassword_589286(protocol: Scheme; host: string;
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

proc validate_SqlInstancesSetRootPassword_589285(path: JsonNode; query: JsonNode;
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
  var valid_589287 = path.getOrDefault("instance")
  valid_589287 = validateParameter(valid_589287, JString, required = true,
                                 default = nil)
  if valid_589287 != nil:
    section.add "instance", valid_589287
  var valid_589288 = path.getOrDefault("project")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "project", valid_589288
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
  var valid_589289 = query.getOrDefault("fields")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "fields", valid_589289
  var valid_589290 = query.getOrDefault("quotaUser")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "quotaUser", valid_589290
  var valid_589291 = query.getOrDefault("alt")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = newJString("json"))
  if valid_589291 != nil:
    section.add "alt", valid_589291
  var valid_589292 = query.getOrDefault("oauth_token")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "oauth_token", valid_589292
  var valid_589293 = query.getOrDefault("userIp")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "userIp", valid_589293
  var valid_589294 = query.getOrDefault("key")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "key", valid_589294
  var valid_589295 = query.getOrDefault("prettyPrint")
  valid_589295 = validateParameter(valid_589295, JBool, required = false,
                                 default = newJBool(true))
  if valid_589295 != nil:
    section.add "prettyPrint", valid_589295
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

proc call*(call_589297: Call_SqlInstancesSetRootPassword_589284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the password for the root user of the specified Cloud SQL instance.
  ## 
  let valid = call_589297.validator(path, query, header, formData, body)
  let scheme = call_589297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589297.url(scheme.get, call_589297.host, call_589297.base,
                         call_589297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589297, url, valid)

proc call*(call_589298: Call_SqlInstancesSetRootPassword_589284; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlInstancesSetRootPassword
  ## Sets the password for the root user of the specified Cloud SQL instance.
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
  var path_589299 = newJObject()
  var query_589300 = newJObject()
  var body_589301 = newJObject()
  add(query_589300, "fields", newJString(fields))
  add(query_589300, "quotaUser", newJString(quotaUser))
  add(query_589300, "alt", newJString(alt))
  add(query_589300, "oauth_token", newJString(oauthToken))
  add(query_589300, "userIp", newJString(userIp))
  add(query_589300, "key", newJString(key))
  add(path_589299, "instance", newJString(instance))
  add(path_589299, "project", newJString(project))
  if body != nil:
    body_589301 = body
  add(query_589300, "prettyPrint", newJBool(prettyPrint))
  result = call_589298.call(path_589299, query_589300, nil, nil, body_589301)

var sqlInstancesSetRootPassword* = Call_SqlInstancesSetRootPassword_589284(
    name: "sqlInstancesSetRootPassword", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/setRootPassword",
    validator: validate_SqlInstancesSetRootPassword_589285, base: "/sql/v1beta3",
    url: url_SqlInstancesSetRootPassword_589286, schemes: {Scheme.Https})
type
  Call_SqlSslCertsInsert_589318 = ref object of OpenApiRestCall_588441
proc url_SqlSslCertsInsert_589320(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsInsert_589319(path: JsonNode; query: JsonNode;
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
  var valid_589321 = path.getOrDefault("instance")
  valid_589321 = validateParameter(valid_589321, JString, required = true,
                                 default = nil)
  if valid_589321 != nil:
    section.add "instance", valid_589321
  var valid_589322 = path.getOrDefault("project")
  valid_589322 = validateParameter(valid_589322, JString, required = true,
                                 default = nil)
  if valid_589322 != nil:
    section.add "project", valid_589322
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
  var valid_589323 = query.getOrDefault("fields")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "fields", valid_589323
  var valid_589324 = query.getOrDefault("quotaUser")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "quotaUser", valid_589324
  var valid_589325 = query.getOrDefault("alt")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = newJString("json"))
  if valid_589325 != nil:
    section.add "alt", valid_589325
  var valid_589326 = query.getOrDefault("oauth_token")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "oauth_token", valid_589326
  var valid_589327 = query.getOrDefault("userIp")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "userIp", valid_589327
  var valid_589328 = query.getOrDefault("key")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "key", valid_589328
  var valid_589329 = query.getOrDefault("prettyPrint")
  valid_589329 = validateParameter(valid_589329, JBool, required = false,
                                 default = newJBool(true))
  if valid_589329 != nil:
    section.add "prettyPrint", valid_589329
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

proc call*(call_589331: Call_SqlSslCertsInsert_589318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an SSL certificate and returns the certificate, the associated private key, and the server certificate authority.
  ## 
  let valid = call_589331.validator(path, query, header, formData, body)
  let scheme = call_589331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589331.url(scheme.get, call_589331.host, call_589331.base,
                         call_589331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589331, url, valid)

proc call*(call_589332: Call_SqlSslCertsInsert_589318; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## sqlSslCertsInsert
  ## Creates an SSL certificate and returns the certificate, the associated private key, and the server certificate authority.
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
  ##          : Project ID of the project to which the newly created Cloud SQL instances should belong.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589333 = newJObject()
  var query_589334 = newJObject()
  var body_589335 = newJObject()
  add(query_589334, "fields", newJString(fields))
  add(query_589334, "quotaUser", newJString(quotaUser))
  add(query_589334, "alt", newJString(alt))
  add(query_589334, "oauth_token", newJString(oauthToken))
  add(query_589334, "userIp", newJString(userIp))
  add(query_589334, "key", newJString(key))
  add(path_589333, "instance", newJString(instance))
  add(path_589333, "project", newJString(project))
  if body != nil:
    body_589335 = body
  add(query_589334, "prettyPrint", newJBool(prettyPrint))
  result = call_589332.call(path_589333, query_589334, nil, nil, body_589335)

var sqlSslCertsInsert* = Call_SqlSslCertsInsert_589318(name: "sqlSslCertsInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsInsert_589319, base: "/sql/v1beta3",
    url: url_SqlSslCertsInsert_589320, schemes: {Scheme.Https})
type
  Call_SqlSslCertsList_589302 = ref object of OpenApiRestCall_588441
proc url_SqlSslCertsList_589304(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsList_589303(path: JsonNode; query: JsonNode;
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
  var valid_589305 = path.getOrDefault("instance")
  valid_589305 = validateParameter(valid_589305, JString, required = true,
                                 default = nil)
  if valid_589305 != nil:
    section.add "instance", valid_589305
  var valid_589306 = path.getOrDefault("project")
  valid_589306 = validateParameter(valid_589306, JString, required = true,
                                 default = nil)
  if valid_589306 != nil:
    section.add "project", valid_589306
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
  var valid_589307 = query.getOrDefault("fields")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "fields", valid_589307
  var valid_589308 = query.getOrDefault("quotaUser")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "quotaUser", valid_589308
  var valid_589309 = query.getOrDefault("alt")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = newJString("json"))
  if valid_589309 != nil:
    section.add "alt", valid_589309
  var valid_589310 = query.getOrDefault("oauth_token")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "oauth_token", valid_589310
  var valid_589311 = query.getOrDefault("userIp")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "userIp", valid_589311
  var valid_589312 = query.getOrDefault("key")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "key", valid_589312
  var valid_589313 = query.getOrDefault("prettyPrint")
  valid_589313 = validateParameter(valid_589313, JBool, required = false,
                                 default = newJBool(true))
  if valid_589313 != nil:
    section.add "prettyPrint", valid_589313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589314: Call_SqlSslCertsList_589302; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the current SSL certificates defined for a Cloud SQL instance.
  ## 
  let valid = call_589314.validator(path, query, header, formData, body)
  let scheme = call_589314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589314.url(scheme.get, call_589314.host, call_589314.base,
                         call_589314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589314, url, valid)

proc call*(call_589315: Call_SqlSslCertsList_589302; instance: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlSslCertsList
  ## Lists all of the current SSL certificates defined for a Cloud SQL instance.
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
  ##          : Project ID of the project for which to list Cloud SQL instances.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589316 = newJObject()
  var query_589317 = newJObject()
  add(query_589317, "fields", newJString(fields))
  add(query_589317, "quotaUser", newJString(quotaUser))
  add(query_589317, "alt", newJString(alt))
  add(query_589317, "oauth_token", newJString(oauthToken))
  add(query_589317, "userIp", newJString(userIp))
  add(query_589317, "key", newJString(key))
  add(path_589316, "instance", newJString(instance))
  add(path_589316, "project", newJString(project))
  add(query_589317, "prettyPrint", newJBool(prettyPrint))
  result = call_589315.call(path_589316, query_589317, nil, nil, nil)

var sqlSslCertsList* = Call_SqlSslCertsList_589302(name: "sqlSslCertsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsList_589303, base: "/sql/v1beta3",
    url: url_SqlSslCertsList_589304, schemes: {Scheme.Https})
type
  Call_SqlSslCertsGet_589336 = ref object of OpenApiRestCall_588441
proc url_SqlSslCertsGet_589338(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsGet_589337(path: JsonNode; query: JsonNode;
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
  var valid_589339 = path.getOrDefault("sha1Fingerprint")
  valid_589339 = validateParameter(valid_589339, JString, required = true,
                                 default = nil)
  if valid_589339 != nil:
    section.add "sha1Fingerprint", valid_589339
  var valid_589340 = path.getOrDefault("instance")
  valid_589340 = validateParameter(valid_589340, JString, required = true,
                                 default = nil)
  if valid_589340 != nil:
    section.add "instance", valid_589340
  var valid_589341 = path.getOrDefault("project")
  valid_589341 = validateParameter(valid_589341, JString, required = true,
                                 default = nil)
  if valid_589341 != nil:
    section.add "project", valid_589341
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
  var valid_589342 = query.getOrDefault("fields")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "fields", valid_589342
  var valid_589343 = query.getOrDefault("quotaUser")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "quotaUser", valid_589343
  var valid_589344 = query.getOrDefault("alt")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = newJString("json"))
  if valid_589344 != nil:
    section.add "alt", valid_589344
  var valid_589345 = query.getOrDefault("oauth_token")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "oauth_token", valid_589345
  var valid_589346 = query.getOrDefault("userIp")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "userIp", valid_589346
  var valid_589347 = query.getOrDefault("key")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "key", valid_589347
  var valid_589348 = query.getOrDefault("prettyPrint")
  valid_589348 = validateParameter(valid_589348, JBool, required = false,
                                 default = newJBool(true))
  if valid_589348 != nil:
    section.add "prettyPrint", valid_589348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589349: Call_SqlSslCertsGet_589336; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an SSL certificate as specified by its SHA-1 fingerprint.
  ## 
  let valid = call_589349.validator(path, query, header, formData, body)
  let scheme = call_589349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589349.url(scheme.get, call_589349.host, call_589349.base,
                         call_589349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589349, url, valid)

proc call*(call_589350: Call_SqlSslCertsGet_589336; sha1Fingerprint: string;
          instance: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlSslCertsGet
  ## Retrieves an SSL certificate as specified by its SHA-1 fingerprint.
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
  var path_589351 = newJObject()
  var query_589352 = newJObject()
  add(query_589352, "fields", newJString(fields))
  add(query_589352, "quotaUser", newJString(quotaUser))
  add(query_589352, "alt", newJString(alt))
  add(query_589352, "oauth_token", newJString(oauthToken))
  add(query_589352, "userIp", newJString(userIp))
  add(path_589351, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(query_589352, "key", newJString(key))
  add(path_589351, "instance", newJString(instance))
  add(path_589351, "project", newJString(project))
  add(query_589352, "prettyPrint", newJBool(prettyPrint))
  result = call_589350.call(path_589351, query_589352, nil, nil, nil)

var sqlSslCertsGet* = Call_SqlSslCertsGet_589336(name: "sqlSslCertsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsGet_589337, base: "/sql/v1beta3",
    url: url_SqlSslCertsGet_589338, schemes: {Scheme.Https})
type
  Call_SqlSslCertsDelete_589353 = ref object of OpenApiRestCall_588441
proc url_SqlSslCertsDelete_589355(protocol: Scheme; host: string; base: string;
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

proc validate_SqlSslCertsDelete_589354(path: JsonNode; query: JsonNode;
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
  var valid_589356 = path.getOrDefault("sha1Fingerprint")
  valid_589356 = validateParameter(valid_589356, JString, required = true,
                                 default = nil)
  if valid_589356 != nil:
    section.add "sha1Fingerprint", valid_589356
  var valid_589357 = path.getOrDefault("instance")
  valid_589357 = validateParameter(valid_589357, JString, required = true,
                                 default = nil)
  if valid_589357 != nil:
    section.add "instance", valid_589357
  var valid_589358 = path.getOrDefault("project")
  valid_589358 = validateParameter(valid_589358, JString, required = true,
                                 default = nil)
  if valid_589358 != nil:
    section.add "project", valid_589358
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
  var valid_589359 = query.getOrDefault("fields")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "fields", valid_589359
  var valid_589360 = query.getOrDefault("quotaUser")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "quotaUser", valid_589360
  var valid_589361 = query.getOrDefault("alt")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = newJString("json"))
  if valid_589361 != nil:
    section.add "alt", valid_589361
  var valid_589362 = query.getOrDefault("oauth_token")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "oauth_token", valid_589362
  var valid_589363 = query.getOrDefault("userIp")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "userIp", valid_589363
  var valid_589364 = query.getOrDefault("key")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "key", valid_589364
  var valid_589365 = query.getOrDefault("prettyPrint")
  valid_589365 = validateParameter(valid_589365, JBool, required = false,
                                 default = newJBool(true))
  if valid_589365 != nil:
    section.add "prettyPrint", valid_589365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589366: Call_SqlSslCertsDelete_589353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an SSL certificate from a Cloud SQL instance.
  ## 
  let valid = call_589366.validator(path, query, header, formData, body)
  let scheme = call_589366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589366.url(scheme.get, call_589366.host, call_589366.base,
                         call_589366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589366, url, valid)

proc call*(call_589367: Call_SqlSslCertsDelete_589353; sha1Fingerprint: string;
          instance: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## sqlSslCertsDelete
  ## Deletes an SSL certificate from a Cloud SQL instance.
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
  ##          : Project ID of the project that contains the instance to be deleted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589368 = newJObject()
  var query_589369 = newJObject()
  add(query_589369, "fields", newJString(fields))
  add(query_589369, "quotaUser", newJString(quotaUser))
  add(query_589369, "alt", newJString(alt))
  add(query_589369, "oauth_token", newJString(oauthToken))
  add(query_589369, "userIp", newJString(userIp))
  add(path_589368, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(query_589369, "key", newJString(key))
  add(path_589368, "instance", newJString(instance))
  add(path_589368, "project", newJString(project))
  add(query_589369, "prettyPrint", newJBool(prettyPrint))
  result = call_589367.call(path_589368, query_589369, nil, nil, nil)

var sqlSslCertsDelete* = Call_SqlSslCertsDelete_589353(name: "sqlSslCertsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsDelete_589354, base: "/sql/v1beta3",
    url: url_SqlSslCertsDelete_589355, schemes: {Scheme.Https})
type
  Call_SqlTiersList_589370 = ref object of OpenApiRestCall_588441
proc url_SqlTiersList_589372(protocol: Scheme; host: string; base: string;
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

proc validate_SqlTiersList_589371(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589373 = path.getOrDefault("project")
  valid_589373 = validateParameter(valid_589373, JString, required = true,
                                 default = nil)
  if valid_589373 != nil:
    section.add "project", valid_589373
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
  var valid_589374 = query.getOrDefault("fields")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "fields", valid_589374
  var valid_589375 = query.getOrDefault("quotaUser")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "quotaUser", valid_589375
  var valid_589376 = query.getOrDefault("alt")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = newJString("json"))
  if valid_589376 != nil:
    section.add "alt", valid_589376
  var valid_589377 = query.getOrDefault("oauth_token")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "oauth_token", valid_589377
  var valid_589378 = query.getOrDefault("userIp")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "userIp", valid_589378
  var valid_589379 = query.getOrDefault("key")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "key", valid_589379
  var valid_589380 = query.getOrDefault("prettyPrint")
  valid_589380 = validateParameter(valid_589380, JBool, required = false,
                                 default = newJBool(true))
  if valid_589380 != nil:
    section.add "prettyPrint", valid_589380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589381: Call_SqlTiersList_589370; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists service tiers that can be used to create Google Cloud SQL instances.
  ## 
  let valid = call_589381.validator(path, query, header, formData, body)
  let scheme = call_589381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589381.url(scheme.get, call_589381.host, call_589381.base,
                         call_589381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589381, url, valid)

proc call*(call_589382: Call_SqlTiersList_589370; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## sqlTiersList
  ## Lists service tiers that can be used to create Google Cloud SQL instances.
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
  var path_589383 = newJObject()
  var query_589384 = newJObject()
  add(query_589384, "fields", newJString(fields))
  add(query_589384, "quotaUser", newJString(quotaUser))
  add(query_589384, "alt", newJString(alt))
  add(query_589384, "oauth_token", newJString(oauthToken))
  add(query_589384, "userIp", newJString(userIp))
  add(query_589384, "key", newJString(key))
  add(path_589383, "project", newJString(project))
  add(query_589384, "prettyPrint", newJBool(prettyPrint))
  result = call_589382.call(path_589383, query_589384, nil, nil, nil)

var sqlTiersList* = Call_SqlTiersList_589370(name: "sqlTiersList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/projects/{project}/tiers", validator: validate_SqlTiersList_589371,
    base: "/sql/v1beta3", url: url_SqlTiersList_589372, schemes: {Scheme.Https})
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
