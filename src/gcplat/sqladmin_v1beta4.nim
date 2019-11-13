
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud SQL Admin
## version: v1beta4
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## API for Cloud SQL database instance management
## 
## https://developers.google.com/cloud-sql/
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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  Call_SqlFlagsList_579644 = ref object of OpenApiRestCall_579373
proc url_SqlFlagsList_579646(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_SqlFlagsList_579645(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   databaseVersion: JString
  ##                  : Database type and version you want to retrieve flags for. By default, this
  ## method returns flags for all database types and versions.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("$.xgafv")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = newJString("1"))
  if valid_579774 != nil:
    section.add "$.xgafv", valid_579774
  var valid_579775 = query.getOrDefault("alt")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = newJString("json"))
  if valid_579775 != nil:
    section.add "alt", valid_579775
  var valid_579776 = query.getOrDefault("uploadType")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "uploadType", valid_579776
  var valid_579777 = query.getOrDefault("databaseVersion")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "databaseVersion", valid_579777
  var valid_579778 = query.getOrDefault("quotaUser")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "quotaUser", valid_579778
  var valid_579779 = query.getOrDefault("callback")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "callback", valid_579779
  var valid_579780 = query.getOrDefault("fields")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "fields", valid_579780
  var valid_579781 = query.getOrDefault("access_token")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "access_token", valid_579781
  var valid_579782 = query.getOrDefault("upload_protocol")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "upload_protocol", valid_579782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579805: Call_SqlFlagsList_579644; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all available database flags for Cloud SQL instances.
  ## 
  let valid = call_579805.validator(path, query, header, formData, body)
  let scheme = call_579805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579805.url(scheme.get, call_579805.host, call_579805.base,
                         call_579805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579805, url, valid)

proc call*(call_579876: Call_SqlFlagsList_579644; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; databaseVersion: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlFlagsList
  ## List all available database flags for Cloud SQL instances.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   databaseVersion: string
  ##                  : Database type and version you want to retrieve flags for. By default, this
  ## method returns flags for all database types and versions.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579877 = newJObject()
  add(query_579877, "key", newJString(key))
  add(query_579877, "prettyPrint", newJBool(prettyPrint))
  add(query_579877, "oauth_token", newJString(oauthToken))
  add(query_579877, "$.xgafv", newJString(Xgafv))
  add(query_579877, "alt", newJString(alt))
  add(query_579877, "uploadType", newJString(uploadType))
  add(query_579877, "databaseVersion", newJString(databaseVersion))
  add(query_579877, "quotaUser", newJString(quotaUser))
  add(query_579877, "callback", newJString(callback))
  add(query_579877, "fields", newJString(fields))
  add(query_579877, "access_token", newJString(accessToken))
  add(query_579877, "upload_protocol", newJString(uploadProtocol))
  result = call_579876.call(nil, query_579877, nil, nil, nil)

var sqlFlagsList* = Call_SqlFlagsList_579644(name: "sqlFlagsList",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/flags", validator: validate_SqlFlagsList_579645, base: "/",
    url: url_SqlFlagsList_579646, schemes: {Scheme.Https})
type
  Call_SqlInstancesInsert_579953 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesInsert_579955(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesInsert_579954(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a new Cloud SQL instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project to which the newly created Cloud SQL instances
  ## should belong.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579956 = path.getOrDefault("project")
  valid_579956 = validateParameter(valid_579956, JString, required = true,
                                 default = nil)
  if valid_579956 != nil:
    section.add "project", valid_579956
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL creates this database instance.
  ## Format: projects/{project}/locations/{location}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579957 = query.getOrDefault("key")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "key", valid_579957
  var valid_579958 = query.getOrDefault("prettyPrint")
  valid_579958 = validateParameter(valid_579958, JBool, required = false,
                                 default = newJBool(true))
  if valid_579958 != nil:
    section.add "prettyPrint", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("$.xgafv")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = newJString("1"))
  if valid_579960 != nil:
    section.add "$.xgafv", valid_579960
  var valid_579961 = query.getOrDefault("alt")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = newJString("json"))
  if valid_579961 != nil:
    section.add "alt", valid_579961
  var valid_579962 = query.getOrDefault("uploadType")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "uploadType", valid_579962
  var valid_579963 = query.getOrDefault("parent")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "parent", valid_579963
  var valid_579964 = query.getOrDefault("quotaUser")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "quotaUser", valid_579964
  var valid_579965 = query.getOrDefault("callback")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "callback", valid_579965
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
  var valid_579967 = query.getOrDefault("access_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "access_token", valid_579967
  var valid_579968 = query.getOrDefault("upload_protocol")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "upload_protocol", valid_579968
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

proc call*(call_579970: Call_SqlInstancesInsert_579953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Cloud SQL instance.
  ## 
  let valid = call_579970.validator(path, query, header, formData, body)
  let scheme = call_579970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579970.url(scheme.get, call_579970.host, call_579970.base,
                         call_579970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579970, url, valid)

proc call*(call_579971: Call_SqlInstancesInsert_579953; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          parent: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlInstancesInsert
  ## Creates a new Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL creates this database instance.
  ## Format: projects/{project}/locations/{location}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   project: string (required)
  ##          : Project ID of the project to which the newly created Cloud SQL instances
  ## should belong.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579972 = newJObject()
  var query_579973 = newJObject()
  var body_579974 = newJObject()
  add(query_579973, "key", newJString(key))
  add(query_579973, "prettyPrint", newJBool(prettyPrint))
  add(query_579973, "oauth_token", newJString(oauthToken))
  add(query_579973, "$.xgafv", newJString(Xgafv))
  add(query_579973, "alt", newJString(alt))
  add(query_579973, "uploadType", newJString(uploadType))
  add(query_579973, "parent", newJString(parent))
  add(query_579973, "quotaUser", newJString(quotaUser))
  add(path_579972, "project", newJString(project))
  if body != nil:
    body_579974 = body
  add(query_579973, "callback", newJString(callback))
  add(query_579973, "fields", newJString(fields))
  add(query_579973, "access_token", newJString(accessToken))
  add(query_579973, "upload_protocol", newJString(uploadProtocol))
  result = call_579971.call(path_579972, query_579973, nil, nil, body_579974)

var sqlInstancesInsert* = Call_SqlInstancesInsert_579953(
    name: "sqlInstancesInsert", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances",
    validator: validate_SqlInstancesInsert_579954, base: "/",
    url: url_SqlInstancesInsert_579955, schemes: {Scheme.Https})
type
  Call_SqlInstancesList_579917 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesList_579919(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesList_579918(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists instances under a given project in the alphabetical order of the
  ## instance name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project for which to list Cloud SQL instances.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579934 = path.getOrDefault("project")
  valid_579934 = validateParameter(valid_579934, JString, required = true,
                                 default = nil)
  if valid_579934 != nil:
    section.add "project", valid_579934
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : An expression for filtering the results of the request, such as by name or
  ## label.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of
  ## results to view.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxResults: JInt
  ##             : The maximum number of results to return per response.
  section = newJObject()
  var valid_579935 = query.getOrDefault("key")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "key", valid_579935
  var valid_579936 = query.getOrDefault("prettyPrint")
  valid_579936 = validateParameter(valid_579936, JBool, required = false,
                                 default = newJBool(true))
  if valid_579936 != nil:
    section.add "prettyPrint", valid_579936
  var valid_579937 = query.getOrDefault("oauth_token")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "oauth_token", valid_579937
  var valid_579938 = query.getOrDefault("$.xgafv")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = newJString("1"))
  if valid_579938 != nil:
    section.add "$.xgafv", valid_579938
  var valid_579939 = query.getOrDefault("alt")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = newJString("json"))
  if valid_579939 != nil:
    section.add "alt", valid_579939
  var valid_579940 = query.getOrDefault("uploadType")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "uploadType", valid_579940
  var valid_579941 = query.getOrDefault("quotaUser")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "quotaUser", valid_579941
  var valid_579942 = query.getOrDefault("filter")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "filter", valid_579942
  var valid_579943 = query.getOrDefault("pageToken")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "pageToken", valid_579943
  var valid_579944 = query.getOrDefault("callback")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "callback", valid_579944
  var valid_579945 = query.getOrDefault("fields")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "fields", valid_579945
  var valid_579946 = query.getOrDefault("access_token")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "access_token", valid_579946
  var valid_579947 = query.getOrDefault("upload_protocol")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "upload_protocol", valid_579947
  var valid_579948 = query.getOrDefault("maxResults")
  valid_579948 = validateParameter(valid_579948, JInt, required = false, default = nil)
  if valid_579948 != nil:
    section.add "maxResults", valid_579948
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579949: Call_SqlInstancesList_579917; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists instances under a given project in the alphabetical order of the
  ## instance name.
  ## 
  let valid = call_579949.validator(path, query, header, formData, body)
  let scheme = call_579949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579949.url(scheme.get, call_579949.host, call_579949.base,
                         call_579949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579949, url, valid)

proc call*(call_579950: Call_SqlInstancesList_579917; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; maxResults: int = 0): Recallable =
  ## sqlInstancesList
  ## Lists instances under a given project in the alphabetical order of the
  ## instance name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : An expression for filtering the results of the request, such as by name or
  ## label.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of
  ## results to view.
  ##   project: string (required)
  ##          : Project ID of the project for which to list Cloud SQL instances.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxResults: int
  ##             : The maximum number of results to return per response.
  var path_579951 = newJObject()
  var query_579952 = newJObject()
  add(query_579952, "key", newJString(key))
  add(query_579952, "prettyPrint", newJBool(prettyPrint))
  add(query_579952, "oauth_token", newJString(oauthToken))
  add(query_579952, "$.xgafv", newJString(Xgafv))
  add(query_579952, "alt", newJString(alt))
  add(query_579952, "uploadType", newJString(uploadType))
  add(query_579952, "quotaUser", newJString(quotaUser))
  add(query_579952, "filter", newJString(filter))
  add(query_579952, "pageToken", newJString(pageToken))
  add(path_579951, "project", newJString(project))
  add(query_579952, "callback", newJString(callback))
  add(query_579952, "fields", newJString(fields))
  add(query_579952, "access_token", newJString(accessToken))
  add(query_579952, "upload_protocol", newJString(uploadProtocol))
  add(query_579952, "maxResults", newJInt(maxResults))
  result = call_579950.call(path_579951, query_579952, nil, nil, nil)

var sqlInstancesList* = Call_SqlInstancesList_579917(name: "sqlInstancesList",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances",
    validator: validate_SqlInstancesList_579918, base: "/",
    url: url_SqlInstancesList_579919, schemes: {Scheme.Https})
type
  Call_SqlInstancesUpdate_579996 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesUpdate_579998(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesUpdate_579997(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates settings of a Cloud SQL instance. <aside
  ## class="caution"><strong>Caution:</strong> This is not a partial update, so
  ## you must include values for all the settings that you want to retain. For
  ## partial updates, use <a
  ## href="/sql/docs/db_path/admin-api/rest/v1beta4/instances/patch">patch</a>.</aside>
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
  var valid_579999 = path.getOrDefault("instance")
  valid_579999 = validateParameter(valid_579999, JString, required = true,
                                 default = nil)
  if valid_579999 != nil:
    section.add "instance", valid_579999
  var valid_580000 = path.getOrDefault("project")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "project", valid_580000
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of the database instance for Cloud SQL to update.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  section = newJObject()
  var valid_580001 = query.getOrDefault("key")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "key", valid_580001
  var valid_580002 = query.getOrDefault("prettyPrint")
  valid_580002 = validateParameter(valid_580002, JBool, required = false,
                                 default = newJBool(true))
  if valid_580002 != nil:
    section.add "prettyPrint", valid_580002
  var valid_580003 = query.getOrDefault("oauth_token")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "oauth_token", valid_580003
  var valid_580004 = query.getOrDefault("$.xgafv")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("1"))
  if valid_580004 != nil:
    section.add "$.xgafv", valid_580004
  var valid_580005 = query.getOrDefault("alt")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("json"))
  if valid_580005 != nil:
    section.add "alt", valid_580005
  var valid_580006 = query.getOrDefault("uploadType")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "uploadType", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("callback")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "callback", valid_580008
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("access_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "access_token", valid_580010
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("resourceName")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "resourceName", valid_580012
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

proc call*(call_580014: Call_SqlInstancesUpdate_579996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings of a Cloud SQL instance. <aside
  ## class="caution"><strong>Caution:</strong> This is not a partial update, so
  ## you must include values for all the settings that you want to retain. For
  ## partial updates, use <a
  ## href="/sql/docs/db_path/admin-api/rest/v1beta4/instances/patch">patch</a>.</aside>
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_SqlInstancesUpdate_579996; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; resourceName: string = ""): Recallable =
  ## sqlInstancesUpdate
  ## Updates settings of a Cloud SQL instance. <aside
  ## class="caution"><strong>Caution:</strong> This is not a partial update, so
  ## you must include values for all the settings that you want to retain. For
  ## partial updates, use <a
  ## href="/sql/docs/db_path/admin-api/rest/v1beta4/instances/patch">patch</a>.</aside>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of the database instance for Cloud SQL to update.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  var path_580016 = newJObject()
  var query_580017 = newJObject()
  var body_580018 = newJObject()
  add(query_580017, "key", newJString(key))
  add(query_580017, "prettyPrint", newJBool(prettyPrint))
  add(query_580017, "oauth_token", newJString(oauthToken))
  add(query_580017, "$.xgafv", newJString(Xgafv))
  add(query_580017, "alt", newJString(alt))
  add(query_580017, "uploadType", newJString(uploadType))
  add(query_580017, "quotaUser", newJString(quotaUser))
  add(path_580016, "instance", newJString(instance))
  add(path_580016, "project", newJString(project))
  if body != nil:
    body_580018 = body
  add(query_580017, "callback", newJString(callback))
  add(query_580017, "fields", newJString(fields))
  add(query_580017, "access_token", newJString(accessToken))
  add(query_580017, "upload_protocol", newJString(uploadProtocol))
  add(query_580017, "resourceName", newJString(resourceName))
  result = call_580015.call(path_580016, query_580017, nil, nil, body_580018)

var sqlInstancesUpdate* = Call_SqlInstancesUpdate_579996(
    name: "sqlInstancesUpdate", meth: HttpMethod.HttpPut,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesUpdate_579997, base: "/",
    url: url_SqlInstancesUpdate_579998, schemes: {Scheme.Https})
type
  Call_SqlInstancesGet_579975 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesGet_579977(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesGet_579976(path: JsonNode; query: JsonNode;
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
  var valid_579978 = path.getOrDefault("instance")
  valid_579978 = validateParameter(valid_579978, JString, required = true,
                                 default = nil)
  if valid_579978 != nil:
    section.add "instance", valid_579978
  var valid_579979 = path.getOrDefault("project")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "project", valid_579979
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : Name of the resource database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  section = newJObject()
  var valid_579980 = query.getOrDefault("key")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "key", valid_579980
  var valid_579981 = query.getOrDefault("prettyPrint")
  valid_579981 = validateParameter(valid_579981, JBool, required = false,
                                 default = newJBool(true))
  if valid_579981 != nil:
    section.add "prettyPrint", valid_579981
  var valid_579982 = query.getOrDefault("oauth_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "oauth_token", valid_579982
  var valid_579983 = query.getOrDefault("$.xgafv")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("1"))
  if valid_579983 != nil:
    section.add "$.xgafv", valid_579983
  var valid_579984 = query.getOrDefault("alt")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("json"))
  if valid_579984 != nil:
    section.add "alt", valid_579984
  var valid_579985 = query.getOrDefault("uploadType")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "uploadType", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("fields")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "fields", valid_579988
  var valid_579989 = query.getOrDefault("access_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "access_token", valid_579989
  var valid_579990 = query.getOrDefault("upload_protocol")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "upload_protocol", valid_579990
  var valid_579991 = query.getOrDefault("resourceName")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "resourceName", valid_579991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579992: Call_SqlInstancesGet_579975; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a Cloud SQL instance.
  ## 
  let valid = call_579992.validator(path, query, header, formData, body)
  let scheme = call_579992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579992.url(scheme.get, call_579992.host, call_579992.base,
                         call_579992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579992, url, valid)

proc call*(call_579993: Call_SqlInstancesGet_579975; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
  ## sqlInstancesGet
  ## Retrieves a resource containing information about a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : Name of the resource database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  var path_579994 = newJObject()
  var query_579995 = newJObject()
  add(query_579995, "key", newJString(key))
  add(query_579995, "prettyPrint", newJBool(prettyPrint))
  add(query_579995, "oauth_token", newJString(oauthToken))
  add(query_579995, "$.xgafv", newJString(Xgafv))
  add(query_579995, "alt", newJString(alt))
  add(query_579995, "uploadType", newJString(uploadType))
  add(query_579995, "quotaUser", newJString(quotaUser))
  add(path_579994, "instance", newJString(instance))
  add(path_579994, "project", newJString(project))
  add(query_579995, "callback", newJString(callback))
  add(query_579995, "fields", newJString(fields))
  add(query_579995, "access_token", newJString(accessToken))
  add(query_579995, "upload_protocol", newJString(uploadProtocol))
  add(query_579995, "resourceName", newJString(resourceName))
  result = call_579993.call(path_579994, query_579995, nil, nil, nil)

var sqlInstancesGet* = Call_SqlInstancesGet_579975(name: "sqlInstancesGet",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesGet_579976, base: "/", url: url_SqlInstancesGet_579977,
    schemes: {Scheme.Https})
type
  Call_SqlInstancesPatch_580040 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesPatch_580042(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesPatch_580041(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates settings of a Cloud SQL instance.
  ## This method supports patch semantics.
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
  var valid_580043 = path.getOrDefault("instance")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "instance", valid_580043
  var valid_580044 = path.getOrDefault("project")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "project", valid_580044
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of the database instance for Cloud SQL to update.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  section = newJObject()
  var valid_580045 = query.getOrDefault("key")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "key", valid_580045
  var valid_580046 = query.getOrDefault("prettyPrint")
  valid_580046 = validateParameter(valid_580046, JBool, required = false,
                                 default = newJBool(true))
  if valid_580046 != nil:
    section.add "prettyPrint", valid_580046
  var valid_580047 = query.getOrDefault("oauth_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "oauth_token", valid_580047
  var valid_580048 = query.getOrDefault("$.xgafv")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("1"))
  if valid_580048 != nil:
    section.add "$.xgafv", valid_580048
  var valid_580049 = query.getOrDefault("alt")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = newJString("json"))
  if valid_580049 != nil:
    section.add "alt", valid_580049
  var valid_580050 = query.getOrDefault("uploadType")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "uploadType", valid_580050
  var valid_580051 = query.getOrDefault("quotaUser")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "quotaUser", valid_580051
  var valid_580052 = query.getOrDefault("callback")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "callback", valid_580052
  var valid_580053 = query.getOrDefault("fields")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "fields", valid_580053
  var valid_580054 = query.getOrDefault("access_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "access_token", valid_580054
  var valid_580055 = query.getOrDefault("upload_protocol")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "upload_protocol", valid_580055
  var valid_580056 = query.getOrDefault("resourceName")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "resourceName", valid_580056
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

proc call*(call_580058: Call_SqlInstancesPatch_580040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates settings of a Cloud SQL instance.
  ## This method supports patch semantics.
  ## 
  let valid = call_580058.validator(path, query, header, formData, body)
  let scheme = call_580058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580058.url(scheme.get, call_580058.host, call_580058.base,
                         call_580058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580058, url, valid)

proc call*(call_580059: Call_SqlInstancesPatch_580040; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; resourceName: string = ""): Recallable =
  ## sqlInstancesPatch
  ## Updates settings of a Cloud SQL instance.
  ## This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of the database instance for Cloud SQL to update.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  var path_580060 = newJObject()
  var query_580061 = newJObject()
  var body_580062 = newJObject()
  add(query_580061, "key", newJString(key))
  add(query_580061, "prettyPrint", newJBool(prettyPrint))
  add(query_580061, "oauth_token", newJString(oauthToken))
  add(query_580061, "$.xgafv", newJString(Xgafv))
  add(query_580061, "alt", newJString(alt))
  add(query_580061, "uploadType", newJString(uploadType))
  add(query_580061, "quotaUser", newJString(quotaUser))
  add(path_580060, "instance", newJString(instance))
  add(path_580060, "project", newJString(project))
  if body != nil:
    body_580062 = body
  add(query_580061, "callback", newJString(callback))
  add(query_580061, "fields", newJString(fields))
  add(query_580061, "access_token", newJString(accessToken))
  add(query_580061, "upload_protocol", newJString(uploadProtocol))
  add(query_580061, "resourceName", newJString(resourceName))
  result = call_580059.call(path_580060, query_580061, nil, nil, body_580062)

var sqlInstancesPatch* = Call_SqlInstancesPatch_580040(name: "sqlInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesPatch_580041, base: "/",
    url: url_SqlInstancesPatch_580042, schemes: {Scheme.Https})
type
  Call_SqlInstancesDelete_580019 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesDelete_580021(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesDelete_580020(path: JsonNode; query: JsonNode;
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
  var valid_580022 = path.getOrDefault("instance")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "instance", valid_580022
  var valid_580023 = path.getOrDefault("project")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "project", valid_580023
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of database instance to delete.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  section = newJObject()
  var valid_580024 = query.getOrDefault("key")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "key", valid_580024
  var valid_580025 = query.getOrDefault("prettyPrint")
  valid_580025 = validateParameter(valid_580025, JBool, required = false,
                                 default = newJBool(true))
  if valid_580025 != nil:
    section.add "prettyPrint", valid_580025
  var valid_580026 = query.getOrDefault("oauth_token")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "oauth_token", valid_580026
  var valid_580027 = query.getOrDefault("$.xgafv")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("1"))
  if valid_580027 != nil:
    section.add "$.xgafv", valid_580027
  var valid_580028 = query.getOrDefault("alt")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("json"))
  if valid_580028 != nil:
    section.add "alt", valid_580028
  var valid_580029 = query.getOrDefault("uploadType")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "uploadType", valid_580029
  var valid_580030 = query.getOrDefault("quotaUser")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "quotaUser", valid_580030
  var valid_580031 = query.getOrDefault("callback")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "callback", valid_580031
  var valid_580032 = query.getOrDefault("fields")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "fields", valid_580032
  var valid_580033 = query.getOrDefault("access_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "access_token", valid_580033
  var valid_580034 = query.getOrDefault("upload_protocol")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "upload_protocol", valid_580034
  var valid_580035 = query.getOrDefault("resourceName")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "resourceName", valid_580035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580036: Call_SqlInstancesDelete_580019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Cloud SQL instance.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_SqlInstancesDelete_580019; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
  ## sqlInstancesDelete
  ## Deletes a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of database instance to delete.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  add(query_580039, "key", newJString(key))
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "$.xgafv", newJString(Xgafv))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "uploadType", newJString(uploadType))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(path_580038, "instance", newJString(instance))
  add(path_580038, "project", newJString(project))
  add(query_580039, "callback", newJString(callback))
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "access_token", newJString(accessToken))
  add(query_580039, "upload_protocol", newJString(uploadProtocol))
  add(query_580039, "resourceName", newJString(resourceName))
  result = call_580037.call(path_580038, query_580039, nil, nil, nil)

var sqlInstancesDelete* = Call_SqlInstancesDelete_580019(
    name: "sqlInstancesDelete", meth: HttpMethod.HttpDelete,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}",
    validator: validate_SqlInstancesDelete_580020, base: "/",
    url: url_SqlInstancesDelete_580021, schemes: {Scheme.Https})
type
  Call_SqlInstancesAddServerCa_580063 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesAddServerCa_580065(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/addServerCa")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesAddServerCa_580064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a new trusted Certificate Authority (CA) version for the specified
  ## instance. Required to prepare for a certificate rotation. If a CA version
  ## was previously added but never used in a certificate rotation, this
  ## operation replaces that version. There cannot be more than one CA version
  ## waiting to be rotated in.
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
  var valid_580066 = path.getOrDefault("instance")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "instance", valid_580066
  var valid_580067 = path.getOrDefault("project")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "project", valid_580067
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL should add this server CA.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580068 = query.getOrDefault("key")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "key", valid_580068
  var valid_580069 = query.getOrDefault("prettyPrint")
  valid_580069 = validateParameter(valid_580069, JBool, required = false,
                                 default = newJBool(true))
  if valid_580069 != nil:
    section.add "prettyPrint", valid_580069
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  var valid_580071 = query.getOrDefault("$.xgafv")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("1"))
  if valid_580071 != nil:
    section.add "$.xgafv", valid_580071
  var valid_580072 = query.getOrDefault("alt")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("json"))
  if valid_580072 != nil:
    section.add "alt", valid_580072
  var valid_580073 = query.getOrDefault("uploadType")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "uploadType", valid_580073
  var valid_580074 = query.getOrDefault("parent")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "parent", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("callback")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "callback", valid_580076
  var valid_580077 = query.getOrDefault("fields")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "fields", valid_580077
  var valid_580078 = query.getOrDefault("access_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "access_token", valid_580078
  var valid_580079 = query.getOrDefault("upload_protocol")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "upload_protocol", valid_580079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580080: Call_SqlInstancesAddServerCa_580063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a new trusted Certificate Authority (CA) version for the specified
  ## instance. Required to prepare for a certificate rotation. If a CA version
  ## was previously added but never used in a certificate rotation, this
  ## operation replaces that version. There cannot be more than one CA version
  ## waiting to be rotated in.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_SqlInstancesAddServerCa_580063; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlInstancesAddServerCa
  ## Add a new trusted Certificate Authority (CA) version for the specified
  ## instance. Required to prepare for a certificate rotation. If a CA version
  ## was previously added but never used in a certificate rotation, this
  ## operation replaces that version. There cannot be more than one CA version
  ## waiting to be rotated in.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL should add this server CA.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  add(query_580083, "key", newJString(key))
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "$.xgafv", newJString(Xgafv))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "uploadType", newJString(uploadType))
  add(query_580083, "parent", newJString(parent))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(path_580082, "instance", newJString(instance))
  add(path_580082, "project", newJString(project))
  add(query_580083, "callback", newJString(callback))
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "access_token", newJString(accessToken))
  add(query_580083, "upload_protocol", newJString(uploadProtocol))
  result = call_580081.call(path_580082, query_580083, nil, nil, nil)

var sqlInstancesAddServerCa* = Call_SqlInstancesAddServerCa_580063(
    name: "sqlInstancesAddServerCa", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/addServerCa",
    validator: validate_SqlInstancesAddServerCa_580064, base: "/",
    url: url_SqlInstancesAddServerCa_580065, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsInsert_580107 = ref object of OpenApiRestCall_579373
proc url_SqlBackupRunsInsert_580109(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/backupRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlBackupRunsInsert_580108(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new backup run on demand. This method is applicable only to
  ## Second Generation instances.
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
  var valid_580110 = path.getOrDefault("instance")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "instance", valid_580110
  var valid_580111 = path.getOrDefault("project")
  valid_580111 = validateParameter(valid_580111, JString, required = true,
                                 default = nil)
  if valid_580111 != nil:
    section.add "project", valid_580111
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL should create this backupRun.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("prettyPrint")
  valid_580113 = validateParameter(valid_580113, JBool, required = false,
                                 default = newJBool(true))
  if valid_580113 != nil:
    section.add "prettyPrint", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("$.xgafv")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = newJString("1"))
  if valid_580115 != nil:
    section.add "$.xgafv", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("uploadType")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "uploadType", valid_580117
  var valid_580118 = query.getOrDefault("parent")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "parent", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("callback")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "callback", valid_580120
  var valid_580121 = query.getOrDefault("fields")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "fields", valid_580121
  var valid_580122 = query.getOrDefault("access_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "access_token", valid_580122
  var valid_580123 = query.getOrDefault("upload_protocol")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "upload_protocol", valid_580123
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

proc call*(call_580125: Call_SqlBackupRunsInsert_580107; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new backup run on demand. This method is applicable only to
  ## Second Generation instances.
  ## 
  let valid = call_580125.validator(path, query, header, formData, body)
  let scheme = call_580125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580125.url(scheme.get, call_580125.host, call_580125.base,
                         call_580125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580125, url, valid)

proc call*(call_580126: Call_SqlBackupRunsInsert_580107; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlBackupRunsInsert
  ## Creates a new backup run on demand. This method is applicable only to
  ## Second Generation instances.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL should create this backupRun.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580127 = newJObject()
  var query_580128 = newJObject()
  var body_580129 = newJObject()
  add(query_580128, "key", newJString(key))
  add(query_580128, "prettyPrint", newJBool(prettyPrint))
  add(query_580128, "oauth_token", newJString(oauthToken))
  add(query_580128, "$.xgafv", newJString(Xgafv))
  add(query_580128, "alt", newJString(alt))
  add(query_580128, "uploadType", newJString(uploadType))
  add(query_580128, "parent", newJString(parent))
  add(query_580128, "quotaUser", newJString(quotaUser))
  add(path_580127, "instance", newJString(instance))
  add(path_580127, "project", newJString(project))
  if body != nil:
    body_580129 = body
  add(query_580128, "callback", newJString(callback))
  add(query_580128, "fields", newJString(fields))
  add(query_580128, "access_token", newJString(accessToken))
  add(query_580128, "upload_protocol", newJString(uploadProtocol))
  result = call_580126.call(path_580127, query_580128, nil, nil, body_580129)

var sqlBackupRunsInsert* = Call_SqlBackupRunsInsert_580107(
    name: "sqlBackupRunsInsert", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsInsert_580108, base: "/",
    url: url_SqlBackupRunsInsert_580109, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsList_580084 = ref object of OpenApiRestCall_579373
proc url_SqlBackupRunsList_580086(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/backupRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlBackupRunsList_580085(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all backup runs associated with a given instance and configuration in
  ## the reverse chronological order of the backup initiation time.
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
  var valid_580087 = path.getOrDefault("instance")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "instance", valid_580087
  var valid_580088 = path.getOrDefault("project")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "project", valid_580088
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent, which owns this collection of backupRuns.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of
  ## results to view.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxResults: JInt
  ##             : Maximum number of backup runs per response.
  section = newJObject()
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("prettyPrint")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "prettyPrint", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("$.xgafv")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("1"))
  if valid_580092 != nil:
    section.add "$.xgafv", valid_580092
  var valid_580093 = query.getOrDefault("alt")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("json"))
  if valid_580093 != nil:
    section.add "alt", valid_580093
  var valid_580094 = query.getOrDefault("uploadType")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "uploadType", valid_580094
  var valid_580095 = query.getOrDefault("parent")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "parent", valid_580095
  var valid_580096 = query.getOrDefault("quotaUser")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "quotaUser", valid_580096
  var valid_580097 = query.getOrDefault("pageToken")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "pageToken", valid_580097
  var valid_580098 = query.getOrDefault("callback")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "callback", valid_580098
  var valid_580099 = query.getOrDefault("fields")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "fields", valid_580099
  var valid_580100 = query.getOrDefault("access_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "access_token", valid_580100
  var valid_580101 = query.getOrDefault("upload_protocol")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "upload_protocol", valid_580101
  var valid_580102 = query.getOrDefault("maxResults")
  valid_580102 = validateParameter(valid_580102, JInt, required = false, default = nil)
  if valid_580102 != nil:
    section.add "maxResults", valid_580102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580103: Call_SqlBackupRunsList_580084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all backup runs associated with a given instance and configuration in
  ## the reverse chronological order of the backup initiation time.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_SqlBackupRunsList_580084; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; maxResults: int = 0): Recallable =
  ## sqlBackupRunsList
  ## Lists all backup runs associated with a given instance and configuration in
  ## the reverse chronological order of the backup initiation time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent, which owns this collection of backupRuns.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of
  ## results to view.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxResults: int
  ##             : Maximum number of backup runs per response.
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  add(query_580106, "key", newJString(key))
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "$.xgafv", newJString(Xgafv))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "uploadType", newJString(uploadType))
  add(query_580106, "parent", newJString(parent))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(query_580106, "pageToken", newJString(pageToken))
  add(path_580105, "instance", newJString(instance))
  add(path_580105, "project", newJString(project))
  add(query_580106, "callback", newJString(callback))
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "access_token", newJString(accessToken))
  add(query_580106, "upload_protocol", newJString(uploadProtocol))
  add(query_580106, "maxResults", newJInt(maxResults))
  result = call_580104.call(path_580105, query_580106, nil, nil, nil)

var sqlBackupRunsList* = Call_SqlBackupRunsList_580084(name: "sqlBackupRunsList",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/backupRuns",
    validator: validate_SqlBackupRunsList_580085, base: "/",
    url: url_SqlBackupRunsList_580086, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsGet_580130 = ref object of OpenApiRestCall_579373
proc url_SqlBackupRunsGet_580132(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/backupRuns/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlBackupRunsGet_580131(path: JsonNode; query: JsonNode;
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
  var valid_580133 = path.getOrDefault("id")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "id", valid_580133
  var valid_580134 = path.getOrDefault("instance")
  valid_580134 = validateParameter(valid_580134, JString, required = true,
                                 default = nil)
  if valid_580134 != nil:
    section.add "instance", valid_580134
  var valid_580135 = path.getOrDefault("project")
  valid_580135 = validateParameter(valid_580135, JString, required = true,
                                 default = nil)
  if valid_580135 != nil:
    section.add "project", valid_580135
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : Name of the resource backupRun.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/backupRuns/{backupRun}
  section = newJObject()
  var valid_580136 = query.getOrDefault("key")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "key", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
  var valid_580138 = query.getOrDefault("oauth_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "oauth_token", valid_580138
  var valid_580139 = query.getOrDefault("$.xgafv")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = newJString("1"))
  if valid_580139 != nil:
    section.add "$.xgafv", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("uploadType")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "uploadType", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("callback")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "callback", valid_580143
  var valid_580144 = query.getOrDefault("fields")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "fields", valid_580144
  var valid_580145 = query.getOrDefault("access_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "access_token", valid_580145
  var valid_580146 = query.getOrDefault("upload_protocol")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "upload_protocol", valid_580146
  var valid_580147 = query.getOrDefault("resourceName")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "resourceName", valid_580147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580148: Call_SqlBackupRunsGet_580130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a backup run.
  ## 
  let valid = call_580148.validator(path, query, header, formData, body)
  let scheme = call_580148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580148.url(scheme.get, call_580148.host, call_580148.base,
                         call_580148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580148, url, valid)

proc call*(call_580149: Call_SqlBackupRunsGet_580130; id: string; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
  ## sqlBackupRunsGet
  ## Retrieves a resource containing information about a backup run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : The ID of this Backup Run.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : Name of the resource backupRun.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/backupRuns/{backupRun}
  var path_580150 = newJObject()
  var query_580151 = newJObject()
  add(query_580151, "key", newJString(key))
  add(query_580151, "prettyPrint", newJBool(prettyPrint))
  add(query_580151, "oauth_token", newJString(oauthToken))
  add(query_580151, "$.xgafv", newJString(Xgafv))
  add(path_580150, "id", newJString(id))
  add(query_580151, "alt", newJString(alt))
  add(query_580151, "uploadType", newJString(uploadType))
  add(query_580151, "quotaUser", newJString(quotaUser))
  add(path_580150, "instance", newJString(instance))
  add(path_580150, "project", newJString(project))
  add(query_580151, "callback", newJString(callback))
  add(query_580151, "fields", newJString(fields))
  add(query_580151, "access_token", newJString(accessToken))
  add(query_580151, "upload_protocol", newJString(uploadProtocol))
  add(query_580151, "resourceName", newJString(resourceName))
  result = call_580149.call(path_580150, query_580151, nil, nil, nil)

var sqlBackupRunsGet* = Call_SqlBackupRunsGet_580130(name: "sqlBackupRunsGet",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/backupRuns/{id}",
    validator: validate_SqlBackupRunsGet_580131, base: "/",
    url: url_SqlBackupRunsGet_580132, schemes: {Scheme.Https})
type
  Call_SqlBackupRunsDelete_580152 = ref object of OpenApiRestCall_579373
proc url_SqlBackupRunsDelete_580154(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/backupRuns/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlBackupRunsDelete_580153(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes the backup taken by a backup run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The ID of the Backup Run to delete. To find a Backup Run ID, use the <a
  ## href="/sql/docs/db_path/admin-api/rest/v1beta4/backupRuns/list">list</a>
  ## method.
  ##   instance: JString (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580155 = path.getOrDefault("id")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "id", valid_580155
  var valid_580156 = path.getOrDefault("instance")
  valid_580156 = validateParameter(valid_580156, JString, required = true,
                                 default = nil)
  if valid_580156 != nil:
    section.add "instance", valid_580156
  var valid_580157 = path.getOrDefault("project")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "project", valid_580157
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of the backupRun to delete.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/backupRuns/{backupRun}
  section = newJObject()
  var valid_580158 = query.getOrDefault("key")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "key", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
  var valid_580160 = query.getOrDefault("oauth_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "oauth_token", valid_580160
  var valid_580161 = query.getOrDefault("$.xgafv")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("1"))
  if valid_580161 != nil:
    section.add "$.xgafv", valid_580161
  var valid_580162 = query.getOrDefault("alt")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = newJString("json"))
  if valid_580162 != nil:
    section.add "alt", valid_580162
  var valid_580163 = query.getOrDefault("uploadType")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "uploadType", valid_580163
  var valid_580164 = query.getOrDefault("quotaUser")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "quotaUser", valid_580164
  var valid_580165 = query.getOrDefault("callback")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "callback", valid_580165
  var valid_580166 = query.getOrDefault("fields")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "fields", valid_580166
  var valid_580167 = query.getOrDefault("access_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "access_token", valid_580167
  var valid_580168 = query.getOrDefault("upload_protocol")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "upload_protocol", valid_580168
  var valid_580169 = query.getOrDefault("resourceName")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "resourceName", valid_580169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580170: Call_SqlBackupRunsDelete_580152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the backup taken by a backup run.
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_SqlBackupRunsDelete_580152; id: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
  ## sqlBackupRunsDelete
  ## Deletes the backup taken by a backup run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   id: string (required)
  ##     : The ID of the Backup Run to delete. To find a Backup Run ID, use the <a
  ## href="/sql/docs/db_path/admin-api/rest/v1beta4/backupRuns/list">list</a>
  ## method.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of the backupRun to delete.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/backupRuns/{backupRun}
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  add(query_580173, "key", newJString(key))
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "$.xgafv", newJString(Xgafv))
  add(path_580172, "id", newJString(id))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "uploadType", newJString(uploadType))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(path_580172, "instance", newJString(instance))
  add(path_580172, "project", newJString(project))
  add(query_580173, "callback", newJString(callback))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "access_token", newJString(accessToken))
  add(query_580173, "upload_protocol", newJString(uploadProtocol))
  add(query_580173, "resourceName", newJString(resourceName))
  result = call_580171.call(path_580172, query_580173, nil, nil, nil)

var sqlBackupRunsDelete* = Call_SqlBackupRunsDelete_580152(
    name: "sqlBackupRunsDelete", meth: HttpMethod.HttpDelete,
    host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/backupRuns/{id}",
    validator: validate_SqlBackupRunsDelete_580153, base: "/",
    url: url_SqlBackupRunsDelete_580154, schemes: {Scheme.Https})
type
  Call_SqlInstancesClone_580174 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesClone_580176(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/clone")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesClone_580175(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a Cloud SQL instance as a clone of the source instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   instance: JString (required)
  ##           : The ID of the Cloud SQL instance to be cloned (source). This does not
  ## include the project ID.
  ##   project: JString (required)
  ##          : Project ID of the source as well as the clone Cloud SQL instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `instance` field"
  var valid_580177 = path.getOrDefault("instance")
  valid_580177 = validateParameter(valid_580177, JString, required = true,
                                 default = nil)
  if valid_580177 != nil:
    section.add "instance", valid_580177
  var valid_580178 = path.getOrDefault("project")
  valid_580178 = validateParameter(valid_580178, JString, required = true,
                                 default = nil)
  if valid_580178 != nil:
    section.add "project", valid_580178
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL should clone this instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580179 = query.getOrDefault("key")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "key", valid_580179
  var valid_580180 = query.getOrDefault("prettyPrint")
  valid_580180 = validateParameter(valid_580180, JBool, required = false,
                                 default = newJBool(true))
  if valid_580180 != nil:
    section.add "prettyPrint", valid_580180
  var valid_580181 = query.getOrDefault("oauth_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "oauth_token", valid_580181
  var valid_580182 = query.getOrDefault("$.xgafv")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("1"))
  if valid_580182 != nil:
    section.add "$.xgafv", valid_580182
  var valid_580183 = query.getOrDefault("alt")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("json"))
  if valid_580183 != nil:
    section.add "alt", valid_580183
  var valid_580184 = query.getOrDefault("uploadType")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "uploadType", valid_580184
  var valid_580185 = query.getOrDefault("parent")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "parent", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("callback")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "callback", valid_580187
  var valid_580188 = query.getOrDefault("fields")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "fields", valid_580188
  var valid_580189 = query.getOrDefault("access_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "access_token", valid_580189
  var valid_580190 = query.getOrDefault("upload_protocol")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "upload_protocol", valid_580190
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

proc call*(call_580192: Call_SqlInstancesClone_580174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Cloud SQL instance as a clone of the source instance.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_SqlInstancesClone_580174; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlInstancesClone
  ## Creates a Cloud SQL instance as a clone of the source instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL should clone this instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : The ID of the Cloud SQL instance to be cloned (source). This does not
  ## include the project ID.
  ##   project: string (required)
  ##          : Project ID of the source as well as the clone Cloud SQL instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  var body_580196 = newJObject()
  add(query_580195, "key", newJString(key))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "$.xgafv", newJString(Xgafv))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "uploadType", newJString(uploadType))
  add(query_580195, "parent", newJString(parent))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(path_580194, "instance", newJString(instance))
  add(path_580194, "project", newJString(project))
  if body != nil:
    body_580196 = body
  add(query_580195, "callback", newJString(callback))
  add(query_580195, "fields", newJString(fields))
  add(query_580195, "access_token", newJString(accessToken))
  add(query_580195, "upload_protocol", newJString(uploadProtocol))
  result = call_580193.call(path_580194, query_580195, nil, nil, body_580196)

var sqlInstancesClone* = Call_SqlInstancesClone_580174(name: "sqlInstancesClone",
    meth: HttpMethod.HttpPost, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/clone",
    validator: validate_SqlInstancesClone_580175, base: "/",
    url: url_SqlInstancesClone_580176, schemes: {Scheme.Https})
type
  Call_SqlSslCertsCreateEphemeral_580197 = ref object of OpenApiRestCall_579373
proc url_SqlSslCertsCreateEphemeral_580199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/createEphemeral")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlSslCertsCreateEphemeral_580198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a short-lived X509 certificate containing the provided public key
  ## and signed by a private key specific to the target instance. Users may use
  ## the certificate to authenticate as themselves when connecting to the
  ## database.
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL creates this ephemeral certificate.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580202 = query.getOrDefault("key")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "key", valid_580202
  var valid_580203 = query.getOrDefault("prettyPrint")
  valid_580203 = validateParameter(valid_580203, JBool, required = false,
                                 default = newJBool(true))
  if valid_580203 != nil:
    section.add "prettyPrint", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("$.xgafv")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = newJString("1"))
  if valid_580205 != nil:
    section.add "$.xgafv", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("uploadType")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "uploadType", valid_580207
  var valid_580208 = query.getOrDefault("parent")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "parent", valid_580208
  var valid_580209 = query.getOrDefault("quotaUser")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "quotaUser", valid_580209
  var valid_580210 = query.getOrDefault("callback")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "callback", valid_580210
  var valid_580211 = query.getOrDefault("fields")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "fields", valid_580211
  var valid_580212 = query.getOrDefault("access_token")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "access_token", valid_580212
  var valid_580213 = query.getOrDefault("upload_protocol")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "upload_protocol", valid_580213
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

proc call*(call_580215: Call_SqlSslCertsCreateEphemeral_580197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a short-lived X509 certificate containing the provided public key
  ## and signed by a private key specific to the target instance. Users may use
  ## the certificate to authenticate as themselves when connecting to the
  ## database.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_SqlSslCertsCreateEphemeral_580197; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlSslCertsCreateEphemeral
  ## Generates a short-lived X509 certificate containing the provided public key
  ## and signed by a private key specific to the target instance. Users may use
  ## the certificate to authenticate as themselves when connecting to the
  ## database.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL creates this ephemeral certificate.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the Cloud SQL project.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580217 = newJObject()
  var query_580218 = newJObject()
  var body_580219 = newJObject()
  add(query_580218, "key", newJString(key))
  add(query_580218, "prettyPrint", newJBool(prettyPrint))
  add(query_580218, "oauth_token", newJString(oauthToken))
  add(query_580218, "$.xgafv", newJString(Xgafv))
  add(query_580218, "alt", newJString(alt))
  add(query_580218, "uploadType", newJString(uploadType))
  add(query_580218, "parent", newJString(parent))
  add(query_580218, "quotaUser", newJString(quotaUser))
  add(path_580217, "instance", newJString(instance))
  add(path_580217, "project", newJString(project))
  if body != nil:
    body_580219 = body
  add(query_580218, "callback", newJString(callback))
  add(query_580218, "fields", newJString(fields))
  add(query_580218, "access_token", newJString(accessToken))
  add(query_580218, "upload_protocol", newJString(uploadProtocol))
  result = call_580216.call(path_580217, query_580218, nil, nil, body_580219)

var sqlSslCertsCreateEphemeral* = Call_SqlSslCertsCreateEphemeral_580197(
    name: "sqlSslCertsCreateEphemeral", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/createEphemeral",
    validator: validate_SqlSslCertsCreateEphemeral_580198, base: "/",
    url: url_SqlSslCertsCreateEphemeral_580199, schemes: {Scheme.Https})
type
  Call_SqlDatabasesInsert_580241 = ref object of OpenApiRestCall_579373
proc url_SqlDatabasesInsert_580243(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlDatabasesInsert_580242(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Inserts a resource containing information about a database inside a Cloud
  ## SQL instance.
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
  var valid_580244 = path.getOrDefault("instance")
  valid_580244 = validateParameter(valid_580244, JString, required = true,
                                 default = nil)
  if valid_580244 != nil:
    section.add "instance", valid_580244
  var valid_580245 = path.getOrDefault("project")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = nil)
  if valid_580245 != nil:
    section.add "project", valid_580245
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL should add this database.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580246 = query.getOrDefault("key")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "key", valid_580246
  var valid_580247 = query.getOrDefault("prettyPrint")
  valid_580247 = validateParameter(valid_580247, JBool, required = false,
                                 default = newJBool(true))
  if valid_580247 != nil:
    section.add "prettyPrint", valid_580247
  var valid_580248 = query.getOrDefault("oauth_token")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "oauth_token", valid_580248
  var valid_580249 = query.getOrDefault("$.xgafv")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("1"))
  if valid_580249 != nil:
    section.add "$.xgafv", valid_580249
  var valid_580250 = query.getOrDefault("alt")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = newJString("json"))
  if valid_580250 != nil:
    section.add "alt", valid_580250
  var valid_580251 = query.getOrDefault("uploadType")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "uploadType", valid_580251
  var valid_580252 = query.getOrDefault("parent")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "parent", valid_580252
  var valid_580253 = query.getOrDefault("quotaUser")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "quotaUser", valid_580253
  var valid_580254 = query.getOrDefault("callback")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "callback", valid_580254
  var valid_580255 = query.getOrDefault("fields")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "fields", valid_580255
  var valid_580256 = query.getOrDefault("access_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "access_token", valid_580256
  var valid_580257 = query.getOrDefault("upload_protocol")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "upload_protocol", valid_580257
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

proc call*(call_580259: Call_SqlDatabasesInsert_580241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a resource containing information about a database inside a Cloud
  ## SQL instance.
  ## 
  let valid = call_580259.validator(path, query, header, formData, body)
  let scheme = call_580259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580259.url(scheme.get, call_580259.host, call_580259.base,
                         call_580259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580259, url, valid)

proc call*(call_580260: Call_SqlDatabasesInsert_580241; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlDatabasesInsert
  ## Inserts a resource containing information about a database inside a Cloud
  ## SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL should add this database.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580261 = newJObject()
  var query_580262 = newJObject()
  var body_580263 = newJObject()
  add(query_580262, "key", newJString(key))
  add(query_580262, "prettyPrint", newJBool(prettyPrint))
  add(query_580262, "oauth_token", newJString(oauthToken))
  add(query_580262, "$.xgafv", newJString(Xgafv))
  add(query_580262, "alt", newJString(alt))
  add(query_580262, "uploadType", newJString(uploadType))
  add(query_580262, "parent", newJString(parent))
  add(query_580262, "quotaUser", newJString(quotaUser))
  add(path_580261, "instance", newJString(instance))
  add(path_580261, "project", newJString(project))
  if body != nil:
    body_580263 = body
  add(query_580262, "callback", newJString(callback))
  add(query_580262, "fields", newJString(fields))
  add(query_580262, "access_token", newJString(accessToken))
  add(query_580262, "upload_protocol", newJString(uploadProtocol))
  result = call_580260.call(path_580261, query_580262, nil, nil, body_580263)

var sqlDatabasesInsert* = Call_SqlDatabasesInsert_580241(
    name: "sqlDatabasesInsert", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/databases",
    validator: validate_SqlDatabasesInsert_580242, base: "/",
    url: url_SqlDatabasesInsert_580243, schemes: {Scheme.Https})
type
  Call_SqlDatabasesList_580220 = ref object of OpenApiRestCall_579373
proc url_SqlDatabasesList_580222(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlDatabasesList_580221(path: JsonNode; query: JsonNode;
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
  var valid_580223 = path.getOrDefault("instance")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "instance", valid_580223
  var valid_580224 = path.getOrDefault("project")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "project", valid_580224
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent, which owns this collection of databases.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580225 = query.getOrDefault("key")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "key", valid_580225
  var valid_580226 = query.getOrDefault("prettyPrint")
  valid_580226 = validateParameter(valid_580226, JBool, required = false,
                                 default = newJBool(true))
  if valid_580226 != nil:
    section.add "prettyPrint", valid_580226
  var valid_580227 = query.getOrDefault("oauth_token")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "oauth_token", valid_580227
  var valid_580228 = query.getOrDefault("$.xgafv")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("1"))
  if valid_580228 != nil:
    section.add "$.xgafv", valid_580228
  var valid_580229 = query.getOrDefault("alt")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("json"))
  if valid_580229 != nil:
    section.add "alt", valid_580229
  var valid_580230 = query.getOrDefault("uploadType")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "uploadType", valid_580230
  var valid_580231 = query.getOrDefault("parent")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "parent", valid_580231
  var valid_580232 = query.getOrDefault("quotaUser")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "quotaUser", valid_580232
  var valid_580233 = query.getOrDefault("callback")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "callback", valid_580233
  var valid_580234 = query.getOrDefault("fields")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "fields", valid_580234
  var valid_580235 = query.getOrDefault("access_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "access_token", valid_580235
  var valid_580236 = query.getOrDefault("upload_protocol")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "upload_protocol", valid_580236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580237: Call_SqlDatabasesList_580220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists databases in the specified Cloud SQL instance.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_SqlDatabasesList_580220; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlDatabasesList
  ## Lists databases in the specified Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent, which owns this collection of databases.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  add(query_580240, "key", newJString(key))
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(query_580240, "$.xgafv", newJString(Xgafv))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "uploadType", newJString(uploadType))
  add(query_580240, "parent", newJString(parent))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(path_580239, "instance", newJString(instance))
  add(path_580239, "project", newJString(project))
  add(query_580240, "callback", newJString(callback))
  add(query_580240, "fields", newJString(fields))
  add(query_580240, "access_token", newJString(accessToken))
  add(query_580240, "upload_protocol", newJString(uploadProtocol))
  result = call_580238.call(path_580239, query_580240, nil, nil, nil)

var sqlDatabasesList* = Call_SqlDatabasesList_580220(name: "sqlDatabasesList",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/databases",
    validator: validate_SqlDatabasesList_580221, base: "/",
    url: url_SqlDatabasesList_580222, schemes: {Scheme.Https})
type
  Call_SqlDatabasesUpdate_580286 = ref object of OpenApiRestCall_579373
proc url_SqlDatabasesUpdate_580288(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlDatabasesUpdate_580287(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates a resource containing information about a database inside a Cloud
  ## SQL instance.
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
  var valid_580289 = path.getOrDefault("database")
  valid_580289 = validateParameter(valid_580289, JString, required = true,
                                 default = nil)
  if valid_580289 != nil:
    section.add "database", valid_580289
  var valid_580290 = path.getOrDefault("instance")
  valid_580290 = validateParameter(valid_580290, JString, required = true,
                                 default = nil)
  if valid_580290 != nil:
    section.add "instance", valid_580290
  var valid_580291 = path.getOrDefault("project")
  valid_580291 = validateParameter(valid_580291, JString, required = true,
                                 default = nil)
  if valid_580291 != nil:
    section.add "project", valid_580291
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of the database for Cloud SQL to update.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/databases/{database}
  section = newJObject()
  var valid_580292 = query.getOrDefault("key")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "key", valid_580292
  var valid_580293 = query.getOrDefault("prettyPrint")
  valid_580293 = validateParameter(valid_580293, JBool, required = false,
                                 default = newJBool(true))
  if valid_580293 != nil:
    section.add "prettyPrint", valid_580293
  var valid_580294 = query.getOrDefault("oauth_token")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "oauth_token", valid_580294
  var valid_580295 = query.getOrDefault("$.xgafv")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = newJString("1"))
  if valid_580295 != nil:
    section.add "$.xgafv", valid_580295
  var valid_580296 = query.getOrDefault("alt")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("json"))
  if valid_580296 != nil:
    section.add "alt", valid_580296
  var valid_580297 = query.getOrDefault("uploadType")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "uploadType", valid_580297
  var valid_580298 = query.getOrDefault("quotaUser")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "quotaUser", valid_580298
  var valid_580299 = query.getOrDefault("callback")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "callback", valid_580299
  var valid_580300 = query.getOrDefault("fields")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "fields", valid_580300
  var valid_580301 = query.getOrDefault("access_token")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "access_token", valid_580301
  var valid_580302 = query.getOrDefault("upload_protocol")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "upload_protocol", valid_580302
  var valid_580303 = query.getOrDefault("resourceName")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "resourceName", valid_580303
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

proc call*(call_580305: Call_SqlDatabasesUpdate_580286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource containing information about a database inside a Cloud
  ## SQL instance.
  ## 
  let valid = call_580305.validator(path, query, header, formData, body)
  let scheme = call_580305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580305.url(scheme.get, call_580305.host, call_580305.base,
                         call_580305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580305, url, valid)

proc call*(call_580306: Call_SqlDatabasesUpdate_580286; database: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; resourceName: string = ""): Recallable =
  ## sqlDatabasesUpdate
  ## Updates a resource containing information about a database inside a Cloud
  ## SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Name of the database to be updated in the instance.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of the database for Cloud SQL to update.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/databases/{database}
  var path_580307 = newJObject()
  var query_580308 = newJObject()
  var body_580309 = newJObject()
  add(query_580308, "key", newJString(key))
  add(query_580308, "prettyPrint", newJBool(prettyPrint))
  add(query_580308, "oauth_token", newJString(oauthToken))
  add(path_580307, "database", newJString(database))
  add(query_580308, "$.xgafv", newJString(Xgafv))
  add(query_580308, "alt", newJString(alt))
  add(query_580308, "uploadType", newJString(uploadType))
  add(query_580308, "quotaUser", newJString(quotaUser))
  add(path_580307, "instance", newJString(instance))
  add(path_580307, "project", newJString(project))
  if body != nil:
    body_580309 = body
  add(query_580308, "callback", newJString(callback))
  add(query_580308, "fields", newJString(fields))
  add(query_580308, "access_token", newJString(accessToken))
  add(query_580308, "upload_protocol", newJString(uploadProtocol))
  add(query_580308, "resourceName", newJString(resourceName))
  result = call_580306.call(path_580307, query_580308, nil, nil, body_580309)

var sqlDatabasesUpdate* = Call_SqlDatabasesUpdate_580286(
    name: "sqlDatabasesUpdate", meth: HttpMethod.HttpPut,
    host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesUpdate_580287, base: "/",
    url: url_SqlDatabasesUpdate_580288, schemes: {Scheme.Https})
type
  Call_SqlDatabasesGet_580264 = ref object of OpenApiRestCall_579373
proc url_SqlDatabasesGet_580266(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlDatabasesGet_580265(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Retrieves a resource containing information about a database inside a Cloud
  ## SQL instance.
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
  var valid_580267 = path.getOrDefault("database")
  valid_580267 = validateParameter(valid_580267, JString, required = true,
                                 default = nil)
  if valid_580267 != nil:
    section.add "database", valid_580267
  var valid_580268 = path.getOrDefault("instance")
  valid_580268 = validateParameter(valid_580268, JString, required = true,
                                 default = nil)
  if valid_580268 != nil:
    section.add "instance", valid_580268
  var valid_580269 = path.getOrDefault("project")
  valid_580269 = validateParameter(valid_580269, JString, required = true,
                                 default = nil)
  if valid_580269 != nil:
    section.add "project", valid_580269
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : Name of the resource database.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/databases/{database}
  section = newJObject()
  var valid_580270 = query.getOrDefault("key")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "key", valid_580270
  var valid_580271 = query.getOrDefault("prettyPrint")
  valid_580271 = validateParameter(valid_580271, JBool, required = false,
                                 default = newJBool(true))
  if valid_580271 != nil:
    section.add "prettyPrint", valid_580271
  var valid_580272 = query.getOrDefault("oauth_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "oauth_token", valid_580272
  var valid_580273 = query.getOrDefault("$.xgafv")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = newJString("1"))
  if valid_580273 != nil:
    section.add "$.xgafv", valid_580273
  var valid_580274 = query.getOrDefault("alt")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("json"))
  if valid_580274 != nil:
    section.add "alt", valid_580274
  var valid_580275 = query.getOrDefault("uploadType")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "uploadType", valid_580275
  var valid_580276 = query.getOrDefault("quotaUser")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "quotaUser", valid_580276
  var valid_580277 = query.getOrDefault("callback")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "callback", valid_580277
  var valid_580278 = query.getOrDefault("fields")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "fields", valid_580278
  var valid_580279 = query.getOrDefault("access_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "access_token", valid_580279
  var valid_580280 = query.getOrDefault("upload_protocol")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "upload_protocol", valid_580280
  var valid_580281 = query.getOrDefault("resourceName")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "resourceName", valid_580281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580282: Call_SqlDatabasesGet_580264; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a resource containing information about a database inside a Cloud
  ## SQL instance.
  ## 
  let valid = call_580282.validator(path, query, header, formData, body)
  let scheme = call_580282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580282.url(scheme.get, call_580282.host, call_580282.base,
                         call_580282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580282, url, valid)

proc call*(call_580283: Call_SqlDatabasesGet_580264; database: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
  ## sqlDatabasesGet
  ## Retrieves a resource containing information about a database inside a Cloud
  ## SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Name of the database in the instance.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : Name of the resource database.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/databases/{database}
  var path_580284 = newJObject()
  var query_580285 = newJObject()
  add(query_580285, "key", newJString(key))
  add(query_580285, "prettyPrint", newJBool(prettyPrint))
  add(query_580285, "oauth_token", newJString(oauthToken))
  add(path_580284, "database", newJString(database))
  add(query_580285, "$.xgafv", newJString(Xgafv))
  add(query_580285, "alt", newJString(alt))
  add(query_580285, "uploadType", newJString(uploadType))
  add(query_580285, "quotaUser", newJString(quotaUser))
  add(path_580284, "instance", newJString(instance))
  add(path_580284, "project", newJString(project))
  add(query_580285, "callback", newJString(callback))
  add(query_580285, "fields", newJString(fields))
  add(query_580285, "access_token", newJString(accessToken))
  add(query_580285, "upload_protocol", newJString(uploadProtocol))
  add(query_580285, "resourceName", newJString(resourceName))
  result = call_580283.call(path_580284, query_580285, nil, nil, nil)

var sqlDatabasesGet* = Call_SqlDatabasesGet_580264(name: "sqlDatabasesGet",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesGet_580265, base: "/", url: url_SqlDatabasesGet_580266,
    schemes: {Scheme.Https})
type
  Call_SqlDatabasesPatch_580332 = ref object of OpenApiRestCall_579373
proc url_SqlDatabasesPatch_580334(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlDatabasesPatch_580333(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Partially updates a resource containing information about a database inside
  ## a Cloud SQL instance. This method supports patch semantics.
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
  var valid_580335 = path.getOrDefault("database")
  valid_580335 = validateParameter(valid_580335, JString, required = true,
                                 default = nil)
  if valid_580335 != nil:
    section.add "database", valid_580335
  var valid_580336 = path.getOrDefault("instance")
  valid_580336 = validateParameter(valid_580336, JString, required = true,
                                 default = nil)
  if valid_580336 != nil:
    section.add "instance", valid_580336
  var valid_580337 = path.getOrDefault("project")
  valid_580337 = validateParameter(valid_580337, JString, required = true,
                                 default = nil)
  if valid_580337 != nil:
    section.add "project", valid_580337
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of the database for Cloud SQL to update.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/databases/{database}
  section = newJObject()
  var valid_580338 = query.getOrDefault("key")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "key", valid_580338
  var valid_580339 = query.getOrDefault("prettyPrint")
  valid_580339 = validateParameter(valid_580339, JBool, required = false,
                                 default = newJBool(true))
  if valid_580339 != nil:
    section.add "prettyPrint", valid_580339
  var valid_580340 = query.getOrDefault("oauth_token")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "oauth_token", valid_580340
  var valid_580341 = query.getOrDefault("$.xgafv")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = newJString("1"))
  if valid_580341 != nil:
    section.add "$.xgafv", valid_580341
  var valid_580342 = query.getOrDefault("alt")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = newJString("json"))
  if valid_580342 != nil:
    section.add "alt", valid_580342
  var valid_580343 = query.getOrDefault("uploadType")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "uploadType", valid_580343
  var valid_580344 = query.getOrDefault("quotaUser")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "quotaUser", valid_580344
  var valid_580345 = query.getOrDefault("callback")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "callback", valid_580345
  var valid_580346 = query.getOrDefault("fields")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "fields", valid_580346
  var valid_580347 = query.getOrDefault("access_token")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "access_token", valid_580347
  var valid_580348 = query.getOrDefault("upload_protocol")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "upload_protocol", valid_580348
  var valid_580349 = query.getOrDefault("resourceName")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "resourceName", valid_580349
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

proc call*(call_580351: Call_SqlDatabasesPatch_580332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Partially updates a resource containing information about a database inside
  ## a Cloud SQL instance. This method supports patch semantics.
  ## 
  let valid = call_580351.validator(path, query, header, formData, body)
  let scheme = call_580351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580351.url(scheme.get, call_580351.host, call_580351.base,
                         call_580351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580351, url, valid)

proc call*(call_580352: Call_SqlDatabasesPatch_580332; database: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; resourceName: string = ""): Recallable =
  ## sqlDatabasesPatch
  ## Partially updates a resource containing information about a database inside
  ## a Cloud SQL instance. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Name of the database to be updated in the instance.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of the database for Cloud SQL to update.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/databases/{database}
  var path_580353 = newJObject()
  var query_580354 = newJObject()
  var body_580355 = newJObject()
  add(query_580354, "key", newJString(key))
  add(query_580354, "prettyPrint", newJBool(prettyPrint))
  add(query_580354, "oauth_token", newJString(oauthToken))
  add(path_580353, "database", newJString(database))
  add(query_580354, "$.xgafv", newJString(Xgafv))
  add(query_580354, "alt", newJString(alt))
  add(query_580354, "uploadType", newJString(uploadType))
  add(query_580354, "quotaUser", newJString(quotaUser))
  add(path_580353, "instance", newJString(instance))
  add(path_580353, "project", newJString(project))
  if body != nil:
    body_580355 = body
  add(query_580354, "callback", newJString(callback))
  add(query_580354, "fields", newJString(fields))
  add(query_580354, "access_token", newJString(accessToken))
  add(query_580354, "upload_protocol", newJString(uploadProtocol))
  add(query_580354, "resourceName", newJString(resourceName))
  result = call_580352.call(path_580353, query_580354, nil, nil, body_580355)

var sqlDatabasesPatch* = Call_SqlDatabasesPatch_580332(name: "sqlDatabasesPatch",
    meth: HttpMethod.HttpPatch, host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesPatch_580333, base: "/",
    url: url_SqlDatabasesPatch_580334, schemes: {Scheme.Https})
type
  Call_SqlDatabasesDelete_580310 = ref object of OpenApiRestCall_579373
proc url_SqlDatabasesDelete_580312(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlDatabasesDelete_580311(path: JsonNode; query: JsonNode;
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
  var valid_580313 = path.getOrDefault("database")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "database", valid_580313
  var valid_580314 = path.getOrDefault("instance")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "instance", valid_580314
  var valid_580315 = path.getOrDefault("project")
  valid_580315 = validateParameter(valid_580315, JString, required = true,
                                 default = nil)
  if valid_580315 != nil:
    section.add "project", valid_580315
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of the database to delete.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/databases/{database}
  section = newJObject()
  var valid_580316 = query.getOrDefault("key")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "key", valid_580316
  var valid_580317 = query.getOrDefault("prettyPrint")
  valid_580317 = validateParameter(valid_580317, JBool, required = false,
                                 default = newJBool(true))
  if valid_580317 != nil:
    section.add "prettyPrint", valid_580317
  var valid_580318 = query.getOrDefault("oauth_token")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "oauth_token", valid_580318
  var valid_580319 = query.getOrDefault("$.xgafv")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = newJString("1"))
  if valid_580319 != nil:
    section.add "$.xgafv", valid_580319
  var valid_580320 = query.getOrDefault("alt")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = newJString("json"))
  if valid_580320 != nil:
    section.add "alt", valid_580320
  var valid_580321 = query.getOrDefault("uploadType")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "uploadType", valid_580321
  var valid_580322 = query.getOrDefault("quotaUser")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "quotaUser", valid_580322
  var valid_580323 = query.getOrDefault("callback")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "callback", valid_580323
  var valid_580324 = query.getOrDefault("fields")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "fields", valid_580324
  var valid_580325 = query.getOrDefault("access_token")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "access_token", valid_580325
  var valid_580326 = query.getOrDefault("upload_protocol")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "upload_protocol", valid_580326
  var valid_580327 = query.getOrDefault("resourceName")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "resourceName", valid_580327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580328: Call_SqlDatabasesDelete_580310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a database from a Cloud SQL instance.
  ## 
  let valid = call_580328.validator(path, query, header, formData, body)
  let scheme = call_580328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580328.url(scheme.get, call_580328.host, call_580328.base,
                         call_580328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580328, url, valid)

proc call*(call_580329: Call_SqlDatabasesDelete_580310; database: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of the database to delete.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/databases/{database}
  var path_580330 = newJObject()
  var query_580331 = newJObject()
  add(query_580331, "key", newJString(key))
  add(query_580331, "prettyPrint", newJBool(prettyPrint))
  add(query_580331, "oauth_token", newJString(oauthToken))
  add(path_580330, "database", newJString(database))
  add(query_580331, "$.xgafv", newJString(Xgafv))
  add(query_580331, "alt", newJString(alt))
  add(query_580331, "uploadType", newJString(uploadType))
  add(query_580331, "quotaUser", newJString(quotaUser))
  add(path_580330, "instance", newJString(instance))
  add(path_580330, "project", newJString(project))
  add(query_580331, "callback", newJString(callback))
  add(query_580331, "fields", newJString(fields))
  add(query_580331, "access_token", newJString(accessToken))
  add(query_580331, "upload_protocol", newJString(uploadProtocol))
  add(query_580331, "resourceName", newJString(resourceName))
  result = call_580329.call(path_580330, query_580331, nil, nil, nil)

var sqlDatabasesDelete* = Call_SqlDatabasesDelete_580310(
    name: "sqlDatabasesDelete", meth: HttpMethod.HttpDelete,
    host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/databases/{database}",
    validator: validate_SqlDatabasesDelete_580311, base: "/",
    url: url_SqlDatabasesDelete_580312, schemes: {Scheme.Https})
type
  Call_SqlInstancesDemoteMaster_580356 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesDemoteMaster_580358(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/demoteMaster")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesDemoteMaster_580357(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Demotes the stand-alone instance to be a Cloud SQL read replica for an
  ## external database server.
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
  var valid_580359 = path.getOrDefault("instance")
  valid_580359 = validateParameter(valid_580359, JString, required = true,
                                 default = nil)
  if valid_580359 != nil:
    section.add "instance", valid_580359
  var valid_580360 = path.getOrDefault("project")
  valid_580360 = validateParameter(valid_580360, JString, required = true,
                                 default = nil)
  if valid_580360 != nil:
    section.add "project", valid_580360
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL demotes this master database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580361 = query.getOrDefault("key")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "key", valid_580361
  var valid_580362 = query.getOrDefault("prettyPrint")
  valid_580362 = validateParameter(valid_580362, JBool, required = false,
                                 default = newJBool(true))
  if valid_580362 != nil:
    section.add "prettyPrint", valid_580362
  var valid_580363 = query.getOrDefault("oauth_token")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "oauth_token", valid_580363
  var valid_580364 = query.getOrDefault("$.xgafv")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = newJString("1"))
  if valid_580364 != nil:
    section.add "$.xgafv", valid_580364
  var valid_580365 = query.getOrDefault("alt")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = newJString("json"))
  if valid_580365 != nil:
    section.add "alt", valid_580365
  var valid_580366 = query.getOrDefault("uploadType")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "uploadType", valid_580366
  var valid_580367 = query.getOrDefault("parent")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "parent", valid_580367
  var valid_580368 = query.getOrDefault("quotaUser")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "quotaUser", valid_580368
  var valid_580369 = query.getOrDefault("callback")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "callback", valid_580369
  var valid_580370 = query.getOrDefault("fields")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "fields", valid_580370
  var valid_580371 = query.getOrDefault("access_token")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "access_token", valid_580371
  var valid_580372 = query.getOrDefault("upload_protocol")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "upload_protocol", valid_580372
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

proc call*(call_580374: Call_SqlInstancesDemoteMaster_580356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Demotes the stand-alone instance to be a Cloud SQL read replica for an
  ## external database server.
  ## 
  let valid = call_580374.validator(path, query, header, formData, body)
  let scheme = call_580374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580374.url(scheme.get, call_580374.host, call_580374.base,
                         call_580374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580374, url, valid)

proc call*(call_580375: Call_SqlInstancesDemoteMaster_580356; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlInstancesDemoteMaster
  ## Demotes the stand-alone instance to be a Cloud SQL read replica for an
  ## external database server.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL demotes this master database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580376 = newJObject()
  var query_580377 = newJObject()
  var body_580378 = newJObject()
  add(query_580377, "key", newJString(key))
  add(query_580377, "prettyPrint", newJBool(prettyPrint))
  add(query_580377, "oauth_token", newJString(oauthToken))
  add(query_580377, "$.xgafv", newJString(Xgafv))
  add(query_580377, "alt", newJString(alt))
  add(query_580377, "uploadType", newJString(uploadType))
  add(query_580377, "parent", newJString(parent))
  add(query_580377, "quotaUser", newJString(quotaUser))
  add(path_580376, "instance", newJString(instance))
  add(path_580376, "project", newJString(project))
  if body != nil:
    body_580378 = body
  add(query_580377, "callback", newJString(callback))
  add(query_580377, "fields", newJString(fields))
  add(query_580377, "access_token", newJString(accessToken))
  add(query_580377, "upload_protocol", newJString(uploadProtocol))
  result = call_580375.call(path_580376, query_580377, nil, nil, body_580378)

var sqlInstancesDemoteMaster* = Call_SqlInstancesDemoteMaster_580356(
    name: "sqlInstancesDemoteMaster", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/demoteMaster",
    validator: validate_SqlInstancesDemoteMaster_580357, base: "/",
    url: url_SqlInstancesDemoteMaster_580358, schemes: {Scheme.Https})
type
  Call_SqlInstancesExport_580379 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesExport_580381(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesExport_580380(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Exports data from a Cloud SQL instance to a Cloud Storage bucket as a SQL
  ## dump or CSV file.
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
  var valid_580382 = path.getOrDefault("instance")
  valid_580382 = validateParameter(valid_580382, JString, required = true,
                                 default = nil)
  if valid_580382 != nil:
    section.add "instance", valid_580382
  var valid_580383 = path.getOrDefault("project")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "project", valid_580383
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL exports this database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580384 = query.getOrDefault("key")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "key", valid_580384
  var valid_580385 = query.getOrDefault("prettyPrint")
  valid_580385 = validateParameter(valid_580385, JBool, required = false,
                                 default = newJBool(true))
  if valid_580385 != nil:
    section.add "prettyPrint", valid_580385
  var valid_580386 = query.getOrDefault("oauth_token")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "oauth_token", valid_580386
  var valid_580387 = query.getOrDefault("$.xgafv")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = newJString("1"))
  if valid_580387 != nil:
    section.add "$.xgafv", valid_580387
  var valid_580388 = query.getOrDefault("alt")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("json"))
  if valid_580388 != nil:
    section.add "alt", valid_580388
  var valid_580389 = query.getOrDefault("uploadType")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "uploadType", valid_580389
  var valid_580390 = query.getOrDefault("parent")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "parent", valid_580390
  var valid_580391 = query.getOrDefault("quotaUser")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "quotaUser", valid_580391
  var valid_580392 = query.getOrDefault("callback")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "callback", valid_580392
  var valid_580393 = query.getOrDefault("fields")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "fields", valid_580393
  var valid_580394 = query.getOrDefault("access_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "access_token", valid_580394
  var valid_580395 = query.getOrDefault("upload_protocol")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "upload_protocol", valid_580395
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

proc call*(call_580397: Call_SqlInstancesExport_580379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports data from a Cloud SQL instance to a Cloud Storage bucket as a SQL
  ## dump or CSV file.
  ## 
  let valid = call_580397.validator(path, query, header, formData, body)
  let scheme = call_580397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580397.url(scheme.get, call_580397.host, call_580397.base,
                         call_580397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580397, url, valid)

proc call*(call_580398: Call_SqlInstancesExport_580379; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlInstancesExport
  ## Exports data from a Cloud SQL instance to a Cloud Storage bucket as a SQL
  ## dump or CSV file.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL exports this database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance to be exported.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580399 = newJObject()
  var query_580400 = newJObject()
  var body_580401 = newJObject()
  add(query_580400, "key", newJString(key))
  add(query_580400, "prettyPrint", newJBool(prettyPrint))
  add(query_580400, "oauth_token", newJString(oauthToken))
  add(query_580400, "$.xgafv", newJString(Xgafv))
  add(query_580400, "alt", newJString(alt))
  add(query_580400, "uploadType", newJString(uploadType))
  add(query_580400, "parent", newJString(parent))
  add(query_580400, "quotaUser", newJString(quotaUser))
  add(path_580399, "instance", newJString(instance))
  add(path_580399, "project", newJString(project))
  if body != nil:
    body_580401 = body
  add(query_580400, "callback", newJString(callback))
  add(query_580400, "fields", newJString(fields))
  add(query_580400, "access_token", newJString(accessToken))
  add(query_580400, "upload_protocol", newJString(uploadProtocol))
  result = call_580398.call(path_580399, query_580400, nil, nil, body_580401)

var sqlInstancesExport* = Call_SqlInstancesExport_580379(
    name: "sqlInstancesExport", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/export",
    validator: validate_SqlInstancesExport_580380, base: "/",
    url: url_SqlInstancesExport_580381, schemes: {Scheme.Https})
type
  Call_SqlInstancesFailover_580402 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesFailover_580404(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesFailover_580403(path: JsonNode; query: JsonNode;
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
  var valid_580405 = path.getOrDefault("instance")
  valid_580405 = validateParameter(valid_580405, JString, required = true,
                                 default = nil)
  if valid_580405 != nil:
    section.add "instance", valid_580405
  var valid_580406 = path.getOrDefault("project")
  valid_580406 = validateParameter(valid_580406, JString, required = true,
                                 default = nil)
  if valid_580406 != nil:
    section.add "project", valid_580406
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL sends this database instance during a
  ## failover. Format:
  ## projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580407 = query.getOrDefault("key")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "key", valid_580407
  var valid_580408 = query.getOrDefault("prettyPrint")
  valid_580408 = validateParameter(valid_580408, JBool, required = false,
                                 default = newJBool(true))
  if valid_580408 != nil:
    section.add "prettyPrint", valid_580408
  var valid_580409 = query.getOrDefault("oauth_token")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "oauth_token", valid_580409
  var valid_580410 = query.getOrDefault("$.xgafv")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("1"))
  if valid_580410 != nil:
    section.add "$.xgafv", valid_580410
  var valid_580411 = query.getOrDefault("alt")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("json"))
  if valid_580411 != nil:
    section.add "alt", valid_580411
  var valid_580412 = query.getOrDefault("uploadType")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "uploadType", valid_580412
  var valid_580413 = query.getOrDefault("parent")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "parent", valid_580413
  var valid_580414 = query.getOrDefault("quotaUser")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "quotaUser", valid_580414
  var valid_580415 = query.getOrDefault("callback")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "callback", valid_580415
  var valid_580416 = query.getOrDefault("fields")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "fields", valid_580416
  var valid_580417 = query.getOrDefault("access_token")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "access_token", valid_580417
  var valid_580418 = query.getOrDefault("upload_protocol")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "upload_protocol", valid_580418
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

proc call*(call_580420: Call_SqlInstancesFailover_580402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Failover the instance to its failover replica instance.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_SqlInstancesFailover_580402; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlInstancesFailover
  ## Failover the instance to its failover replica instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL sends this database instance during a
  ## failover. Format:
  ## projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580422 = newJObject()
  var query_580423 = newJObject()
  var body_580424 = newJObject()
  add(query_580423, "key", newJString(key))
  add(query_580423, "prettyPrint", newJBool(prettyPrint))
  add(query_580423, "oauth_token", newJString(oauthToken))
  add(query_580423, "$.xgafv", newJString(Xgafv))
  add(query_580423, "alt", newJString(alt))
  add(query_580423, "uploadType", newJString(uploadType))
  add(query_580423, "parent", newJString(parent))
  add(query_580423, "quotaUser", newJString(quotaUser))
  add(path_580422, "instance", newJString(instance))
  add(path_580422, "project", newJString(project))
  if body != nil:
    body_580424 = body
  add(query_580423, "callback", newJString(callback))
  add(query_580423, "fields", newJString(fields))
  add(query_580423, "access_token", newJString(accessToken))
  add(query_580423, "upload_protocol", newJString(uploadProtocol))
  result = call_580421.call(path_580422, query_580423, nil, nil, body_580424)

var sqlInstancesFailover* = Call_SqlInstancesFailover_580402(
    name: "sqlInstancesFailover", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/failover",
    validator: validate_SqlInstancesFailover_580403, base: "/",
    url: url_SqlInstancesFailover_580404, schemes: {Scheme.Https})
type
  Call_SqlInstancesImport_580425 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesImport_580427(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesImport_580426(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Imports data into a Cloud SQL instance from a SQL dump  or CSV file in
  ## Cloud Storage.
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
  var valid_580428 = path.getOrDefault("instance")
  valid_580428 = validateParameter(valid_580428, JString, required = true,
                                 default = nil)
  if valid_580428 != nil:
    section.add "instance", valid_580428
  var valid_580429 = path.getOrDefault("project")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "project", valid_580429
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL imports this database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580430 = query.getOrDefault("key")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "key", valid_580430
  var valid_580431 = query.getOrDefault("prettyPrint")
  valid_580431 = validateParameter(valid_580431, JBool, required = false,
                                 default = newJBool(true))
  if valid_580431 != nil:
    section.add "prettyPrint", valid_580431
  var valid_580432 = query.getOrDefault("oauth_token")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "oauth_token", valid_580432
  var valid_580433 = query.getOrDefault("$.xgafv")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("1"))
  if valid_580433 != nil:
    section.add "$.xgafv", valid_580433
  var valid_580434 = query.getOrDefault("alt")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = newJString("json"))
  if valid_580434 != nil:
    section.add "alt", valid_580434
  var valid_580435 = query.getOrDefault("uploadType")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "uploadType", valid_580435
  var valid_580436 = query.getOrDefault("parent")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "parent", valid_580436
  var valid_580437 = query.getOrDefault("quotaUser")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "quotaUser", valid_580437
  var valid_580438 = query.getOrDefault("callback")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "callback", valid_580438
  var valid_580439 = query.getOrDefault("fields")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "fields", valid_580439
  var valid_580440 = query.getOrDefault("access_token")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "access_token", valid_580440
  var valid_580441 = query.getOrDefault("upload_protocol")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "upload_protocol", valid_580441
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

proc call*(call_580443: Call_SqlInstancesImport_580425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports data into a Cloud SQL instance from a SQL dump  or CSV file in
  ## Cloud Storage.
  ## 
  let valid = call_580443.validator(path, query, header, formData, body)
  let scheme = call_580443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580443.url(scheme.get, call_580443.host, call_580443.base,
                         call_580443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580443, url, valid)

proc call*(call_580444: Call_SqlInstancesImport_580425; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlInstancesImport
  ## Imports data into a Cloud SQL instance from a SQL dump  or CSV file in
  ## Cloud Storage.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL imports this database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580445 = newJObject()
  var query_580446 = newJObject()
  var body_580447 = newJObject()
  add(query_580446, "key", newJString(key))
  add(query_580446, "prettyPrint", newJBool(prettyPrint))
  add(query_580446, "oauth_token", newJString(oauthToken))
  add(query_580446, "$.xgafv", newJString(Xgafv))
  add(query_580446, "alt", newJString(alt))
  add(query_580446, "uploadType", newJString(uploadType))
  add(query_580446, "parent", newJString(parent))
  add(query_580446, "quotaUser", newJString(quotaUser))
  add(path_580445, "instance", newJString(instance))
  add(path_580445, "project", newJString(project))
  if body != nil:
    body_580447 = body
  add(query_580446, "callback", newJString(callback))
  add(query_580446, "fields", newJString(fields))
  add(query_580446, "access_token", newJString(accessToken))
  add(query_580446, "upload_protocol", newJString(uploadProtocol))
  result = call_580444.call(path_580445, query_580446, nil, nil, body_580447)

var sqlInstancesImport* = Call_SqlInstancesImport_580425(
    name: "sqlInstancesImport", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/import",
    validator: validate_SqlInstancesImport_580426, base: "/",
    url: url_SqlInstancesImport_580427, schemes: {Scheme.Https})
type
  Call_SqlInstancesListServerCas_580448 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesListServerCas_580450(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/listServerCas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesListServerCas_580449(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the trusted Certificate Authorities (CAs) for the specified
  ## instance. There can be up to three CAs listed: the CA that was used to sign
  ## the certificate that is currently in use, a CA that has been added but not
  ## yet used to sign a certificate, and a CA used to sign a certificate that
  ## has previously rotated out.
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
  var valid_580451 = path.getOrDefault("instance")
  valid_580451 = validateParameter(valid_580451, JString, required = true,
                                 default = nil)
  if valid_580451 != nil:
    section.add "instance", valid_580451
  var valid_580452 = path.getOrDefault("project")
  valid_580452 = validateParameter(valid_580452, JString, required = true,
                                 default = nil)
  if valid_580452 != nil:
    section.add "project", valid_580452
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent, which owns this collection of server CAs.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580453 = query.getOrDefault("key")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "key", valid_580453
  var valid_580454 = query.getOrDefault("prettyPrint")
  valid_580454 = validateParameter(valid_580454, JBool, required = false,
                                 default = newJBool(true))
  if valid_580454 != nil:
    section.add "prettyPrint", valid_580454
  var valid_580455 = query.getOrDefault("oauth_token")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "oauth_token", valid_580455
  var valid_580456 = query.getOrDefault("$.xgafv")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = newJString("1"))
  if valid_580456 != nil:
    section.add "$.xgafv", valid_580456
  var valid_580457 = query.getOrDefault("alt")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = newJString("json"))
  if valid_580457 != nil:
    section.add "alt", valid_580457
  var valid_580458 = query.getOrDefault("uploadType")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "uploadType", valid_580458
  var valid_580459 = query.getOrDefault("parent")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "parent", valid_580459
  var valid_580460 = query.getOrDefault("quotaUser")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "quotaUser", valid_580460
  var valid_580461 = query.getOrDefault("callback")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "callback", valid_580461
  var valid_580462 = query.getOrDefault("fields")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "fields", valid_580462
  var valid_580463 = query.getOrDefault("access_token")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "access_token", valid_580463
  var valid_580464 = query.getOrDefault("upload_protocol")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "upload_protocol", valid_580464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580465: Call_SqlInstancesListServerCas_580448; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the trusted Certificate Authorities (CAs) for the specified
  ## instance. There can be up to three CAs listed: the CA that was used to sign
  ## the certificate that is currently in use, a CA that has been added but not
  ## yet used to sign a certificate, and a CA used to sign a certificate that
  ## has previously rotated out.
  ## 
  let valid = call_580465.validator(path, query, header, formData, body)
  let scheme = call_580465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580465.url(scheme.get, call_580465.host, call_580465.base,
                         call_580465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580465, url, valid)

proc call*(call_580466: Call_SqlInstancesListServerCas_580448; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlInstancesListServerCas
  ## Lists all of the trusted Certificate Authorities (CAs) for the specified
  ## instance. There can be up to three CAs listed: the CA that was used to sign
  ## the certificate that is currently in use, a CA that has been added but not
  ## yet used to sign a certificate, and a CA used to sign a certificate that
  ## has previously rotated out.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent, which owns this collection of server CAs.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580467 = newJObject()
  var query_580468 = newJObject()
  add(query_580468, "key", newJString(key))
  add(query_580468, "prettyPrint", newJBool(prettyPrint))
  add(query_580468, "oauth_token", newJString(oauthToken))
  add(query_580468, "$.xgafv", newJString(Xgafv))
  add(query_580468, "alt", newJString(alt))
  add(query_580468, "uploadType", newJString(uploadType))
  add(query_580468, "parent", newJString(parent))
  add(query_580468, "quotaUser", newJString(quotaUser))
  add(path_580467, "instance", newJString(instance))
  add(path_580467, "project", newJString(project))
  add(query_580468, "callback", newJString(callback))
  add(query_580468, "fields", newJString(fields))
  add(query_580468, "access_token", newJString(accessToken))
  add(query_580468, "upload_protocol", newJString(uploadProtocol))
  result = call_580466.call(path_580467, query_580468, nil, nil, nil)

var sqlInstancesListServerCas* = Call_SqlInstancesListServerCas_580448(
    name: "sqlInstancesListServerCas", meth: HttpMethod.HttpGet,
    host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/listServerCas",
    validator: validate_SqlInstancesListServerCas_580449, base: "/",
    url: url_SqlInstancesListServerCas_580450, schemes: {Scheme.Https})
type
  Call_SqlInstancesPromoteReplica_580469 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesPromoteReplica_580471(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/promoteReplica")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesPromoteReplica_580470(path: JsonNode; query: JsonNode;
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
  var valid_580472 = path.getOrDefault("instance")
  valid_580472 = validateParameter(valid_580472, JString, required = true,
                                 default = nil)
  if valid_580472 != nil:
    section.add "instance", valid_580472
  var valid_580473 = path.getOrDefault("project")
  valid_580473 = validateParameter(valid_580473, JString, required = true,
                                 default = nil)
  if valid_580473 != nil:
    section.add "project", valid_580473
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL promotes this replica database
  ## instance. Format: projects/{project}/locations/{location}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580474 = query.getOrDefault("key")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "key", valid_580474
  var valid_580475 = query.getOrDefault("prettyPrint")
  valid_580475 = validateParameter(valid_580475, JBool, required = false,
                                 default = newJBool(true))
  if valid_580475 != nil:
    section.add "prettyPrint", valid_580475
  var valid_580476 = query.getOrDefault("oauth_token")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "oauth_token", valid_580476
  var valid_580477 = query.getOrDefault("$.xgafv")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = newJString("1"))
  if valid_580477 != nil:
    section.add "$.xgafv", valid_580477
  var valid_580478 = query.getOrDefault("alt")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = newJString("json"))
  if valid_580478 != nil:
    section.add "alt", valid_580478
  var valid_580479 = query.getOrDefault("uploadType")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "uploadType", valid_580479
  var valid_580480 = query.getOrDefault("parent")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "parent", valid_580480
  var valid_580481 = query.getOrDefault("quotaUser")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "quotaUser", valid_580481
  var valid_580482 = query.getOrDefault("callback")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "callback", valid_580482
  var valid_580483 = query.getOrDefault("fields")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "fields", valid_580483
  var valid_580484 = query.getOrDefault("access_token")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "access_token", valid_580484
  var valid_580485 = query.getOrDefault("upload_protocol")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "upload_protocol", valid_580485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580486: Call_SqlInstancesPromoteReplica_580469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ## 
  let valid = call_580486.validator(path, query, header, formData, body)
  let scheme = call_580486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580486.url(scheme.get, call_580486.host, call_580486.base,
                         call_580486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580486, url, valid)

proc call*(call_580487: Call_SqlInstancesPromoteReplica_580469; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlInstancesPromoteReplica
  ## Promotes the read replica instance to be a stand-alone Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL promotes this replica database
  ## instance. Format: projects/{project}/locations/{location}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580488 = newJObject()
  var query_580489 = newJObject()
  add(query_580489, "key", newJString(key))
  add(query_580489, "prettyPrint", newJBool(prettyPrint))
  add(query_580489, "oauth_token", newJString(oauthToken))
  add(query_580489, "$.xgafv", newJString(Xgafv))
  add(query_580489, "alt", newJString(alt))
  add(query_580489, "uploadType", newJString(uploadType))
  add(query_580489, "parent", newJString(parent))
  add(query_580489, "quotaUser", newJString(quotaUser))
  add(path_580488, "instance", newJString(instance))
  add(path_580488, "project", newJString(project))
  add(query_580489, "callback", newJString(callback))
  add(query_580489, "fields", newJString(fields))
  add(query_580489, "access_token", newJString(accessToken))
  add(query_580489, "upload_protocol", newJString(uploadProtocol))
  result = call_580487.call(path_580488, query_580489, nil, nil, nil)

var sqlInstancesPromoteReplica* = Call_SqlInstancesPromoteReplica_580469(
    name: "sqlInstancesPromoteReplica", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/promoteReplica",
    validator: validate_SqlInstancesPromoteReplica_580470, base: "/",
    url: url_SqlInstancesPromoteReplica_580471, schemes: {Scheme.Https})
type
  Call_SqlInstancesResetSslConfig_580490 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesResetSslConfig_580492(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/resetSslConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesResetSslConfig_580491(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes all client certificates and generates a new server SSL certificate
  ## for the instance.
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
  var valid_580493 = path.getOrDefault("instance")
  valid_580493 = validateParameter(valid_580493, JString, required = true,
                                 default = nil)
  if valid_580493 != nil:
    section.add "instance", valid_580493
  var valid_580494 = path.getOrDefault("project")
  valid_580494 = validateParameter(valid_580494, JString, required = true,
                                 default = nil)
  if valid_580494 != nil:
    section.add "project", valid_580494
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL resets this SSL config.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580495 = query.getOrDefault("key")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "key", valid_580495
  var valid_580496 = query.getOrDefault("prettyPrint")
  valid_580496 = validateParameter(valid_580496, JBool, required = false,
                                 default = newJBool(true))
  if valid_580496 != nil:
    section.add "prettyPrint", valid_580496
  var valid_580497 = query.getOrDefault("oauth_token")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "oauth_token", valid_580497
  var valid_580498 = query.getOrDefault("$.xgafv")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = newJString("1"))
  if valid_580498 != nil:
    section.add "$.xgafv", valid_580498
  var valid_580499 = query.getOrDefault("alt")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = newJString("json"))
  if valid_580499 != nil:
    section.add "alt", valid_580499
  var valid_580500 = query.getOrDefault("uploadType")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "uploadType", valid_580500
  var valid_580501 = query.getOrDefault("parent")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "parent", valid_580501
  var valid_580502 = query.getOrDefault("quotaUser")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "quotaUser", valid_580502
  var valid_580503 = query.getOrDefault("callback")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "callback", valid_580503
  var valid_580504 = query.getOrDefault("fields")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "fields", valid_580504
  var valid_580505 = query.getOrDefault("access_token")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "access_token", valid_580505
  var valid_580506 = query.getOrDefault("upload_protocol")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "upload_protocol", valid_580506
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580507: Call_SqlInstancesResetSslConfig_580490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes all client certificates and generates a new server SSL certificate
  ## for the instance.
  ## 
  let valid = call_580507.validator(path, query, header, formData, body)
  let scheme = call_580507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580507.url(scheme.get, call_580507.host, call_580507.base,
                         call_580507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580507, url, valid)

proc call*(call_580508: Call_SqlInstancesResetSslConfig_580490; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlInstancesResetSslConfig
  ## Deletes all client certificates and generates a new server SSL certificate
  ## for the instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL resets this SSL config.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580509 = newJObject()
  var query_580510 = newJObject()
  add(query_580510, "key", newJString(key))
  add(query_580510, "prettyPrint", newJBool(prettyPrint))
  add(query_580510, "oauth_token", newJString(oauthToken))
  add(query_580510, "$.xgafv", newJString(Xgafv))
  add(query_580510, "alt", newJString(alt))
  add(query_580510, "uploadType", newJString(uploadType))
  add(query_580510, "parent", newJString(parent))
  add(query_580510, "quotaUser", newJString(quotaUser))
  add(path_580509, "instance", newJString(instance))
  add(path_580509, "project", newJString(project))
  add(query_580510, "callback", newJString(callback))
  add(query_580510, "fields", newJString(fields))
  add(query_580510, "access_token", newJString(accessToken))
  add(query_580510, "upload_protocol", newJString(uploadProtocol))
  result = call_580508.call(path_580509, query_580510, nil, nil, nil)

var sqlInstancesResetSslConfig* = Call_SqlInstancesResetSslConfig_580490(
    name: "sqlInstancesResetSslConfig", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/resetSslConfig",
    validator: validate_SqlInstancesResetSslConfig_580491, base: "/",
    url: url_SqlInstancesResetSslConfig_580492, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestart_580511 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesRestart_580513(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesRestart_580512(path: JsonNode; query: JsonNode;
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
  var valid_580514 = path.getOrDefault("instance")
  valid_580514 = validateParameter(valid_580514, JString, required = true,
                                 default = nil)
  if valid_580514 != nil:
    section.add "instance", valid_580514
  var valid_580515 = path.getOrDefault("project")
  valid_580515 = validateParameter(valid_580515, JString, required = true,
                                 default = nil)
  if valid_580515 != nil:
    section.add "project", valid_580515
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL restarts this database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580516 = query.getOrDefault("key")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "key", valid_580516
  var valid_580517 = query.getOrDefault("prettyPrint")
  valid_580517 = validateParameter(valid_580517, JBool, required = false,
                                 default = newJBool(true))
  if valid_580517 != nil:
    section.add "prettyPrint", valid_580517
  var valid_580518 = query.getOrDefault("oauth_token")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "oauth_token", valid_580518
  var valid_580519 = query.getOrDefault("$.xgafv")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = newJString("1"))
  if valid_580519 != nil:
    section.add "$.xgafv", valid_580519
  var valid_580520 = query.getOrDefault("alt")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = newJString("json"))
  if valid_580520 != nil:
    section.add "alt", valid_580520
  var valid_580521 = query.getOrDefault("uploadType")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "uploadType", valid_580521
  var valid_580522 = query.getOrDefault("parent")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "parent", valid_580522
  var valid_580523 = query.getOrDefault("quotaUser")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "quotaUser", valid_580523
  var valid_580524 = query.getOrDefault("callback")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "callback", valid_580524
  var valid_580525 = query.getOrDefault("fields")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "fields", valid_580525
  var valid_580526 = query.getOrDefault("access_token")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "access_token", valid_580526
  var valid_580527 = query.getOrDefault("upload_protocol")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "upload_protocol", valid_580527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580528: Call_SqlInstancesRestart_580511; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a Cloud SQL instance.
  ## 
  let valid = call_580528.validator(path, query, header, formData, body)
  let scheme = call_580528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580528.url(scheme.get, call_580528.host, call_580528.base,
                         call_580528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580528, url, valid)

proc call*(call_580529: Call_SqlInstancesRestart_580511; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlInstancesRestart
  ## Restarts a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL restarts this database instance.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance to be restarted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580530 = newJObject()
  var query_580531 = newJObject()
  add(query_580531, "key", newJString(key))
  add(query_580531, "prettyPrint", newJBool(prettyPrint))
  add(query_580531, "oauth_token", newJString(oauthToken))
  add(query_580531, "$.xgafv", newJString(Xgafv))
  add(query_580531, "alt", newJString(alt))
  add(query_580531, "uploadType", newJString(uploadType))
  add(query_580531, "parent", newJString(parent))
  add(query_580531, "quotaUser", newJString(quotaUser))
  add(path_580530, "instance", newJString(instance))
  add(path_580530, "project", newJString(project))
  add(query_580531, "callback", newJString(callback))
  add(query_580531, "fields", newJString(fields))
  add(query_580531, "access_token", newJString(accessToken))
  add(query_580531, "upload_protocol", newJString(uploadProtocol))
  result = call_580529.call(path_580530, query_580531, nil, nil, nil)

var sqlInstancesRestart* = Call_SqlInstancesRestart_580511(
    name: "sqlInstancesRestart", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/restart",
    validator: validate_SqlInstancesRestart_580512, base: "/",
    url: url_SqlInstancesRestart_580513, schemes: {Scheme.Https})
type
  Call_SqlInstancesRestoreBackup_580532 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesRestoreBackup_580534(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/restoreBackup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesRestoreBackup_580533(path: JsonNode; query: JsonNode;
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
  var valid_580535 = path.getOrDefault("instance")
  valid_580535 = validateParameter(valid_580535, JString, required = true,
                                 default = nil)
  if valid_580535 != nil:
    section.add "instance", valid_580535
  var valid_580536 = path.getOrDefault("project")
  valid_580536 = validateParameter(valid_580536, JString, required = true,
                                 default = nil)
  if valid_580536 != nil:
    section.add "project", valid_580536
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL restores this database instance from
  ## backup. Format:
  ## projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
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
  var valid_580539 = query.getOrDefault("oauth_token")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "oauth_token", valid_580539
  var valid_580540 = query.getOrDefault("$.xgafv")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = newJString("1"))
  if valid_580540 != nil:
    section.add "$.xgafv", valid_580540
  var valid_580541 = query.getOrDefault("alt")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = newJString("json"))
  if valid_580541 != nil:
    section.add "alt", valid_580541
  var valid_580542 = query.getOrDefault("uploadType")
  valid_580542 = validateParameter(valid_580542, JString, required = false,
                                 default = nil)
  if valid_580542 != nil:
    section.add "uploadType", valid_580542
  var valid_580543 = query.getOrDefault("parent")
  valid_580543 = validateParameter(valid_580543, JString, required = false,
                                 default = nil)
  if valid_580543 != nil:
    section.add "parent", valid_580543
  var valid_580544 = query.getOrDefault("quotaUser")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "quotaUser", valid_580544
  var valid_580545 = query.getOrDefault("callback")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "callback", valid_580545
  var valid_580546 = query.getOrDefault("fields")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "fields", valid_580546
  var valid_580547 = query.getOrDefault("access_token")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "access_token", valid_580547
  var valid_580548 = query.getOrDefault("upload_protocol")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "upload_protocol", valid_580548
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

proc call*(call_580550: Call_SqlInstancesRestoreBackup_580532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores a backup of a Cloud SQL instance.
  ## 
  let valid = call_580550.validator(path, query, header, formData, body)
  let scheme = call_580550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580550.url(scheme.get, call_580550.host, call_580550.base,
                         call_580550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580550, url, valid)

proc call*(call_580551: Call_SqlInstancesRestoreBackup_580532; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlInstancesRestoreBackup
  ## Restores a backup of a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL restores this database instance from
  ## backup. Format:
  ## projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580552 = newJObject()
  var query_580553 = newJObject()
  var body_580554 = newJObject()
  add(query_580553, "key", newJString(key))
  add(query_580553, "prettyPrint", newJBool(prettyPrint))
  add(query_580553, "oauth_token", newJString(oauthToken))
  add(query_580553, "$.xgafv", newJString(Xgafv))
  add(query_580553, "alt", newJString(alt))
  add(query_580553, "uploadType", newJString(uploadType))
  add(query_580553, "parent", newJString(parent))
  add(query_580553, "quotaUser", newJString(quotaUser))
  add(path_580552, "instance", newJString(instance))
  add(path_580552, "project", newJString(project))
  if body != nil:
    body_580554 = body
  add(query_580553, "callback", newJString(callback))
  add(query_580553, "fields", newJString(fields))
  add(query_580553, "access_token", newJString(accessToken))
  add(query_580553, "upload_protocol", newJString(uploadProtocol))
  result = call_580551.call(path_580552, query_580553, nil, nil, body_580554)

var sqlInstancesRestoreBackup* = Call_SqlInstancesRestoreBackup_580532(
    name: "sqlInstancesRestoreBackup", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/restoreBackup",
    validator: validate_SqlInstancesRestoreBackup_580533, base: "/",
    url: url_SqlInstancesRestoreBackup_580534, schemes: {Scheme.Https})
type
  Call_SqlInstancesRotateServerCa_580555 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesRotateServerCa_580557(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/rotateServerCa")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesRotateServerCa_580556(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rotates the server certificate to one signed by the Certificate Authority
  ## (CA) version previously added with the addServerCA method.
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
  var valid_580558 = path.getOrDefault("instance")
  valid_580558 = validateParameter(valid_580558, JString, required = true,
                                 default = nil)
  if valid_580558 != nil:
    section.add "instance", valid_580558
  var valid_580559 = path.getOrDefault("project")
  valid_580559 = validateParameter(valid_580559, JString, required = true,
                                 default = nil)
  if valid_580559 != nil:
    section.add "project", valid_580559
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL rotates these server CAs.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580560 = query.getOrDefault("key")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = nil)
  if valid_580560 != nil:
    section.add "key", valid_580560
  var valid_580561 = query.getOrDefault("prettyPrint")
  valid_580561 = validateParameter(valid_580561, JBool, required = false,
                                 default = newJBool(true))
  if valid_580561 != nil:
    section.add "prettyPrint", valid_580561
  var valid_580562 = query.getOrDefault("oauth_token")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "oauth_token", valid_580562
  var valid_580563 = query.getOrDefault("$.xgafv")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = newJString("1"))
  if valid_580563 != nil:
    section.add "$.xgafv", valid_580563
  var valid_580564 = query.getOrDefault("alt")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = newJString("json"))
  if valid_580564 != nil:
    section.add "alt", valid_580564
  var valid_580565 = query.getOrDefault("uploadType")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "uploadType", valid_580565
  var valid_580566 = query.getOrDefault("parent")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "parent", valid_580566
  var valid_580567 = query.getOrDefault("quotaUser")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "quotaUser", valid_580567
  var valid_580568 = query.getOrDefault("callback")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "callback", valid_580568
  var valid_580569 = query.getOrDefault("fields")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "fields", valid_580569
  var valid_580570 = query.getOrDefault("access_token")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "access_token", valid_580570
  var valid_580571 = query.getOrDefault("upload_protocol")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "upload_protocol", valid_580571
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

proc call*(call_580573: Call_SqlInstancesRotateServerCa_580555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rotates the server certificate to one signed by the Certificate Authority
  ## (CA) version previously added with the addServerCA method.
  ## 
  let valid = call_580573.validator(path, query, header, formData, body)
  let scheme = call_580573.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580573.url(scheme.get, call_580573.host, call_580573.base,
                         call_580573.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580573, url, valid)

proc call*(call_580574: Call_SqlInstancesRotateServerCa_580555; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlInstancesRotateServerCa
  ## Rotates the server certificate to one signed by the Certificate Authority
  ## (CA) version previously added with the addServerCA method.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL rotates these server CAs.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580575 = newJObject()
  var query_580576 = newJObject()
  var body_580577 = newJObject()
  add(query_580576, "key", newJString(key))
  add(query_580576, "prettyPrint", newJBool(prettyPrint))
  add(query_580576, "oauth_token", newJString(oauthToken))
  add(query_580576, "$.xgafv", newJString(Xgafv))
  add(query_580576, "alt", newJString(alt))
  add(query_580576, "uploadType", newJString(uploadType))
  add(query_580576, "parent", newJString(parent))
  add(query_580576, "quotaUser", newJString(quotaUser))
  add(path_580575, "instance", newJString(instance))
  add(path_580575, "project", newJString(project))
  if body != nil:
    body_580577 = body
  add(query_580576, "callback", newJString(callback))
  add(query_580576, "fields", newJString(fields))
  add(query_580576, "access_token", newJString(accessToken))
  add(query_580576, "upload_protocol", newJString(uploadProtocol))
  result = call_580574.call(path_580575, query_580576, nil, nil, body_580577)

var sqlInstancesRotateServerCa* = Call_SqlInstancesRotateServerCa_580555(
    name: "sqlInstancesRotateServerCa", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/rotateServerCa",
    validator: validate_SqlInstancesRotateServerCa_580556, base: "/",
    url: url_SqlInstancesRotateServerCa_580557, schemes: {Scheme.Https})
type
  Call_SqlSslCertsInsert_580599 = ref object of OpenApiRestCall_579373
proc url_SqlSslCertsInsert_580601(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/sslCerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlSslCertsInsert_580600(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an SSL certificate and returns it along with the private key and
  ## server certificate authority.  The new certificate will not be usable until
  ## the instance is restarted.
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
  var valid_580602 = path.getOrDefault("instance")
  valid_580602 = validateParameter(valid_580602, JString, required = true,
                                 default = nil)
  if valid_580602 != nil:
    section.add "instance", valid_580602
  var valid_580603 = path.getOrDefault("project")
  valid_580603 = validateParameter(valid_580603, JString, required = true,
                                 default = nil)
  if valid_580603 != nil:
    section.add "project", valid_580603
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL creates this SSL certificate.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580604 = query.getOrDefault("key")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "key", valid_580604
  var valid_580605 = query.getOrDefault("prettyPrint")
  valid_580605 = validateParameter(valid_580605, JBool, required = false,
                                 default = newJBool(true))
  if valid_580605 != nil:
    section.add "prettyPrint", valid_580605
  var valid_580606 = query.getOrDefault("oauth_token")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "oauth_token", valid_580606
  var valid_580607 = query.getOrDefault("$.xgafv")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = newJString("1"))
  if valid_580607 != nil:
    section.add "$.xgafv", valid_580607
  var valid_580608 = query.getOrDefault("alt")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = newJString("json"))
  if valid_580608 != nil:
    section.add "alt", valid_580608
  var valid_580609 = query.getOrDefault("uploadType")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "uploadType", valid_580609
  var valid_580610 = query.getOrDefault("parent")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "parent", valid_580610
  var valid_580611 = query.getOrDefault("quotaUser")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "quotaUser", valid_580611
  var valid_580612 = query.getOrDefault("callback")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "callback", valid_580612
  var valid_580613 = query.getOrDefault("fields")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "fields", valid_580613
  var valid_580614 = query.getOrDefault("access_token")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "access_token", valid_580614
  var valid_580615 = query.getOrDefault("upload_protocol")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "upload_protocol", valid_580615
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

proc call*(call_580617: Call_SqlSslCertsInsert_580599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an SSL certificate and returns it along with the private key and
  ## server certificate authority.  The new certificate will not be usable until
  ## the instance is restarted.
  ## 
  let valid = call_580617.validator(path, query, header, formData, body)
  let scheme = call_580617.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580617.url(scheme.get, call_580617.host, call_580617.base,
                         call_580617.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580617, url, valid)

proc call*(call_580618: Call_SqlSslCertsInsert_580599; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlSslCertsInsert
  ## Creates an SSL certificate and returns it along with the private key and
  ## server certificate authority.  The new certificate will not be usable until
  ## the instance is restarted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL creates this SSL certificate.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580619 = newJObject()
  var query_580620 = newJObject()
  var body_580621 = newJObject()
  add(query_580620, "key", newJString(key))
  add(query_580620, "prettyPrint", newJBool(prettyPrint))
  add(query_580620, "oauth_token", newJString(oauthToken))
  add(query_580620, "$.xgafv", newJString(Xgafv))
  add(query_580620, "alt", newJString(alt))
  add(query_580620, "uploadType", newJString(uploadType))
  add(query_580620, "parent", newJString(parent))
  add(query_580620, "quotaUser", newJString(quotaUser))
  add(path_580619, "instance", newJString(instance))
  add(path_580619, "project", newJString(project))
  if body != nil:
    body_580621 = body
  add(query_580620, "callback", newJString(callback))
  add(query_580620, "fields", newJString(fields))
  add(query_580620, "access_token", newJString(accessToken))
  add(query_580620, "upload_protocol", newJString(uploadProtocol))
  result = call_580618.call(path_580619, query_580620, nil, nil, body_580621)

var sqlSslCertsInsert* = Call_SqlSslCertsInsert_580599(name: "sqlSslCertsInsert",
    meth: HttpMethod.HttpPost, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsInsert_580600, base: "/",
    url: url_SqlSslCertsInsert_580601, schemes: {Scheme.Https})
type
  Call_SqlSslCertsList_580578 = ref object of OpenApiRestCall_579373
proc url_SqlSslCertsList_580580(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/sslCerts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlSslCertsList_580579(path: JsonNode; query: JsonNode;
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
  var valid_580581 = path.getOrDefault("instance")
  valid_580581 = validateParameter(valid_580581, JString, required = true,
                                 default = nil)
  if valid_580581 != nil:
    section.add "instance", valid_580581
  var valid_580582 = path.getOrDefault("project")
  valid_580582 = validateParameter(valid_580582, JString, required = true,
                                 default = nil)
  if valid_580582 != nil:
    section.add "project", valid_580582
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent, which owns this collection of SSL certificates.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580583 = query.getOrDefault("key")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "key", valid_580583
  var valid_580584 = query.getOrDefault("prettyPrint")
  valid_580584 = validateParameter(valid_580584, JBool, required = false,
                                 default = newJBool(true))
  if valid_580584 != nil:
    section.add "prettyPrint", valid_580584
  var valid_580585 = query.getOrDefault("oauth_token")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "oauth_token", valid_580585
  var valid_580586 = query.getOrDefault("$.xgafv")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = newJString("1"))
  if valid_580586 != nil:
    section.add "$.xgafv", valid_580586
  var valid_580587 = query.getOrDefault("alt")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = newJString("json"))
  if valid_580587 != nil:
    section.add "alt", valid_580587
  var valid_580588 = query.getOrDefault("uploadType")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "uploadType", valid_580588
  var valid_580589 = query.getOrDefault("parent")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "parent", valid_580589
  var valid_580590 = query.getOrDefault("quotaUser")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "quotaUser", valid_580590
  var valid_580591 = query.getOrDefault("callback")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "callback", valid_580591
  var valid_580592 = query.getOrDefault("fields")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "fields", valid_580592
  var valid_580593 = query.getOrDefault("access_token")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "access_token", valid_580593
  var valid_580594 = query.getOrDefault("upload_protocol")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "upload_protocol", valid_580594
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580595: Call_SqlSslCertsList_580578; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the current SSL certificates for the instance.
  ## 
  let valid = call_580595.validator(path, query, header, formData, body)
  let scheme = call_580595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580595.url(scheme.get, call_580595.host, call_580595.base,
                         call_580595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580595, url, valid)

proc call*(call_580596: Call_SqlSslCertsList_580578; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlSslCertsList
  ## Lists all of the current SSL certificates for the instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent, which owns this collection of SSL certificates.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580597 = newJObject()
  var query_580598 = newJObject()
  add(query_580598, "key", newJString(key))
  add(query_580598, "prettyPrint", newJBool(prettyPrint))
  add(query_580598, "oauth_token", newJString(oauthToken))
  add(query_580598, "$.xgafv", newJString(Xgafv))
  add(query_580598, "alt", newJString(alt))
  add(query_580598, "uploadType", newJString(uploadType))
  add(query_580598, "parent", newJString(parent))
  add(query_580598, "quotaUser", newJString(quotaUser))
  add(path_580597, "instance", newJString(instance))
  add(path_580597, "project", newJString(project))
  add(query_580598, "callback", newJString(callback))
  add(query_580598, "fields", newJString(fields))
  add(query_580598, "access_token", newJString(accessToken))
  add(query_580598, "upload_protocol", newJString(uploadProtocol))
  result = call_580596.call(path_580597, query_580598, nil, nil, nil)

var sqlSslCertsList* = Call_SqlSslCertsList_580578(name: "sqlSslCertsList",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/sslCerts",
    validator: validate_SqlSslCertsList_580579, base: "/", url: url_SqlSslCertsList_580580,
    schemes: {Scheme.Https})
type
  Call_SqlSslCertsGet_580622 = ref object of OpenApiRestCall_579373
proc url_SqlSslCertsGet_580624(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "sha1Fingerprint" in path, "`sha1Fingerprint` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/sslCerts/"),
               (kind: VariableSegment, value: "sha1Fingerprint")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlSslCertsGet_580623(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves a particular SSL certificate.  Does not include the private key
  ## (required for usage).  The private key must be saved from the response to
  ## initial creation.
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
  var valid_580625 = path.getOrDefault("sha1Fingerprint")
  valid_580625 = validateParameter(valid_580625, JString, required = true,
                                 default = nil)
  if valid_580625 != nil:
    section.add "sha1Fingerprint", valid_580625
  var valid_580626 = path.getOrDefault("instance")
  valid_580626 = validateParameter(valid_580626, JString, required = true,
                                 default = nil)
  if valid_580626 != nil:
    section.add "instance", valid_580626
  var valid_580627 = path.getOrDefault("project")
  valid_580627 = validateParameter(valid_580627, JString, required = true,
                                 default = nil)
  if valid_580627 != nil:
    section.add "project", valid_580627
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : Name of the resource ssl certificate.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/sslCerts/{sslCert}
  section = newJObject()
  var valid_580628 = query.getOrDefault("key")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "key", valid_580628
  var valid_580629 = query.getOrDefault("prettyPrint")
  valid_580629 = validateParameter(valid_580629, JBool, required = false,
                                 default = newJBool(true))
  if valid_580629 != nil:
    section.add "prettyPrint", valid_580629
  var valid_580630 = query.getOrDefault("oauth_token")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "oauth_token", valid_580630
  var valid_580631 = query.getOrDefault("$.xgafv")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = newJString("1"))
  if valid_580631 != nil:
    section.add "$.xgafv", valid_580631
  var valid_580632 = query.getOrDefault("alt")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = newJString("json"))
  if valid_580632 != nil:
    section.add "alt", valid_580632
  var valid_580633 = query.getOrDefault("uploadType")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "uploadType", valid_580633
  var valid_580634 = query.getOrDefault("quotaUser")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "quotaUser", valid_580634
  var valid_580635 = query.getOrDefault("callback")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "callback", valid_580635
  var valid_580636 = query.getOrDefault("fields")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "fields", valid_580636
  var valid_580637 = query.getOrDefault("access_token")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "access_token", valid_580637
  var valid_580638 = query.getOrDefault("upload_protocol")
  valid_580638 = validateParameter(valid_580638, JString, required = false,
                                 default = nil)
  if valid_580638 != nil:
    section.add "upload_protocol", valid_580638
  var valid_580639 = query.getOrDefault("resourceName")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "resourceName", valid_580639
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580640: Call_SqlSslCertsGet_580622; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a particular SSL certificate.  Does not include the private key
  ## (required for usage).  The private key must be saved from the response to
  ## initial creation.
  ## 
  let valid = call_580640.validator(path, query, header, formData, body)
  let scheme = call_580640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580640.url(scheme.get, call_580640.host, call_580640.base,
                         call_580640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580640, url, valid)

proc call*(call_580641: Call_SqlSslCertsGet_580622; sha1Fingerprint: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
  ## sqlSslCertsGet
  ## Retrieves a particular SSL certificate.  Does not include the private key
  ## (required for usage).  The private key must be saved from the response to
  ## initial creation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sha1Fingerprint: string (required)
  ##                  : Sha1 FingerPrint.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : Name of the resource ssl certificate.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/sslCerts/{sslCert}
  var path_580642 = newJObject()
  var query_580643 = newJObject()
  add(query_580643, "key", newJString(key))
  add(query_580643, "prettyPrint", newJBool(prettyPrint))
  add(query_580643, "oauth_token", newJString(oauthToken))
  add(query_580643, "$.xgafv", newJString(Xgafv))
  add(query_580643, "alt", newJString(alt))
  add(query_580643, "uploadType", newJString(uploadType))
  add(query_580643, "quotaUser", newJString(quotaUser))
  add(path_580642, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(path_580642, "instance", newJString(instance))
  add(path_580642, "project", newJString(project))
  add(query_580643, "callback", newJString(callback))
  add(query_580643, "fields", newJString(fields))
  add(query_580643, "access_token", newJString(accessToken))
  add(query_580643, "upload_protocol", newJString(uploadProtocol))
  add(query_580643, "resourceName", newJString(resourceName))
  result = call_580641.call(path_580642, query_580643, nil, nil, nil)

var sqlSslCertsGet* = Call_SqlSslCertsGet_580622(name: "sqlSslCertsGet",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsGet_580623, base: "/", url: url_SqlSslCertsGet_580624,
    schemes: {Scheme.Https})
type
  Call_SqlSslCertsDelete_580644 = ref object of OpenApiRestCall_579373
proc url_SqlSslCertsDelete_580646(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  assert "sha1Fingerprint" in path, "`sha1Fingerprint` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/sslCerts/"),
               (kind: VariableSegment, value: "sha1Fingerprint")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlSslCertsDelete_580645(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the SSL certificate. For First Generation instances, the
  ## certificate remains valid until the instance is restarted.
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
  var valid_580647 = path.getOrDefault("sha1Fingerprint")
  valid_580647 = validateParameter(valid_580647, JString, required = true,
                                 default = nil)
  if valid_580647 != nil:
    section.add "sha1Fingerprint", valid_580647
  var valid_580648 = path.getOrDefault("instance")
  valid_580648 = validateParameter(valid_580648, JString, required = true,
                                 default = nil)
  if valid_580648 != nil:
    section.add "instance", valid_580648
  var valid_580649 = path.getOrDefault("project")
  valid_580649 = validateParameter(valid_580649, JString, required = true,
                                 default = nil)
  if valid_580649 != nil:
    section.add "project", valid_580649
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of SSL certificate to delete.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/sslCerts/{sslCert}
  section = newJObject()
  var valid_580650 = query.getOrDefault("key")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "key", valid_580650
  var valid_580651 = query.getOrDefault("prettyPrint")
  valid_580651 = validateParameter(valid_580651, JBool, required = false,
                                 default = newJBool(true))
  if valid_580651 != nil:
    section.add "prettyPrint", valid_580651
  var valid_580652 = query.getOrDefault("oauth_token")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "oauth_token", valid_580652
  var valid_580653 = query.getOrDefault("$.xgafv")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = newJString("1"))
  if valid_580653 != nil:
    section.add "$.xgafv", valid_580653
  var valid_580654 = query.getOrDefault("alt")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = newJString("json"))
  if valid_580654 != nil:
    section.add "alt", valid_580654
  var valid_580655 = query.getOrDefault("uploadType")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "uploadType", valid_580655
  var valid_580656 = query.getOrDefault("quotaUser")
  valid_580656 = validateParameter(valid_580656, JString, required = false,
                                 default = nil)
  if valid_580656 != nil:
    section.add "quotaUser", valid_580656
  var valid_580657 = query.getOrDefault("callback")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "callback", valid_580657
  var valid_580658 = query.getOrDefault("fields")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = nil)
  if valid_580658 != nil:
    section.add "fields", valid_580658
  var valid_580659 = query.getOrDefault("access_token")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "access_token", valid_580659
  var valid_580660 = query.getOrDefault("upload_protocol")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "upload_protocol", valid_580660
  var valid_580661 = query.getOrDefault("resourceName")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "resourceName", valid_580661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580662: Call_SqlSslCertsDelete_580644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the SSL certificate. For First Generation instances, the
  ## certificate remains valid until the instance is restarted.
  ## 
  let valid = call_580662.validator(path, query, header, formData, body)
  let scheme = call_580662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580662.url(scheme.get, call_580662.host, call_580662.base,
                         call_580662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580662, url, valid)

proc call*(call_580663: Call_SqlSslCertsDelete_580644; sha1Fingerprint: string;
          instance: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
  ## sqlSslCertsDelete
  ## Deletes the SSL certificate. For First Generation instances, the
  ## certificate remains valid until the instance is restarted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   sha1Fingerprint: string (required)
  ##                  : Sha1 FingerPrint.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of SSL certificate to delete.
  ## Format:
  ## 
  ## projects/{project}/locations/{location}/instances/{instance}/sslCerts/{sslCert}
  var path_580664 = newJObject()
  var query_580665 = newJObject()
  add(query_580665, "key", newJString(key))
  add(query_580665, "prettyPrint", newJBool(prettyPrint))
  add(query_580665, "oauth_token", newJString(oauthToken))
  add(query_580665, "$.xgafv", newJString(Xgafv))
  add(query_580665, "alt", newJString(alt))
  add(query_580665, "uploadType", newJString(uploadType))
  add(query_580665, "quotaUser", newJString(quotaUser))
  add(path_580664, "sha1Fingerprint", newJString(sha1Fingerprint))
  add(path_580664, "instance", newJString(instance))
  add(path_580664, "project", newJString(project))
  add(query_580665, "callback", newJString(callback))
  add(query_580665, "fields", newJString(fields))
  add(query_580665, "access_token", newJString(accessToken))
  add(query_580665, "upload_protocol", newJString(uploadProtocol))
  add(query_580665, "resourceName", newJString(resourceName))
  result = call_580663.call(path_580664, query_580665, nil, nil, nil)

var sqlSslCertsDelete* = Call_SqlSslCertsDelete_580644(name: "sqlSslCertsDelete",
    meth: HttpMethod.HttpDelete, host: "sqladmin.googleapis.com", route: "/sql/v1beta4/projects/{project}/instances/{instance}/sslCerts/{sha1Fingerprint}",
    validator: validate_SqlSslCertsDelete_580645, base: "/",
    url: url_SqlSslCertsDelete_580646, schemes: {Scheme.Https})
type
  Call_SqlInstancesStartReplica_580666 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesStartReplica_580668(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/startReplica")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesStartReplica_580667(path: JsonNode; query: JsonNode;
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
  var valid_580669 = path.getOrDefault("instance")
  valid_580669 = validateParameter(valid_580669, JString, required = true,
                                 default = nil)
  if valid_580669 != nil:
    section.add "instance", valid_580669
  var valid_580670 = path.getOrDefault("project")
  valid_580670 = validateParameter(valid_580670, JString, required = true,
                                 default = nil)
  if valid_580670 != nil:
    section.add "project", valid_580670
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL starts this database instance
  ## replication. Format:
  ## projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580671 = query.getOrDefault("key")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "key", valid_580671
  var valid_580672 = query.getOrDefault("prettyPrint")
  valid_580672 = validateParameter(valid_580672, JBool, required = false,
                                 default = newJBool(true))
  if valid_580672 != nil:
    section.add "prettyPrint", valid_580672
  var valid_580673 = query.getOrDefault("oauth_token")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "oauth_token", valid_580673
  var valid_580674 = query.getOrDefault("$.xgafv")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = newJString("1"))
  if valid_580674 != nil:
    section.add "$.xgafv", valid_580674
  var valid_580675 = query.getOrDefault("alt")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = newJString("json"))
  if valid_580675 != nil:
    section.add "alt", valid_580675
  var valid_580676 = query.getOrDefault("uploadType")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "uploadType", valid_580676
  var valid_580677 = query.getOrDefault("parent")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "parent", valid_580677
  var valid_580678 = query.getOrDefault("quotaUser")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "quotaUser", valid_580678
  var valid_580679 = query.getOrDefault("callback")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "callback", valid_580679
  var valid_580680 = query.getOrDefault("fields")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "fields", valid_580680
  var valid_580681 = query.getOrDefault("access_token")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "access_token", valid_580681
  var valid_580682 = query.getOrDefault("upload_protocol")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "upload_protocol", valid_580682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580683: Call_SqlInstancesStartReplica_580666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts the replication in the read replica instance.
  ## 
  let valid = call_580683.validator(path, query, header, formData, body)
  let scheme = call_580683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580683.url(scheme.get, call_580683.host, call_580683.base,
                         call_580683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580683, url, valid)

proc call*(call_580684: Call_SqlInstancesStartReplica_580666; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlInstancesStartReplica
  ## Starts the replication in the read replica instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL starts this database instance
  ## replication. Format:
  ## projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580685 = newJObject()
  var query_580686 = newJObject()
  add(query_580686, "key", newJString(key))
  add(query_580686, "prettyPrint", newJBool(prettyPrint))
  add(query_580686, "oauth_token", newJString(oauthToken))
  add(query_580686, "$.xgafv", newJString(Xgafv))
  add(query_580686, "alt", newJString(alt))
  add(query_580686, "uploadType", newJString(uploadType))
  add(query_580686, "parent", newJString(parent))
  add(query_580686, "quotaUser", newJString(quotaUser))
  add(path_580685, "instance", newJString(instance))
  add(path_580685, "project", newJString(project))
  add(query_580686, "callback", newJString(callback))
  add(query_580686, "fields", newJString(fields))
  add(query_580686, "access_token", newJString(accessToken))
  add(query_580686, "upload_protocol", newJString(uploadProtocol))
  result = call_580684.call(path_580685, query_580686, nil, nil, nil)

var sqlInstancesStartReplica* = Call_SqlInstancesStartReplica_580666(
    name: "sqlInstancesStartReplica", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/startReplica",
    validator: validate_SqlInstancesStartReplica_580667, base: "/",
    url: url_SqlInstancesStartReplica_580668, schemes: {Scheme.Https})
type
  Call_SqlInstancesStopReplica_580687 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesStopReplica_580689(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/stopReplica")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesStopReplica_580688(path: JsonNode; query: JsonNode;
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
  var valid_580690 = path.getOrDefault("instance")
  valid_580690 = validateParameter(valid_580690, JString, required = true,
                                 default = nil)
  if valid_580690 != nil:
    section.add "instance", valid_580690
  var valid_580691 = path.getOrDefault("project")
  valid_580691 = validateParameter(valid_580691, JString, required = true,
                                 default = nil)
  if valid_580691 != nil:
    section.add "project", valid_580691
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL stops this database instance
  ## replication. Format:
  ## projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580692 = query.getOrDefault("key")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "key", valid_580692
  var valid_580693 = query.getOrDefault("prettyPrint")
  valid_580693 = validateParameter(valid_580693, JBool, required = false,
                                 default = newJBool(true))
  if valid_580693 != nil:
    section.add "prettyPrint", valid_580693
  var valid_580694 = query.getOrDefault("oauth_token")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "oauth_token", valid_580694
  var valid_580695 = query.getOrDefault("$.xgafv")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = newJString("1"))
  if valid_580695 != nil:
    section.add "$.xgafv", valid_580695
  var valid_580696 = query.getOrDefault("alt")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = newJString("json"))
  if valid_580696 != nil:
    section.add "alt", valid_580696
  var valid_580697 = query.getOrDefault("uploadType")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "uploadType", valid_580697
  var valid_580698 = query.getOrDefault("parent")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "parent", valid_580698
  var valid_580699 = query.getOrDefault("quotaUser")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "quotaUser", valid_580699
  var valid_580700 = query.getOrDefault("callback")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "callback", valid_580700
  var valid_580701 = query.getOrDefault("fields")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "fields", valid_580701
  var valid_580702 = query.getOrDefault("access_token")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "access_token", valid_580702
  var valid_580703 = query.getOrDefault("upload_protocol")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "upload_protocol", valid_580703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580704: Call_SqlInstancesStopReplica_580687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops the replication in the read replica instance.
  ## 
  let valid = call_580704.validator(path, query, header, formData, body)
  let scheme = call_580704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580704.url(scheme.get, call_580704.host, call_580704.base,
                         call_580704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580704, url, valid)

proc call*(call_580705: Call_SqlInstancesStopReplica_580687; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlInstancesStopReplica
  ## Stops the replication in the read replica instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL stops this database instance
  ## replication. Format:
  ## projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL read replica instance name.
  ##   project: string (required)
  ##          : ID of the project that contains the read replica.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580706 = newJObject()
  var query_580707 = newJObject()
  add(query_580707, "key", newJString(key))
  add(query_580707, "prettyPrint", newJBool(prettyPrint))
  add(query_580707, "oauth_token", newJString(oauthToken))
  add(query_580707, "$.xgafv", newJString(Xgafv))
  add(query_580707, "alt", newJString(alt))
  add(query_580707, "uploadType", newJString(uploadType))
  add(query_580707, "parent", newJString(parent))
  add(query_580707, "quotaUser", newJString(quotaUser))
  add(path_580706, "instance", newJString(instance))
  add(path_580706, "project", newJString(project))
  add(query_580707, "callback", newJString(callback))
  add(query_580707, "fields", newJString(fields))
  add(query_580707, "access_token", newJString(accessToken))
  add(query_580707, "upload_protocol", newJString(uploadProtocol))
  result = call_580705.call(path_580706, query_580707, nil, nil, nil)

var sqlInstancesStopReplica* = Call_SqlInstancesStopReplica_580687(
    name: "sqlInstancesStopReplica", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/stopReplica",
    validator: validate_SqlInstancesStopReplica_580688, base: "/",
    url: url_SqlInstancesStopReplica_580689, schemes: {Scheme.Https})
type
  Call_SqlInstancesTruncateLog_580708 = ref object of OpenApiRestCall_579373
proc url_SqlInstancesTruncateLog_580710(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/truncateLog")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlInstancesTruncateLog_580709(path: JsonNode; query: JsonNode;
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
  var valid_580711 = path.getOrDefault("instance")
  valid_580711 = validateParameter(valid_580711, JString, required = true,
                                 default = nil)
  if valid_580711 != nil:
    section.add "instance", valid_580711
  var valid_580712 = path.getOrDefault("project")
  valid_580712 = validateParameter(valid_580712, JString, required = true,
                                 default = nil)
  if valid_580712 != nil:
    section.add "project", valid_580712
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL truncates this log.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580713 = query.getOrDefault("key")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "key", valid_580713
  var valid_580714 = query.getOrDefault("prettyPrint")
  valid_580714 = validateParameter(valid_580714, JBool, required = false,
                                 default = newJBool(true))
  if valid_580714 != nil:
    section.add "prettyPrint", valid_580714
  var valid_580715 = query.getOrDefault("oauth_token")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "oauth_token", valid_580715
  var valid_580716 = query.getOrDefault("$.xgafv")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = newJString("1"))
  if valid_580716 != nil:
    section.add "$.xgafv", valid_580716
  var valid_580717 = query.getOrDefault("alt")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = newJString("json"))
  if valid_580717 != nil:
    section.add "alt", valid_580717
  var valid_580718 = query.getOrDefault("uploadType")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "uploadType", valid_580718
  var valid_580719 = query.getOrDefault("parent")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "parent", valid_580719
  var valid_580720 = query.getOrDefault("quotaUser")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "quotaUser", valid_580720
  var valid_580721 = query.getOrDefault("callback")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "callback", valid_580721
  var valid_580722 = query.getOrDefault("fields")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "fields", valid_580722
  var valid_580723 = query.getOrDefault("access_token")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "access_token", valid_580723
  var valid_580724 = query.getOrDefault("upload_protocol")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = nil)
  if valid_580724 != nil:
    section.add "upload_protocol", valid_580724
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

proc call*(call_580726: Call_SqlInstancesTruncateLog_580708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Truncate MySQL general and slow query log tables
  ## 
  let valid = call_580726.validator(path, query, header, formData, body)
  let scheme = call_580726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580726.url(scheme.get, call_580726.host, call_580726.base,
                         call_580726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580726, url, valid)

proc call*(call_580727: Call_SqlInstancesTruncateLog_580708; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlInstancesTruncateLog
  ## Truncate MySQL general and slow query log tables
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL truncates this log.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the Cloud SQL project.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580728 = newJObject()
  var query_580729 = newJObject()
  var body_580730 = newJObject()
  add(query_580729, "key", newJString(key))
  add(query_580729, "prettyPrint", newJBool(prettyPrint))
  add(query_580729, "oauth_token", newJString(oauthToken))
  add(query_580729, "$.xgafv", newJString(Xgafv))
  add(query_580729, "alt", newJString(alt))
  add(query_580729, "uploadType", newJString(uploadType))
  add(query_580729, "parent", newJString(parent))
  add(query_580729, "quotaUser", newJString(quotaUser))
  add(path_580728, "instance", newJString(instance))
  add(path_580728, "project", newJString(project))
  if body != nil:
    body_580730 = body
  add(query_580729, "callback", newJString(callback))
  add(query_580729, "fields", newJString(fields))
  add(query_580729, "access_token", newJString(accessToken))
  add(query_580729, "upload_protocol", newJString(uploadProtocol))
  result = call_580727.call(path_580728, query_580729, nil, nil, body_580730)

var sqlInstancesTruncateLog* = Call_SqlInstancesTruncateLog_580708(
    name: "sqlInstancesTruncateLog", meth: HttpMethod.HttpPost,
    host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/truncateLog",
    validator: validate_SqlInstancesTruncateLog_580709, base: "/",
    url: url_SqlInstancesTruncateLog_580710, schemes: {Scheme.Https})
type
  Call_SqlUsersUpdate_580752 = ref object of OpenApiRestCall_579373
proc url_SqlUsersUpdate_580754(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlUsersUpdate_580753(path: JsonNode; query: JsonNode;
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
  var valid_580755 = path.getOrDefault("instance")
  valid_580755 = validateParameter(valid_580755, JString, required = true,
                                 default = nil)
  if valid_580755 != nil:
    section.add "instance", valid_580755
  var valid_580756 = path.getOrDefault("project")
  valid_580756 = validateParameter(valid_580756, JString, required = true,
                                 default = nil)
  if valid_580756 != nil:
    section.add "project", valid_580756
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : Name of the user in the instance.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   host: JString
  ##       : Host of the user in the instance. For a MySQL instance, it's required; For
  ## a PostgreSQL instance, it's optional.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of the user for Cloud SQL to update.
  ## Format: projects/{project}/locations/{location}/instances/{instance}/users
  section = newJObject()
  var valid_580757 = query.getOrDefault("key")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "key", valid_580757
  var valid_580758 = query.getOrDefault("prettyPrint")
  valid_580758 = validateParameter(valid_580758, JBool, required = false,
                                 default = newJBool(true))
  if valid_580758 != nil:
    section.add "prettyPrint", valid_580758
  var valid_580759 = query.getOrDefault("oauth_token")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "oauth_token", valid_580759
  var valid_580760 = query.getOrDefault("name")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "name", valid_580760
  var valid_580761 = query.getOrDefault("$.xgafv")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = newJString("1"))
  if valid_580761 != nil:
    section.add "$.xgafv", valid_580761
  var valid_580762 = query.getOrDefault("alt")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = newJString("json"))
  if valid_580762 != nil:
    section.add "alt", valid_580762
  var valid_580763 = query.getOrDefault("uploadType")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "uploadType", valid_580763
  var valid_580764 = query.getOrDefault("quotaUser")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "quotaUser", valid_580764
  var valid_580765 = query.getOrDefault("host")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = nil)
  if valid_580765 != nil:
    section.add "host", valid_580765
  var valid_580766 = query.getOrDefault("callback")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "callback", valid_580766
  var valid_580767 = query.getOrDefault("fields")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "fields", valid_580767
  var valid_580768 = query.getOrDefault("access_token")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = nil)
  if valid_580768 != nil:
    section.add "access_token", valid_580768
  var valid_580769 = query.getOrDefault("upload_protocol")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "upload_protocol", valid_580769
  var valid_580770 = query.getOrDefault("resourceName")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "resourceName", valid_580770
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

proc call*(call_580772: Call_SqlUsersUpdate_580752; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing user in a Cloud SQL instance.
  ## 
  let valid = call_580772.validator(path, query, header, formData, body)
  let scheme = call_580772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580772.url(scheme.get, call_580772.host, call_580772.base,
                         call_580772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580772, url, valid)

proc call*(call_580773: Call_SqlUsersUpdate_580752; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          host: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
  ## sqlUsersUpdate
  ## Updates an existing user in a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : Name of the user in the instance.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   host: string
  ##       : Host of the user in the instance. For a MySQL instance, it's required; For
  ## a PostgreSQL instance, it's optional.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of the user for Cloud SQL to update.
  ## Format: projects/{project}/locations/{location}/instances/{instance}/users
  var path_580774 = newJObject()
  var query_580775 = newJObject()
  var body_580776 = newJObject()
  add(query_580775, "key", newJString(key))
  add(query_580775, "prettyPrint", newJBool(prettyPrint))
  add(query_580775, "oauth_token", newJString(oauthToken))
  add(query_580775, "name", newJString(name))
  add(query_580775, "$.xgafv", newJString(Xgafv))
  add(query_580775, "alt", newJString(alt))
  add(query_580775, "uploadType", newJString(uploadType))
  add(query_580775, "quotaUser", newJString(quotaUser))
  add(path_580774, "instance", newJString(instance))
  add(query_580775, "host", newJString(host))
  add(path_580774, "project", newJString(project))
  if body != nil:
    body_580776 = body
  add(query_580775, "callback", newJString(callback))
  add(query_580775, "fields", newJString(fields))
  add(query_580775, "access_token", newJString(accessToken))
  add(query_580775, "upload_protocol", newJString(uploadProtocol))
  add(query_580775, "resourceName", newJString(resourceName))
  result = call_580773.call(path_580774, query_580775, nil, nil, body_580776)

var sqlUsersUpdate* = Call_SqlUsersUpdate_580752(name: "sqlUsersUpdate",
    meth: HttpMethod.HttpPut, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersUpdate_580753, base: "/", url: url_SqlUsersUpdate_580754,
    schemes: {Scheme.Https})
type
  Call_SqlUsersInsert_580777 = ref object of OpenApiRestCall_579373
proc url_SqlUsersInsert_580779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlUsersInsert_580778(path: JsonNode; query: JsonNode;
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
  var valid_580780 = path.getOrDefault("instance")
  valid_580780 = validateParameter(valid_580780, JString, required = true,
                                 default = nil)
  if valid_580780 != nil:
    section.add "instance", valid_580780
  var valid_580781 = path.getOrDefault("project")
  valid_580781 = validateParameter(valid_580781, JString, required = true,
                                 default = nil)
  if valid_580781 != nil:
    section.add "project", valid_580781
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent resource where Cloud SQL creates this user.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580782 = query.getOrDefault("key")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "key", valid_580782
  var valid_580783 = query.getOrDefault("prettyPrint")
  valid_580783 = validateParameter(valid_580783, JBool, required = false,
                                 default = newJBool(true))
  if valid_580783 != nil:
    section.add "prettyPrint", valid_580783
  var valid_580784 = query.getOrDefault("oauth_token")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "oauth_token", valid_580784
  var valid_580785 = query.getOrDefault("$.xgafv")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = newJString("1"))
  if valid_580785 != nil:
    section.add "$.xgafv", valid_580785
  var valid_580786 = query.getOrDefault("alt")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = newJString("json"))
  if valid_580786 != nil:
    section.add "alt", valid_580786
  var valid_580787 = query.getOrDefault("uploadType")
  valid_580787 = validateParameter(valid_580787, JString, required = false,
                                 default = nil)
  if valid_580787 != nil:
    section.add "uploadType", valid_580787
  var valid_580788 = query.getOrDefault("parent")
  valid_580788 = validateParameter(valid_580788, JString, required = false,
                                 default = nil)
  if valid_580788 != nil:
    section.add "parent", valid_580788
  var valid_580789 = query.getOrDefault("quotaUser")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "quotaUser", valid_580789
  var valid_580790 = query.getOrDefault("callback")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = nil)
  if valid_580790 != nil:
    section.add "callback", valid_580790
  var valid_580791 = query.getOrDefault("fields")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = nil)
  if valid_580791 != nil:
    section.add "fields", valid_580791
  var valid_580792 = query.getOrDefault("access_token")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "access_token", valid_580792
  var valid_580793 = query.getOrDefault("upload_protocol")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "upload_protocol", valid_580793
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

proc call*(call_580795: Call_SqlUsersInsert_580777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new user in a Cloud SQL instance.
  ## 
  let valid = call_580795.validator(path, query, header, formData, body)
  let scheme = call_580795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580795.url(scheme.get, call_580795.host, call_580795.base,
                         call_580795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580795, url, valid)

proc call*(call_580796: Call_SqlUsersInsert_580777; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlUsersInsert
  ## Creates a new user in a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent resource where Cloud SQL creates this user.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580797 = newJObject()
  var query_580798 = newJObject()
  var body_580799 = newJObject()
  add(query_580798, "key", newJString(key))
  add(query_580798, "prettyPrint", newJBool(prettyPrint))
  add(query_580798, "oauth_token", newJString(oauthToken))
  add(query_580798, "$.xgafv", newJString(Xgafv))
  add(query_580798, "alt", newJString(alt))
  add(query_580798, "uploadType", newJString(uploadType))
  add(query_580798, "parent", newJString(parent))
  add(query_580798, "quotaUser", newJString(quotaUser))
  add(path_580797, "instance", newJString(instance))
  add(path_580797, "project", newJString(project))
  if body != nil:
    body_580799 = body
  add(query_580798, "callback", newJString(callback))
  add(query_580798, "fields", newJString(fields))
  add(query_580798, "access_token", newJString(accessToken))
  add(query_580798, "upload_protocol", newJString(uploadProtocol))
  result = call_580796.call(path_580797, query_580798, nil, nil, body_580799)

var sqlUsersInsert* = Call_SqlUsersInsert_580777(name: "sqlUsersInsert",
    meth: HttpMethod.HttpPost, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersInsert_580778, base: "/", url: url_SqlUsersInsert_580779,
    schemes: {Scheme.Https})
type
  Call_SqlUsersList_580731 = ref object of OpenApiRestCall_579373
proc url_SqlUsersList_580733(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlUsersList_580732(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580734 = path.getOrDefault("instance")
  valid_580734 = validateParameter(valid_580734, JString, required = true,
                                 default = nil)
  if valid_580734 != nil:
    section.add "instance", valid_580734
  var valid_580735 = path.getOrDefault("project")
  valid_580735 = validateParameter(valid_580735, JString, required = true,
                                 default = nil)
  if valid_580735 != nil:
    section.add "project", valid_580735
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The parent, which owns this collection of users.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580736 = query.getOrDefault("key")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "key", valid_580736
  var valid_580737 = query.getOrDefault("prettyPrint")
  valid_580737 = validateParameter(valid_580737, JBool, required = false,
                                 default = newJBool(true))
  if valid_580737 != nil:
    section.add "prettyPrint", valid_580737
  var valid_580738 = query.getOrDefault("oauth_token")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "oauth_token", valid_580738
  var valid_580739 = query.getOrDefault("$.xgafv")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = newJString("1"))
  if valid_580739 != nil:
    section.add "$.xgafv", valid_580739
  var valid_580740 = query.getOrDefault("alt")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = newJString("json"))
  if valid_580740 != nil:
    section.add "alt", valid_580740
  var valid_580741 = query.getOrDefault("uploadType")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "uploadType", valid_580741
  var valid_580742 = query.getOrDefault("parent")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "parent", valid_580742
  var valid_580743 = query.getOrDefault("quotaUser")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = nil)
  if valid_580743 != nil:
    section.add "quotaUser", valid_580743
  var valid_580744 = query.getOrDefault("callback")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = nil)
  if valid_580744 != nil:
    section.add "callback", valid_580744
  var valid_580745 = query.getOrDefault("fields")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "fields", valid_580745
  var valid_580746 = query.getOrDefault("access_token")
  valid_580746 = validateParameter(valid_580746, JString, required = false,
                                 default = nil)
  if valid_580746 != nil:
    section.add "access_token", valid_580746
  var valid_580747 = query.getOrDefault("upload_protocol")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = nil)
  if valid_580747 != nil:
    section.add "upload_protocol", valid_580747
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580748: Call_SqlUsersList_580731; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists users in the specified Cloud SQL instance.
  ## 
  let valid = call_580748.validator(path, query, header, formData, body)
  let scheme = call_580748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580748.url(scheme.get, call_580748.host, call_580748.base,
                         call_580748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580748, url, valid)

proc call*(call_580749: Call_SqlUsersList_580731; instance: string; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          parent: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlUsersList
  ## Lists users in the specified Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The parent, which owns this collection of users.
  ## Format: projects/{project}/locations/{location}/instances/{instance}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580750 = newJObject()
  var query_580751 = newJObject()
  add(query_580751, "key", newJString(key))
  add(query_580751, "prettyPrint", newJBool(prettyPrint))
  add(query_580751, "oauth_token", newJString(oauthToken))
  add(query_580751, "$.xgafv", newJString(Xgafv))
  add(query_580751, "alt", newJString(alt))
  add(query_580751, "uploadType", newJString(uploadType))
  add(query_580751, "parent", newJString(parent))
  add(query_580751, "quotaUser", newJString(quotaUser))
  add(path_580750, "instance", newJString(instance))
  add(path_580750, "project", newJString(project))
  add(query_580751, "callback", newJString(callback))
  add(query_580751, "fields", newJString(fields))
  add(query_580751, "access_token", newJString(accessToken))
  add(query_580751, "upload_protocol", newJString(uploadProtocol))
  result = call_580749.call(path_580750, query_580751, nil, nil, nil)

var sqlUsersList* = Call_SqlUsersList_580731(name: "sqlUsersList",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersList_580732, base: "/", url: url_SqlUsersList_580733,
    schemes: {Scheme.Https})
type
  Call_SqlUsersDelete_580800 = ref object of OpenApiRestCall_579373
proc url_SqlUsersDelete_580802(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "instance" in path, "`instance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/instances/"),
               (kind: VariableSegment, value: "instance"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlUsersDelete_580801(path: JsonNode; query: JsonNode;
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
  var valid_580803 = path.getOrDefault("instance")
  valid_580803 = validateParameter(valid_580803, JString, required = true,
                                 default = nil)
  if valid_580803 != nil:
    section.add "instance", valid_580803
  var valid_580804 = path.getOrDefault("project")
  valid_580804 = validateParameter(valid_580804, JString, required = true,
                                 default = nil)
  if valid_580804 != nil:
    section.add "project", valid_580804
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : Name of the user in the instance.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   host: JString
  ##       : Host of the user in the instance.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: JString
  ##               : The name of the user to delete.
  ## Format: projects/{project}/locations/{location}/instances/{instance}/users
  section = newJObject()
  var valid_580805 = query.getOrDefault("key")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = nil)
  if valid_580805 != nil:
    section.add "key", valid_580805
  var valid_580806 = query.getOrDefault("prettyPrint")
  valid_580806 = validateParameter(valid_580806, JBool, required = false,
                                 default = newJBool(true))
  if valid_580806 != nil:
    section.add "prettyPrint", valid_580806
  var valid_580807 = query.getOrDefault("oauth_token")
  valid_580807 = validateParameter(valid_580807, JString, required = false,
                                 default = nil)
  if valid_580807 != nil:
    section.add "oauth_token", valid_580807
  var valid_580808 = query.getOrDefault("name")
  valid_580808 = validateParameter(valid_580808, JString, required = false,
                                 default = nil)
  if valid_580808 != nil:
    section.add "name", valid_580808
  var valid_580809 = query.getOrDefault("$.xgafv")
  valid_580809 = validateParameter(valid_580809, JString, required = false,
                                 default = newJString("1"))
  if valid_580809 != nil:
    section.add "$.xgafv", valid_580809
  var valid_580810 = query.getOrDefault("alt")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = newJString("json"))
  if valid_580810 != nil:
    section.add "alt", valid_580810
  var valid_580811 = query.getOrDefault("uploadType")
  valid_580811 = validateParameter(valid_580811, JString, required = false,
                                 default = nil)
  if valid_580811 != nil:
    section.add "uploadType", valid_580811
  var valid_580812 = query.getOrDefault("quotaUser")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = nil)
  if valid_580812 != nil:
    section.add "quotaUser", valid_580812
  var valid_580813 = query.getOrDefault("host")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = nil)
  if valid_580813 != nil:
    section.add "host", valid_580813
  var valid_580814 = query.getOrDefault("callback")
  valid_580814 = validateParameter(valid_580814, JString, required = false,
                                 default = nil)
  if valid_580814 != nil:
    section.add "callback", valid_580814
  var valid_580815 = query.getOrDefault("fields")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "fields", valid_580815
  var valid_580816 = query.getOrDefault("access_token")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "access_token", valid_580816
  var valid_580817 = query.getOrDefault("upload_protocol")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = nil)
  if valid_580817 != nil:
    section.add "upload_protocol", valid_580817
  var valid_580818 = query.getOrDefault("resourceName")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = nil)
  if valid_580818 != nil:
    section.add "resourceName", valid_580818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580819: Call_SqlUsersDelete_580800; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a user from a Cloud SQL instance.
  ## 
  let valid = call_580819.validator(path, query, header, formData, body)
  let scheme = call_580819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580819.url(scheme.get, call_580819.host, call_580819.base,
                         call_580819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580819, url, valid)

proc call*(call_580820: Call_SqlUsersDelete_580800; instance: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          host: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          resourceName: string = ""): Recallable =
  ## sqlUsersDelete
  ## Deletes a user from a Cloud SQL instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : Name of the user in the instance.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   instance: string (required)
  ##           : Database instance ID. This does not include the project ID.
  ##   host: string
  ##       : Host of the user in the instance.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   resourceName: string
  ##               : The name of the user to delete.
  ## Format: projects/{project}/locations/{location}/instances/{instance}/users
  var path_580821 = newJObject()
  var query_580822 = newJObject()
  add(query_580822, "key", newJString(key))
  add(query_580822, "prettyPrint", newJBool(prettyPrint))
  add(query_580822, "oauth_token", newJString(oauthToken))
  add(query_580822, "name", newJString(name))
  add(query_580822, "$.xgafv", newJString(Xgafv))
  add(query_580822, "alt", newJString(alt))
  add(query_580822, "uploadType", newJString(uploadType))
  add(query_580822, "quotaUser", newJString(quotaUser))
  add(path_580821, "instance", newJString(instance))
  add(query_580822, "host", newJString(host))
  add(path_580821, "project", newJString(project))
  add(query_580822, "callback", newJString(callback))
  add(query_580822, "fields", newJString(fields))
  add(query_580822, "access_token", newJString(accessToken))
  add(query_580822, "upload_protocol", newJString(uploadProtocol))
  add(query_580822, "resourceName", newJString(resourceName))
  result = call_580820.call(path_580821, query_580822, nil, nil, nil)

var sqlUsersDelete* = Call_SqlUsersDelete_580800(name: "sqlUsersDelete",
    meth: HttpMethod.HttpDelete, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/instances/{instance}/users",
    validator: validate_SqlUsersDelete_580801, base: "/", url: url_SqlUsersDelete_580802,
    schemes: {Scheme.Https})
type
  Call_SqlOperationsList_580823 = ref object of OpenApiRestCall_579373
proc url_SqlOperationsList_580825(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlOperationsList_580824(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists all instance operations that have been performed on the given Cloud
  ## SQL instance in the reverse chronological order of the start time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project that contains the instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580826 = path.getOrDefault("project")
  valid_580826 = validateParameter(valid_580826, JString, required = true,
                                 default = nil)
  if valid_580826 != nil:
    section.add "project", valid_580826
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : Indirect parent. The direct parent should combine with the instance name,
  ## which owns this collection of operations.
  ## Format:
  ## projects/{project}/locations/{location}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of
  ## results to view.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   instance: JString
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   maxResults: JInt
  ##             : Maximum number of operations per response.
  section = newJObject()
  var valid_580827 = query.getOrDefault("key")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "key", valid_580827
  var valid_580828 = query.getOrDefault("prettyPrint")
  valid_580828 = validateParameter(valid_580828, JBool, required = false,
                                 default = newJBool(true))
  if valid_580828 != nil:
    section.add "prettyPrint", valid_580828
  var valid_580829 = query.getOrDefault("oauth_token")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = nil)
  if valid_580829 != nil:
    section.add "oauth_token", valid_580829
  var valid_580830 = query.getOrDefault("$.xgafv")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = newJString("1"))
  if valid_580830 != nil:
    section.add "$.xgafv", valid_580830
  var valid_580831 = query.getOrDefault("alt")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = newJString("json"))
  if valid_580831 != nil:
    section.add "alt", valid_580831
  var valid_580832 = query.getOrDefault("uploadType")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "uploadType", valid_580832
  var valid_580833 = query.getOrDefault("parent")
  valid_580833 = validateParameter(valid_580833, JString, required = false,
                                 default = nil)
  if valid_580833 != nil:
    section.add "parent", valid_580833
  var valid_580834 = query.getOrDefault("quotaUser")
  valid_580834 = validateParameter(valid_580834, JString, required = false,
                                 default = nil)
  if valid_580834 != nil:
    section.add "quotaUser", valid_580834
  var valid_580835 = query.getOrDefault("pageToken")
  valid_580835 = validateParameter(valid_580835, JString, required = false,
                                 default = nil)
  if valid_580835 != nil:
    section.add "pageToken", valid_580835
  var valid_580836 = query.getOrDefault("callback")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "callback", valid_580836
  var valid_580837 = query.getOrDefault("fields")
  valid_580837 = validateParameter(valid_580837, JString, required = false,
                                 default = nil)
  if valid_580837 != nil:
    section.add "fields", valid_580837
  var valid_580838 = query.getOrDefault("access_token")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = nil)
  if valid_580838 != nil:
    section.add "access_token", valid_580838
  var valid_580839 = query.getOrDefault("upload_protocol")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "upload_protocol", valid_580839
  var valid_580840 = query.getOrDefault("instance")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = nil)
  if valid_580840 != nil:
    section.add "instance", valid_580840
  var valid_580841 = query.getOrDefault("maxResults")
  valid_580841 = validateParameter(valid_580841, JInt, required = false, default = nil)
  if valid_580841 != nil:
    section.add "maxResults", valid_580841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580842: Call_SqlOperationsList_580823; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all instance operations that have been performed on the given Cloud
  ## SQL instance in the reverse chronological order of the start time.
  ## 
  let valid = call_580842.validator(path, query, header, formData, body)
  let scheme = call_580842.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580842.url(scheme.get, call_580842.host, call_580842.base,
                         call_580842.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580842, url, valid)

proc call*(call_580843: Call_SqlOperationsList_580823; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          parent: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; instance: string = ""; maxResults: int = 0): Recallable =
  ## sqlOperationsList
  ## Lists all instance operations that have been performed on the given Cloud
  ## SQL instance in the reverse chronological order of the start time.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : Indirect parent. The direct parent should combine with the instance name,
  ## which owns this collection of operations.
  ## Format:
  ## projects/{project}/locations/{location}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of
  ## results to view.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   instance: string
  ##           : Cloud SQL instance ID. This does not include the project ID.
  ##   maxResults: int
  ##             : Maximum number of operations per response.
  var path_580844 = newJObject()
  var query_580845 = newJObject()
  add(query_580845, "key", newJString(key))
  add(query_580845, "prettyPrint", newJBool(prettyPrint))
  add(query_580845, "oauth_token", newJString(oauthToken))
  add(query_580845, "$.xgafv", newJString(Xgafv))
  add(query_580845, "alt", newJString(alt))
  add(query_580845, "uploadType", newJString(uploadType))
  add(query_580845, "parent", newJString(parent))
  add(query_580845, "quotaUser", newJString(quotaUser))
  add(query_580845, "pageToken", newJString(pageToken))
  add(path_580844, "project", newJString(project))
  add(query_580845, "callback", newJString(callback))
  add(query_580845, "fields", newJString(fields))
  add(query_580845, "access_token", newJString(accessToken))
  add(query_580845, "upload_protocol", newJString(uploadProtocol))
  add(query_580845, "instance", newJString(instance))
  add(query_580845, "maxResults", newJInt(maxResults))
  result = call_580843.call(path_580844, query_580845, nil, nil, nil)

var sqlOperationsList* = Call_SqlOperationsList_580823(name: "sqlOperationsList",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/operations",
    validator: validate_SqlOperationsList_580824, base: "/",
    url: url_SqlOperationsList_580825, schemes: {Scheme.Https})
type
  Call_SqlOperationsGet_580846 = ref object of OpenApiRestCall_579373
proc url_SqlOperationsGet_580848(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlOperationsGet_580847(path: JsonNode; query: JsonNode;
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
  var valid_580849 = path.getOrDefault("operation")
  valid_580849 = validateParameter(valid_580849, JString, required = true,
                                 default = nil)
  if valid_580849 != nil:
    section.add "operation", valid_580849
  var valid_580850 = path.getOrDefault("project")
  valid_580850 = validateParameter(valid_580850, JString, required = true,
                                 default = nil)
  if valid_580850 != nil:
    section.add "project", valid_580850
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580851 = query.getOrDefault("key")
  valid_580851 = validateParameter(valid_580851, JString, required = false,
                                 default = nil)
  if valid_580851 != nil:
    section.add "key", valid_580851
  var valid_580852 = query.getOrDefault("prettyPrint")
  valid_580852 = validateParameter(valid_580852, JBool, required = false,
                                 default = newJBool(true))
  if valid_580852 != nil:
    section.add "prettyPrint", valid_580852
  var valid_580853 = query.getOrDefault("oauth_token")
  valid_580853 = validateParameter(valid_580853, JString, required = false,
                                 default = nil)
  if valid_580853 != nil:
    section.add "oauth_token", valid_580853
  var valid_580854 = query.getOrDefault("$.xgafv")
  valid_580854 = validateParameter(valid_580854, JString, required = false,
                                 default = newJString("1"))
  if valid_580854 != nil:
    section.add "$.xgafv", valid_580854
  var valid_580855 = query.getOrDefault("alt")
  valid_580855 = validateParameter(valid_580855, JString, required = false,
                                 default = newJString("json"))
  if valid_580855 != nil:
    section.add "alt", valid_580855
  var valid_580856 = query.getOrDefault("uploadType")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = nil)
  if valid_580856 != nil:
    section.add "uploadType", valid_580856
  var valid_580857 = query.getOrDefault("quotaUser")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "quotaUser", valid_580857
  var valid_580858 = query.getOrDefault("callback")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = nil)
  if valid_580858 != nil:
    section.add "callback", valid_580858
  var valid_580859 = query.getOrDefault("fields")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "fields", valid_580859
  var valid_580860 = query.getOrDefault("access_token")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = nil)
  if valid_580860 != nil:
    section.add "access_token", valid_580860
  var valid_580861 = query.getOrDefault("upload_protocol")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "upload_protocol", valid_580861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580862: Call_SqlOperationsGet_580846; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an instance operation that has been performed on an instance.
  ## 
  let valid = call_580862.validator(path, query, header, formData, body)
  let scheme = call_580862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580862.url(scheme.get, call_580862.host, call_580862.base,
                         call_580862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580862, url, valid)

proc call*(call_580863: Call_SqlOperationsGet_580846; operation: string;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## sqlOperationsGet
  ## Retrieves an instance operation that has been performed on an instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   operation: string (required)
  ##            : Instance operation ID.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   project: string (required)
  ##          : Project ID of the project that contains the instance.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580864 = newJObject()
  var query_580865 = newJObject()
  add(query_580865, "key", newJString(key))
  add(query_580865, "prettyPrint", newJBool(prettyPrint))
  add(query_580865, "oauth_token", newJString(oauthToken))
  add(query_580865, "$.xgafv", newJString(Xgafv))
  add(path_580864, "operation", newJString(operation))
  add(query_580865, "alt", newJString(alt))
  add(query_580865, "uploadType", newJString(uploadType))
  add(query_580865, "quotaUser", newJString(quotaUser))
  add(path_580864, "project", newJString(project))
  add(query_580865, "callback", newJString(callback))
  add(query_580865, "fields", newJString(fields))
  add(query_580865, "access_token", newJString(accessToken))
  add(query_580865, "upload_protocol", newJString(uploadProtocol))
  result = call_580863.call(path_580864, query_580865, nil, nil, nil)

var sqlOperationsGet* = Call_SqlOperationsGet_580846(name: "sqlOperationsGet",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/operations/{operation}",
    validator: validate_SqlOperationsGet_580847, base: "/",
    url: url_SqlOperationsGet_580848, schemes: {Scheme.Https})
type
  Call_SqlTiersList_580866 = ref object of OpenApiRestCall_579373
proc url_SqlTiersList_580868(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/sql/v1beta4/projects/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/tiers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SqlTiersList_580867(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available machine types (tiers) for Cloud SQL, for example,
  ## db-n1-standard-1. For related information, see <a
  ## href="/sql/pricing">Pricing</a>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : Project ID of the project for which to list tiers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_580869 = path.getOrDefault("project")
  valid_580869 = validateParameter(valid_580869, JString, required = true,
                                 default = nil)
  if valid_580869 != nil:
    section.add "project", valid_580869
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580870 = query.getOrDefault("key")
  valid_580870 = validateParameter(valid_580870, JString, required = false,
                                 default = nil)
  if valid_580870 != nil:
    section.add "key", valid_580870
  var valid_580871 = query.getOrDefault("prettyPrint")
  valid_580871 = validateParameter(valid_580871, JBool, required = false,
                                 default = newJBool(true))
  if valid_580871 != nil:
    section.add "prettyPrint", valid_580871
  var valid_580872 = query.getOrDefault("oauth_token")
  valid_580872 = validateParameter(valid_580872, JString, required = false,
                                 default = nil)
  if valid_580872 != nil:
    section.add "oauth_token", valid_580872
  var valid_580873 = query.getOrDefault("$.xgafv")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = newJString("1"))
  if valid_580873 != nil:
    section.add "$.xgafv", valid_580873
  var valid_580874 = query.getOrDefault("alt")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = newJString("json"))
  if valid_580874 != nil:
    section.add "alt", valid_580874
  var valid_580875 = query.getOrDefault("uploadType")
  valid_580875 = validateParameter(valid_580875, JString, required = false,
                                 default = nil)
  if valid_580875 != nil:
    section.add "uploadType", valid_580875
  var valid_580876 = query.getOrDefault("quotaUser")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = nil)
  if valid_580876 != nil:
    section.add "quotaUser", valid_580876
  var valid_580877 = query.getOrDefault("callback")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "callback", valid_580877
  var valid_580878 = query.getOrDefault("fields")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = nil)
  if valid_580878 != nil:
    section.add "fields", valid_580878
  var valid_580879 = query.getOrDefault("access_token")
  valid_580879 = validateParameter(valid_580879, JString, required = false,
                                 default = nil)
  if valid_580879 != nil:
    section.add "access_token", valid_580879
  var valid_580880 = query.getOrDefault("upload_protocol")
  valid_580880 = validateParameter(valid_580880, JString, required = false,
                                 default = nil)
  if valid_580880 != nil:
    section.add "upload_protocol", valid_580880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580881: Call_SqlTiersList_580866; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available machine types (tiers) for Cloud SQL, for example,
  ## db-n1-standard-1. For related information, see <a
  ## href="/sql/pricing">Pricing</a>.
  ## 
  let valid = call_580881.validator(path, query, header, formData, body)
  let scheme = call_580881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580881.url(scheme.get, call_580881.host, call_580881.base,
                         call_580881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580881, url, valid)

proc call*(call_580882: Call_SqlTiersList_580866; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## sqlTiersList
  ## Lists all available machine types (tiers) for Cloud SQL, for example,
  ## db-n1-standard-1. For related information, see <a
  ## href="/sql/pricing">Pricing</a>.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   project: string (required)
  ##          : Project ID of the project for which to list tiers.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580883 = newJObject()
  var query_580884 = newJObject()
  add(query_580884, "key", newJString(key))
  add(query_580884, "prettyPrint", newJBool(prettyPrint))
  add(query_580884, "oauth_token", newJString(oauthToken))
  add(query_580884, "$.xgafv", newJString(Xgafv))
  add(query_580884, "alt", newJString(alt))
  add(query_580884, "uploadType", newJString(uploadType))
  add(query_580884, "quotaUser", newJString(quotaUser))
  add(path_580883, "project", newJString(project))
  add(query_580884, "callback", newJString(callback))
  add(query_580884, "fields", newJString(fields))
  add(query_580884, "access_token", newJString(accessToken))
  add(query_580884, "upload_protocol", newJString(uploadProtocol))
  result = call_580882.call(path_580883, query_580884, nil, nil, nil)

var sqlTiersList* = Call_SqlTiersList_580866(name: "sqlTiersList",
    meth: HttpMethod.HttpGet, host: "sqladmin.googleapis.com",
    route: "/sql/v1beta4/projects/{project}/tiers",
    validator: validate_SqlTiersList_580867, base: "/", url: url_SqlTiersList_580868,
    schemes: {Scheme.Https})
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
