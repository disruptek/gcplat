
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "spanner"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpannerProjectsInstancesDatabasesDropDatabase_579690 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesDropDatabase_579692(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesDropDatabase_579691(
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
  var valid_579818 = path.getOrDefault("database")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "database", valid_579818
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579819 = query.getOrDefault("upload_protocol")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "upload_protocol", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("callback")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "callback", valid_579837
  var valid_579838 = query.getOrDefault("access_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "access_token", valid_579838
  var valid_579839 = query.getOrDefault("uploadType")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "uploadType", valid_579839
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("$.xgafv")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = newJString("1"))
  if valid_579841 != nil:
    section.add "$.xgafv", valid_579841
  var valid_579842 = query.getOrDefault("prettyPrint")
  valid_579842 = validateParameter(valid_579842, JBool, required = false,
                                 default = newJBool(true))
  if valid_579842 != nil:
    section.add "prettyPrint", valid_579842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579865: Call_SpannerProjectsInstancesDatabasesDropDatabase_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Drops (aka deletes) a Cloud Spanner database.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579936: Call_SpannerProjectsInstancesDatabasesDropDatabase_579690;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesDropDatabase
  ## Drops (aka deletes) a Cloud Spanner database.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database to be dropped.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579937 = newJObject()
  var query_579939 = newJObject()
  add(query_579939, "upload_protocol", newJString(uploadProtocol))
  add(query_579939, "fields", newJString(fields))
  add(query_579939, "quotaUser", newJString(quotaUser))
  add(query_579939, "alt", newJString(alt))
  add(query_579939, "oauth_token", newJString(oauthToken))
  add(query_579939, "callback", newJString(callback))
  add(query_579939, "access_token", newJString(accessToken))
  add(query_579939, "uploadType", newJString(uploadType))
  add(query_579939, "key", newJString(key))
  add(path_579937, "database", newJString(database))
  add(query_579939, "$.xgafv", newJString(Xgafv))
  add(query_579939, "prettyPrint", newJBool(prettyPrint))
  result = call_579936.call(path_579937, query_579939, nil, nil, nil)

var spannerProjectsInstancesDatabasesDropDatabase* = Call_SpannerProjectsInstancesDatabasesDropDatabase_579690(
    name: "spannerProjectsInstancesDatabasesDropDatabase",
    meth: HttpMethod.HttpDelete, host: "spanner.googleapis.com",
    route: "/v1/{database}",
    validator: validate_SpannerProjectsInstancesDatabasesDropDatabase_579691,
    base: "/", url: url_SpannerProjectsInstancesDatabasesDropDatabase_579692,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetDdl_579978 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesGetDdl_579980(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesGetDdl_579979(path: JsonNode;
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
  var valid_579981 = path.getOrDefault("database")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "database", valid_579981
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579982 = query.getOrDefault("upload_protocol")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "upload_protocol", valid_579982
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579993: Call_SpannerProjectsInstancesDatabasesGetDdl_579978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_SpannerProjectsInstancesDatabasesGetDdl_579978;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesGetDdl
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database whose schema we wish to get.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  add(query_579996, "upload_protocol", newJString(uploadProtocol))
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "callback", newJString(callback))
  add(query_579996, "access_token", newJString(accessToken))
  add(query_579996, "uploadType", newJString(uploadType))
  add(query_579996, "key", newJString(key))
  add(path_579995, "database", newJString(database))
  add(query_579996, "$.xgafv", newJString(Xgafv))
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, nil)

var spannerProjectsInstancesDatabasesGetDdl* = Call_SpannerProjectsInstancesDatabasesGetDdl_579978(
    name: "spannerProjectsInstancesDatabasesGetDdl", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesGetDdl_579979, base: "/",
    url: url_SpannerProjectsInstancesDatabasesGetDdl_579980,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesUpdateDdl_579997 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesUpdateDdl_579999(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesUpdateDdl_579998(path: JsonNode;
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
  var valid_580000 = path.getOrDefault("database")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "database", valid_580000
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("callback")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "callback", valid_580006
  var valid_580007 = query.getOrDefault("access_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "access_token", valid_580007
  var valid_580008 = query.getOrDefault("uploadType")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "uploadType", valid_580008
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("$.xgafv")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("1"))
  if valid_580010 != nil:
    section.add "$.xgafv", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
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

proc call*(call_580013: Call_SpannerProjectsInstancesDatabasesUpdateDdl_579997;
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
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_SpannerProjectsInstancesDatabasesUpdateDdl_579997;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesUpdateDdl
  ## Updates the schema of a Cloud Spanner database by
  ## creating/altering/dropping tables, columns, indexes, etc. The returned
  ## long-running operation will have a name of
  ## the format `<database_name>/operations/<operation_id>` and can be used to
  ## track execution of the schema change(s). The
  ## metadata field type is
  ## UpdateDatabaseDdlMetadata.  The operation has no response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database to update.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  var body_580017 = newJObject()
  add(query_580016, "upload_protocol", newJString(uploadProtocol))
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "callback", newJString(callback))
  add(query_580016, "access_token", newJString(accessToken))
  add(query_580016, "uploadType", newJString(uploadType))
  add(query_580016, "key", newJString(key))
  add(path_580015, "database", newJString(database))
  add(query_580016, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580017 = body
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  result = call_580014.call(path_580015, query_580016, nil, nil, body_580017)

var spannerProjectsInstancesDatabasesUpdateDdl* = Call_SpannerProjectsInstancesDatabasesUpdateDdl_579997(
    name: "spannerProjectsInstancesDatabasesUpdateDdl",
    meth: HttpMethod.HttpPatch, host: "spanner.googleapis.com",
    route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesUpdateDdl_579998,
    base: "/", url: url_SpannerProjectsInstancesDatabasesUpdateDdl_579999,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCreate_580040 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsCreate_580042(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsCreate_580041(
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
  var valid_580043 = path.getOrDefault("database")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "database", valid_580043
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580044 = query.getOrDefault("upload_protocol")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "upload_protocol", valid_580044
  var valid_580045 = query.getOrDefault("fields")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "fields", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("callback")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "callback", valid_580049
  var valid_580050 = query.getOrDefault("access_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "access_token", valid_580050
  var valid_580051 = query.getOrDefault("uploadType")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "uploadType", valid_580051
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("$.xgafv")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("1"))
  if valid_580053 != nil:
    section.add "$.xgafv", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
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

proc call*(call_580056: Call_SpannerProjectsInstancesDatabasesSessionsCreate_580040;
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
  let valid = call_580056.validator(path, query, header, formData, body)
  let scheme = call_580056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580056.url(scheme.get, call_580056.host, call_580056.base,
                         call_580056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580056, url, valid)

proc call*(call_580057: Call_SpannerProjectsInstancesDatabasesSessionsCreate_580040;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database in which the new session is created.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580058 = newJObject()
  var query_580059 = newJObject()
  var body_580060 = newJObject()
  add(query_580059, "upload_protocol", newJString(uploadProtocol))
  add(query_580059, "fields", newJString(fields))
  add(query_580059, "quotaUser", newJString(quotaUser))
  add(query_580059, "alt", newJString(alt))
  add(query_580059, "oauth_token", newJString(oauthToken))
  add(query_580059, "callback", newJString(callback))
  add(query_580059, "access_token", newJString(accessToken))
  add(query_580059, "uploadType", newJString(uploadType))
  add(query_580059, "key", newJString(key))
  add(path_580058, "database", newJString(database))
  add(query_580059, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580060 = body
  add(query_580059, "prettyPrint", newJBool(prettyPrint))
  result = call_580057.call(path_580058, query_580059, nil, nil, body_580060)

var spannerProjectsInstancesDatabasesSessionsCreate* = Call_SpannerProjectsInstancesDatabasesSessionsCreate_580040(
    name: "spannerProjectsInstancesDatabasesSessionsCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCreate_580041,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCreate_580042,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsList_580018 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsList_580020(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsList_580019(
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
  var valid_580021 = path.getOrDefault("database")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "database", valid_580021
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a previous
  ## ListSessionsResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of sessions to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_580022 = query.getOrDefault("upload_protocol")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "upload_protocol", valid_580022
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  var valid_580024 = query.getOrDefault("pageToken")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "pageToken", valid_580024
  var valid_580025 = query.getOrDefault("quotaUser")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "quotaUser", valid_580025
  var valid_580026 = query.getOrDefault("alt")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = newJString("json"))
  if valid_580026 != nil:
    section.add "alt", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  var valid_580028 = query.getOrDefault("callback")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "callback", valid_580028
  var valid_580029 = query.getOrDefault("access_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "access_token", valid_580029
  var valid_580030 = query.getOrDefault("uploadType")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "uploadType", valid_580030
  var valid_580031 = query.getOrDefault("key")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "key", valid_580031
  var valid_580032 = query.getOrDefault("$.xgafv")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("1"))
  if valid_580032 != nil:
    section.add "$.xgafv", valid_580032
  var valid_580033 = query.getOrDefault("pageSize")
  valid_580033 = validateParameter(valid_580033, JInt, required = false, default = nil)
  if valid_580033 != nil:
    section.add "pageSize", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  var valid_580035 = query.getOrDefault("filter")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "filter", valid_580035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580036: Call_SpannerProjectsInstancesDatabasesSessionsList_580018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sessions in a given database.
  ## 
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_SpannerProjectsInstancesDatabasesSessionsList_580018;
          database: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsList
  ## Lists all sessions in a given database.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a previous
  ## ListSessionsResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database in which to list sessions.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of sessions to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  add(query_580039, "upload_protocol", newJString(uploadProtocol))
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "pageToken", newJString(pageToken))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "callback", newJString(callback))
  add(query_580039, "access_token", newJString(accessToken))
  add(query_580039, "uploadType", newJString(uploadType))
  add(query_580039, "key", newJString(key))
  add(path_580038, "database", newJString(database))
  add(query_580039, "$.xgafv", newJString(Xgafv))
  add(query_580039, "pageSize", newJInt(pageSize))
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  add(query_580039, "filter", newJString(filter))
  result = call_580037.call(path_580038, query_580039, nil, nil, nil)

var spannerProjectsInstancesDatabasesSessionsList* = Call_SpannerProjectsInstancesDatabasesSessionsList_580018(
    name: "spannerProjectsInstancesDatabasesSessionsList",
    meth: HttpMethod.HttpGet, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsList_580019,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsList_580020,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580061 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580063(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580062(
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
  var valid_580064 = path.getOrDefault("database")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "database", valid_580064
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580065 = query.getOrDefault("upload_protocol")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "upload_protocol", valid_580065
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("quotaUser")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "quotaUser", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("callback")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "callback", valid_580070
  var valid_580071 = query.getOrDefault("access_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "access_token", valid_580071
  var valid_580072 = query.getOrDefault("uploadType")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "uploadType", valid_580072
  var valid_580073 = query.getOrDefault("key")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "key", valid_580073
  var valid_580074 = query.getOrDefault("$.xgafv")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("1"))
  if valid_580074 != nil:
    section.add "$.xgafv", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
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

proc call*(call_580077: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ## 
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580061;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsBatchCreate
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database in which the new sessions are created.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580079 = newJObject()
  var query_580080 = newJObject()
  var body_580081 = newJObject()
  add(query_580080, "upload_protocol", newJString(uploadProtocol))
  add(query_580080, "fields", newJString(fields))
  add(query_580080, "quotaUser", newJString(quotaUser))
  add(query_580080, "alt", newJString(alt))
  add(query_580080, "oauth_token", newJString(oauthToken))
  add(query_580080, "callback", newJString(callback))
  add(query_580080, "access_token", newJString(accessToken))
  add(query_580080, "uploadType", newJString(uploadType))
  add(query_580080, "key", newJString(key))
  add(path_580079, "database", newJString(database))
  add(query_580080, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580081 = body
  add(query_580080, "prettyPrint", newJBool(prettyPrint))
  result = call_580078.call(path_580079, query_580080, nil, nil, body_580081)

var spannerProjectsInstancesDatabasesSessionsBatchCreate* = Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580061(
    name: "spannerProjectsInstancesDatabasesSessionsBatchCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions:batchCreate",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580062,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_580063,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstanceConfigsGet_580082 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstanceConfigsGet_580084(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstanceConfigsGet_580083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a particular instance configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the requested instance configuration. Values are of
  ## the form `projects/<project>/instanceConfigs/<config>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580085 = path.getOrDefault("name")
  valid_580085 = validateParameter(valid_580085, JString, required = true,
                                 default = nil)
  if valid_580085 != nil:
    section.add "name", valid_580085
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580086 = query.getOrDefault("upload_protocol")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "upload_protocol", valid_580086
  var valid_580087 = query.getOrDefault("fields")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "fields", valid_580087
  var valid_580088 = query.getOrDefault("quotaUser")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "quotaUser", valid_580088
  var valid_580089 = query.getOrDefault("alt")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = newJString("json"))
  if valid_580089 != nil:
    section.add "alt", valid_580089
  var valid_580090 = query.getOrDefault("oauth_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "oauth_token", valid_580090
  var valid_580091 = query.getOrDefault("callback")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "callback", valid_580091
  var valid_580092 = query.getOrDefault("access_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "access_token", valid_580092
  var valid_580093 = query.getOrDefault("uploadType")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "uploadType", valid_580093
  var valid_580094 = query.getOrDefault("key")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "key", valid_580094
  var valid_580095 = query.getOrDefault("$.xgafv")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("1"))
  if valid_580095 != nil:
    section.add "$.xgafv", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580097: Call_SpannerProjectsInstanceConfigsGet_580082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a particular instance configuration.
  ## 
  let valid = call_580097.validator(path, query, header, formData, body)
  let scheme = call_580097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580097.url(scheme.get, call_580097.host, call_580097.base,
                         call_580097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580097, url, valid)

proc call*(call_580098: Call_SpannerProjectsInstanceConfigsGet_580082;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstanceConfigsGet
  ## Gets information about a particular instance configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the requested instance configuration. Values are of
  ## the form `projects/<project>/instanceConfigs/<config>`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580099 = newJObject()
  var query_580100 = newJObject()
  add(query_580100, "upload_protocol", newJString(uploadProtocol))
  add(query_580100, "fields", newJString(fields))
  add(query_580100, "quotaUser", newJString(quotaUser))
  add(path_580099, "name", newJString(name))
  add(query_580100, "alt", newJString(alt))
  add(query_580100, "oauth_token", newJString(oauthToken))
  add(query_580100, "callback", newJString(callback))
  add(query_580100, "access_token", newJString(accessToken))
  add(query_580100, "uploadType", newJString(uploadType))
  add(query_580100, "key", newJString(key))
  add(query_580100, "$.xgafv", newJString(Xgafv))
  add(query_580100, "prettyPrint", newJBool(prettyPrint))
  result = call_580098.call(path_580099, query_580100, nil, nil, nil)

var spannerProjectsInstanceConfigsGet* = Call_SpannerProjectsInstanceConfigsGet_580082(
    name: "spannerProjectsInstanceConfigsGet", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstanceConfigsGet_580083, base: "/",
    url: url_SpannerProjectsInstanceConfigsGet_580084, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesPatch_580120 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesPatch_580122(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesPatch_580121(path: JsonNode; query: JsonNode;
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
  var valid_580123 = path.getOrDefault("name")
  valid_580123 = validateParameter(valid_580123, JString, required = true,
                                 default = nil)
  if valid_580123 != nil:
    section.add "name", valid_580123
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580124 = query.getOrDefault("upload_protocol")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "upload_protocol", valid_580124
  var valid_580125 = query.getOrDefault("fields")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "fields", valid_580125
  var valid_580126 = query.getOrDefault("quotaUser")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "quotaUser", valid_580126
  var valid_580127 = query.getOrDefault("alt")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("json"))
  if valid_580127 != nil:
    section.add "alt", valid_580127
  var valid_580128 = query.getOrDefault("oauth_token")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "oauth_token", valid_580128
  var valid_580129 = query.getOrDefault("callback")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "callback", valid_580129
  var valid_580130 = query.getOrDefault("access_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "access_token", valid_580130
  var valid_580131 = query.getOrDefault("uploadType")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "uploadType", valid_580131
  var valid_580132 = query.getOrDefault("key")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "key", valid_580132
  var valid_580133 = query.getOrDefault("$.xgafv")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("1"))
  if valid_580133 != nil:
    section.add "$.xgafv", valid_580133
  var valid_580134 = query.getOrDefault("prettyPrint")
  valid_580134 = validateParameter(valid_580134, JBool, required = false,
                                 default = newJBool(true))
  if valid_580134 != nil:
    section.add "prettyPrint", valid_580134
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

proc call*(call_580136: Call_SpannerProjectsInstancesPatch_580120; path: JsonNode;
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
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_SpannerProjectsInstancesPatch_580120; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. A unique identifier for the instance, which cannot be changed
  ## after the instance is created. Values are of the form
  ## `projects/<project>/instances/a-z*[a-z0-9]`. The final
  ## segment of the name must be between 2 and 64 characters in length.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  var body_580140 = newJObject()
  add(query_580139, "upload_protocol", newJString(uploadProtocol))
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(path_580138, "name", newJString(name))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "callback", newJString(callback))
  add(query_580139, "access_token", newJString(accessToken))
  add(query_580139, "uploadType", newJString(uploadType))
  add(query_580139, "key", newJString(key))
  add(query_580139, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580140 = body
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  result = call_580137.call(path_580138, query_580139, nil, nil, body_580140)

var spannerProjectsInstancesPatch* = Call_SpannerProjectsInstancesPatch_580120(
    name: "spannerProjectsInstancesPatch", meth: HttpMethod.HttpPatch,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesPatch_580121, base: "/",
    url: url_SpannerProjectsInstancesPatch_580122, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsDelete_580101 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsDelete_580103(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsDelete_580102(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Ends a session, releasing server resources associated with it. This will
  ## asynchronously trigger cancellation of any operations that are running with
  ## this session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the session to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580104 = path.getOrDefault("name")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "name", valid_580104
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580105 = query.getOrDefault("upload_protocol")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "upload_protocol", valid_580105
  var valid_580106 = query.getOrDefault("fields")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "fields", valid_580106
  var valid_580107 = query.getOrDefault("quotaUser")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "quotaUser", valid_580107
  var valid_580108 = query.getOrDefault("alt")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("json"))
  if valid_580108 != nil:
    section.add "alt", valid_580108
  var valid_580109 = query.getOrDefault("oauth_token")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "oauth_token", valid_580109
  var valid_580110 = query.getOrDefault("callback")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "callback", valid_580110
  var valid_580111 = query.getOrDefault("access_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "access_token", valid_580111
  var valid_580112 = query.getOrDefault("uploadType")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "uploadType", valid_580112
  var valid_580113 = query.getOrDefault("key")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "key", valid_580113
  var valid_580114 = query.getOrDefault("$.xgafv")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("1"))
  if valid_580114 != nil:
    section.add "$.xgafv", valid_580114
  var valid_580115 = query.getOrDefault("prettyPrint")
  valid_580115 = validateParameter(valid_580115, JBool, required = false,
                                 default = newJBool(true))
  if valid_580115 != nil:
    section.add "prettyPrint", valid_580115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580116: Call_SpannerProjectsInstancesDatabasesSessionsDelete_580101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Ends a session, releasing server resources associated with it. This will
  ## asynchronously trigger cancellation of any operations that are running with
  ## this session.
  ## 
  let valid = call_580116.validator(path, query, header, formData, body)
  let scheme = call_580116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580116.url(scheme.get, call_580116.host, call_580116.base,
                         call_580116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580116, url, valid)

proc call*(call_580117: Call_SpannerProjectsInstancesDatabasesSessionsDelete_580101;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsDelete
  ## Ends a session, releasing server resources associated with it. This will
  ## asynchronously trigger cancellation of any operations that are running with
  ## this session.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the session to delete.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580118 = newJObject()
  var query_580119 = newJObject()
  add(query_580119, "upload_protocol", newJString(uploadProtocol))
  add(query_580119, "fields", newJString(fields))
  add(query_580119, "quotaUser", newJString(quotaUser))
  add(path_580118, "name", newJString(name))
  add(query_580119, "alt", newJString(alt))
  add(query_580119, "oauth_token", newJString(oauthToken))
  add(query_580119, "callback", newJString(callback))
  add(query_580119, "access_token", newJString(accessToken))
  add(query_580119, "uploadType", newJString(uploadType))
  add(query_580119, "key", newJString(key))
  add(query_580119, "$.xgafv", newJString(Xgafv))
  add(query_580119, "prettyPrint", newJBool(prettyPrint))
  result = call_580117.call(path_580118, query_580119, nil, nil, nil)

var spannerProjectsInstancesDatabasesSessionsDelete* = Call_SpannerProjectsInstancesDatabasesSessionsDelete_580101(
    name: "spannerProjectsInstancesDatabasesSessionsDelete",
    meth: HttpMethod.HttpDelete, host: "spanner.googleapis.com",
    route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsDelete_580102,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsDelete_580103,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesOperationsCancel_580141 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesOperationsCancel_580143(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesOperationsCancel_580142(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
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
  var valid_580144 = path.getOrDefault("name")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "name", valid_580144
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580145 = query.getOrDefault("upload_protocol")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "upload_protocol", valid_580145
  var valid_580146 = query.getOrDefault("fields")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "fields", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("oauth_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "oauth_token", valid_580149
  var valid_580150 = query.getOrDefault("callback")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "callback", valid_580150
  var valid_580151 = query.getOrDefault("access_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "access_token", valid_580151
  var valid_580152 = query.getOrDefault("uploadType")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "uploadType", valid_580152
  var valid_580153 = query.getOrDefault("key")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "key", valid_580153
  var valid_580154 = query.getOrDefault("$.xgafv")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("1"))
  if valid_580154 != nil:
    section.add "$.xgafv", valid_580154
  var valid_580155 = query.getOrDefault("prettyPrint")
  valid_580155 = validateParameter(valid_580155, JBool, required = false,
                                 default = newJBool(true))
  if valid_580155 != nil:
    section.add "prettyPrint", valid_580155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580156: Call_SpannerProjectsInstancesDatabasesOperationsCancel_580141;
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
  let valid = call_580156.validator(path, query, header, formData, body)
  let scheme = call_580156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580156.url(scheme.get, call_580156.host, call_580156.base,
                         call_580156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580156, url, valid)

proc call*(call_580157: Call_SpannerProjectsInstancesDatabasesOperationsCancel_580141;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesOperationsCancel
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580158 = newJObject()
  var query_580159 = newJObject()
  add(query_580159, "upload_protocol", newJString(uploadProtocol))
  add(query_580159, "fields", newJString(fields))
  add(query_580159, "quotaUser", newJString(quotaUser))
  add(path_580158, "name", newJString(name))
  add(query_580159, "alt", newJString(alt))
  add(query_580159, "oauth_token", newJString(oauthToken))
  add(query_580159, "callback", newJString(callback))
  add(query_580159, "access_token", newJString(accessToken))
  add(query_580159, "uploadType", newJString(uploadType))
  add(query_580159, "key", newJString(key))
  add(query_580159, "$.xgafv", newJString(Xgafv))
  add(query_580159, "prettyPrint", newJBool(prettyPrint))
  result = call_580157.call(path_580158, query_580159, nil, nil, nil)

var spannerProjectsInstancesDatabasesOperationsCancel* = Call_SpannerProjectsInstancesDatabasesOperationsCancel_580141(
    name: "spannerProjectsInstancesDatabasesOperationsCancel",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_SpannerProjectsInstancesDatabasesOperationsCancel_580142,
    base: "/", url: url_SpannerProjectsInstancesDatabasesOperationsCancel_580143,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesCreate_580181 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesCreate_580183(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesCreate_580182(path: JsonNode;
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
  var valid_580184 = path.getOrDefault("parent")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "parent", valid_580184
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580185 = query.getOrDefault("upload_protocol")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "upload_protocol", valid_580185
  var valid_580186 = query.getOrDefault("fields")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "fields", valid_580186
  var valid_580187 = query.getOrDefault("quotaUser")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "quotaUser", valid_580187
  var valid_580188 = query.getOrDefault("alt")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = newJString("json"))
  if valid_580188 != nil:
    section.add "alt", valid_580188
  var valid_580189 = query.getOrDefault("oauth_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "oauth_token", valid_580189
  var valid_580190 = query.getOrDefault("callback")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "callback", valid_580190
  var valid_580191 = query.getOrDefault("access_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "access_token", valid_580191
  var valid_580192 = query.getOrDefault("uploadType")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "uploadType", valid_580192
  var valid_580193 = query.getOrDefault("key")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "key", valid_580193
  var valid_580194 = query.getOrDefault("$.xgafv")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("1"))
  if valid_580194 != nil:
    section.add "$.xgafv", valid_580194
  var valid_580195 = query.getOrDefault("prettyPrint")
  valid_580195 = validateParameter(valid_580195, JBool, required = false,
                                 default = newJBool(true))
  if valid_580195 != nil:
    section.add "prettyPrint", valid_580195
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

proc call*(call_580197: Call_SpannerProjectsInstancesDatabasesCreate_580181;
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
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_SpannerProjectsInstancesDatabasesCreate_580181;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesCreate
  ## Creates a new Cloud Spanner database and starts to prepare it for serving.
  ## The returned long-running operation will
  ## have a name of the format `<database_name>/operations/<operation_id>` and
  ## can be used to track preparation of the database. The
  ## metadata field type is
  ## CreateDatabaseMetadata. The
  ## response field type is
  ## Database, if successful.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the instance that will serve the new database.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  var body_580201 = newJObject()
  add(query_580200, "upload_protocol", newJString(uploadProtocol))
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(query_580200, "callback", newJString(callback))
  add(query_580200, "access_token", newJString(accessToken))
  add(query_580200, "uploadType", newJString(uploadType))
  add(path_580199, "parent", newJString(parent))
  add(query_580200, "key", newJString(key))
  add(query_580200, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580201 = body
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  result = call_580198.call(path_580199, query_580200, nil, nil, body_580201)

var spannerProjectsInstancesDatabasesCreate* = Call_SpannerProjectsInstancesDatabasesCreate_580181(
    name: "spannerProjectsInstancesDatabasesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesCreate_580182, base: "/",
    url: url_SpannerProjectsInstancesDatabasesCreate_580183,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesList_580160 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesList_580162(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesList_580161(path: JsonNode;
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
  var valid_580163 = path.getOrDefault("parent")
  valid_580163 = validateParameter(valid_580163, JString, required = true,
                                 default = nil)
  if valid_580163 != nil:
    section.add "parent", valid_580163
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListDatabasesResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of databases to be returned in the response. If 0 or less,
  ## defaults to the server's maximum allowed page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580164 = query.getOrDefault("upload_protocol")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "upload_protocol", valid_580164
  var valid_580165 = query.getOrDefault("fields")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "fields", valid_580165
  var valid_580166 = query.getOrDefault("pageToken")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "pageToken", valid_580166
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
  var valid_580170 = query.getOrDefault("callback")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "callback", valid_580170
  var valid_580171 = query.getOrDefault("access_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "access_token", valid_580171
  var valid_580172 = query.getOrDefault("uploadType")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "uploadType", valid_580172
  var valid_580173 = query.getOrDefault("key")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "key", valid_580173
  var valid_580174 = query.getOrDefault("$.xgafv")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("1"))
  if valid_580174 != nil:
    section.add "$.xgafv", valid_580174
  var valid_580175 = query.getOrDefault("pageSize")
  valid_580175 = validateParameter(valid_580175, JInt, required = false, default = nil)
  if valid_580175 != nil:
    section.add "pageSize", valid_580175
  var valid_580176 = query.getOrDefault("prettyPrint")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "prettyPrint", valid_580176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580177: Call_SpannerProjectsInstancesDatabasesList_580160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Cloud Spanner databases.
  ## 
  let valid = call_580177.validator(path, query, header, formData, body)
  let scheme = call_580177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580177.url(scheme.get, call_580177.host, call_580177.base,
                         call_580177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580177, url, valid)

proc call*(call_580178: Call_SpannerProjectsInstancesDatabasesList_580160;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesList
  ## Lists Cloud Spanner databases.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListDatabasesResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The instance whose databases should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of databases to be returned in the response. If 0 or less,
  ## defaults to the server's maximum allowed page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580179 = newJObject()
  var query_580180 = newJObject()
  add(query_580180, "upload_protocol", newJString(uploadProtocol))
  add(query_580180, "fields", newJString(fields))
  add(query_580180, "pageToken", newJString(pageToken))
  add(query_580180, "quotaUser", newJString(quotaUser))
  add(query_580180, "alt", newJString(alt))
  add(query_580180, "oauth_token", newJString(oauthToken))
  add(query_580180, "callback", newJString(callback))
  add(query_580180, "access_token", newJString(accessToken))
  add(query_580180, "uploadType", newJString(uploadType))
  add(path_580179, "parent", newJString(parent))
  add(query_580180, "key", newJString(key))
  add(query_580180, "$.xgafv", newJString(Xgafv))
  add(query_580180, "pageSize", newJInt(pageSize))
  add(query_580180, "prettyPrint", newJBool(prettyPrint))
  result = call_580178.call(path_580179, query_580180, nil, nil, nil)

var spannerProjectsInstancesDatabasesList* = Call_SpannerProjectsInstancesDatabasesList_580160(
    name: "spannerProjectsInstancesDatabasesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesList_580161, base: "/",
    url: url_SpannerProjectsInstancesDatabasesList_580162, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstanceConfigsList_580202 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstanceConfigsList_580204(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstanceConfigsList_580203(path: JsonNode;
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
  var valid_580205 = path.getOrDefault("parent")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "parent", valid_580205
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token
  ## from a previous ListInstanceConfigsResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of instance configurations to be returned in the response. If 0 or
  ## less, defaults to the server's maximum allowed page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580206 = query.getOrDefault("upload_protocol")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "upload_protocol", valid_580206
  var valid_580207 = query.getOrDefault("fields")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fields", valid_580207
  var valid_580208 = query.getOrDefault("pageToken")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "pageToken", valid_580208
  var valid_580209 = query.getOrDefault("quotaUser")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "quotaUser", valid_580209
  var valid_580210 = query.getOrDefault("alt")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = newJString("json"))
  if valid_580210 != nil:
    section.add "alt", valid_580210
  var valid_580211 = query.getOrDefault("oauth_token")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "oauth_token", valid_580211
  var valid_580212 = query.getOrDefault("callback")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "callback", valid_580212
  var valid_580213 = query.getOrDefault("access_token")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "access_token", valid_580213
  var valid_580214 = query.getOrDefault("uploadType")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "uploadType", valid_580214
  var valid_580215 = query.getOrDefault("key")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "key", valid_580215
  var valid_580216 = query.getOrDefault("$.xgafv")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = newJString("1"))
  if valid_580216 != nil:
    section.add "$.xgafv", valid_580216
  var valid_580217 = query.getOrDefault("pageSize")
  valid_580217 = validateParameter(valid_580217, JInt, required = false, default = nil)
  if valid_580217 != nil:
    section.add "pageSize", valid_580217
  var valid_580218 = query.getOrDefault("prettyPrint")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(true))
  if valid_580218 != nil:
    section.add "prettyPrint", valid_580218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580219: Call_SpannerProjectsInstanceConfigsList_580202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the supported instance configurations for a given project.
  ## 
  let valid = call_580219.validator(path, query, header, formData, body)
  let scheme = call_580219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580219.url(scheme.get, call_580219.host, call_580219.base,
                         call_580219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580219, url, valid)

proc call*(call_580220: Call_SpannerProjectsInstanceConfigsList_580202;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstanceConfigsList
  ## Lists the supported instance configurations for a given project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token
  ## from a previous ListInstanceConfigsResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the project for which a list of supported instance
  ## configurations is requested. Values are of the form
  ## `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of instance configurations to be returned in the response. If 0 or
  ## less, defaults to the server's maximum allowed page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580221 = newJObject()
  var query_580222 = newJObject()
  add(query_580222, "upload_protocol", newJString(uploadProtocol))
  add(query_580222, "fields", newJString(fields))
  add(query_580222, "pageToken", newJString(pageToken))
  add(query_580222, "quotaUser", newJString(quotaUser))
  add(query_580222, "alt", newJString(alt))
  add(query_580222, "oauth_token", newJString(oauthToken))
  add(query_580222, "callback", newJString(callback))
  add(query_580222, "access_token", newJString(accessToken))
  add(query_580222, "uploadType", newJString(uploadType))
  add(path_580221, "parent", newJString(parent))
  add(query_580222, "key", newJString(key))
  add(query_580222, "$.xgafv", newJString(Xgafv))
  add(query_580222, "pageSize", newJInt(pageSize))
  add(query_580222, "prettyPrint", newJBool(prettyPrint))
  result = call_580220.call(path_580221, query_580222, nil, nil, nil)

var spannerProjectsInstanceConfigsList* = Call_SpannerProjectsInstanceConfigsList_580202(
    name: "spannerProjectsInstanceConfigsList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instanceConfigs",
    validator: validate_SpannerProjectsInstanceConfigsList_580203, base: "/",
    url: url_SpannerProjectsInstanceConfigsList_580204, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesCreate_580245 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesCreate_580247(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesCreate_580246(path: JsonNode;
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
  var valid_580248 = path.getOrDefault("parent")
  valid_580248 = validateParameter(valid_580248, JString, required = true,
                                 default = nil)
  if valid_580248 != nil:
    section.add "parent", valid_580248
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580249 = query.getOrDefault("upload_protocol")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "upload_protocol", valid_580249
  var valid_580250 = query.getOrDefault("fields")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "fields", valid_580250
  var valid_580251 = query.getOrDefault("quotaUser")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "quotaUser", valid_580251
  var valid_580252 = query.getOrDefault("alt")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = newJString("json"))
  if valid_580252 != nil:
    section.add "alt", valid_580252
  var valid_580253 = query.getOrDefault("oauth_token")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "oauth_token", valid_580253
  var valid_580254 = query.getOrDefault("callback")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "callback", valid_580254
  var valid_580255 = query.getOrDefault("access_token")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "access_token", valid_580255
  var valid_580256 = query.getOrDefault("uploadType")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "uploadType", valid_580256
  var valid_580257 = query.getOrDefault("key")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "key", valid_580257
  var valid_580258 = query.getOrDefault("$.xgafv")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = newJString("1"))
  if valid_580258 != nil:
    section.add "$.xgafv", valid_580258
  var valid_580259 = query.getOrDefault("prettyPrint")
  valid_580259 = validateParameter(valid_580259, JBool, required = false,
                                 default = newJBool(true))
  if valid_580259 != nil:
    section.add "prettyPrint", valid_580259
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

proc call*(call_580261: Call_SpannerProjectsInstancesCreate_580245; path: JsonNode;
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
  let valid = call_580261.validator(path, query, header, formData, body)
  let scheme = call_580261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580261.url(scheme.get, call_580261.host, call_580261.base,
                         call_580261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580261, url, valid)

proc call*(call_580262: Call_SpannerProjectsInstancesCreate_580245; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the project in which to create the instance. Values
  ## are of the form `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580263 = newJObject()
  var query_580264 = newJObject()
  var body_580265 = newJObject()
  add(query_580264, "upload_protocol", newJString(uploadProtocol))
  add(query_580264, "fields", newJString(fields))
  add(query_580264, "quotaUser", newJString(quotaUser))
  add(query_580264, "alt", newJString(alt))
  add(query_580264, "oauth_token", newJString(oauthToken))
  add(query_580264, "callback", newJString(callback))
  add(query_580264, "access_token", newJString(accessToken))
  add(query_580264, "uploadType", newJString(uploadType))
  add(path_580263, "parent", newJString(parent))
  add(query_580264, "key", newJString(key))
  add(query_580264, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580265 = body
  add(query_580264, "prettyPrint", newJBool(prettyPrint))
  result = call_580262.call(path_580263, query_580264, nil, nil, body_580265)

var spannerProjectsInstancesCreate* = Call_SpannerProjectsInstancesCreate_580245(
    name: "spannerProjectsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesCreate_580246, base: "/",
    url: url_SpannerProjectsInstancesCreate_580247, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesList_580223 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesList_580225(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesList_580224(path: JsonNode; query: JsonNode;
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
  var valid_580226 = path.getOrDefault("parent")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "parent", valid_580226
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListInstancesResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of instances to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  section = newJObject()
  var valid_580227 = query.getOrDefault("upload_protocol")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "upload_protocol", valid_580227
  var valid_580228 = query.getOrDefault("fields")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "fields", valid_580228
  var valid_580229 = query.getOrDefault("pageToken")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "pageToken", valid_580229
  var valid_580230 = query.getOrDefault("quotaUser")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "quotaUser", valid_580230
  var valid_580231 = query.getOrDefault("alt")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = newJString("json"))
  if valid_580231 != nil:
    section.add "alt", valid_580231
  var valid_580232 = query.getOrDefault("oauth_token")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "oauth_token", valid_580232
  var valid_580233 = query.getOrDefault("callback")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "callback", valid_580233
  var valid_580234 = query.getOrDefault("access_token")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "access_token", valid_580234
  var valid_580235 = query.getOrDefault("uploadType")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "uploadType", valid_580235
  var valid_580236 = query.getOrDefault("key")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "key", valid_580236
  var valid_580237 = query.getOrDefault("$.xgafv")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = newJString("1"))
  if valid_580237 != nil:
    section.add "$.xgafv", valid_580237
  var valid_580238 = query.getOrDefault("pageSize")
  valid_580238 = validateParameter(valid_580238, JInt, required = false, default = nil)
  if valid_580238 != nil:
    section.add "pageSize", valid_580238
  var valid_580239 = query.getOrDefault("prettyPrint")
  valid_580239 = validateParameter(valid_580239, JBool, required = false,
                                 default = newJBool(true))
  if valid_580239 != nil:
    section.add "prettyPrint", valid_580239
  var valid_580240 = query.getOrDefault("filter")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "filter", valid_580240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580241: Call_SpannerProjectsInstancesList_580223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all instances in the given project.
  ## 
  let valid = call_580241.validator(path, query, header, formData, body)
  let scheme = call_580241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580241.url(scheme.get, call_580241.host, call_580241.base,
                         call_580241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580241, url, valid)

proc call*(call_580242: Call_SpannerProjectsInstancesList_580223; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## spannerProjectsInstancesList
  ## Lists all instances in the given project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListInstancesResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the project for which a list of instances is
  ## requested. Values are of the form `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of instances to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var path_580243 = newJObject()
  var query_580244 = newJObject()
  add(query_580244, "upload_protocol", newJString(uploadProtocol))
  add(query_580244, "fields", newJString(fields))
  add(query_580244, "pageToken", newJString(pageToken))
  add(query_580244, "quotaUser", newJString(quotaUser))
  add(query_580244, "alt", newJString(alt))
  add(query_580244, "oauth_token", newJString(oauthToken))
  add(query_580244, "callback", newJString(callback))
  add(query_580244, "access_token", newJString(accessToken))
  add(query_580244, "uploadType", newJString(uploadType))
  add(path_580243, "parent", newJString(parent))
  add(query_580244, "key", newJString(key))
  add(query_580244, "$.xgafv", newJString(Xgafv))
  add(query_580244, "pageSize", newJInt(pageSize))
  add(query_580244, "prettyPrint", newJBool(prettyPrint))
  add(query_580244, "filter", newJString(filter))
  result = call_580242.call(path_580243, query_580244, nil, nil, nil)

var spannerProjectsInstancesList* = Call_SpannerProjectsInstancesList_580223(
    name: "spannerProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesList_580224, base: "/",
    url: url_SpannerProjectsInstancesList_580225, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetIamPolicy_580266 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesGetIamPolicy_580268(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesGetIamPolicy_580267(
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
  var valid_580269 = path.getOrDefault("resource")
  valid_580269 = validateParameter(valid_580269, JString, required = true,
                                 default = nil)
  if valid_580269 != nil:
    section.add "resource", valid_580269
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580270 = query.getOrDefault("upload_protocol")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "upload_protocol", valid_580270
  var valid_580271 = query.getOrDefault("fields")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "fields", valid_580271
  var valid_580272 = query.getOrDefault("quotaUser")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "quotaUser", valid_580272
  var valid_580273 = query.getOrDefault("alt")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = newJString("json"))
  if valid_580273 != nil:
    section.add "alt", valid_580273
  var valid_580274 = query.getOrDefault("oauth_token")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "oauth_token", valid_580274
  var valid_580275 = query.getOrDefault("callback")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "callback", valid_580275
  var valid_580276 = query.getOrDefault("access_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "access_token", valid_580276
  var valid_580277 = query.getOrDefault("uploadType")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "uploadType", valid_580277
  var valid_580278 = query.getOrDefault("key")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "key", valid_580278
  var valid_580279 = query.getOrDefault("$.xgafv")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = newJString("1"))
  if valid_580279 != nil:
    section.add "$.xgafv", valid_580279
  var valid_580280 = query.getOrDefault("prettyPrint")
  valid_580280 = validateParameter(valid_580280, JBool, required = false,
                                 default = newJBool(true))
  if valid_580280 != nil:
    section.add "prettyPrint", valid_580280
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

proc call*(call_580282: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_580266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ## 
  let valid = call_580282.validator(path, query, header, formData, body)
  let scheme = call_580282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580282.url(scheme.get, call_580282.host, call_580282.base,
                         call_580282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580282, url, valid)

proc call*(call_580283: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_580266;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesGetIamPolicy
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being retrieved. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580284 = newJObject()
  var query_580285 = newJObject()
  var body_580286 = newJObject()
  add(query_580285, "upload_protocol", newJString(uploadProtocol))
  add(query_580285, "fields", newJString(fields))
  add(query_580285, "quotaUser", newJString(quotaUser))
  add(query_580285, "alt", newJString(alt))
  add(query_580285, "oauth_token", newJString(oauthToken))
  add(query_580285, "callback", newJString(callback))
  add(query_580285, "access_token", newJString(accessToken))
  add(query_580285, "uploadType", newJString(uploadType))
  add(query_580285, "key", newJString(key))
  add(query_580285, "$.xgafv", newJString(Xgafv))
  add(path_580284, "resource", newJString(resource))
  if body != nil:
    body_580286 = body
  add(query_580285, "prettyPrint", newJBool(prettyPrint))
  result = call_580283.call(path_580284, query_580285, nil, nil, body_580286)

var spannerProjectsInstancesDatabasesGetIamPolicy* = Call_SpannerProjectsInstancesDatabasesGetIamPolicy_580266(
    name: "spannerProjectsInstancesDatabasesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesGetIamPolicy_580267,
    base: "/", url: url_SpannerProjectsInstancesDatabasesGetIamPolicy_580268,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSetIamPolicy_580287 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSetIamPolicy_580289(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSetIamPolicy_580288(
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
  var valid_580290 = path.getOrDefault("resource")
  valid_580290 = validateParameter(valid_580290, JString, required = true,
                                 default = nil)
  if valid_580290 != nil:
    section.add "resource", valid_580290
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580291 = query.getOrDefault("upload_protocol")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "upload_protocol", valid_580291
  var valid_580292 = query.getOrDefault("fields")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "fields", valid_580292
  var valid_580293 = query.getOrDefault("quotaUser")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "quotaUser", valid_580293
  var valid_580294 = query.getOrDefault("alt")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = newJString("json"))
  if valid_580294 != nil:
    section.add "alt", valid_580294
  var valid_580295 = query.getOrDefault("oauth_token")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "oauth_token", valid_580295
  var valid_580296 = query.getOrDefault("callback")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "callback", valid_580296
  var valid_580297 = query.getOrDefault("access_token")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "access_token", valid_580297
  var valid_580298 = query.getOrDefault("uploadType")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "uploadType", valid_580298
  var valid_580299 = query.getOrDefault("key")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "key", valid_580299
  var valid_580300 = query.getOrDefault("$.xgafv")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = newJString("1"))
  if valid_580300 != nil:
    section.add "$.xgafv", valid_580300
  var valid_580301 = query.getOrDefault("prettyPrint")
  valid_580301 = validateParameter(valid_580301, JBool, required = false,
                                 default = newJBool(true))
  if valid_580301 != nil:
    section.add "prettyPrint", valid_580301
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

proc call*(call_580303: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_580287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ## 
  let valid = call_580303.validator(path, query, header, formData, body)
  let scheme = call_580303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580303.url(scheme.get, call_580303.host, call_580303.base,
                         call_580303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580303, url, valid)

proc call*(call_580304: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_580287;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSetIamPolicy
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being set. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for databases resources.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580305 = newJObject()
  var query_580306 = newJObject()
  var body_580307 = newJObject()
  add(query_580306, "upload_protocol", newJString(uploadProtocol))
  add(query_580306, "fields", newJString(fields))
  add(query_580306, "quotaUser", newJString(quotaUser))
  add(query_580306, "alt", newJString(alt))
  add(query_580306, "oauth_token", newJString(oauthToken))
  add(query_580306, "callback", newJString(callback))
  add(query_580306, "access_token", newJString(accessToken))
  add(query_580306, "uploadType", newJString(uploadType))
  add(query_580306, "key", newJString(key))
  add(query_580306, "$.xgafv", newJString(Xgafv))
  add(path_580305, "resource", newJString(resource))
  if body != nil:
    body_580307 = body
  add(query_580306, "prettyPrint", newJBool(prettyPrint))
  result = call_580304.call(path_580305, query_580306, nil, nil, body_580307)

var spannerProjectsInstancesDatabasesSetIamPolicy* = Call_SpannerProjectsInstancesDatabasesSetIamPolicy_580287(
    name: "spannerProjectsInstancesDatabasesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesSetIamPolicy_580288,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSetIamPolicy_580289,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesTestIamPermissions_580308 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesTestIamPermissions_580310(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesTestIamPermissions_580309(
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
  var valid_580311 = path.getOrDefault("resource")
  valid_580311 = validateParameter(valid_580311, JString, required = true,
                                 default = nil)
  if valid_580311 != nil:
    section.add "resource", valid_580311
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580312 = query.getOrDefault("upload_protocol")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "upload_protocol", valid_580312
  var valid_580313 = query.getOrDefault("fields")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "fields", valid_580313
  var valid_580314 = query.getOrDefault("quotaUser")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "quotaUser", valid_580314
  var valid_580315 = query.getOrDefault("alt")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = newJString("json"))
  if valid_580315 != nil:
    section.add "alt", valid_580315
  var valid_580316 = query.getOrDefault("oauth_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "oauth_token", valid_580316
  var valid_580317 = query.getOrDefault("callback")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "callback", valid_580317
  var valid_580318 = query.getOrDefault("access_token")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "access_token", valid_580318
  var valid_580319 = query.getOrDefault("uploadType")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "uploadType", valid_580319
  var valid_580320 = query.getOrDefault("key")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "key", valid_580320
  var valid_580321 = query.getOrDefault("$.xgafv")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = newJString("1"))
  if valid_580321 != nil:
    section.add "$.xgafv", valid_580321
  var valid_580322 = query.getOrDefault("prettyPrint")
  valid_580322 = validateParameter(valid_580322, JBool, required = false,
                                 default = newJBool(true))
  if valid_580322 != nil:
    section.add "prettyPrint", valid_580322
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

proc call*(call_580324: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_580308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ## 
  let valid = call_580324.validator(path, query, header, formData, body)
  let scheme = call_580324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580324.url(scheme.get, call_580324.host, call_580324.base,
                         call_580324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580324, url, valid)

proc call*(call_580325: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_580308;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesTestIamPermissions
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which permissions are being tested. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580326 = newJObject()
  var query_580327 = newJObject()
  var body_580328 = newJObject()
  add(query_580327, "upload_protocol", newJString(uploadProtocol))
  add(query_580327, "fields", newJString(fields))
  add(query_580327, "quotaUser", newJString(quotaUser))
  add(query_580327, "alt", newJString(alt))
  add(query_580327, "oauth_token", newJString(oauthToken))
  add(query_580327, "callback", newJString(callback))
  add(query_580327, "access_token", newJString(accessToken))
  add(query_580327, "uploadType", newJString(uploadType))
  add(query_580327, "key", newJString(key))
  add(query_580327, "$.xgafv", newJString(Xgafv))
  add(path_580326, "resource", newJString(resource))
  if body != nil:
    body_580328 = body
  add(query_580327, "prettyPrint", newJBool(prettyPrint))
  result = call_580325.call(path_580326, query_580327, nil, nil, body_580328)

var spannerProjectsInstancesDatabasesTestIamPermissions* = Call_SpannerProjectsInstancesDatabasesTestIamPermissions_580308(
    name: "spannerProjectsInstancesDatabasesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_SpannerProjectsInstancesDatabasesTestIamPermissions_580309,
    base: "/", url: url_SpannerProjectsInstancesDatabasesTestIamPermissions_580310,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580329 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580331(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580330(
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
  var valid_580332 = path.getOrDefault("session")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "session", valid_580332
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580333 = query.getOrDefault("upload_protocol")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "upload_protocol", valid_580333
  var valid_580334 = query.getOrDefault("fields")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "fields", valid_580334
  var valid_580335 = query.getOrDefault("quotaUser")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "quotaUser", valid_580335
  var valid_580336 = query.getOrDefault("alt")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = newJString("json"))
  if valid_580336 != nil:
    section.add "alt", valid_580336
  var valid_580337 = query.getOrDefault("oauth_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "oauth_token", valid_580337
  var valid_580338 = query.getOrDefault("callback")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "callback", valid_580338
  var valid_580339 = query.getOrDefault("access_token")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "access_token", valid_580339
  var valid_580340 = query.getOrDefault("uploadType")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "uploadType", valid_580340
  var valid_580341 = query.getOrDefault("key")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "key", valid_580341
  var valid_580342 = query.getOrDefault("$.xgafv")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = newJString("1"))
  if valid_580342 != nil:
    section.add "$.xgafv", valid_580342
  var valid_580343 = query.getOrDefault("prettyPrint")
  valid_580343 = validateParameter(valid_580343, JBool, required = false,
                                 default = newJBool(true))
  if valid_580343 != nil:
    section.add "prettyPrint", valid_580343
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

proc call*(call_580345: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ## 
  let valid = call_580345.validator(path, query, header, formData, body)
  let scheme = call_580345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580345.url(scheme.get, call_580345.host, call_580345.base,
                         call_580345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580345, url, valid)

proc call*(call_580346: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580329;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsBeginTransaction
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the transaction runs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580347 = newJObject()
  var query_580348 = newJObject()
  var body_580349 = newJObject()
  add(query_580348, "upload_protocol", newJString(uploadProtocol))
  add(path_580347, "session", newJString(session))
  add(query_580348, "fields", newJString(fields))
  add(query_580348, "quotaUser", newJString(quotaUser))
  add(query_580348, "alt", newJString(alt))
  add(query_580348, "oauth_token", newJString(oauthToken))
  add(query_580348, "callback", newJString(callback))
  add(query_580348, "access_token", newJString(accessToken))
  add(query_580348, "uploadType", newJString(uploadType))
  add(query_580348, "key", newJString(key))
  add(query_580348, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580349 = body
  add(query_580348, "prettyPrint", newJBool(prettyPrint))
  result = call_580346.call(path_580347, query_580348, nil, nil, body_580349)

var spannerProjectsInstancesDatabasesSessionsBeginTransaction* = Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580329(
    name: "spannerProjectsInstancesDatabasesSessionsBeginTransaction",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:beginTransaction", validator: validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580330,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_580331,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCommit_580350 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsCommit_580352(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsCommit_580351(
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
  var valid_580353 = path.getOrDefault("session")
  valid_580353 = validateParameter(valid_580353, JString, required = true,
                                 default = nil)
  if valid_580353 != nil:
    section.add "session", valid_580353
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580354 = query.getOrDefault("upload_protocol")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "upload_protocol", valid_580354
  var valid_580355 = query.getOrDefault("fields")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "fields", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  var valid_580357 = query.getOrDefault("alt")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = newJString("json"))
  if valid_580357 != nil:
    section.add "alt", valid_580357
  var valid_580358 = query.getOrDefault("oauth_token")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "oauth_token", valid_580358
  var valid_580359 = query.getOrDefault("callback")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "callback", valid_580359
  var valid_580360 = query.getOrDefault("access_token")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "access_token", valid_580360
  var valid_580361 = query.getOrDefault("uploadType")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "uploadType", valid_580361
  var valid_580362 = query.getOrDefault("key")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "key", valid_580362
  var valid_580363 = query.getOrDefault("$.xgafv")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("1"))
  if valid_580363 != nil:
    section.add "$.xgafv", valid_580363
  var valid_580364 = query.getOrDefault("prettyPrint")
  valid_580364 = validateParameter(valid_580364, JBool, required = false,
                                 default = newJBool(true))
  if valid_580364 != nil:
    section.add "prettyPrint", valid_580364
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

proc call*(call_580366: Call_SpannerProjectsInstancesDatabasesSessionsCommit_580350;
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
  let valid = call_580366.validator(path, query, header, formData, body)
  let scheme = call_580366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580366.url(scheme.get, call_580366.host, call_580366.base,
                         call_580366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580366, url, valid)

proc call*(call_580367: Call_SpannerProjectsInstancesDatabasesSessionsCommit_580350;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsCommit
  ## Commits a transaction. The request includes the mutations to be
  ## applied to rows in the database.
  ## 
  ## `Commit` might return an `ABORTED` error. This can occur at any time;
  ## commonly, the cause is conflicts with concurrent
  ## transactions. However, it can also happen for a variety of other
  ## reasons. If `Commit` returns `ABORTED`, the caller should re-attempt
  ## the transaction from the beginning, re-using the same session.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the transaction to be committed is running.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580368 = newJObject()
  var query_580369 = newJObject()
  var body_580370 = newJObject()
  add(query_580369, "upload_protocol", newJString(uploadProtocol))
  add(path_580368, "session", newJString(session))
  add(query_580369, "fields", newJString(fields))
  add(query_580369, "quotaUser", newJString(quotaUser))
  add(query_580369, "alt", newJString(alt))
  add(query_580369, "oauth_token", newJString(oauthToken))
  add(query_580369, "callback", newJString(callback))
  add(query_580369, "access_token", newJString(accessToken))
  add(query_580369, "uploadType", newJString(uploadType))
  add(query_580369, "key", newJString(key))
  add(query_580369, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580370 = body
  add(query_580369, "prettyPrint", newJBool(prettyPrint))
  result = call_580367.call(path_580368, query_580369, nil, nil, body_580370)

var spannerProjectsInstancesDatabasesSessionsCommit* = Call_SpannerProjectsInstancesDatabasesSessionsCommit_580350(
    name: "spannerProjectsInstancesDatabasesSessionsCommit",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:commit",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCommit_580351,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCommit_580352,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580371 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580373(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580372(
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
  var valid_580374 = path.getOrDefault("session")
  valid_580374 = validateParameter(valid_580374, JString, required = true,
                                 default = nil)
  if valid_580374 != nil:
    section.add "session", valid_580374
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580375 = query.getOrDefault("upload_protocol")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "upload_protocol", valid_580375
  var valid_580376 = query.getOrDefault("fields")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "fields", valid_580376
  var valid_580377 = query.getOrDefault("quotaUser")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "quotaUser", valid_580377
  var valid_580378 = query.getOrDefault("alt")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = newJString("json"))
  if valid_580378 != nil:
    section.add "alt", valid_580378
  var valid_580379 = query.getOrDefault("oauth_token")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "oauth_token", valid_580379
  var valid_580380 = query.getOrDefault("callback")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "callback", valid_580380
  var valid_580381 = query.getOrDefault("access_token")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "access_token", valid_580381
  var valid_580382 = query.getOrDefault("uploadType")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "uploadType", valid_580382
  var valid_580383 = query.getOrDefault("key")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "key", valid_580383
  var valid_580384 = query.getOrDefault("$.xgafv")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = newJString("1"))
  if valid_580384 != nil:
    section.add "$.xgafv", valid_580384
  var valid_580385 = query.getOrDefault("prettyPrint")
  valid_580385 = validateParameter(valid_580385, JBool, required = false,
                                 default = newJBool(true))
  if valid_580385 != nil:
    section.add "prettyPrint", valid_580385
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

proc call*(call_580387: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580371;
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
  let valid = call_580387.validator(path, query, header, formData, body)
  let scheme = call_580387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580387.url(scheme.get, call_580387.host, call_580387.base,
                         call_580387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580387, url, valid)

proc call*(call_580388: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580371;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the DML statements should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580389 = newJObject()
  var query_580390 = newJObject()
  var body_580391 = newJObject()
  add(query_580390, "upload_protocol", newJString(uploadProtocol))
  add(path_580389, "session", newJString(session))
  add(query_580390, "fields", newJString(fields))
  add(query_580390, "quotaUser", newJString(quotaUser))
  add(query_580390, "alt", newJString(alt))
  add(query_580390, "oauth_token", newJString(oauthToken))
  add(query_580390, "callback", newJString(callback))
  add(query_580390, "access_token", newJString(accessToken))
  add(query_580390, "uploadType", newJString(uploadType))
  add(query_580390, "key", newJString(key))
  add(query_580390, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580391 = body
  add(query_580390, "prettyPrint", newJBool(prettyPrint))
  result = call_580388.call(path_580389, query_580390, nil, nil, body_580391)

var spannerProjectsInstancesDatabasesSessionsExecuteBatchDml* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580371(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteBatchDml",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeBatchDml", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580372,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_580373,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580392 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580394(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580393(
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
  var valid_580395 = path.getOrDefault("session")
  valid_580395 = validateParameter(valid_580395, JString, required = true,
                                 default = nil)
  if valid_580395 != nil:
    section.add "session", valid_580395
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580396 = query.getOrDefault("upload_protocol")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "upload_protocol", valid_580396
  var valid_580397 = query.getOrDefault("fields")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "fields", valid_580397
  var valid_580398 = query.getOrDefault("quotaUser")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "quotaUser", valid_580398
  var valid_580399 = query.getOrDefault("alt")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = newJString("json"))
  if valid_580399 != nil:
    section.add "alt", valid_580399
  var valid_580400 = query.getOrDefault("oauth_token")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "oauth_token", valid_580400
  var valid_580401 = query.getOrDefault("callback")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "callback", valid_580401
  var valid_580402 = query.getOrDefault("access_token")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "access_token", valid_580402
  var valid_580403 = query.getOrDefault("uploadType")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "uploadType", valid_580403
  var valid_580404 = query.getOrDefault("key")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "key", valid_580404
  var valid_580405 = query.getOrDefault("$.xgafv")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("1"))
  if valid_580405 != nil:
    section.add "$.xgafv", valid_580405
  var valid_580406 = query.getOrDefault("prettyPrint")
  valid_580406 = validateParameter(valid_580406, JBool, required = false,
                                 default = newJBool(true))
  if valid_580406 != nil:
    section.add "prettyPrint", valid_580406
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

proc call*(call_580408: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580392;
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
  let valid = call_580408.validator(path, query, header, formData, body)
  let scheme = call_580408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580408.url(scheme.get, call_580408.host, call_580408.base,
                         call_580408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580408, url, valid)

proc call*(call_580409: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580392;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the SQL query should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580410 = newJObject()
  var query_580411 = newJObject()
  var body_580412 = newJObject()
  add(query_580411, "upload_protocol", newJString(uploadProtocol))
  add(path_580410, "session", newJString(session))
  add(query_580411, "fields", newJString(fields))
  add(query_580411, "quotaUser", newJString(quotaUser))
  add(query_580411, "alt", newJString(alt))
  add(query_580411, "oauth_token", newJString(oauthToken))
  add(query_580411, "callback", newJString(callback))
  add(query_580411, "access_token", newJString(accessToken))
  add(query_580411, "uploadType", newJString(uploadType))
  add(query_580411, "key", newJString(key))
  add(query_580411, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580412 = body
  add(query_580411, "prettyPrint", newJBool(prettyPrint))
  result = call_580409.call(path_580410, query_580411, nil, nil, body_580412)

var spannerProjectsInstancesDatabasesSessionsExecuteSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580392(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeSql",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580393,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_580394,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580413 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580415(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580414(
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
  var valid_580416 = path.getOrDefault("session")
  valid_580416 = validateParameter(valid_580416, JString, required = true,
                                 default = nil)
  if valid_580416 != nil:
    section.add "session", valid_580416
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580417 = query.getOrDefault("upload_protocol")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "upload_protocol", valid_580417
  var valid_580418 = query.getOrDefault("fields")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "fields", valid_580418
  var valid_580419 = query.getOrDefault("quotaUser")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "quotaUser", valid_580419
  var valid_580420 = query.getOrDefault("alt")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = newJString("json"))
  if valid_580420 != nil:
    section.add "alt", valid_580420
  var valid_580421 = query.getOrDefault("oauth_token")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "oauth_token", valid_580421
  var valid_580422 = query.getOrDefault("callback")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "callback", valid_580422
  var valid_580423 = query.getOrDefault("access_token")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "access_token", valid_580423
  var valid_580424 = query.getOrDefault("uploadType")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "uploadType", valid_580424
  var valid_580425 = query.getOrDefault("key")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "key", valid_580425
  var valid_580426 = query.getOrDefault("$.xgafv")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("1"))
  if valid_580426 != nil:
    section.add "$.xgafv", valid_580426
  var valid_580427 = query.getOrDefault("prettyPrint")
  valid_580427 = validateParameter(valid_580427, JBool, required = false,
                                 default = newJBool(true))
  if valid_580427 != nil:
    section.add "prettyPrint", valid_580427
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

proc call*(call_580429: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580413;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ## 
  let valid = call_580429.validator(path, query, header, formData, body)
  let scheme = call_580429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580429.url(scheme.get, call_580429.host, call_580429.base,
                         call_580429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580429, url, valid)

proc call*(call_580430: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580413;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the SQL query should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580431 = newJObject()
  var query_580432 = newJObject()
  var body_580433 = newJObject()
  add(query_580432, "upload_protocol", newJString(uploadProtocol))
  add(path_580431, "session", newJString(session))
  add(query_580432, "fields", newJString(fields))
  add(query_580432, "quotaUser", newJString(quotaUser))
  add(query_580432, "alt", newJString(alt))
  add(query_580432, "oauth_token", newJString(oauthToken))
  add(query_580432, "callback", newJString(callback))
  add(query_580432, "access_token", newJString(accessToken))
  add(query_580432, "uploadType", newJString(uploadType))
  add(query_580432, "key", newJString(key))
  add(query_580432, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580433 = body
  add(query_580432, "prettyPrint", newJBool(prettyPrint))
  result = call_580430.call(path_580431, query_580432, nil, nil, body_580433)

var spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580413(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeStreamingSql", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580414,
    base: "/",
    url: url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_580415,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580434 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580436(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580435(
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
  var valid_580437 = path.getOrDefault("session")
  valid_580437 = validateParameter(valid_580437, JString, required = true,
                                 default = nil)
  if valid_580437 != nil:
    section.add "session", valid_580437
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580438 = query.getOrDefault("upload_protocol")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "upload_protocol", valid_580438
  var valid_580439 = query.getOrDefault("fields")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "fields", valid_580439
  var valid_580440 = query.getOrDefault("quotaUser")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "quotaUser", valid_580440
  var valid_580441 = query.getOrDefault("alt")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = newJString("json"))
  if valid_580441 != nil:
    section.add "alt", valid_580441
  var valid_580442 = query.getOrDefault("oauth_token")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "oauth_token", valid_580442
  var valid_580443 = query.getOrDefault("callback")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "callback", valid_580443
  var valid_580444 = query.getOrDefault("access_token")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "access_token", valid_580444
  var valid_580445 = query.getOrDefault("uploadType")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "uploadType", valid_580445
  var valid_580446 = query.getOrDefault("key")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "key", valid_580446
  var valid_580447 = query.getOrDefault("$.xgafv")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = newJString("1"))
  if valid_580447 != nil:
    section.add "$.xgafv", valid_580447
  var valid_580448 = query.getOrDefault("prettyPrint")
  valid_580448 = validateParameter(valid_580448, JBool, required = false,
                                 default = newJBool(true))
  if valid_580448 != nil:
    section.add "prettyPrint", valid_580448
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

proc call*(call_580450: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580434;
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
  let valid = call_580450.validator(path, query, header, formData, body)
  let scheme = call_580450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580450.url(scheme.get, call_580450.host, call_580450.base,
                         call_580450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580450, url, valid)

proc call*(call_580451: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580434;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session used to create the partitions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580452 = newJObject()
  var query_580453 = newJObject()
  var body_580454 = newJObject()
  add(query_580453, "upload_protocol", newJString(uploadProtocol))
  add(path_580452, "session", newJString(session))
  add(query_580453, "fields", newJString(fields))
  add(query_580453, "quotaUser", newJString(quotaUser))
  add(query_580453, "alt", newJString(alt))
  add(query_580453, "oauth_token", newJString(oauthToken))
  add(query_580453, "callback", newJString(callback))
  add(query_580453, "access_token", newJString(accessToken))
  add(query_580453, "uploadType", newJString(uploadType))
  add(query_580453, "key", newJString(key))
  add(query_580453, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580454 = body
  add(query_580453, "prettyPrint", newJBool(prettyPrint))
  result = call_580451.call(path_580452, query_580453, nil, nil, body_580454)

var spannerProjectsInstancesDatabasesSessionsPartitionQuery* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580434(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionQuery",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionQuery", validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580435,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_580436,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580455 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580457(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580456(
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
  var valid_580458 = path.getOrDefault("session")
  valid_580458 = validateParameter(valid_580458, JString, required = true,
                                 default = nil)
  if valid_580458 != nil:
    section.add "session", valid_580458
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580459 = query.getOrDefault("upload_protocol")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "upload_protocol", valid_580459
  var valid_580460 = query.getOrDefault("fields")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "fields", valid_580460
  var valid_580461 = query.getOrDefault("quotaUser")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "quotaUser", valid_580461
  var valid_580462 = query.getOrDefault("alt")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = newJString("json"))
  if valid_580462 != nil:
    section.add "alt", valid_580462
  var valid_580463 = query.getOrDefault("oauth_token")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "oauth_token", valid_580463
  var valid_580464 = query.getOrDefault("callback")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "callback", valid_580464
  var valid_580465 = query.getOrDefault("access_token")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "access_token", valid_580465
  var valid_580466 = query.getOrDefault("uploadType")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "uploadType", valid_580466
  var valid_580467 = query.getOrDefault("key")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "key", valid_580467
  var valid_580468 = query.getOrDefault("$.xgafv")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = newJString("1"))
  if valid_580468 != nil:
    section.add "$.xgafv", valid_580468
  var valid_580469 = query.getOrDefault("prettyPrint")
  valid_580469 = validateParameter(valid_580469, JBool, required = false,
                                 default = newJBool(true))
  if valid_580469 != nil:
    section.add "prettyPrint", valid_580469
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

proc call*(call_580471: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580455;
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
  let valid = call_580471.validator(path, query, header, formData, body)
  let scheme = call_580471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580471.url(scheme.get, call_580471.host, call_580471.base,
                         call_580471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580471, url, valid)

proc call*(call_580472: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580455;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session used to create the partitions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580473 = newJObject()
  var query_580474 = newJObject()
  var body_580475 = newJObject()
  add(query_580474, "upload_protocol", newJString(uploadProtocol))
  add(path_580473, "session", newJString(session))
  add(query_580474, "fields", newJString(fields))
  add(query_580474, "quotaUser", newJString(quotaUser))
  add(query_580474, "alt", newJString(alt))
  add(query_580474, "oauth_token", newJString(oauthToken))
  add(query_580474, "callback", newJString(callback))
  add(query_580474, "access_token", newJString(accessToken))
  add(query_580474, "uploadType", newJString(uploadType))
  add(query_580474, "key", newJString(key))
  add(query_580474, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580475 = body
  add(query_580474, "prettyPrint", newJBool(prettyPrint))
  result = call_580472.call(path_580473, query_580474, nil, nil, body_580475)

var spannerProjectsInstancesDatabasesSessionsPartitionRead* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580455(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580456,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_580457,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRead_580476 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsRead_580478(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsRead_580477(
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
  var valid_580479 = path.getOrDefault("session")
  valid_580479 = validateParameter(valid_580479, JString, required = true,
                                 default = nil)
  if valid_580479 != nil:
    section.add "session", valid_580479
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580480 = query.getOrDefault("upload_protocol")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "upload_protocol", valid_580480
  var valid_580481 = query.getOrDefault("fields")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "fields", valid_580481
  var valid_580482 = query.getOrDefault("quotaUser")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "quotaUser", valid_580482
  var valid_580483 = query.getOrDefault("alt")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = newJString("json"))
  if valid_580483 != nil:
    section.add "alt", valid_580483
  var valid_580484 = query.getOrDefault("oauth_token")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "oauth_token", valid_580484
  var valid_580485 = query.getOrDefault("callback")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "callback", valid_580485
  var valid_580486 = query.getOrDefault("access_token")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "access_token", valid_580486
  var valid_580487 = query.getOrDefault("uploadType")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "uploadType", valid_580487
  var valid_580488 = query.getOrDefault("key")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "key", valid_580488
  var valid_580489 = query.getOrDefault("$.xgafv")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = newJString("1"))
  if valid_580489 != nil:
    section.add "$.xgafv", valid_580489
  var valid_580490 = query.getOrDefault("prettyPrint")
  valid_580490 = validateParameter(valid_580490, JBool, required = false,
                                 default = newJBool(true))
  if valid_580490 != nil:
    section.add "prettyPrint", valid_580490
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

proc call*(call_580492: Call_SpannerProjectsInstancesDatabasesSessionsRead_580476;
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
  let valid = call_580492.validator(path, query, header, formData, body)
  let scheme = call_580492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580492.url(scheme.get, call_580492.host, call_580492.base,
                         call_580492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580492, url, valid)

proc call*(call_580493: Call_SpannerProjectsInstancesDatabasesSessionsRead_580476;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the read should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580494 = newJObject()
  var query_580495 = newJObject()
  var body_580496 = newJObject()
  add(query_580495, "upload_protocol", newJString(uploadProtocol))
  add(path_580494, "session", newJString(session))
  add(query_580495, "fields", newJString(fields))
  add(query_580495, "quotaUser", newJString(quotaUser))
  add(query_580495, "alt", newJString(alt))
  add(query_580495, "oauth_token", newJString(oauthToken))
  add(query_580495, "callback", newJString(callback))
  add(query_580495, "access_token", newJString(accessToken))
  add(query_580495, "uploadType", newJString(uploadType))
  add(query_580495, "key", newJString(key))
  add(query_580495, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580496 = body
  add(query_580495, "prettyPrint", newJBool(prettyPrint))
  result = call_580493.call(path_580494, query_580495, nil, nil, body_580496)

var spannerProjectsInstancesDatabasesSessionsRead* = Call_SpannerProjectsInstancesDatabasesSessionsRead_580476(
    name: "spannerProjectsInstancesDatabasesSessionsRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:read",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRead_580477,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRead_580478,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRollback_580497 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsRollback_580499(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsRollback_580498(
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
  var valid_580500 = path.getOrDefault("session")
  valid_580500 = validateParameter(valid_580500, JString, required = true,
                                 default = nil)
  if valid_580500 != nil:
    section.add "session", valid_580500
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580501 = query.getOrDefault("upload_protocol")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "upload_protocol", valid_580501
  var valid_580502 = query.getOrDefault("fields")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "fields", valid_580502
  var valid_580503 = query.getOrDefault("quotaUser")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "quotaUser", valid_580503
  var valid_580504 = query.getOrDefault("alt")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = newJString("json"))
  if valid_580504 != nil:
    section.add "alt", valid_580504
  var valid_580505 = query.getOrDefault("oauth_token")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "oauth_token", valid_580505
  var valid_580506 = query.getOrDefault("callback")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "callback", valid_580506
  var valid_580507 = query.getOrDefault("access_token")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "access_token", valid_580507
  var valid_580508 = query.getOrDefault("uploadType")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "uploadType", valid_580508
  var valid_580509 = query.getOrDefault("key")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "key", valid_580509
  var valid_580510 = query.getOrDefault("$.xgafv")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = newJString("1"))
  if valid_580510 != nil:
    section.add "$.xgafv", valid_580510
  var valid_580511 = query.getOrDefault("prettyPrint")
  valid_580511 = validateParameter(valid_580511, JBool, required = false,
                                 default = newJBool(true))
  if valid_580511 != nil:
    section.add "prettyPrint", valid_580511
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

proc call*(call_580513: Call_SpannerProjectsInstancesDatabasesSessionsRollback_580497;
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
  let valid = call_580513.validator(path, query, header, formData, body)
  let scheme = call_580513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580513.url(scheme.get, call_580513.host, call_580513.base,
                         call_580513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580513, url, valid)

proc call*(call_580514: Call_SpannerProjectsInstancesDatabasesSessionsRollback_580497;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsRollback
  ## Rolls back a transaction, releasing any locks it holds. It is a good
  ## idea to call this for any transaction that includes one or more
  ## Read or ExecuteSql requests and
  ## ultimately decides not to commit.
  ## 
  ## `Rollback` returns `OK` if it successfully aborts the transaction, the
  ## transaction was already aborted, or the transaction is not
  ## found. `Rollback` never returns `ABORTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the transaction to roll back is running.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580515 = newJObject()
  var query_580516 = newJObject()
  var body_580517 = newJObject()
  add(query_580516, "upload_protocol", newJString(uploadProtocol))
  add(path_580515, "session", newJString(session))
  add(query_580516, "fields", newJString(fields))
  add(query_580516, "quotaUser", newJString(quotaUser))
  add(query_580516, "alt", newJString(alt))
  add(query_580516, "oauth_token", newJString(oauthToken))
  add(query_580516, "callback", newJString(callback))
  add(query_580516, "access_token", newJString(accessToken))
  add(query_580516, "uploadType", newJString(uploadType))
  add(query_580516, "key", newJString(key))
  add(query_580516, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580517 = body
  add(query_580516, "prettyPrint", newJBool(prettyPrint))
  result = call_580514.call(path_580515, query_580516, nil, nil, body_580517)

var spannerProjectsInstancesDatabasesSessionsRollback* = Call_SpannerProjectsInstancesDatabasesSessionsRollback_580497(
    name: "spannerProjectsInstancesDatabasesSessionsRollback",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:rollback",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRollback_580498,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRollback_580499,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580518 = ref object of OpenApiRestCall_579421
proc url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580520(
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580519(
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
  var valid_580521 = path.getOrDefault("session")
  valid_580521 = validateParameter(valid_580521, JString, required = true,
                                 default = nil)
  if valid_580521 != nil:
    section.add "session", valid_580521
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580522 = query.getOrDefault("upload_protocol")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "upload_protocol", valid_580522
  var valid_580523 = query.getOrDefault("fields")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "fields", valid_580523
  var valid_580524 = query.getOrDefault("quotaUser")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "quotaUser", valid_580524
  var valid_580525 = query.getOrDefault("alt")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = newJString("json"))
  if valid_580525 != nil:
    section.add "alt", valid_580525
  var valid_580526 = query.getOrDefault("oauth_token")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "oauth_token", valid_580526
  var valid_580527 = query.getOrDefault("callback")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "callback", valid_580527
  var valid_580528 = query.getOrDefault("access_token")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "access_token", valid_580528
  var valid_580529 = query.getOrDefault("uploadType")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "uploadType", valid_580529
  var valid_580530 = query.getOrDefault("key")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "key", valid_580530
  var valid_580531 = query.getOrDefault("$.xgafv")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = newJString("1"))
  if valid_580531 != nil:
    section.add "$.xgafv", valid_580531
  var valid_580532 = query.getOrDefault("prettyPrint")
  valid_580532 = validateParameter(valid_580532, JBool, required = false,
                                 default = newJBool(true))
  if valid_580532 != nil:
    section.add "prettyPrint", valid_580532
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

proc call*(call_580534: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ## 
  let valid = call_580534.validator(path, query, header, formData, body)
  let scheme = call_580534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580534.url(scheme.get, call_580534.host, call_580534.base,
                         call_580534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580534, url, valid)

proc call*(call_580535: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580518;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsStreamingRead
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the read should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580536 = newJObject()
  var query_580537 = newJObject()
  var body_580538 = newJObject()
  add(query_580537, "upload_protocol", newJString(uploadProtocol))
  add(path_580536, "session", newJString(session))
  add(query_580537, "fields", newJString(fields))
  add(query_580537, "quotaUser", newJString(quotaUser))
  add(query_580537, "alt", newJString(alt))
  add(query_580537, "oauth_token", newJString(oauthToken))
  add(query_580537, "callback", newJString(callback))
  add(query_580537, "access_token", newJString(accessToken))
  add(query_580537, "uploadType", newJString(uploadType))
  add(query_580537, "key", newJString(key))
  add(query_580537, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580538 = body
  add(query_580537, "prettyPrint", newJBool(prettyPrint))
  result = call_580535.call(path_580536, query_580537, nil, nil, body_580538)

var spannerProjectsInstancesDatabasesSessionsStreamingRead* = Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580518(
    name: "spannerProjectsInstancesDatabasesSessionsStreamingRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:streamingRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580519,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_580520,
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
