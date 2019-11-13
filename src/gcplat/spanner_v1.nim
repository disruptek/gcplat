
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Spanner
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Cloud Spanner is a managed, mission-critical, globally consistent and scalable relational database service.
## 
## https://cloud.google.com/spanner/
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
  gcpServiceName = "spanner"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpannerProjectsInstancesDatabasesDropDatabase_579644 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesDropDatabase_579646(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
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

proc validate_SpannerProjectsInstancesDatabasesDropDatabase_579645(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Drops (aka deletes) a Cloud Spanner database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database to be dropped.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_579772 = path.getOrDefault("database")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "database", valid_579772
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
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("$.xgafv")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = newJString("1"))
  if valid_579789 != nil:
    section.add "$.xgafv", valid_579789
  var valid_579790 = query.getOrDefault("alt")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = newJString("json"))
  if valid_579790 != nil:
    section.add "alt", valid_579790
  var valid_579791 = query.getOrDefault("uploadType")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "uploadType", valid_579791
  var valid_579792 = query.getOrDefault("quotaUser")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "quotaUser", valid_579792
  var valid_579793 = query.getOrDefault("callback")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "callback", valid_579793
  var valid_579794 = query.getOrDefault("fields")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "fields", valid_579794
  var valid_579795 = query.getOrDefault("access_token")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "access_token", valid_579795
  var valid_579796 = query.getOrDefault("upload_protocol")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "upload_protocol", valid_579796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579819: Call_SpannerProjectsInstancesDatabasesDropDatabase_579644;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Drops (aka deletes) a Cloud Spanner database.
  ## 
  let valid = call_579819.validator(path, query, header, formData, body)
  let scheme = call_579819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579819.url(scheme.get, call_579819.host, call_579819.base,
                         call_579819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579819, url, valid)

proc call*(call_579890: Call_SpannerProjectsInstancesDatabasesDropDatabase_579644;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesDropDatabase
  ## Drops (aka deletes) a Cloud Spanner database.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database to be dropped.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  var path_579891 = newJObject()
  var query_579893 = newJObject()
  add(query_579893, "key", newJString(key))
  add(query_579893, "prettyPrint", newJBool(prettyPrint))
  add(query_579893, "oauth_token", newJString(oauthToken))
  add(path_579891, "database", newJString(database))
  add(query_579893, "$.xgafv", newJString(Xgafv))
  add(query_579893, "alt", newJString(alt))
  add(query_579893, "uploadType", newJString(uploadType))
  add(query_579893, "quotaUser", newJString(quotaUser))
  add(query_579893, "callback", newJString(callback))
  add(query_579893, "fields", newJString(fields))
  add(query_579893, "access_token", newJString(accessToken))
  add(query_579893, "upload_protocol", newJString(uploadProtocol))
  result = call_579890.call(path_579891, query_579893, nil, nil, nil)

var spannerProjectsInstancesDatabasesDropDatabase* = Call_SpannerProjectsInstancesDatabasesDropDatabase_579644(
    name: "spannerProjectsInstancesDatabasesDropDatabase",
    meth: HttpMethod.HttpDelete, host: "spanner.googleapis.com",
    route: "/v1/{database}",
    validator: validate_SpannerProjectsInstancesDatabasesDropDatabase_579645,
    base: "/", url: url_SpannerProjectsInstancesDatabasesDropDatabase_579646,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetDdl_579932 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesGetDdl_579934(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/ddl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesGetDdl_579933(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database whose schema we wish to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_579935 = path.getOrDefault("database")
  valid_579935 = validateParameter(valid_579935, JString, required = true,
                                 default = nil)
  if valid_579935 != nil:
    section.add "database", valid_579935
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
  var valid_579936 = query.getOrDefault("key")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "key", valid_579936
  var valid_579937 = query.getOrDefault("prettyPrint")
  valid_579937 = validateParameter(valid_579937, JBool, required = false,
                                 default = newJBool(true))
  if valid_579937 != nil:
    section.add "prettyPrint", valid_579937
  var valid_579938 = query.getOrDefault("oauth_token")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "oauth_token", valid_579938
  var valid_579939 = query.getOrDefault("$.xgafv")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = newJString("1"))
  if valid_579939 != nil:
    section.add "$.xgafv", valid_579939
  var valid_579940 = query.getOrDefault("alt")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = newJString("json"))
  if valid_579940 != nil:
    section.add "alt", valid_579940
  var valid_579941 = query.getOrDefault("uploadType")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "uploadType", valid_579941
  var valid_579942 = query.getOrDefault("quotaUser")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "quotaUser", valid_579942
  var valid_579943 = query.getOrDefault("callback")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "callback", valid_579943
  var valid_579944 = query.getOrDefault("fields")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "fields", valid_579944
  var valid_579945 = query.getOrDefault("access_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "access_token", valid_579945
  var valid_579946 = query.getOrDefault("upload_protocol")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "upload_protocol", valid_579946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579947: Call_SpannerProjectsInstancesDatabasesGetDdl_579932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ## 
  let valid = call_579947.validator(path, query, header, formData, body)
  let scheme = call_579947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579947.url(scheme.get, call_579947.host, call_579947.base,
                         call_579947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579947, url, valid)

proc call*(call_579948: Call_SpannerProjectsInstancesDatabasesGetDdl_579932;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesGetDdl
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database whose schema we wish to get.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  var path_579949 = newJObject()
  var query_579950 = newJObject()
  add(query_579950, "key", newJString(key))
  add(query_579950, "prettyPrint", newJBool(prettyPrint))
  add(query_579950, "oauth_token", newJString(oauthToken))
  add(path_579949, "database", newJString(database))
  add(query_579950, "$.xgafv", newJString(Xgafv))
  add(query_579950, "alt", newJString(alt))
  add(query_579950, "uploadType", newJString(uploadType))
  add(query_579950, "quotaUser", newJString(quotaUser))
  add(query_579950, "callback", newJString(callback))
  add(query_579950, "fields", newJString(fields))
  add(query_579950, "access_token", newJString(accessToken))
  add(query_579950, "upload_protocol", newJString(uploadProtocol))
  result = call_579948.call(path_579949, query_579950, nil, nil, nil)

var spannerProjectsInstancesDatabasesGetDdl* = Call_SpannerProjectsInstancesDatabasesGetDdl_579932(
    name: "spannerProjectsInstancesDatabasesGetDdl", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesGetDdl_579933, base: "/",
    url: url_SpannerProjectsInstancesDatabasesGetDdl_579934,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesUpdateDdl_579951 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesUpdateDdl_579953(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/ddl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesUpdateDdl_579952(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the schema of a Cloud Spanner database by
  ## creating/altering/dropping tables, columns, indexes, etc. The returned
  ## long-running operation will have a name of
  ## the format `<database_name>/operations/<operation_id>` and can be used to
  ## track execution of the schema change(s). The
  ## metadata field type is
  ## UpdateDatabaseDdlMetadata.  The operation has no response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_579954 = path.getOrDefault("database")
  valid_579954 = validateParameter(valid_579954, JString, required = true,
                                 default = nil)
  if valid_579954 != nil:
    section.add "database", valid_579954
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
  var valid_579955 = query.getOrDefault("key")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "key", valid_579955
  var valid_579956 = query.getOrDefault("prettyPrint")
  valid_579956 = validateParameter(valid_579956, JBool, required = false,
                                 default = newJBool(true))
  if valid_579956 != nil:
    section.add "prettyPrint", valid_579956
  var valid_579957 = query.getOrDefault("oauth_token")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "oauth_token", valid_579957
  var valid_579958 = query.getOrDefault("$.xgafv")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("1"))
  if valid_579958 != nil:
    section.add "$.xgafv", valid_579958
  var valid_579959 = query.getOrDefault("alt")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = newJString("json"))
  if valid_579959 != nil:
    section.add "alt", valid_579959
  var valid_579960 = query.getOrDefault("uploadType")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "uploadType", valid_579960
  var valid_579961 = query.getOrDefault("quotaUser")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "quotaUser", valid_579961
  var valid_579962 = query.getOrDefault("callback")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "callback", valid_579962
  var valid_579963 = query.getOrDefault("fields")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "fields", valid_579963
  var valid_579964 = query.getOrDefault("access_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "access_token", valid_579964
  var valid_579965 = query.getOrDefault("upload_protocol")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "upload_protocol", valid_579965
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

proc call*(call_579967: Call_SpannerProjectsInstancesDatabasesUpdateDdl_579951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the schema of a Cloud Spanner database by
  ## creating/altering/dropping tables, columns, indexes, etc. The returned
  ## long-running operation will have a name of
  ## the format `<database_name>/operations/<operation_id>` and can be used to
  ## track execution of the schema change(s). The
  ## metadata field type is
  ## UpdateDatabaseDdlMetadata.  The operation has no response.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_SpannerProjectsInstancesDatabasesUpdateDdl_579951;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesUpdateDdl
  ## Updates the schema of a Cloud Spanner database by
  ## creating/altering/dropping tables, columns, indexes, etc. The returned
  ## long-running operation will have a name of
  ## the format `<database_name>/operations/<operation_id>` and can be used to
  ## track execution of the schema change(s). The
  ## metadata field type is
  ## UpdateDatabaseDdlMetadata.  The operation has no response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database to update.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579969 = newJObject()
  var query_579970 = newJObject()
  var body_579971 = newJObject()
  add(query_579970, "key", newJString(key))
  add(query_579970, "prettyPrint", newJBool(prettyPrint))
  add(query_579970, "oauth_token", newJString(oauthToken))
  add(path_579969, "database", newJString(database))
  add(query_579970, "$.xgafv", newJString(Xgafv))
  add(query_579970, "alt", newJString(alt))
  add(query_579970, "uploadType", newJString(uploadType))
  add(query_579970, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579971 = body
  add(query_579970, "callback", newJString(callback))
  add(query_579970, "fields", newJString(fields))
  add(query_579970, "access_token", newJString(accessToken))
  add(query_579970, "upload_protocol", newJString(uploadProtocol))
  result = call_579968.call(path_579969, query_579970, nil, nil, body_579971)

var spannerProjectsInstancesDatabasesUpdateDdl* = Call_SpannerProjectsInstancesDatabasesUpdateDdl_579951(
    name: "spannerProjectsInstancesDatabasesUpdateDdl",
    meth: HttpMethod.HttpPatch, host: "spanner.googleapis.com",
    route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesUpdateDdl_579952,
    base: "/", url: url_SpannerProjectsInstancesDatabasesUpdateDdl_579953,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCreate_579994 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsCreate_579996(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/sessions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsCreate_579995(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new session. A session can be used to perform
  ## transactions that read and/or modify data in a Cloud Spanner database.
  ## Sessions are meant to be reused for many consecutive
  ## transactions.
  ## 
  ## Sessions can only execute one transaction at a time. To execute
  ## multiple concurrent read-write/write-only transactions, create
  ## multiple sessions. Note that standalone reads and queries use a
  ## transaction internally, and count toward the one transaction
  ## limit.
  ## 
  ## Active sessions use additional server resources, so it is a good idea to
  ## delete idle and unneeded sessions.
  ## Aside from explicit deletes, Cloud Spanner can delete sessions for which no
  ## operations are sent for more than an hour. If a session is deleted,
  ## requests to it return `NOT_FOUND`.
  ## 
  ## Idle sessions can be kept alive by sending a trivial SQL query
  ## periodically, e.g., `"SELECT 1"`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database in which the new session is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_579997 = path.getOrDefault("database")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "database", valid_579997
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
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("prettyPrint")
  valid_579999 = validateParameter(valid_579999, JBool, required = false,
                                 default = newJBool(true))
  if valid_579999 != nil:
    section.add "prettyPrint", valid_579999
  var valid_580000 = query.getOrDefault("oauth_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "oauth_token", valid_580000
  var valid_580001 = query.getOrDefault("$.xgafv")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("1"))
  if valid_580001 != nil:
    section.add "$.xgafv", valid_580001
  var valid_580002 = query.getOrDefault("alt")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = newJString("json"))
  if valid_580002 != nil:
    section.add "alt", valid_580002
  var valid_580003 = query.getOrDefault("uploadType")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "uploadType", valid_580003
  var valid_580004 = query.getOrDefault("quotaUser")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "quotaUser", valid_580004
  var valid_580005 = query.getOrDefault("callback")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "callback", valid_580005
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("access_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "access_token", valid_580007
  var valid_580008 = query.getOrDefault("upload_protocol")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "upload_protocol", valid_580008
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

proc call*(call_580010: Call_SpannerProjectsInstancesDatabasesSessionsCreate_579994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new session. A session can be used to perform
  ## transactions that read and/or modify data in a Cloud Spanner database.
  ## Sessions are meant to be reused for many consecutive
  ## transactions.
  ## 
  ## Sessions can only execute one transaction at a time. To execute
  ## multiple concurrent read-write/write-only transactions, create
  ## multiple sessions. Note that standalone reads and queries use a
  ## transaction internally, and count toward the one transaction
  ## limit.
  ## 
  ## Active sessions use additional server resources, so it is a good idea to
  ## delete idle and unneeded sessions.
  ## Aside from explicit deletes, Cloud Spanner can delete sessions for which no
  ## operations are sent for more than an hour. If a session is deleted,
  ## requests to it return `NOT_FOUND`.
  ## 
  ## Idle sessions can be kept alive by sending a trivial SQL query
  ## periodically, e.g., `"SELECT 1"`.
  ## 
  let valid = call_580010.validator(path, query, header, formData, body)
  let scheme = call_580010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580010.url(scheme.get, call_580010.host, call_580010.base,
                         call_580010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580010, url, valid)

proc call*(call_580011: Call_SpannerProjectsInstancesDatabasesSessionsCreate_579994;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsCreate
  ## Creates a new session. A session can be used to perform
  ## transactions that read and/or modify data in a Cloud Spanner database.
  ## Sessions are meant to be reused for many consecutive
  ## transactions.
  ## 
  ## Sessions can only execute one transaction at a time. To execute
  ## multiple concurrent read-write/write-only transactions, create
  ## multiple sessions. Note that standalone reads and queries use a
  ## transaction internally, and count toward the one transaction
  ## limit.
  ## 
  ## Active sessions use additional server resources, so it is a good idea to
  ## delete idle and unneeded sessions.
  ## Aside from explicit deletes, Cloud Spanner can delete sessions for which no
  ## operations are sent for more than an hour. If a session is deleted,
  ## requests to it return `NOT_FOUND`.
  ## 
  ## Idle sessions can be kept alive by sending a trivial SQL query
  ## periodically, e.g., `"SELECT 1"`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database in which the new session is created.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580012 = newJObject()
  var query_580013 = newJObject()
  var body_580014 = newJObject()
  add(query_580013, "key", newJString(key))
  add(query_580013, "prettyPrint", newJBool(prettyPrint))
  add(query_580013, "oauth_token", newJString(oauthToken))
  add(path_580012, "database", newJString(database))
  add(query_580013, "$.xgafv", newJString(Xgafv))
  add(query_580013, "alt", newJString(alt))
  add(query_580013, "uploadType", newJString(uploadType))
  add(query_580013, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580014 = body
  add(query_580013, "callback", newJString(callback))
  add(query_580013, "fields", newJString(fields))
  add(query_580013, "access_token", newJString(accessToken))
  add(query_580013, "upload_protocol", newJString(uploadProtocol))
  result = call_580011.call(path_580012, query_580013, nil, nil, body_580014)

var spannerProjectsInstancesDatabasesSessionsCreate* = Call_SpannerProjectsInstancesDatabasesSessionsCreate_579994(
    name: "spannerProjectsInstancesDatabasesSessionsCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCreate_579995,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCreate_579996,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsList_579972 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsList_579974(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/sessions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsList_579973(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all sessions in a given database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database in which to list sessions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_579975 = path.getOrDefault("database")
  valid_579975 = validateParameter(valid_579975, JString, required = true,
                                 default = nil)
  if valid_579975 != nil:
    section.add "database", valid_579975
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
  ##   pageSize: JInt
  ##           : Number of sessions to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : An expression for filtering the results of the request. Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ##   * `labels.key` where key is the name of a label
  ## 
  ## Some examples of using filters are:
  ## 
  ##   * `labels.env:*` --> The session has the label "env".
  ##   * `labels.env:dev` --> The session has the label "env" and the value of
  ##                        the label contains the string "dev".
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a previous
  ## ListSessionsResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579976 = query.getOrDefault("key")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "key", valid_579976
  var valid_579977 = query.getOrDefault("prettyPrint")
  valid_579977 = validateParameter(valid_579977, JBool, required = false,
                                 default = newJBool(true))
  if valid_579977 != nil:
    section.add "prettyPrint", valid_579977
  var valid_579978 = query.getOrDefault("oauth_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "oauth_token", valid_579978
  var valid_579979 = query.getOrDefault("$.xgafv")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("1"))
  if valid_579979 != nil:
    section.add "$.xgafv", valid_579979
  var valid_579980 = query.getOrDefault("pageSize")
  valid_579980 = validateParameter(valid_579980, JInt, required = false, default = nil)
  if valid_579980 != nil:
    section.add "pageSize", valid_579980
  var valid_579981 = query.getOrDefault("alt")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("json"))
  if valid_579981 != nil:
    section.add "alt", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  var valid_579984 = query.getOrDefault("filter")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "filter", valid_579984
  var valid_579985 = query.getOrDefault("pageToken")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "pageToken", valid_579985
  var valid_579986 = query.getOrDefault("callback")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "callback", valid_579986
  var valid_579987 = query.getOrDefault("fields")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "fields", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("upload_protocol")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "upload_protocol", valid_579989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579990: Call_SpannerProjectsInstancesDatabasesSessionsList_579972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sessions in a given database.
  ## 
  let valid = call_579990.validator(path, query, header, formData, body)
  let scheme = call_579990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579990.url(scheme.get, call_579990.host, call_579990.base,
                         call_579990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579990, url, valid)

proc call*(call_579991: Call_SpannerProjectsInstancesDatabasesSessionsList_579972;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsList
  ## Lists all sessions in a given database.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database in which to list sessions.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of sessions to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : An expression for filtering the results of the request. Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ##   * `labels.key` where key is the name of a label
  ## 
  ## Some examples of using filters are:
  ## 
  ##   * `labels.env:*` --> The session has the label "env".
  ##   * `labels.env:dev` --> The session has the label "env" and the value of
  ##                        the label contains the string "dev".
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a previous
  ## ListSessionsResponse.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579992 = newJObject()
  var query_579993 = newJObject()
  add(query_579993, "key", newJString(key))
  add(query_579993, "prettyPrint", newJBool(prettyPrint))
  add(query_579993, "oauth_token", newJString(oauthToken))
  add(path_579992, "database", newJString(database))
  add(query_579993, "$.xgafv", newJString(Xgafv))
  add(query_579993, "pageSize", newJInt(pageSize))
  add(query_579993, "alt", newJString(alt))
  add(query_579993, "uploadType", newJString(uploadType))
  add(query_579993, "quotaUser", newJString(quotaUser))
  add(query_579993, "filter", newJString(filter))
  add(query_579993, "pageToken", newJString(pageToken))
  add(query_579993, "callback", newJString(callback))
  add(query_579993, "fields", newJString(fields))
  add(query_579993, "access_token", newJString(accessToken))
  add(query_579993, "upload_protocol", newJString(uploadProtocol))
  result = call_579991.call(path_579992, query_579993, nil, nil, nil)

var spannerProjectsInstancesDatabasesSessionsList* = Call_SpannerProjectsInstancesDatabasesSessionsList_579972(
    name: "spannerProjectsInstancesDatabasesSessionsList",
    meth: HttpMethod.HttpGet, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsList_579973,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsList_579974,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580015 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580017(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/sessions:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580016(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database in which the new sessions are created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_580018 = path.getOrDefault("database")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "database", valid_580018
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
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("prettyPrint")
  valid_580020 = validateParameter(valid_580020, JBool, required = false,
                                 default = newJBool(true))
  if valid_580020 != nil:
    section.add "prettyPrint", valid_580020
  var valid_580021 = query.getOrDefault("oauth_token")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "oauth_token", valid_580021
  var valid_580022 = query.getOrDefault("$.xgafv")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("1"))
  if valid_580022 != nil:
    section.add "$.xgafv", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("uploadType")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "uploadType", valid_580024
  var valid_580025 = query.getOrDefault("quotaUser")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "quotaUser", valid_580025
  var valid_580026 = query.getOrDefault("callback")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "callback", valid_580026
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("access_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "access_token", valid_580028
  var valid_580029 = query.getOrDefault("upload_protocol")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "upload_protocol", valid_580029
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

proc call*(call_580031: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ## 
  let valid = call_580031.validator(path, query, header, formData, body)
  let scheme = call_580031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580031.url(scheme.get, call_580031.host, call_580031.base,
                         call_580031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580031, url, valid)

proc call*(call_580032: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580015;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsBatchCreate
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database in which the new sessions are created.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580033 = newJObject()
  var query_580034 = newJObject()
  var body_580035 = newJObject()
  add(query_580034, "key", newJString(key))
  add(query_580034, "prettyPrint", newJBool(prettyPrint))
  add(query_580034, "oauth_token", newJString(oauthToken))
  add(path_580033, "database", newJString(database))
  add(query_580034, "$.xgafv", newJString(Xgafv))
  add(query_580034, "alt", newJString(alt))
  add(query_580034, "uploadType", newJString(uploadType))
  add(query_580034, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580035 = body
  add(query_580034, "callback", newJString(callback))
  add(query_580034, "fields", newJString(fields))
  add(query_580034, "access_token", newJString(accessToken))
  add(query_580034, "upload_protocol", newJString(uploadProtocol))
  result = call_580032.call(path_580033, query_580034, nil, nil, body_580035)

var spannerProjectsInstancesDatabasesSessionsBatchCreate* = Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580015(
    name: "spannerProjectsInstancesDatabasesSessionsBatchCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions:batchCreate",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580016,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580017,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesOperationsGet_580036 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesOperationsGet_580038(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesOperationsGet_580037(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580039 = path.getOrDefault("name")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "name", valid_580039
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
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("prettyPrint")
  valid_580041 = validateParameter(valid_580041, JBool, required = false,
                                 default = newJBool(true))
  if valid_580041 != nil:
    section.add "prettyPrint", valid_580041
  var valid_580042 = query.getOrDefault("oauth_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "oauth_token", valid_580042
  var valid_580043 = query.getOrDefault("$.xgafv")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("1"))
  if valid_580043 != nil:
    section.add "$.xgafv", valid_580043
  var valid_580044 = query.getOrDefault("alt")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("json"))
  if valid_580044 != nil:
    section.add "alt", valid_580044
  var valid_580045 = query.getOrDefault("uploadType")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "uploadType", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("callback")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "callback", valid_580047
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("access_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "access_token", valid_580049
  var valid_580050 = query.getOrDefault("upload_protocol")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "upload_protocol", valid_580050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580051: Call_SpannerProjectsInstancesOperationsGet_580036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580051.validator(path, query, header, formData, body)
  let scheme = call_580051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580051.url(scheme.get, call_580051.host, call_580051.base,
                         call_580051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580051, url, valid)

proc call*(call_580052: Call_SpannerProjectsInstancesOperationsGet_580036;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580053 = newJObject()
  var query_580054 = newJObject()
  add(query_580054, "key", newJString(key))
  add(query_580054, "prettyPrint", newJBool(prettyPrint))
  add(query_580054, "oauth_token", newJString(oauthToken))
  add(query_580054, "$.xgafv", newJString(Xgafv))
  add(query_580054, "alt", newJString(alt))
  add(query_580054, "uploadType", newJString(uploadType))
  add(query_580054, "quotaUser", newJString(quotaUser))
  add(path_580053, "name", newJString(name))
  add(query_580054, "callback", newJString(callback))
  add(query_580054, "fields", newJString(fields))
  add(query_580054, "access_token", newJString(accessToken))
  add(query_580054, "upload_protocol", newJString(uploadProtocol))
  result = call_580052.call(path_580053, query_580054, nil, nil, nil)

var spannerProjectsInstancesOperationsGet* = Call_SpannerProjectsInstancesOperationsGet_580036(
    name: "spannerProjectsInstancesOperationsGet", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesOperationsGet_580037, base: "/",
    url: url_SpannerProjectsInstancesOperationsGet_580038, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesPatch_580074 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesPatch_580076(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesPatch_580075(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an instance, and begins allocating or releasing resources
  ## as requested. The returned long-running
  ## operation can be used to track the
  ## progress of updating the instance. If the named instance does not
  ## exist, returns `NOT_FOUND`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * For resource types for which a decrease in the instance's allocation
  ##     has been requested, billing is based on the newly-requested level.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation sets its metadata's
  ##     cancel_time, and begins
  ##     restoring resources to their pre-request values. The operation
  ##     is guaranteed to succeed at undoing all resource changes,
  ##     after which point it terminates with a `CANCELLED` status.
  ##   * All other attempts to modify the instance are rejected.
  ##   * Reading the instance via the API continues to give the pre-request
  ##     resource levels.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing begins for all successfully-allocated resources (some types
  ##     may have lower than the requested levels).
  ##   * All newly-reserved resources are available for serving the instance's
  ##     tables.
  ##   * The instance's new resource levels are readable via the API.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track the instance modification.  The
  ## metadata field type is
  ## UpdateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  ## Authorization requires `spanner.instances.update` permission on
  ## resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. A unique identifier for the instance, which cannot be changed
  ## after the instance is created. Values are of the form
  ## `projects/<project>/instances/a-z*[a-z0-9]`. The final
  ## segment of the name must be between 2 and 64 characters in length.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580077 = path.getOrDefault("name")
  valid_580077 = validateParameter(valid_580077, JString, required = true,
                                 default = nil)
  if valid_580077 != nil:
    section.add "name", valid_580077
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
  var valid_580078 = query.getOrDefault("key")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "key", valid_580078
  var valid_580079 = query.getOrDefault("prettyPrint")
  valid_580079 = validateParameter(valid_580079, JBool, required = false,
                                 default = newJBool(true))
  if valid_580079 != nil:
    section.add "prettyPrint", valid_580079
  var valid_580080 = query.getOrDefault("oauth_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "oauth_token", valid_580080
  var valid_580081 = query.getOrDefault("$.xgafv")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("1"))
  if valid_580081 != nil:
    section.add "$.xgafv", valid_580081
  var valid_580082 = query.getOrDefault("alt")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("json"))
  if valid_580082 != nil:
    section.add "alt", valid_580082
  var valid_580083 = query.getOrDefault("uploadType")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "uploadType", valid_580083
  var valid_580084 = query.getOrDefault("quotaUser")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "quotaUser", valid_580084
  var valid_580085 = query.getOrDefault("callback")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "callback", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("access_token")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "access_token", valid_580087
  var valid_580088 = query.getOrDefault("upload_protocol")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "upload_protocol", valid_580088
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

proc call*(call_580090: Call_SpannerProjectsInstancesPatch_580074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an instance, and begins allocating or releasing resources
  ## as requested. The returned long-running
  ## operation can be used to track the
  ## progress of updating the instance. If the named instance does not
  ## exist, returns `NOT_FOUND`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * For resource types for which a decrease in the instance's allocation
  ##     has been requested, billing is based on the newly-requested level.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation sets its metadata's
  ##     cancel_time, and begins
  ##     restoring resources to their pre-request values. The operation
  ##     is guaranteed to succeed at undoing all resource changes,
  ##     after which point it terminates with a `CANCELLED` status.
  ##   * All other attempts to modify the instance are rejected.
  ##   * Reading the instance via the API continues to give the pre-request
  ##     resource levels.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing begins for all successfully-allocated resources (some types
  ##     may have lower than the requested levels).
  ##   * All newly-reserved resources are available for serving the instance's
  ##     tables.
  ##   * The instance's new resource levels are readable via the API.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track the instance modification.  The
  ## metadata field type is
  ## UpdateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  ## Authorization requires `spanner.instances.update` permission on
  ## resource name.
  ## 
  let valid = call_580090.validator(path, query, header, formData, body)
  let scheme = call_580090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580090.url(scheme.get, call_580090.host, call_580090.base,
                         call_580090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580090, url, valid)

proc call*(call_580091: Call_SpannerProjectsInstancesPatch_580074; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesPatch
  ## Updates an instance, and begins allocating or releasing resources
  ## as requested. The returned long-running
  ## operation can be used to track the
  ## progress of updating the instance. If the named instance does not
  ## exist, returns `NOT_FOUND`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * For resource types for which a decrease in the instance's allocation
  ##     has been requested, billing is based on the newly-requested level.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation sets its metadata's
  ##     cancel_time, and begins
  ##     restoring resources to their pre-request values. The operation
  ##     is guaranteed to succeed at undoing all resource changes,
  ##     after which point it terminates with a `CANCELLED` status.
  ##   * All other attempts to modify the instance are rejected.
  ##   * Reading the instance via the API continues to give the pre-request
  ##     resource levels.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing begins for all successfully-allocated resources (some types
  ##     may have lower than the requested levels).
  ##   * All newly-reserved resources are available for serving the instance's
  ##     tables.
  ##   * The instance's new resource levels are readable via the API.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track the instance modification.  The
  ## metadata field type is
  ## UpdateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  ## Authorization requires `spanner.instances.update` permission on
  ## resource name.
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
  ##   name: string (required)
  ##       : Required. A unique identifier for the instance, which cannot be changed
  ## after the instance is created. Values are of the form
  ## `projects/<project>/instances/a-z*[a-z0-9]`. The final
  ## segment of the name must be between 2 and 64 characters in length.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580092 = newJObject()
  var query_580093 = newJObject()
  var body_580094 = newJObject()
  add(query_580093, "key", newJString(key))
  add(query_580093, "prettyPrint", newJBool(prettyPrint))
  add(query_580093, "oauth_token", newJString(oauthToken))
  add(query_580093, "$.xgafv", newJString(Xgafv))
  add(query_580093, "alt", newJString(alt))
  add(query_580093, "uploadType", newJString(uploadType))
  add(query_580093, "quotaUser", newJString(quotaUser))
  add(path_580092, "name", newJString(name))
  if body != nil:
    body_580094 = body
  add(query_580093, "callback", newJString(callback))
  add(query_580093, "fields", newJString(fields))
  add(query_580093, "access_token", newJString(accessToken))
  add(query_580093, "upload_protocol", newJString(uploadProtocol))
  result = call_580091.call(path_580092, query_580093, nil, nil, body_580094)

var spannerProjectsInstancesPatch* = Call_SpannerProjectsInstancesPatch_580074(
    name: "spannerProjectsInstancesPatch", meth: HttpMethod.HttpPatch,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesPatch_580075, base: "/",
    url: url_SpannerProjectsInstancesPatch_580076, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesOperationsDelete_580055 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesOperationsDelete_580057(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesOperationsDelete_580056(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580058 = path.getOrDefault("name")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "name", valid_580058
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
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("prettyPrint")
  valid_580060 = validateParameter(valid_580060, JBool, required = false,
                                 default = newJBool(true))
  if valid_580060 != nil:
    section.add "prettyPrint", valid_580060
  var valid_580061 = query.getOrDefault("oauth_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "oauth_token", valid_580061
  var valid_580062 = query.getOrDefault("$.xgafv")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("1"))
  if valid_580062 != nil:
    section.add "$.xgafv", valid_580062
  var valid_580063 = query.getOrDefault("alt")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("json"))
  if valid_580063 != nil:
    section.add "alt", valid_580063
  var valid_580064 = query.getOrDefault("uploadType")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "uploadType", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("callback")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "callback", valid_580066
  var valid_580067 = query.getOrDefault("fields")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "fields", valid_580067
  var valid_580068 = query.getOrDefault("access_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "access_token", valid_580068
  var valid_580069 = query.getOrDefault("upload_protocol")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "upload_protocol", valid_580069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580070: Call_SpannerProjectsInstancesOperationsDelete_580055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_580070.validator(path, query, header, formData, body)
  let scheme = call_580070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580070.url(scheme.get, call_580070.host, call_580070.base,
                         call_580070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580070, url, valid)

proc call*(call_580071: Call_SpannerProjectsInstancesOperationsDelete_580055;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
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
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580072 = newJObject()
  var query_580073 = newJObject()
  add(query_580073, "key", newJString(key))
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(query_580073, "$.xgafv", newJString(Xgafv))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "uploadType", newJString(uploadType))
  add(query_580073, "quotaUser", newJString(quotaUser))
  add(path_580072, "name", newJString(name))
  add(query_580073, "callback", newJString(callback))
  add(query_580073, "fields", newJString(fields))
  add(query_580073, "access_token", newJString(accessToken))
  add(query_580073, "upload_protocol", newJString(uploadProtocol))
  result = call_580071.call(path_580072, query_580073, nil, nil, nil)

var spannerProjectsInstancesOperationsDelete* = Call_SpannerProjectsInstancesOperationsDelete_580055(
    name: "spannerProjectsInstancesOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesOperationsDelete_580056,
    base: "/", url: url_SpannerProjectsInstancesOperationsDelete_580057,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesOperationsCancel_580095 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesOperationsCancel_580097(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesOperationsCancel_580096(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580098 = path.getOrDefault("name")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "name", valid_580098
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
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("prettyPrint")
  valid_580100 = validateParameter(valid_580100, JBool, required = false,
                                 default = newJBool(true))
  if valid_580100 != nil:
    section.add "prettyPrint", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("$.xgafv")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("1"))
  if valid_580102 != nil:
    section.add "$.xgafv", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("uploadType")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "uploadType", valid_580104
  var valid_580105 = query.getOrDefault("quotaUser")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "quotaUser", valid_580105
  var valid_580106 = query.getOrDefault("callback")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "callback", valid_580106
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  var valid_580108 = query.getOrDefault("access_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "access_token", valid_580108
  var valid_580109 = query.getOrDefault("upload_protocol")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "upload_protocol", valid_580109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580110: Call_SpannerProjectsInstancesOperationsCancel_580095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_SpannerProjectsInstancesOperationsCancel_580095;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
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
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580112 = newJObject()
  var query_580113 = newJObject()
  add(query_580113, "key", newJString(key))
  add(query_580113, "prettyPrint", newJBool(prettyPrint))
  add(query_580113, "oauth_token", newJString(oauthToken))
  add(query_580113, "$.xgafv", newJString(Xgafv))
  add(query_580113, "alt", newJString(alt))
  add(query_580113, "uploadType", newJString(uploadType))
  add(query_580113, "quotaUser", newJString(quotaUser))
  add(path_580112, "name", newJString(name))
  add(query_580113, "callback", newJString(callback))
  add(query_580113, "fields", newJString(fields))
  add(query_580113, "access_token", newJString(accessToken))
  add(query_580113, "upload_protocol", newJString(uploadProtocol))
  result = call_580111.call(path_580112, query_580113, nil, nil, nil)

var spannerProjectsInstancesOperationsCancel* = Call_SpannerProjectsInstancesOperationsCancel_580095(
    name: "spannerProjectsInstancesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_SpannerProjectsInstancesOperationsCancel_580096,
    base: "/", url: url_SpannerProjectsInstancesOperationsCancel_580097,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesCreate_580135 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesCreate_580137(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
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

proc validate_SpannerProjectsInstancesDatabasesCreate_580136(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Cloud Spanner database and starts to prepare it for serving.
  ## The returned long-running operation will
  ## have a name of the format `<database_name>/operations/<operation_id>` and
  ## can be used to track preparation of the database. The
  ## metadata field type is
  ## CreateDatabaseMetadata. The
  ## response field type is
  ## Database, if successful.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the instance that will serve the new database.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580138 = path.getOrDefault("parent")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "parent", valid_580138
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
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("$.xgafv")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("1"))
  if valid_580142 != nil:
    section.add "$.xgafv", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("uploadType")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "uploadType", valid_580144
  var valid_580145 = query.getOrDefault("quotaUser")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "quotaUser", valid_580145
  var valid_580146 = query.getOrDefault("callback")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "callback", valid_580146
  var valid_580147 = query.getOrDefault("fields")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "fields", valid_580147
  var valid_580148 = query.getOrDefault("access_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "access_token", valid_580148
  var valid_580149 = query.getOrDefault("upload_protocol")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "upload_protocol", valid_580149
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

proc call*(call_580151: Call_SpannerProjectsInstancesDatabasesCreate_580135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Cloud Spanner database and starts to prepare it for serving.
  ## The returned long-running operation will
  ## have a name of the format `<database_name>/operations/<operation_id>` and
  ## can be used to track preparation of the database. The
  ## metadata field type is
  ## CreateDatabaseMetadata. The
  ## response field type is
  ## Database, if successful.
  ## 
  let valid = call_580151.validator(path, query, header, formData, body)
  let scheme = call_580151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580151.url(scheme.get, call_580151.host, call_580151.base,
                         call_580151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580151, url, valid)

proc call*(call_580152: Call_SpannerProjectsInstancesDatabasesCreate_580135;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesCreate
  ## Creates a new Cloud Spanner database and starts to prepare it for serving.
  ## The returned long-running operation will
  ## have a name of the format `<database_name>/operations/<operation_id>` and
  ## can be used to track preparation of the database. The
  ## metadata field type is
  ## CreateDatabaseMetadata. The
  ## response field type is
  ## Database, if successful.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the instance that will serve the new database.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580153 = newJObject()
  var query_580154 = newJObject()
  var body_580155 = newJObject()
  add(query_580154, "key", newJString(key))
  add(query_580154, "prettyPrint", newJBool(prettyPrint))
  add(query_580154, "oauth_token", newJString(oauthToken))
  add(query_580154, "$.xgafv", newJString(Xgafv))
  add(query_580154, "alt", newJString(alt))
  add(query_580154, "uploadType", newJString(uploadType))
  add(query_580154, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580155 = body
  add(query_580154, "callback", newJString(callback))
  add(path_580153, "parent", newJString(parent))
  add(query_580154, "fields", newJString(fields))
  add(query_580154, "access_token", newJString(accessToken))
  add(query_580154, "upload_protocol", newJString(uploadProtocol))
  result = call_580152.call(path_580153, query_580154, nil, nil, body_580155)

var spannerProjectsInstancesDatabasesCreate* = Call_SpannerProjectsInstancesDatabasesCreate_580135(
    name: "spannerProjectsInstancesDatabasesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesCreate_580136, base: "/",
    url: url_SpannerProjectsInstancesDatabasesCreate_580137,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesList_580114 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesList_580116(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
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

proc validate_SpannerProjectsInstancesDatabasesList_580115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Cloud Spanner databases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The instance whose databases should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580117 = path.getOrDefault("parent")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "parent", valid_580117
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
  ##   pageSize: JInt
  ##           : Number of databases to be returned in the response. If 0 or less,
  ## defaults to the server's maximum allowed page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListDatabasesResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580118 = query.getOrDefault("key")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "key", valid_580118
  var valid_580119 = query.getOrDefault("prettyPrint")
  valid_580119 = validateParameter(valid_580119, JBool, required = false,
                                 default = newJBool(true))
  if valid_580119 != nil:
    section.add "prettyPrint", valid_580119
  var valid_580120 = query.getOrDefault("oauth_token")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "oauth_token", valid_580120
  var valid_580121 = query.getOrDefault("$.xgafv")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("1"))
  if valid_580121 != nil:
    section.add "$.xgafv", valid_580121
  var valid_580122 = query.getOrDefault("pageSize")
  valid_580122 = validateParameter(valid_580122, JInt, required = false, default = nil)
  if valid_580122 != nil:
    section.add "pageSize", valid_580122
  var valid_580123 = query.getOrDefault("alt")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("json"))
  if valid_580123 != nil:
    section.add "alt", valid_580123
  var valid_580124 = query.getOrDefault("uploadType")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "uploadType", valid_580124
  var valid_580125 = query.getOrDefault("quotaUser")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "quotaUser", valid_580125
  var valid_580126 = query.getOrDefault("pageToken")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "pageToken", valid_580126
  var valid_580127 = query.getOrDefault("callback")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "callback", valid_580127
  var valid_580128 = query.getOrDefault("fields")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "fields", valid_580128
  var valid_580129 = query.getOrDefault("access_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "access_token", valid_580129
  var valid_580130 = query.getOrDefault("upload_protocol")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "upload_protocol", valid_580130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580131: Call_SpannerProjectsInstancesDatabasesList_580114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Cloud Spanner databases.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_SpannerProjectsInstancesDatabasesList_580114;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesList
  ## Lists Cloud Spanner databases.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of databases to be returned in the response. If 0 or less,
  ## defaults to the server's maximum allowed page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListDatabasesResponse.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The instance whose databases should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580133 = newJObject()
  var query_580134 = newJObject()
  add(query_580134, "key", newJString(key))
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "$.xgafv", newJString(Xgafv))
  add(query_580134, "pageSize", newJInt(pageSize))
  add(query_580134, "alt", newJString(alt))
  add(query_580134, "uploadType", newJString(uploadType))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(query_580134, "pageToken", newJString(pageToken))
  add(query_580134, "callback", newJString(callback))
  add(path_580133, "parent", newJString(parent))
  add(query_580134, "fields", newJString(fields))
  add(query_580134, "access_token", newJString(accessToken))
  add(query_580134, "upload_protocol", newJString(uploadProtocol))
  result = call_580132.call(path_580133, query_580134, nil, nil, nil)

var spannerProjectsInstancesDatabasesList* = Call_SpannerProjectsInstancesDatabasesList_580114(
    name: "spannerProjectsInstancesDatabasesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesList_580115, base: "/",
    url: url_SpannerProjectsInstancesDatabasesList_580116, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstanceConfigsList_580156 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstanceConfigsList_580158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instanceConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstanceConfigsList_580157(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the supported instance configurations for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project for which a list of supported instance
  ## configurations is requested. Values are of the form
  ## `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580159 = path.getOrDefault("parent")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "parent", valid_580159
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
  ##   pageSize: JInt
  ##           : Number of instance configurations to be returned in the response. If 0 or
  ## less, defaults to the server's maximum allowed page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token
  ## from a previous ListInstanceConfigsResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("prettyPrint")
  valid_580161 = validateParameter(valid_580161, JBool, required = false,
                                 default = newJBool(true))
  if valid_580161 != nil:
    section.add "prettyPrint", valid_580161
  var valid_580162 = query.getOrDefault("oauth_token")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "oauth_token", valid_580162
  var valid_580163 = query.getOrDefault("$.xgafv")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = newJString("1"))
  if valid_580163 != nil:
    section.add "$.xgafv", valid_580163
  var valid_580164 = query.getOrDefault("pageSize")
  valid_580164 = validateParameter(valid_580164, JInt, required = false, default = nil)
  if valid_580164 != nil:
    section.add "pageSize", valid_580164
  var valid_580165 = query.getOrDefault("alt")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("json"))
  if valid_580165 != nil:
    section.add "alt", valid_580165
  var valid_580166 = query.getOrDefault("uploadType")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "uploadType", valid_580166
  var valid_580167 = query.getOrDefault("quotaUser")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "quotaUser", valid_580167
  var valid_580168 = query.getOrDefault("pageToken")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "pageToken", valid_580168
  var valid_580169 = query.getOrDefault("callback")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "callback", valid_580169
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
  var valid_580171 = query.getOrDefault("access_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "access_token", valid_580171
  var valid_580172 = query.getOrDefault("upload_protocol")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "upload_protocol", valid_580172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580173: Call_SpannerProjectsInstanceConfigsList_580156;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the supported instance configurations for a given project.
  ## 
  let valid = call_580173.validator(path, query, header, formData, body)
  let scheme = call_580173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580173.url(scheme.get, call_580173.host, call_580173.base,
                         call_580173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580173, url, valid)

proc call*(call_580174: Call_SpannerProjectsInstanceConfigsList_580156;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstanceConfigsList
  ## Lists the supported instance configurations for a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of instance configurations to be returned in the response. If 0 or
  ## less, defaults to the server's maximum allowed page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token
  ## from a previous ListInstanceConfigsResponse.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project for which a list of supported instance
  ## configurations is requested. Values are of the form
  ## `projects/<project>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580175 = newJObject()
  var query_580176 = newJObject()
  add(query_580176, "key", newJString(key))
  add(query_580176, "prettyPrint", newJBool(prettyPrint))
  add(query_580176, "oauth_token", newJString(oauthToken))
  add(query_580176, "$.xgafv", newJString(Xgafv))
  add(query_580176, "pageSize", newJInt(pageSize))
  add(query_580176, "alt", newJString(alt))
  add(query_580176, "uploadType", newJString(uploadType))
  add(query_580176, "quotaUser", newJString(quotaUser))
  add(query_580176, "pageToken", newJString(pageToken))
  add(query_580176, "callback", newJString(callback))
  add(path_580175, "parent", newJString(parent))
  add(query_580176, "fields", newJString(fields))
  add(query_580176, "access_token", newJString(accessToken))
  add(query_580176, "upload_protocol", newJString(uploadProtocol))
  result = call_580174.call(path_580175, query_580176, nil, nil, nil)

var spannerProjectsInstanceConfigsList* = Call_SpannerProjectsInstanceConfigsList_580156(
    name: "spannerProjectsInstanceConfigsList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instanceConfigs",
    validator: validate_SpannerProjectsInstanceConfigsList_580157, base: "/",
    url: url_SpannerProjectsInstanceConfigsList_580158, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesCreate_580199 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesCreate_580201(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
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

proc validate_SpannerProjectsInstancesCreate_580200(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an instance and begins preparing it to begin serving. The
  ## returned long-running operation
  ## can be used to track the progress of preparing the new
  ## instance. The instance name is assigned by the caller. If the
  ## named instance already exists, `CreateInstance` returns
  ## `ALREADY_EXISTS`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * The instance is readable via the API, with all requested attributes
  ##     but no allocated resources. Its state is `CREATING`.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation renders the instance immediately unreadable
  ##     via the API.
  ##   * The instance can be deleted.
  ##   * All other attempts to modify the instance are rejected.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing for all successfully-allocated resources begins (some types
  ##     may have lower than the requested levels).
  ##   * Databases can be created in the instance.
  ##   * The instance's allocated resource levels are readable via the API.
  ##   * The instance's state becomes `READY`.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track creation of the instance.  The
  ## metadata field type is
  ## CreateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project in which to create the instance. Values
  ## are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580202 = path.getOrDefault("parent")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "parent", valid_580202
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
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
  var valid_580204 = query.getOrDefault("prettyPrint")
  valid_580204 = validateParameter(valid_580204, JBool, required = false,
                                 default = newJBool(true))
  if valid_580204 != nil:
    section.add "prettyPrint", valid_580204
  var valid_580205 = query.getOrDefault("oauth_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "oauth_token", valid_580205
  var valid_580206 = query.getOrDefault("$.xgafv")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("1"))
  if valid_580206 != nil:
    section.add "$.xgafv", valid_580206
  var valid_580207 = query.getOrDefault("alt")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("json"))
  if valid_580207 != nil:
    section.add "alt", valid_580207
  var valid_580208 = query.getOrDefault("uploadType")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "uploadType", valid_580208
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

proc call*(call_580215: Call_SpannerProjectsInstancesCreate_580199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an instance and begins preparing it to begin serving. The
  ## returned long-running operation
  ## can be used to track the progress of preparing the new
  ## instance. The instance name is assigned by the caller. If the
  ## named instance already exists, `CreateInstance` returns
  ## `ALREADY_EXISTS`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * The instance is readable via the API, with all requested attributes
  ##     but no allocated resources. Its state is `CREATING`.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation renders the instance immediately unreadable
  ##     via the API.
  ##   * The instance can be deleted.
  ##   * All other attempts to modify the instance are rejected.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing for all successfully-allocated resources begins (some types
  ##     may have lower than the requested levels).
  ##   * Databases can be created in the instance.
  ##   * The instance's allocated resource levels are readable via the API.
  ##   * The instance's state becomes `READY`.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track creation of the instance.  The
  ## metadata field type is
  ## CreateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_SpannerProjectsInstancesCreate_580199; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesCreate
  ## Creates an instance and begins preparing it to begin serving. The
  ## returned long-running operation
  ## can be used to track the progress of preparing the new
  ## instance. The instance name is assigned by the caller. If the
  ## named instance already exists, `CreateInstance` returns
  ## `ALREADY_EXISTS`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * The instance is readable via the API, with all requested attributes
  ##     but no allocated resources. Its state is `CREATING`.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation renders the instance immediately unreadable
  ##     via the API.
  ##   * The instance can be deleted.
  ##   * All other attempts to modify the instance are rejected.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing for all successfully-allocated resources begins (some types
  ##     may have lower than the requested levels).
  ##   * Databases can be created in the instance.
  ##   * The instance's allocated resource levels are readable via the API.
  ##   * The instance's state becomes `READY`.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track creation of the instance.  The
  ## metadata field type is
  ## CreateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project in which to create the instance. Values
  ## are of the form `projects/<project>`.
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
  add(query_580218, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580219 = body
  add(query_580218, "callback", newJString(callback))
  add(path_580217, "parent", newJString(parent))
  add(query_580218, "fields", newJString(fields))
  add(query_580218, "access_token", newJString(accessToken))
  add(query_580218, "upload_protocol", newJString(uploadProtocol))
  result = call_580216.call(path_580217, query_580218, nil, nil, body_580219)

var spannerProjectsInstancesCreate* = Call_SpannerProjectsInstancesCreate_580199(
    name: "spannerProjectsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesCreate_580200, base: "/",
    url: url_SpannerProjectsInstancesCreate_580201, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesList_580177 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesList_580179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
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

proc validate_SpannerProjectsInstancesList_580178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all instances in the given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project for which a list of instances is
  ## requested. Values are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580180 = path.getOrDefault("parent")
  valid_580180 = validateParameter(valid_580180, JString, required = true,
                                 default = nil)
  if valid_580180 != nil:
    section.add "parent", valid_580180
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
  ##   pageSize: JInt
  ##           : Number of instances to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : An expression for filtering the results of the request. Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ##   * `name`
  ##   * `display_name`
  ##   * `labels.key` where key is the name of a label
  ## 
  ## Some examples of using filters are:
  ## 
  ##   * `name:*` --> The instance has a name.
  ##   * `name:Howl` --> The instance's name contains the string "howl".
  ##   * `name:HOWL` --> Equivalent to above.
  ##   * `NAME:howl` --> Equivalent to above.
  ##   * `labels.env:*` --> The instance has the label "env".
  ##   * `labels.env:dev` --> The instance has the label "env" and the value of
  ##                        the label contains the string "dev".
  ##   * `name:howl labels.env:dev` --> The instance's name contains "howl" and
  ##                                  it has the label "env" with its value
  ##                                  containing "dev".
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListInstancesResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580181 = query.getOrDefault("key")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "key", valid_580181
  var valid_580182 = query.getOrDefault("prettyPrint")
  valid_580182 = validateParameter(valid_580182, JBool, required = false,
                                 default = newJBool(true))
  if valid_580182 != nil:
    section.add "prettyPrint", valid_580182
  var valid_580183 = query.getOrDefault("oauth_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "oauth_token", valid_580183
  var valid_580184 = query.getOrDefault("$.xgafv")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("1"))
  if valid_580184 != nil:
    section.add "$.xgafv", valid_580184
  var valid_580185 = query.getOrDefault("pageSize")
  valid_580185 = validateParameter(valid_580185, JInt, required = false, default = nil)
  if valid_580185 != nil:
    section.add "pageSize", valid_580185
  var valid_580186 = query.getOrDefault("alt")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = newJString("json"))
  if valid_580186 != nil:
    section.add "alt", valid_580186
  var valid_580187 = query.getOrDefault("uploadType")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "uploadType", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("filter")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "filter", valid_580189
  var valid_580190 = query.getOrDefault("pageToken")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "pageToken", valid_580190
  var valid_580191 = query.getOrDefault("callback")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "callback", valid_580191
  var valid_580192 = query.getOrDefault("fields")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "fields", valid_580192
  var valid_580193 = query.getOrDefault("access_token")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "access_token", valid_580193
  var valid_580194 = query.getOrDefault("upload_protocol")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "upload_protocol", valid_580194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580195: Call_SpannerProjectsInstancesList_580177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all instances in the given project.
  ## 
  let valid = call_580195.validator(path, query, header, formData, body)
  let scheme = call_580195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580195.url(scheme.get, call_580195.host, call_580195.base,
                         call_580195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580195, url, valid)

proc call*(call_580196: Call_SpannerProjectsInstancesList_580177; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesList
  ## Lists all instances in the given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of instances to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : An expression for filtering the results of the request. Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ##   * `name`
  ##   * `display_name`
  ##   * `labels.key` where key is the name of a label
  ## 
  ## Some examples of using filters are:
  ## 
  ##   * `name:*` --> The instance has a name.
  ##   * `name:Howl` --> The instance's name contains the string "howl".
  ##   * `name:HOWL` --> Equivalent to above.
  ##   * `NAME:howl` --> Equivalent to above.
  ##   * `labels.env:*` --> The instance has the label "env".
  ##   * `labels.env:dev` --> The instance has the label "env" and the value of
  ##                        the label contains the string "dev".
  ##   * `name:howl labels.env:dev` --> The instance's name contains "howl" and
  ##                                  it has the label "env" with its value
  ##                                  containing "dev".
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListInstancesResponse.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project for which a list of instances is
  ## requested. Values are of the form `projects/<project>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580197 = newJObject()
  var query_580198 = newJObject()
  add(query_580198, "key", newJString(key))
  add(query_580198, "prettyPrint", newJBool(prettyPrint))
  add(query_580198, "oauth_token", newJString(oauthToken))
  add(query_580198, "$.xgafv", newJString(Xgafv))
  add(query_580198, "pageSize", newJInt(pageSize))
  add(query_580198, "alt", newJString(alt))
  add(query_580198, "uploadType", newJString(uploadType))
  add(query_580198, "quotaUser", newJString(quotaUser))
  add(query_580198, "filter", newJString(filter))
  add(query_580198, "pageToken", newJString(pageToken))
  add(query_580198, "callback", newJString(callback))
  add(path_580197, "parent", newJString(parent))
  add(query_580198, "fields", newJString(fields))
  add(query_580198, "access_token", newJString(accessToken))
  add(query_580198, "upload_protocol", newJString(uploadProtocol))
  result = call_580196.call(path_580197, query_580198, nil, nil, nil)

var spannerProjectsInstancesList* = Call_SpannerProjectsInstancesList_580177(
    name: "spannerProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesList_580178, base: "/",
    url: url_SpannerProjectsInstancesList_580179, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetIamPolicy_580220 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesGetIamPolicy_580222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesGetIamPolicy_580221(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being retrieved. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580223 = path.getOrDefault("resource")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "resource", valid_580223
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
  var valid_580224 = query.getOrDefault("key")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "key", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
  var valid_580226 = query.getOrDefault("oauth_token")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "oauth_token", valid_580226
  var valid_580227 = query.getOrDefault("$.xgafv")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("1"))
  if valid_580227 != nil:
    section.add "$.xgafv", valid_580227
  var valid_580228 = query.getOrDefault("alt")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("json"))
  if valid_580228 != nil:
    section.add "alt", valid_580228
  var valid_580229 = query.getOrDefault("uploadType")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "uploadType", valid_580229
  var valid_580230 = query.getOrDefault("quotaUser")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "quotaUser", valid_580230
  var valid_580231 = query.getOrDefault("callback")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "callback", valid_580231
  var valid_580232 = query.getOrDefault("fields")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "fields", valid_580232
  var valid_580233 = query.getOrDefault("access_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "access_token", valid_580233
  var valid_580234 = query.getOrDefault("upload_protocol")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "upload_protocol", valid_580234
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

proc call*(call_580236: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_580220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ## 
  let valid = call_580236.validator(path, query, header, formData, body)
  let scheme = call_580236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580236.url(scheme.get, call_580236.host, call_580236.base,
                         call_580236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580236, url, valid)

proc call*(call_580237: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_580220;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesGetIamPolicy
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
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
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being retrieved. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580238 = newJObject()
  var query_580239 = newJObject()
  var body_580240 = newJObject()
  add(query_580239, "key", newJString(key))
  add(query_580239, "prettyPrint", newJBool(prettyPrint))
  add(query_580239, "oauth_token", newJString(oauthToken))
  add(query_580239, "$.xgafv", newJString(Xgafv))
  add(query_580239, "alt", newJString(alt))
  add(query_580239, "uploadType", newJString(uploadType))
  add(query_580239, "quotaUser", newJString(quotaUser))
  add(path_580238, "resource", newJString(resource))
  if body != nil:
    body_580240 = body
  add(query_580239, "callback", newJString(callback))
  add(query_580239, "fields", newJString(fields))
  add(query_580239, "access_token", newJString(accessToken))
  add(query_580239, "upload_protocol", newJString(uploadProtocol))
  result = call_580237.call(path_580238, query_580239, nil, nil, body_580240)

var spannerProjectsInstancesDatabasesGetIamPolicy* = Call_SpannerProjectsInstancesDatabasesGetIamPolicy_580220(
    name: "spannerProjectsInstancesDatabasesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesGetIamPolicy_580221,
    base: "/", url: url_SpannerProjectsInstancesDatabasesGetIamPolicy_580222,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSetIamPolicy_580241 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSetIamPolicy_580243(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSetIamPolicy_580242(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being set. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for databases resources.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580244 = path.getOrDefault("resource")
  valid_580244 = validateParameter(valid_580244, JString, required = true,
                                 default = nil)
  if valid_580244 != nil:
    section.add "resource", valid_580244
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
  var valid_580245 = query.getOrDefault("key")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "key", valid_580245
  var valid_580246 = query.getOrDefault("prettyPrint")
  valid_580246 = validateParameter(valid_580246, JBool, required = false,
                                 default = newJBool(true))
  if valid_580246 != nil:
    section.add "prettyPrint", valid_580246
  var valid_580247 = query.getOrDefault("oauth_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "oauth_token", valid_580247
  var valid_580248 = query.getOrDefault("$.xgafv")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("1"))
  if valid_580248 != nil:
    section.add "$.xgafv", valid_580248
  var valid_580249 = query.getOrDefault("alt")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("json"))
  if valid_580249 != nil:
    section.add "alt", valid_580249
  var valid_580250 = query.getOrDefault("uploadType")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "uploadType", valid_580250
  var valid_580251 = query.getOrDefault("quotaUser")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "quotaUser", valid_580251
  var valid_580252 = query.getOrDefault("callback")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "callback", valid_580252
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
  var valid_580254 = query.getOrDefault("access_token")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "access_token", valid_580254
  var valid_580255 = query.getOrDefault("upload_protocol")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "upload_protocol", valid_580255
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

proc call*(call_580257: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_580241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ## 
  let valid = call_580257.validator(path, query, header, formData, body)
  let scheme = call_580257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580257.url(scheme.get, call_580257.host, call_580257.base,
                         call_580257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580257, url, valid)

proc call*(call_580258: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_580241;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSetIamPolicy
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
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
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being set. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for databases resources.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580259 = newJObject()
  var query_580260 = newJObject()
  var body_580261 = newJObject()
  add(query_580260, "key", newJString(key))
  add(query_580260, "prettyPrint", newJBool(prettyPrint))
  add(query_580260, "oauth_token", newJString(oauthToken))
  add(query_580260, "$.xgafv", newJString(Xgafv))
  add(query_580260, "alt", newJString(alt))
  add(query_580260, "uploadType", newJString(uploadType))
  add(query_580260, "quotaUser", newJString(quotaUser))
  add(path_580259, "resource", newJString(resource))
  if body != nil:
    body_580261 = body
  add(query_580260, "callback", newJString(callback))
  add(query_580260, "fields", newJString(fields))
  add(query_580260, "access_token", newJString(accessToken))
  add(query_580260, "upload_protocol", newJString(uploadProtocol))
  result = call_580258.call(path_580259, query_580260, nil, nil, body_580261)

var spannerProjectsInstancesDatabasesSetIamPolicy* = Call_SpannerProjectsInstancesDatabasesSetIamPolicy_580241(
    name: "spannerProjectsInstancesDatabasesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesSetIamPolicy_580242,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSetIamPolicy_580243,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesTestIamPermissions_580262 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesTestIamPermissions_580264(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesTestIamPermissions_580263(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The Cloud Spanner resource for which permissions are being tested. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580265 = path.getOrDefault("resource")
  valid_580265 = validateParameter(valid_580265, JString, required = true,
                                 default = nil)
  if valid_580265 != nil:
    section.add "resource", valid_580265
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
  var valid_580266 = query.getOrDefault("key")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "key", valid_580266
  var valid_580267 = query.getOrDefault("prettyPrint")
  valid_580267 = validateParameter(valid_580267, JBool, required = false,
                                 default = newJBool(true))
  if valid_580267 != nil:
    section.add "prettyPrint", valid_580267
  var valid_580268 = query.getOrDefault("oauth_token")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "oauth_token", valid_580268
  var valid_580269 = query.getOrDefault("$.xgafv")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("1"))
  if valid_580269 != nil:
    section.add "$.xgafv", valid_580269
  var valid_580270 = query.getOrDefault("alt")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = newJString("json"))
  if valid_580270 != nil:
    section.add "alt", valid_580270
  var valid_580271 = query.getOrDefault("uploadType")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "uploadType", valid_580271
  var valid_580272 = query.getOrDefault("quotaUser")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "quotaUser", valid_580272
  var valid_580273 = query.getOrDefault("callback")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "callback", valid_580273
  var valid_580274 = query.getOrDefault("fields")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "fields", valid_580274
  var valid_580275 = query.getOrDefault("access_token")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "access_token", valid_580275
  var valid_580276 = query.getOrDefault("upload_protocol")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "upload_protocol", valid_580276
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

proc call*(call_580278: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_580262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ## 
  let valid = call_580278.validator(path, query, header, formData, body)
  let scheme = call_580278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580278.url(scheme.get, call_580278.host, call_580278.base,
                         call_580278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580278, url, valid)

proc call*(call_580279: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_580262;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesTestIamPermissions
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
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
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which permissions are being tested. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580280 = newJObject()
  var query_580281 = newJObject()
  var body_580282 = newJObject()
  add(query_580281, "key", newJString(key))
  add(query_580281, "prettyPrint", newJBool(prettyPrint))
  add(query_580281, "oauth_token", newJString(oauthToken))
  add(query_580281, "$.xgafv", newJString(Xgafv))
  add(query_580281, "alt", newJString(alt))
  add(query_580281, "uploadType", newJString(uploadType))
  add(query_580281, "quotaUser", newJString(quotaUser))
  add(path_580280, "resource", newJString(resource))
  if body != nil:
    body_580282 = body
  add(query_580281, "callback", newJString(callback))
  add(query_580281, "fields", newJString(fields))
  add(query_580281, "access_token", newJString(accessToken))
  add(query_580281, "upload_protocol", newJString(uploadProtocol))
  result = call_580279.call(path_580280, query_580281, nil, nil, body_580282)

var spannerProjectsInstancesDatabasesTestIamPermissions* = Call_SpannerProjectsInstancesDatabasesTestIamPermissions_580262(
    name: "spannerProjectsInstancesDatabasesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_SpannerProjectsInstancesDatabasesTestIamPermissions_580263,
    base: "/", url: url_SpannerProjectsInstancesDatabasesTestIamPermissions_580264,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580283 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580285(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":beginTransaction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580284(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the transaction runs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580286 = path.getOrDefault("session")
  valid_580286 = validateParameter(valid_580286, JString, required = true,
                                 default = nil)
  if valid_580286 != nil:
    section.add "session", valid_580286
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
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("prettyPrint")
  valid_580288 = validateParameter(valid_580288, JBool, required = false,
                                 default = newJBool(true))
  if valid_580288 != nil:
    section.add "prettyPrint", valid_580288
  var valid_580289 = query.getOrDefault("oauth_token")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "oauth_token", valid_580289
  var valid_580290 = query.getOrDefault("$.xgafv")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = newJString("1"))
  if valid_580290 != nil:
    section.add "$.xgafv", valid_580290
  var valid_580291 = query.getOrDefault("alt")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = newJString("json"))
  if valid_580291 != nil:
    section.add "alt", valid_580291
  var valid_580292 = query.getOrDefault("uploadType")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "uploadType", valid_580292
  var valid_580293 = query.getOrDefault("quotaUser")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "quotaUser", valid_580293
  var valid_580294 = query.getOrDefault("callback")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "callback", valid_580294
  var valid_580295 = query.getOrDefault("fields")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "fields", valid_580295
  var valid_580296 = query.getOrDefault("access_token")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "access_token", valid_580296
  var valid_580297 = query.getOrDefault("upload_protocol")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "upload_protocol", valid_580297
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

proc call*(call_580299: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ## 
  let valid = call_580299.validator(path, query, header, formData, body)
  let scheme = call_580299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580299.url(scheme.get, call_580299.host, call_580299.base,
                         call_580299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580299, url, valid)

proc call*(call_580300: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580283;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsBeginTransaction
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
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
  ##   session: string (required)
  ##          : Required. The session in which the transaction runs.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580301 = newJObject()
  var query_580302 = newJObject()
  var body_580303 = newJObject()
  add(query_580302, "key", newJString(key))
  add(query_580302, "prettyPrint", newJBool(prettyPrint))
  add(query_580302, "oauth_token", newJString(oauthToken))
  add(query_580302, "$.xgafv", newJString(Xgafv))
  add(query_580302, "alt", newJString(alt))
  add(query_580302, "uploadType", newJString(uploadType))
  add(query_580302, "quotaUser", newJString(quotaUser))
  add(path_580301, "session", newJString(session))
  if body != nil:
    body_580303 = body
  add(query_580302, "callback", newJString(callback))
  add(query_580302, "fields", newJString(fields))
  add(query_580302, "access_token", newJString(accessToken))
  add(query_580302, "upload_protocol", newJString(uploadProtocol))
  result = call_580300.call(path_580301, query_580302, nil, nil, body_580303)

var spannerProjectsInstancesDatabasesSessionsBeginTransaction* = Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580283(
    name: "spannerProjectsInstancesDatabasesSessionsBeginTransaction",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:beginTransaction", validator: validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580284,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580285,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCommit_580304 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsCommit_580306(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":commit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsCommit_580305(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Commits a transaction. The request includes the mutations to be
  ## applied to rows in the database.
  ## 
  ## `Commit` might return an `ABORTED` error. This can occur at any time;
  ## commonly, the cause is conflicts with concurrent
  ## transactions. However, it can also happen for a variety of other
  ## reasons. If `Commit` returns `ABORTED`, the caller should re-attempt
  ## the transaction from the beginning, re-using the same session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the transaction to be committed is running.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580307 = path.getOrDefault("session")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "session", valid_580307
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
  var valid_580308 = query.getOrDefault("key")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "key", valid_580308
  var valid_580309 = query.getOrDefault("prettyPrint")
  valid_580309 = validateParameter(valid_580309, JBool, required = false,
                                 default = newJBool(true))
  if valid_580309 != nil:
    section.add "prettyPrint", valid_580309
  var valid_580310 = query.getOrDefault("oauth_token")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "oauth_token", valid_580310
  var valid_580311 = query.getOrDefault("$.xgafv")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = newJString("1"))
  if valid_580311 != nil:
    section.add "$.xgafv", valid_580311
  var valid_580312 = query.getOrDefault("alt")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = newJString("json"))
  if valid_580312 != nil:
    section.add "alt", valid_580312
  var valid_580313 = query.getOrDefault("uploadType")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "uploadType", valid_580313
  var valid_580314 = query.getOrDefault("quotaUser")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "quotaUser", valid_580314
  var valid_580315 = query.getOrDefault("callback")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "callback", valid_580315
  var valid_580316 = query.getOrDefault("fields")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "fields", valid_580316
  var valid_580317 = query.getOrDefault("access_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "access_token", valid_580317
  var valid_580318 = query.getOrDefault("upload_protocol")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "upload_protocol", valid_580318
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

proc call*(call_580320: Call_SpannerProjectsInstancesDatabasesSessionsCommit_580304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Commits a transaction. The request includes the mutations to be
  ## applied to rows in the database.
  ## 
  ## `Commit` might return an `ABORTED` error. This can occur at any time;
  ## commonly, the cause is conflicts with concurrent
  ## transactions. However, it can also happen for a variety of other
  ## reasons. If `Commit` returns `ABORTED`, the caller should re-attempt
  ## the transaction from the beginning, re-using the same session.
  ## 
  let valid = call_580320.validator(path, query, header, formData, body)
  let scheme = call_580320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580320.url(scheme.get, call_580320.host, call_580320.base,
                         call_580320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580320, url, valid)

proc call*(call_580321: Call_SpannerProjectsInstancesDatabasesSessionsCommit_580304;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsCommit
  ## Commits a transaction. The request includes the mutations to be
  ## applied to rows in the database.
  ## 
  ## `Commit` might return an `ABORTED` error. This can occur at any time;
  ## commonly, the cause is conflicts with concurrent
  ## transactions. However, it can also happen for a variety of other
  ## reasons. If `Commit` returns `ABORTED`, the caller should re-attempt
  ## the transaction from the beginning, re-using the same session.
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
  ##   session: string (required)
  ##          : Required. The session in which the transaction to be committed is running.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580322 = newJObject()
  var query_580323 = newJObject()
  var body_580324 = newJObject()
  add(query_580323, "key", newJString(key))
  add(query_580323, "prettyPrint", newJBool(prettyPrint))
  add(query_580323, "oauth_token", newJString(oauthToken))
  add(query_580323, "$.xgafv", newJString(Xgafv))
  add(query_580323, "alt", newJString(alt))
  add(query_580323, "uploadType", newJString(uploadType))
  add(query_580323, "quotaUser", newJString(quotaUser))
  add(path_580322, "session", newJString(session))
  if body != nil:
    body_580324 = body
  add(query_580323, "callback", newJString(callback))
  add(query_580323, "fields", newJString(fields))
  add(query_580323, "access_token", newJString(accessToken))
  add(query_580323, "upload_protocol", newJString(uploadProtocol))
  result = call_580321.call(path_580322, query_580323, nil, nil, body_580324)

var spannerProjectsInstancesDatabasesSessionsCommit* = Call_SpannerProjectsInstancesDatabasesSessionsCommit_580304(
    name: "spannerProjectsInstancesDatabasesSessionsCommit",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:commit",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCommit_580305,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCommit_580306,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580325 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580327(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":executeBatchDml")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580326(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Executes a batch of SQL DML statements. This method allows many statements
  ## to be run with lower latency than submitting them sequentially with
  ## ExecuteSql.
  ## 
  ## Statements are executed in sequential order. A request can succeed even if
  ## a statement fails. The ExecuteBatchDmlResponse.status field in the
  ## response provides information about the statement that failed. Clients must
  ## inspect this field to determine whether an error occurred.
  ## 
  ## Execution stops after the first failed statement; the remaining statements
  ## are not executed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the DML statements should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580328 = path.getOrDefault("session")
  valid_580328 = validateParameter(valid_580328, JString, required = true,
                                 default = nil)
  if valid_580328 != nil:
    section.add "session", valid_580328
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
  var valid_580329 = query.getOrDefault("key")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "key", valid_580329
  var valid_580330 = query.getOrDefault("prettyPrint")
  valid_580330 = validateParameter(valid_580330, JBool, required = false,
                                 default = newJBool(true))
  if valid_580330 != nil:
    section.add "prettyPrint", valid_580330
  var valid_580331 = query.getOrDefault("oauth_token")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "oauth_token", valid_580331
  var valid_580332 = query.getOrDefault("$.xgafv")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = newJString("1"))
  if valid_580332 != nil:
    section.add "$.xgafv", valid_580332
  var valid_580333 = query.getOrDefault("alt")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = newJString("json"))
  if valid_580333 != nil:
    section.add "alt", valid_580333
  var valid_580334 = query.getOrDefault("uploadType")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "uploadType", valid_580334
  var valid_580335 = query.getOrDefault("quotaUser")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "quotaUser", valid_580335
  var valid_580336 = query.getOrDefault("callback")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "callback", valid_580336
  var valid_580337 = query.getOrDefault("fields")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "fields", valid_580337
  var valid_580338 = query.getOrDefault("access_token")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "access_token", valid_580338
  var valid_580339 = query.getOrDefault("upload_protocol")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "upload_protocol", valid_580339
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

proc call*(call_580341: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580325;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes a batch of SQL DML statements. This method allows many statements
  ## to be run with lower latency than submitting them sequentially with
  ## ExecuteSql.
  ## 
  ## Statements are executed in sequential order. A request can succeed even if
  ## a statement fails. The ExecuteBatchDmlResponse.status field in the
  ## response provides information about the statement that failed. Clients must
  ## inspect this field to determine whether an error occurred.
  ## 
  ## Execution stops after the first failed statement; the remaining statements
  ## are not executed.
  ## 
  let valid = call_580341.validator(path, query, header, formData, body)
  let scheme = call_580341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580341.url(scheme.get, call_580341.host, call_580341.base,
                         call_580341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580341, url, valid)

proc call*(call_580342: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580325;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsExecuteBatchDml
  ## Executes a batch of SQL DML statements. This method allows many statements
  ## to be run with lower latency than submitting them sequentially with
  ## ExecuteSql.
  ## 
  ## Statements are executed in sequential order. A request can succeed even if
  ## a statement fails. The ExecuteBatchDmlResponse.status field in the
  ## response provides information about the statement that failed. Clients must
  ## inspect this field to determine whether an error occurred.
  ## 
  ## Execution stops after the first failed statement; the remaining statements
  ## are not executed.
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
  ##   session: string (required)
  ##          : Required. The session in which the DML statements should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580343 = newJObject()
  var query_580344 = newJObject()
  var body_580345 = newJObject()
  add(query_580344, "key", newJString(key))
  add(query_580344, "prettyPrint", newJBool(prettyPrint))
  add(query_580344, "oauth_token", newJString(oauthToken))
  add(query_580344, "$.xgafv", newJString(Xgafv))
  add(query_580344, "alt", newJString(alt))
  add(query_580344, "uploadType", newJString(uploadType))
  add(query_580344, "quotaUser", newJString(quotaUser))
  add(path_580343, "session", newJString(session))
  if body != nil:
    body_580345 = body
  add(query_580344, "callback", newJString(callback))
  add(query_580344, "fields", newJString(fields))
  add(query_580344, "access_token", newJString(accessToken))
  add(query_580344, "upload_protocol", newJString(uploadProtocol))
  result = call_580342.call(path_580343, query_580344, nil, nil, body_580345)

var spannerProjectsInstancesDatabasesSessionsExecuteBatchDml* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580325(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteBatchDml",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeBatchDml", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580326,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580327,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580346 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580348(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":executeSql")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580347(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Executes an SQL statement, returning all results in a single reply. This
  ## method cannot be used to return a result set larger than 10 MiB;
  ## if the query yields more data than that, the query fails with
  ## a `FAILED_PRECONDITION` error.
  ## 
  ## Operations inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be fetched in streaming fashion by calling
  ## ExecuteStreamingSql instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the SQL query should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580349 = path.getOrDefault("session")
  valid_580349 = validateParameter(valid_580349, JString, required = true,
                                 default = nil)
  if valid_580349 != nil:
    section.add "session", valid_580349
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
  var valid_580350 = query.getOrDefault("key")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "key", valid_580350
  var valid_580351 = query.getOrDefault("prettyPrint")
  valid_580351 = validateParameter(valid_580351, JBool, required = false,
                                 default = newJBool(true))
  if valid_580351 != nil:
    section.add "prettyPrint", valid_580351
  var valid_580352 = query.getOrDefault("oauth_token")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "oauth_token", valid_580352
  var valid_580353 = query.getOrDefault("$.xgafv")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = newJString("1"))
  if valid_580353 != nil:
    section.add "$.xgafv", valid_580353
  var valid_580354 = query.getOrDefault("alt")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = newJString("json"))
  if valid_580354 != nil:
    section.add "alt", valid_580354
  var valid_580355 = query.getOrDefault("uploadType")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "uploadType", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  var valid_580357 = query.getOrDefault("callback")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "callback", valid_580357
  var valid_580358 = query.getOrDefault("fields")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "fields", valid_580358
  var valid_580359 = query.getOrDefault("access_token")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "access_token", valid_580359
  var valid_580360 = query.getOrDefault("upload_protocol")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "upload_protocol", valid_580360
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

proc call*(call_580362: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes an SQL statement, returning all results in a single reply. This
  ## method cannot be used to return a result set larger than 10 MiB;
  ## if the query yields more data than that, the query fails with
  ## a `FAILED_PRECONDITION` error.
  ## 
  ## Operations inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be fetched in streaming fashion by calling
  ## ExecuteStreamingSql instead.
  ## 
  let valid = call_580362.validator(path, query, header, formData, body)
  let scheme = call_580362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580362.url(scheme.get, call_580362.host, call_580362.base,
                         call_580362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580362, url, valid)

proc call*(call_580363: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580346;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsExecuteSql
  ## Executes an SQL statement, returning all results in a single reply. This
  ## method cannot be used to return a result set larger than 10 MiB;
  ## if the query yields more data than that, the query fails with
  ## a `FAILED_PRECONDITION` error.
  ## 
  ## Operations inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be fetched in streaming fashion by calling
  ## ExecuteStreamingSql instead.
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
  ##   session: string (required)
  ##          : Required. The session in which the SQL query should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580364 = newJObject()
  var query_580365 = newJObject()
  var body_580366 = newJObject()
  add(query_580365, "key", newJString(key))
  add(query_580365, "prettyPrint", newJBool(prettyPrint))
  add(query_580365, "oauth_token", newJString(oauthToken))
  add(query_580365, "$.xgafv", newJString(Xgafv))
  add(query_580365, "alt", newJString(alt))
  add(query_580365, "uploadType", newJString(uploadType))
  add(query_580365, "quotaUser", newJString(quotaUser))
  add(path_580364, "session", newJString(session))
  if body != nil:
    body_580366 = body
  add(query_580365, "callback", newJString(callback))
  add(query_580365, "fields", newJString(fields))
  add(query_580365, "access_token", newJString(accessToken))
  add(query_580365, "upload_protocol", newJString(uploadProtocol))
  result = call_580363.call(path_580364, query_580365, nil, nil, body_580366)

var spannerProjectsInstancesDatabasesSessionsExecuteSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580346(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeSql",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580347,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580348,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580367 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580369(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":executeStreamingSql")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580368(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the SQL query should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580370 = path.getOrDefault("session")
  valid_580370 = validateParameter(valid_580370, JString, required = true,
                                 default = nil)
  if valid_580370 != nil:
    section.add "session", valid_580370
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
  var valid_580371 = query.getOrDefault("key")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "key", valid_580371
  var valid_580372 = query.getOrDefault("prettyPrint")
  valid_580372 = validateParameter(valid_580372, JBool, required = false,
                                 default = newJBool(true))
  if valid_580372 != nil:
    section.add "prettyPrint", valid_580372
  var valid_580373 = query.getOrDefault("oauth_token")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "oauth_token", valid_580373
  var valid_580374 = query.getOrDefault("$.xgafv")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = newJString("1"))
  if valid_580374 != nil:
    section.add "$.xgafv", valid_580374
  var valid_580375 = query.getOrDefault("alt")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = newJString("json"))
  if valid_580375 != nil:
    section.add "alt", valid_580375
  var valid_580376 = query.getOrDefault("uploadType")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "uploadType", valid_580376
  var valid_580377 = query.getOrDefault("quotaUser")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "quotaUser", valid_580377
  var valid_580378 = query.getOrDefault("callback")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "callback", valid_580378
  var valid_580379 = query.getOrDefault("fields")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "fields", valid_580379
  var valid_580380 = query.getOrDefault("access_token")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "access_token", valid_580380
  var valid_580381 = query.getOrDefault("upload_protocol")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "upload_protocol", valid_580381
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

proc call*(call_580383: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ## 
  let valid = call_580383.validator(path, query, header, formData, body)
  let scheme = call_580383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580383.url(scheme.get, call_580383.host, call_580383.base,
                         call_580383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580383, url, valid)

proc call*(call_580384: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580367;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
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
  ##   session: string (required)
  ##          : Required. The session in which the SQL query should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580385 = newJObject()
  var query_580386 = newJObject()
  var body_580387 = newJObject()
  add(query_580386, "key", newJString(key))
  add(query_580386, "prettyPrint", newJBool(prettyPrint))
  add(query_580386, "oauth_token", newJString(oauthToken))
  add(query_580386, "$.xgafv", newJString(Xgafv))
  add(query_580386, "alt", newJString(alt))
  add(query_580386, "uploadType", newJString(uploadType))
  add(query_580386, "quotaUser", newJString(quotaUser))
  add(path_580385, "session", newJString(session))
  if body != nil:
    body_580387 = body
  add(query_580386, "callback", newJString(callback))
  add(query_580386, "fields", newJString(fields))
  add(query_580386, "access_token", newJString(accessToken))
  add(query_580386, "upload_protocol", newJString(uploadProtocol))
  result = call_580384.call(path_580385, query_580386, nil, nil, body_580387)

var spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580367(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeStreamingSql", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580368,
    base: "/",
    url: url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580369,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580388 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580390(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":partitionQuery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580389(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a set of partition tokens that can be used to execute a query
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by ExecuteStreamingSql to specify a subset
  ## of the query result to read.  The same session and read-only transaction
  ## must be used by the PartitionQueryRequest used to create the
  ## partition tokens and the ExecuteSqlRequests that use the partition tokens.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the query, and
  ## the whole operation must be restarted from the beginning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session used to create the partitions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580391 = path.getOrDefault("session")
  valid_580391 = validateParameter(valid_580391, JString, required = true,
                                 default = nil)
  if valid_580391 != nil:
    section.add "session", valid_580391
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
  var valid_580392 = query.getOrDefault("key")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "key", valid_580392
  var valid_580393 = query.getOrDefault("prettyPrint")
  valid_580393 = validateParameter(valid_580393, JBool, required = false,
                                 default = newJBool(true))
  if valid_580393 != nil:
    section.add "prettyPrint", valid_580393
  var valid_580394 = query.getOrDefault("oauth_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "oauth_token", valid_580394
  var valid_580395 = query.getOrDefault("$.xgafv")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = newJString("1"))
  if valid_580395 != nil:
    section.add "$.xgafv", valid_580395
  var valid_580396 = query.getOrDefault("alt")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = newJString("json"))
  if valid_580396 != nil:
    section.add "alt", valid_580396
  var valid_580397 = query.getOrDefault("uploadType")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "uploadType", valid_580397
  var valid_580398 = query.getOrDefault("quotaUser")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "quotaUser", valid_580398
  var valid_580399 = query.getOrDefault("callback")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "callback", valid_580399
  var valid_580400 = query.getOrDefault("fields")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "fields", valid_580400
  var valid_580401 = query.getOrDefault("access_token")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "access_token", valid_580401
  var valid_580402 = query.getOrDefault("upload_protocol")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "upload_protocol", valid_580402
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

proc call*(call_580404: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a set of partition tokens that can be used to execute a query
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by ExecuteStreamingSql to specify a subset
  ## of the query result to read.  The same session and read-only transaction
  ## must be used by the PartitionQueryRequest used to create the
  ## partition tokens and the ExecuteSqlRequests that use the partition tokens.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the query, and
  ## the whole operation must be restarted from the beginning.
  ## 
  let valid = call_580404.validator(path, query, header, formData, body)
  let scheme = call_580404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580404.url(scheme.get, call_580404.host, call_580404.base,
                         call_580404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580404, url, valid)

proc call*(call_580405: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580388;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsPartitionQuery
  ## Creates a set of partition tokens that can be used to execute a query
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by ExecuteStreamingSql to specify a subset
  ## of the query result to read.  The same session and read-only transaction
  ## must be used by the PartitionQueryRequest used to create the
  ## partition tokens and the ExecuteSqlRequests that use the partition tokens.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the query, and
  ## the whole operation must be restarted from the beginning.
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
  ##   session: string (required)
  ##          : Required. The session used to create the partitions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580406 = newJObject()
  var query_580407 = newJObject()
  var body_580408 = newJObject()
  add(query_580407, "key", newJString(key))
  add(query_580407, "prettyPrint", newJBool(prettyPrint))
  add(query_580407, "oauth_token", newJString(oauthToken))
  add(query_580407, "$.xgafv", newJString(Xgafv))
  add(query_580407, "alt", newJString(alt))
  add(query_580407, "uploadType", newJString(uploadType))
  add(query_580407, "quotaUser", newJString(quotaUser))
  add(path_580406, "session", newJString(session))
  if body != nil:
    body_580408 = body
  add(query_580407, "callback", newJString(callback))
  add(query_580407, "fields", newJString(fields))
  add(query_580407, "access_token", newJString(accessToken))
  add(query_580407, "upload_protocol", newJString(uploadProtocol))
  result = call_580405.call(path_580406, query_580407, nil, nil, body_580408)

var spannerProjectsInstancesDatabasesSessionsPartitionQuery* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580388(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionQuery",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionQuery", validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580389,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580390,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580409 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580411(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":partitionRead")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580410(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a set of partition tokens that can be used to execute a read
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by StreamingRead to specify a subset of the read
  ## result to read.  The same session and read-only transaction must be used by
  ## the PartitionReadRequest used to create the partition tokens and the
  ## ReadRequests that use the partition tokens.  There are no ordering
  ## guarantees on rows returned among the returned partition tokens, or even
  ## within each individual StreamingRead call issued with a partition_token.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the read, and
  ## the whole operation must be restarted from the beginning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session used to create the partitions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580412 = path.getOrDefault("session")
  valid_580412 = validateParameter(valid_580412, JString, required = true,
                                 default = nil)
  if valid_580412 != nil:
    section.add "session", valid_580412
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
  var valid_580413 = query.getOrDefault("key")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "key", valid_580413
  var valid_580414 = query.getOrDefault("prettyPrint")
  valid_580414 = validateParameter(valid_580414, JBool, required = false,
                                 default = newJBool(true))
  if valid_580414 != nil:
    section.add "prettyPrint", valid_580414
  var valid_580415 = query.getOrDefault("oauth_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "oauth_token", valid_580415
  var valid_580416 = query.getOrDefault("$.xgafv")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = newJString("1"))
  if valid_580416 != nil:
    section.add "$.xgafv", valid_580416
  var valid_580417 = query.getOrDefault("alt")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = newJString("json"))
  if valid_580417 != nil:
    section.add "alt", valid_580417
  var valid_580418 = query.getOrDefault("uploadType")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "uploadType", valid_580418
  var valid_580419 = query.getOrDefault("quotaUser")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "quotaUser", valid_580419
  var valid_580420 = query.getOrDefault("callback")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "callback", valid_580420
  var valid_580421 = query.getOrDefault("fields")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "fields", valid_580421
  var valid_580422 = query.getOrDefault("access_token")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "access_token", valid_580422
  var valid_580423 = query.getOrDefault("upload_protocol")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "upload_protocol", valid_580423
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

proc call*(call_580425: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580409;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a set of partition tokens that can be used to execute a read
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by StreamingRead to specify a subset of the read
  ## result to read.  The same session and read-only transaction must be used by
  ## the PartitionReadRequest used to create the partition tokens and the
  ## ReadRequests that use the partition tokens.  There are no ordering
  ## guarantees on rows returned among the returned partition tokens, or even
  ## within each individual StreamingRead call issued with a partition_token.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the read, and
  ## the whole operation must be restarted from the beginning.
  ## 
  let valid = call_580425.validator(path, query, header, formData, body)
  let scheme = call_580425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580425.url(scheme.get, call_580425.host, call_580425.base,
                         call_580425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580425, url, valid)

proc call*(call_580426: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580409;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsPartitionRead
  ## Creates a set of partition tokens that can be used to execute a read
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by StreamingRead to specify a subset of the read
  ## result to read.  The same session and read-only transaction must be used by
  ## the PartitionReadRequest used to create the partition tokens and the
  ## ReadRequests that use the partition tokens.  There are no ordering
  ## guarantees on rows returned among the returned partition tokens, or even
  ## within each individual StreamingRead call issued with a partition_token.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the read, and
  ## the whole operation must be restarted from the beginning.
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
  ##   session: string (required)
  ##          : Required. The session used to create the partitions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580427 = newJObject()
  var query_580428 = newJObject()
  var body_580429 = newJObject()
  add(query_580428, "key", newJString(key))
  add(query_580428, "prettyPrint", newJBool(prettyPrint))
  add(query_580428, "oauth_token", newJString(oauthToken))
  add(query_580428, "$.xgafv", newJString(Xgafv))
  add(query_580428, "alt", newJString(alt))
  add(query_580428, "uploadType", newJString(uploadType))
  add(query_580428, "quotaUser", newJString(quotaUser))
  add(path_580427, "session", newJString(session))
  if body != nil:
    body_580429 = body
  add(query_580428, "callback", newJString(callback))
  add(query_580428, "fields", newJString(fields))
  add(query_580428, "access_token", newJString(accessToken))
  add(query_580428, "upload_protocol", newJString(uploadProtocol))
  result = call_580426.call(path_580427, query_580428, nil, nil, body_580429)

var spannerProjectsInstancesDatabasesSessionsPartitionRead* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580409(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580410,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580411,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRead_580430 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsRead_580432(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":read")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsRead_580431(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Reads rows from the database using key lookups and scans, as a
  ## simple key/value style alternative to
  ## ExecuteSql.  This method cannot be used to
  ## return a result set larger than 10 MiB; if the read matches more
  ## data than that, the read fails with a `FAILED_PRECONDITION`
  ## error.
  ## 
  ## Reads inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be yielded in streaming fashion by calling
  ## StreamingRead instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the read should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580433 = path.getOrDefault("session")
  valid_580433 = validateParameter(valid_580433, JString, required = true,
                                 default = nil)
  if valid_580433 != nil:
    section.add "session", valid_580433
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
  var valid_580434 = query.getOrDefault("key")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "key", valid_580434
  var valid_580435 = query.getOrDefault("prettyPrint")
  valid_580435 = validateParameter(valid_580435, JBool, required = false,
                                 default = newJBool(true))
  if valid_580435 != nil:
    section.add "prettyPrint", valid_580435
  var valid_580436 = query.getOrDefault("oauth_token")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "oauth_token", valid_580436
  var valid_580437 = query.getOrDefault("$.xgafv")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = newJString("1"))
  if valid_580437 != nil:
    section.add "$.xgafv", valid_580437
  var valid_580438 = query.getOrDefault("alt")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = newJString("json"))
  if valid_580438 != nil:
    section.add "alt", valid_580438
  var valid_580439 = query.getOrDefault("uploadType")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "uploadType", valid_580439
  var valid_580440 = query.getOrDefault("quotaUser")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "quotaUser", valid_580440
  var valid_580441 = query.getOrDefault("callback")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "callback", valid_580441
  var valid_580442 = query.getOrDefault("fields")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "fields", valid_580442
  var valid_580443 = query.getOrDefault("access_token")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "access_token", valid_580443
  var valid_580444 = query.getOrDefault("upload_protocol")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "upload_protocol", valid_580444
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

proc call*(call_580446: Call_SpannerProjectsInstancesDatabasesSessionsRead_580430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reads rows from the database using key lookups and scans, as a
  ## simple key/value style alternative to
  ## ExecuteSql.  This method cannot be used to
  ## return a result set larger than 10 MiB; if the read matches more
  ## data than that, the read fails with a `FAILED_PRECONDITION`
  ## error.
  ## 
  ## Reads inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be yielded in streaming fashion by calling
  ## StreamingRead instead.
  ## 
  let valid = call_580446.validator(path, query, header, formData, body)
  let scheme = call_580446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580446.url(scheme.get, call_580446.host, call_580446.base,
                         call_580446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580446, url, valid)

proc call*(call_580447: Call_SpannerProjectsInstancesDatabasesSessionsRead_580430;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsRead
  ## Reads rows from the database using key lookups and scans, as a
  ## simple key/value style alternative to
  ## ExecuteSql.  This method cannot be used to
  ## return a result set larger than 10 MiB; if the read matches more
  ## data than that, the read fails with a `FAILED_PRECONDITION`
  ## error.
  ## 
  ## Reads inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be yielded in streaming fashion by calling
  ## StreamingRead instead.
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
  ##   session: string (required)
  ##          : Required. The session in which the read should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580448 = newJObject()
  var query_580449 = newJObject()
  var body_580450 = newJObject()
  add(query_580449, "key", newJString(key))
  add(query_580449, "prettyPrint", newJBool(prettyPrint))
  add(query_580449, "oauth_token", newJString(oauthToken))
  add(query_580449, "$.xgafv", newJString(Xgafv))
  add(query_580449, "alt", newJString(alt))
  add(query_580449, "uploadType", newJString(uploadType))
  add(query_580449, "quotaUser", newJString(quotaUser))
  add(path_580448, "session", newJString(session))
  if body != nil:
    body_580450 = body
  add(query_580449, "callback", newJString(callback))
  add(query_580449, "fields", newJString(fields))
  add(query_580449, "access_token", newJString(accessToken))
  add(query_580449, "upload_protocol", newJString(uploadProtocol))
  result = call_580447.call(path_580448, query_580449, nil, nil, body_580450)

var spannerProjectsInstancesDatabasesSessionsRead* = Call_SpannerProjectsInstancesDatabasesSessionsRead_580430(
    name: "spannerProjectsInstancesDatabasesSessionsRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:read",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRead_580431,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRead_580432,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRollback_580451 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsRollback_580453(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsRollback_580452(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Rolls back a transaction, releasing any locks it holds. It is a good
  ## idea to call this for any transaction that includes one or more
  ## Read or ExecuteSql requests and
  ## ultimately decides not to commit.
  ## 
  ## `Rollback` returns `OK` if it successfully aborts the transaction, the
  ## transaction was already aborted, or the transaction is not
  ## found. `Rollback` never returns `ABORTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the transaction to roll back is running.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580454 = path.getOrDefault("session")
  valid_580454 = validateParameter(valid_580454, JString, required = true,
                                 default = nil)
  if valid_580454 != nil:
    section.add "session", valid_580454
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
  var valid_580455 = query.getOrDefault("key")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "key", valid_580455
  var valid_580456 = query.getOrDefault("prettyPrint")
  valid_580456 = validateParameter(valid_580456, JBool, required = false,
                                 default = newJBool(true))
  if valid_580456 != nil:
    section.add "prettyPrint", valid_580456
  var valid_580457 = query.getOrDefault("oauth_token")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "oauth_token", valid_580457
  var valid_580458 = query.getOrDefault("$.xgafv")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = newJString("1"))
  if valid_580458 != nil:
    section.add "$.xgafv", valid_580458
  var valid_580459 = query.getOrDefault("alt")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = newJString("json"))
  if valid_580459 != nil:
    section.add "alt", valid_580459
  var valid_580460 = query.getOrDefault("uploadType")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "uploadType", valid_580460
  var valid_580461 = query.getOrDefault("quotaUser")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "quotaUser", valid_580461
  var valid_580462 = query.getOrDefault("callback")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "callback", valid_580462
  var valid_580463 = query.getOrDefault("fields")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "fields", valid_580463
  var valid_580464 = query.getOrDefault("access_token")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "access_token", valid_580464
  var valid_580465 = query.getOrDefault("upload_protocol")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "upload_protocol", valid_580465
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

proc call*(call_580467: Call_SpannerProjectsInstancesDatabasesSessionsRollback_580451;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a transaction, releasing any locks it holds. It is a good
  ## idea to call this for any transaction that includes one or more
  ## Read or ExecuteSql requests and
  ## ultimately decides not to commit.
  ## 
  ## `Rollback` returns `OK` if it successfully aborts the transaction, the
  ## transaction was already aborted, or the transaction is not
  ## found. `Rollback` never returns `ABORTED`.
  ## 
  let valid = call_580467.validator(path, query, header, formData, body)
  let scheme = call_580467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580467.url(scheme.get, call_580467.host, call_580467.base,
                         call_580467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580467, url, valid)

proc call*(call_580468: Call_SpannerProjectsInstancesDatabasesSessionsRollback_580451;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsRollback
  ## Rolls back a transaction, releasing any locks it holds. It is a good
  ## idea to call this for any transaction that includes one or more
  ## Read or ExecuteSql requests and
  ## ultimately decides not to commit.
  ## 
  ## `Rollback` returns `OK` if it successfully aborts the transaction, the
  ## transaction was already aborted, or the transaction is not
  ## found. `Rollback` never returns `ABORTED`.
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
  ##   session: string (required)
  ##          : Required. The session in which the transaction to roll back is running.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580469 = newJObject()
  var query_580470 = newJObject()
  var body_580471 = newJObject()
  add(query_580470, "key", newJString(key))
  add(query_580470, "prettyPrint", newJBool(prettyPrint))
  add(query_580470, "oauth_token", newJString(oauthToken))
  add(query_580470, "$.xgafv", newJString(Xgafv))
  add(query_580470, "alt", newJString(alt))
  add(query_580470, "uploadType", newJString(uploadType))
  add(query_580470, "quotaUser", newJString(quotaUser))
  add(path_580469, "session", newJString(session))
  if body != nil:
    body_580471 = body
  add(query_580470, "callback", newJString(callback))
  add(query_580470, "fields", newJString(fields))
  add(query_580470, "access_token", newJString(accessToken))
  add(query_580470, "upload_protocol", newJString(uploadProtocol))
  result = call_580468.call(path_580469, query_580470, nil, nil, body_580471)

var spannerProjectsInstancesDatabasesSessionsRollback* = Call_SpannerProjectsInstancesDatabasesSessionsRollback_580451(
    name: "spannerProjectsInstancesDatabasesSessionsRollback",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:rollback",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRollback_580452,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRollback_580453,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580472 = ref object of OpenApiRestCall_579373
proc url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580474(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":streamingRead")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580473(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the read should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_580475 = path.getOrDefault("session")
  valid_580475 = validateParameter(valid_580475, JString, required = true,
                                 default = nil)
  if valid_580475 != nil:
    section.add "session", valid_580475
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
  var valid_580476 = query.getOrDefault("key")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "key", valid_580476
  var valid_580477 = query.getOrDefault("prettyPrint")
  valid_580477 = validateParameter(valid_580477, JBool, required = false,
                                 default = newJBool(true))
  if valid_580477 != nil:
    section.add "prettyPrint", valid_580477
  var valid_580478 = query.getOrDefault("oauth_token")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "oauth_token", valid_580478
  var valid_580479 = query.getOrDefault("$.xgafv")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = newJString("1"))
  if valid_580479 != nil:
    section.add "$.xgafv", valid_580479
  var valid_580480 = query.getOrDefault("alt")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = newJString("json"))
  if valid_580480 != nil:
    section.add "alt", valid_580480
  var valid_580481 = query.getOrDefault("uploadType")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "uploadType", valid_580481
  var valid_580482 = query.getOrDefault("quotaUser")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "quotaUser", valid_580482
  var valid_580483 = query.getOrDefault("callback")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "callback", valid_580483
  var valid_580484 = query.getOrDefault("fields")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "fields", valid_580484
  var valid_580485 = query.getOrDefault("access_token")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "access_token", valid_580485
  var valid_580486 = query.getOrDefault("upload_protocol")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "upload_protocol", valid_580486
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

proc call*(call_580488: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580472;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ## 
  let valid = call_580488.validator(path, query, header, formData, body)
  let scheme = call_580488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580488.url(scheme.get, call_580488.host, call_580488.base,
                         call_580488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580488, url, valid)

proc call*(call_580489: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580472;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsStreamingRead
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
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
  ##   session: string (required)
  ##          : Required. The session in which the read should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580490 = newJObject()
  var query_580491 = newJObject()
  var body_580492 = newJObject()
  add(query_580491, "key", newJString(key))
  add(query_580491, "prettyPrint", newJBool(prettyPrint))
  add(query_580491, "oauth_token", newJString(oauthToken))
  add(query_580491, "$.xgafv", newJString(Xgafv))
  add(query_580491, "alt", newJString(alt))
  add(query_580491, "uploadType", newJString(uploadType))
  add(query_580491, "quotaUser", newJString(quotaUser))
  add(path_580490, "session", newJString(session))
  if body != nil:
    body_580492 = body
  add(query_580491, "callback", newJString(callback))
  add(query_580491, "fields", newJString(fields))
  add(query_580491, "access_token", newJString(accessToken))
  add(query_580491, "upload_protocol", newJString(uploadProtocol))
  result = call_580489.call(path_580490, query_580491, nil, nil, body_580492)

var spannerProjectsInstancesDatabasesSessionsStreamingRead* = Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580472(
    name: "spannerProjectsInstancesDatabasesSessionsStreamingRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:streamingRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580473,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580474,
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
