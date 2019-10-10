
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
  gcpServiceName = "spanner"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpannerProjectsInstancesDatabasesDropDatabase_588719 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesDropDatabase_588721(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesDropDatabase_588720(
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
  var valid_588847 = path.getOrDefault("database")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "database", valid_588847
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
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("callback")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "callback", valid_588866
  var valid_588867 = query.getOrDefault("access_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "access_token", valid_588867
  var valid_588868 = query.getOrDefault("uploadType")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "uploadType", valid_588868
  var valid_588869 = query.getOrDefault("key")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "key", valid_588869
  var valid_588870 = query.getOrDefault("$.xgafv")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("1"))
  if valid_588870 != nil:
    section.add "$.xgafv", valid_588870
  var valid_588871 = query.getOrDefault("prettyPrint")
  valid_588871 = validateParameter(valid_588871, JBool, required = false,
                                 default = newJBool(true))
  if valid_588871 != nil:
    section.add "prettyPrint", valid_588871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588894: Call_SpannerProjectsInstancesDatabasesDropDatabase_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Drops (aka deletes) a Cloud Spanner database.
  ## 
  let valid = call_588894.validator(path, query, header, formData, body)
  let scheme = call_588894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588894.url(scheme.get, call_588894.host, call_588894.base,
                         call_588894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588894, url, valid)

proc call*(call_588965: Call_SpannerProjectsInstancesDatabasesDropDatabase_588719;
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
  var path_588966 = newJObject()
  var query_588968 = newJObject()
  add(query_588968, "upload_protocol", newJString(uploadProtocol))
  add(query_588968, "fields", newJString(fields))
  add(query_588968, "quotaUser", newJString(quotaUser))
  add(query_588968, "alt", newJString(alt))
  add(query_588968, "oauth_token", newJString(oauthToken))
  add(query_588968, "callback", newJString(callback))
  add(query_588968, "access_token", newJString(accessToken))
  add(query_588968, "uploadType", newJString(uploadType))
  add(query_588968, "key", newJString(key))
  add(path_588966, "database", newJString(database))
  add(query_588968, "$.xgafv", newJString(Xgafv))
  add(query_588968, "prettyPrint", newJBool(prettyPrint))
  result = call_588965.call(path_588966, query_588968, nil, nil, nil)

var spannerProjectsInstancesDatabasesDropDatabase* = Call_SpannerProjectsInstancesDatabasesDropDatabase_588719(
    name: "spannerProjectsInstancesDatabasesDropDatabase",
    meth: HttpMethod.HttpDelete, host: "spanner.googleapis.com",
    route: "/v1/{database}",
    validator: validate_SpannerProjectsInstancesDatabasesDropDatabase_588720,
    base: "/", url: url_SpannerProjectsInstancesDatabasesDropDatabase_588721,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetDdl_589007 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesGetDdl_589009(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesGetDdl_589008(path: JsonNode;
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
  var valid_589010 = path.getOrDefault("database")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "database", valid_589010
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
  var valid_589011 = query.getOrDefault("upload_protocol")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "upload_protocol", valid_589011
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
  var valid_589016 = query.getOrDefault("callback")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "callback", valid_589016
  var valid_589017 = query.getOrDefault("access_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "access_token", valid_589017
  var valid_589018 = query.getOrDefault("uploadType")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "uploadType", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("$.xgafv")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("1"))
  if valid_589020 != nil:
    section.add "$.xgafv", valid_589020
  var valid_589021 = query.getOrDefault("prettyPrint")
  valid_589021 = validateParameter(valid_589021, JBool, required = false,
                                 default = newJBool(true))
  if valid_589021 != nil:
    section.add "prettyPrint", valid_589021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589022: Call_SpannerProjectsInstancesDatabasesGetDdl_589007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_SpannerProjectsInstancesDatabasesGetDdl_589007;
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
  var path_589024 = newJObject()
  var query_589025 = newJObject()
  add(query_589025, "upload_protocol", newJString(uploadProtocol))
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(query_589025, "alt", newJString(alt))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(query_589025, "callback", newJString(callback))
  add(query_589025, "access_token", newJString(accessToken))
  add(query_589025, "uploadType", newJString(uploadType))
  add(query_589025, "key", newJString(key))
  add(path_589024, "database", newJString(database))
  add(query_589025, "$.xgafv", newJString(Xgafv))
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  result = call_589023.call(path_589024, query_589025, nil, nil, nil)

var spannerProjectsInstancesDatabasesGetDdl* = Call_SpannerProjectsInstancesDatabasesGetDdl_589007(
    name: "spannerProjectsInstancesDatabasesGetDdl", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesGetDdl_589008, base: "/",
    url: url_SpannerProjectsInstancesDatabasesGetDdl_589009,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesUpdateDdl_589026 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesUpdateDdl_589028(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesUpdateDdl_589027(path: JsonNode;
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
  var valid_589029 = path.getOrDefault("database")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "database", valid_589029
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
  var valid_589030 = query.getOrDefault("upload_protocol")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "upload_protocol", valid_589030
  var valid_589031 = query.getOrDefault("fields")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "fields", valid_589031
  var valid_589032 = query.getOrDefault("quotaUser")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "quotaUser", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("callback")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "callback", valid_589035
  var valid_589036 = query.getOrDefault("access_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "access_token", valid_589036
  var valid_589037 = query.getOrDefault("uploadType")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "uploadType", valid_589037
  var valid_589038 = query.getOrDefault("key")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "key", valid_589038
  var valid_589039 = query.getOrDefault("$.xgafv")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("1"))
  if valid_589039 != nil:
    section.add "$.xgafv", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
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

proc call*(call_589042: Call_SpannerProjectsInstancesDatabasesUpdateDdl_589026;
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
  let valid = call_589042.validator(path, query, header, formData, body)
  let scheme = call_589042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589042.url(scheme.get, call_589042.host, call_589042.base,
                         call_589042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589042, url, valid)

proc call*(call_589043: Call_SpannerProjectsInstancesDatabasesUpdateDdl_589026;
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
  var path_589044 = newJObject()
  var query_589045 = newJObject()
  var body_589046 = newJObject()
  add(query_589045, "upload_protocol", newJString(uploadProtocol))
  add(query_589045, "fields", newJString(fields))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(query_589045, "alt", newJString(alt))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(query_589045, "callback", newJString(callback))
  add(query_589045, "access_token", newJString(accessToken))
  add(query_589045, "uploadType", newJString(uploadType))
  add(query_589045, "key", newJString(key))
  add(path_589044, "database", newJString(database))
  add(query_589045, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589046 = body
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  result = call_589043.call(path_589044, query_589045, nil, nil, body_589046)

var spannerProjectsInstancesDatabasesUpdateDdl* = Call_SpannerProjectsInstancesDatabasesUpdateDdl_589026(
    name: "spannerProjectsInstancesDatabasesUpdateDdl",
    meth: HttpMethod.HttpPatch, host: "spanner.googleapis.com",
    route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesUpdateDdl_589027,
    base: "/", url: url_SpannerProjectsInstancesDatabasesUpdateDdl_589028,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCreate_589069 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsCreate_589071(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesSessionsCreate_589070(
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
  var valid_589072 = path.getOrDefault("database")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "database", valid_589072
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
  var valid_589073 = query.getOrDefault("upload_protocol")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "upload_protocol", valid_589073
  var valid_589074 = query.getOrDefault("fields")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "fields", valid_589074
  var valid_589075 = query.getOrDefault("quotaUser")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "quotaUser", valid_589075
  var valid_589076 = query.getOrDefault("alt")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("json"))
  if valid_589076 != nil:
    section.add "alt", valid_589076
  var valid_589077 = query.getOrDefault("oauth_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "oauth_token", valid_589077
  var valid_589078 = query.getOrDefault("callback")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "callback", valid_589078
  var valid_589079 = query.getOrDefault("access_token")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "access_token", valid_589079
  var valid_589080 = query.getOrDefault("uploadType")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "uploadType", valid_589080
  var valid_589081 = query.getOrDefault("key")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "key", valid_589081
  var valid_589082 = query.getOrDefault("$.xgafv")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("1"))
  if valid_589082 != nil:
    section.add "$.xgafv", valid_589082
  var valid_589083 = query.getOrDefault("prettyPrint")
  valid_589083 = validateParameter(valid_589083, JBool, required = false,
                                 default = newJBool(true))
  if valid_589083 != nil:
    section.add "prettyPrint", valid_589083
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

proc call*(call_589085: Call_SpannerProjectsInstancesDatabasesSessionsCreate_589069;
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
  let valid = call_589085.validator(path, query, header, formData, body)
  let scheme = call_589085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589085.url(scheme.get, call_589085.host, call_589085.base,
                         call_589085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589085, url, valid)

proc call*(call_589086: Call_SpannerProjectsInstancesDatabasesSessionsCreate_589069;
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
  var path_589087 = newJObject()
  var query_589088 = newJObject()
  var body_589089 = newJObject()
  add(query_589088, "upload_protocol", newJString(uploadProtocol))
  add(query_589088, "fields", newJString(fields))
  add(query_589088, "quotaUser", newJString(quotaUser))
  add(query_589088, "alt", newJString(alt))
  add(query_589088, "oauth_token", newJString(oauthToken))
  add(query_589088, "callback", newJString(callback))
  add(query_589088, "access_token", newJString(accessToken))
  add(query_589088, "uploadType", newJString(uploadType))
  add(query_589088, "key", newJString(key))
  add(path_589087, "database", newJString(database))
  add(query_589088, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589089 = body
  add(query_589088, "prettyPrint", newJBool(prettyPrint))
  result = call_589086.call(path_589087, query_589088, nil, nil, body_589089)

var spannerProjectsInstancesDatabasesSessionsCreate* = Call_SpannerProjectsInstancesDatabasesSessionsCreate_589069(
    name: "spannerProjectsInstancesDatabasesSessionsCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCreate_589070,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCreate_589071,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsList_589047 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsList_589049(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesSessionsList_589048(
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
  var valid_589050 = path.getOrDefault("database")
  valid_589050 = validateParameter(valid_589050, JString, required = true,
                                 default = nil)
  if valid_589050 != nil:
    section.add "database", valid_589050
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
  var valid_589051 = query.getOrDefault("upload_protocol")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "upload_protocol", valid_589051
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("pageToken")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "pageToken", valid_589053
  var valid_589054 = query.getOrDefault("quotaUser")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "quotaUser", valid_589054
  var valid_589055 = query.getOrDefault("alt")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("json"))
  if valid_589055 != nil:
    section.add "alt", valid_589055
  var valid_589056 = query.getOrDefault("oauth_token")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "oauth_token", valid_589056
  var valid_589057 = query.getOrDefault("callback")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "callback", valid_589057
  var valid_589058 = query.getOrDefault("access_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "access_token", valid_589058
  var valid_589059 = query.getOrDefault("uploadType")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "uploadType", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("$.xgafv")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = newJString("1"))
  if valid_589061 != nil:
    section.add "$.xgafv", valid_589061
  var valid_589062 = query.getOrDefault("pageSize")
  valid_589062 = validateParameter(valid_589062, JInt, required = false, default = nil)
  if valid_589062 != nil:
    section.add "pageSize", valid_589062
  var valid_589063 = query.getOrDefault("prettyPrint")
  valid_589063 = validateParameter(valid_589063, JBool, required = false,
                                 default = newJBool(true))
  if valid_589063 != nil:
    section.add "prettyPrint", valid_589063
  var valid_589064 = query.getOrDefault("filter")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "filter", valid_589064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589065: Call_SpannerProjectsInstancesDatabasesSessionsList_589047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sessions in a given database.
  ## 
  let valid = call_589065.validator(path, query, header, formData, body)
  let scheme = call_589065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589065.url(scheme.get, call_589065.host, call_589065.base,
                         call_589065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589065, url, valid)

proc call*(call_589066: Call_SpannerProjectsInstancesDatabasesSessionsList_589047;
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
  var path_589067 = newJObject()
  var query_589068 = newJObject()
  add(query_589068, "upload_protocol", newJString(uploadProtocol))
  add(query_589068, "fields", newJString(fields))
  add(query_589068, "pageToken", newJString(pageToken))
  add(query_589068, "quotaUser", newJString(quotaUser))
  add(query_589068, "alt", newJString(alt))
  add(query_589068, "oauth_token", newJString(oauthToken))
  add(query_589068, "callback", newJString(callback))
  add(query_589068, "access_token", newJString(accessToken))
  add(query_589068, "uploadType", newJString(uploadType))
  add(query_589068, "key", newJString(key))
  add(path_589067, "database", newJString(database))
  add(query_589068, "$.xgafv", newJString(Xgafv))
  add(query_589068, "pageSize", newJInt(pageSize))
  add(query_589068, "prettyPrint", newJBool(prettyPrint))
  add(query_589068, "filter", newJString(filter))
  result = call_589066.call(path_589067, query_589068, nil, nil, nil)

var spannerProjectsInstancesDatabasesSessionsList* = Call_SpannerProjectsInstancesDatabasesSessionsList_589047(
    name: "spannerProjectsInstancesDatabasesSessionsList",
    meth: HttpMethod.HttpGet, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsList_589048,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsList_589049,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_589090 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_589092(
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

proc validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_589091(
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
  var valid_589093 = path.getOrDefault("database")
  valid_589093 = validateParameter(valid_589093, JString, required = true,
                                 default = nil)
  if valid_589093 != nil:
    section.add "database", valid_589093
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
  var valid_589094 = query.getOrDefault("upload_protocol")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "upload_protocol", valid_589094
  var valid_589095 = query.getOrDefault("fields")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "fields", valid_589095
  var valid_589096 = query.getOrDefault("quotaUser")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "quotaUser", valid_589096
  var valid_589097 = query.getOrDefault("alt")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = newJString("json"))
  if valid_589097 != nil:
    section.add "alt", valid_589097
  var valid_589098 = query.getOrDefault("oauth_token")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "oauth_token", valid_589098
  var valid_589099 = query.getOrDefault("callback")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "callback", valid_589099
  var valid_589100 = query.getOrDefault("access_token")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "access_token", valid_589100
  var valid_589101 = query.getOrDefault("uploadType")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "uploadType", valid_589101
  var valid_589102 = query.getOrDefault("key")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "key", valid_589102
  var valid_589103 = query.getOrDefault("$.xgafv")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = newJString("1"))
  if valid_589103 != nil:
    section.add "$.xgafv", valid_589103
  var valid_589104 = query.getOrDefault("prettyPrint")
  valid_589104 = validateParameter(valid_589104, JBool, required = false,
                                 default = newJBool(true))
  if valid_589104 != nil:
    section.add "prettyPrint", valid_589104
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

proc call*(call_589106: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_589090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ## 
  let valid = call_589106.validator(path, query, header, formData, body)
  let scheme = call_589106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589106.url(scheme.get, call_589106.host, call_589106.base,
                         call_589106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589106, url, valid)

proc call*(call_589107: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_589090;
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
  var path_589108 = newJObject()
  var query_589109 = newJObject()
  var body_589110 = newJObject()
  add(query_589109, "upload_protocol", newJString(uploadProtocol))
  add(query_589109, "fields", newJString(fields))
  add(query_589109, "quotaUser", newJString(quotaUser))
  add(query_589109, "alt", newJString(alt))
  add(query_589109, "oauth_token", newJString(oauthToken))
  add(query_589109, "callback", newJString(callback))
  add(query_589109, "access_token", newJString(accessToken))
  add(query_589109, "uploadType", newJString(uploadType))
  add(query_589109, "key", newJString(key))
  add(path_589108, "database", newJString(database))
  add(query_589109, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589110 = body
  add(query_589109, "prettyPrint", newJBool(prettyPrint))
  result = call_589107.call(path_589108, query_589109, nil, nil, body_589110)

var spannerProjectsInstancesDatabasesSessionsBatchCreate* = Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_589090(
    name: "spannerProjectsInstancesDatabasesSessionsBatchCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions:batchCreate",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_589091,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_589092,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstanceConfigsGet_589111 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstanceConfigsGet_589113(protocol: Scheme; host: string;
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

proc validate_SpannerProjectsInstanceConfigsGet_589112(path: JsonNode;
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
  var valid_589114 = path.getOrDefault("name")
  valid_589114 = validateParameter(valid_589114, JString, required = true,
                                 default = nil)
  if valid_589114 != nil:
    section.add "name", valid_589114
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
  var valid_589115 = query.getOrDefault("upload_protocol")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "upload_protocol", valid_589115
  var valid_589116 = query.getOrDefault("fields")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "fields", valid_589116
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
  var valid_589119 = query.getOrDefault("oauth_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "oauth_token", valid_589119
  var valid_589120 = query.getOrDefault("callback")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "callback", valid_589120
  var valid_589121 = query.getOrDefault("access_token")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "access_token", valid_589121
  var valid_589122 = query.getOrDefault("uploadType")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "uploadType", valid_589122
  var valid_589123 = query.getOrDefault("key")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "key", valid_589123
  var valid_589124 = query.getOrDefault("$.xgafv")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = newJString("1"))
  if valid_589124 != nil:
    section.add "$.xgafv", valid_589124
  var valid_589125 = query.getOrDefault("prettyPrint")
  valid_589125 = validateParameter(valid_589125, JBool, required = false,
                                 default = newJBool(true))
  if valid_589125 != nil:
    section.add "prettyPrint", valid_589125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589126: Call_SpannerProjectsInstanceConfigsGet_589111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a particular instance configuration.
  ## 
  let valid = call_589126.validator(path, query, header, formData, body)
  let scheme = call_589126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589126.url(scheme.get, call_589126.host, call_589126.base,
                         call_589126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589126, url, valid)

proc call*(call_589127: Call_SpannerProjectsInstanceConfigsGet_589111;
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
  var path_589128 = newJObject()
  var query_589129 = newJObject()
  add(query_589129, "upload_protocol", newJString(uploadProtocol))
  add(query_589129, "fields", newJString(fields))
  add(query_589129, "quotaUser", newJString(quotaUser))
  add(path_589128, "name", newJString(name))
  add(query_589129, "alt", newJString(alt))
  add(query_589129, "oauth_token", newJString(oauthToken))
  add(query_589129, "callback", newJString(callback))
  add(query_589129, "access_token", newJString(accessToken))
  add(query_589129, "uploadType", newJString(uploadType))
  add(query_589129, "key", newJString(key))
  add(query_589129, "$.xgafv", newJString(Xgafv))
  add(query_589129, "prettyPrint", newJBool(prettyPrint))
  result = call_589127.call(path_589128, query_589129, nil, nil, nil)

var spannerProjectsInstanceConfigsGet* = Call_SpannerProjectsInstanceConfigsGet_589111(
    name: "spannerProjectsInstanceConfigsGet", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstanceConfigsGet_589112, base: "/",
    url: url_SpannerProjectsInstanceConfigsGet_589113, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesPatch_589149 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesPatch_589151(protocol: Scheme; host: string;
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

proc validate_SpannerProjectsInstancesPatch_589150(path: JsonNode; query: JsonNode;
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
  var valid_589152 = path.getOrDefault("name")
  valid_589152 = validateParameter(valid_589152, JString, required = true,
                                 default = nil)
  if valid_589152 != nil:
    section.add "name", valid_589152
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
  var valid_589153 = query.getOrDefault("upload_protocol")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "upload_protocol", valid_589153
  var valid_589154 = query.getOrDefault("fields")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "fields", valid_589154
  var valid_589155 = query.getOrDefault("quotaUser")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "quotaUser", valid_589155
  var valid_589156 = query.getOrDefault("alt")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("json"))
  if valid_589156 != nil:
    section.add "alt", valid_589156
  var valid_589157 = query.getOrDefault("oauth_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "oauth_token", valid_589157
  var valid_589158 = query.getOrDefault("callback")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "callback", valid_589158
  var valid_589159 = query.getOrDefault("access_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "access_token", valid_589159
  var valid_589160 = query.getOrDefault("uploadType")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "uploadType", valid_589160
  var valid_589161 = query.getOrDefault("key")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "key", valid_589161
  var valid_589162 = query.getOrDefault("$.xgafv")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = newJString("1"))
  if valid_589162 != nil:
    section.add "$.xgafv", valid_589162
  var valid_589163 = query.getOrDefault("prettyPrint")
  valid_589163 = validateParameter(valid_589163, JBool, required = false,
                                 default = newJBool(true))
  if valid_589163 != nil:
    section.add "prettyPrint", valid_589163
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

proc call*(call_589165: Call_SpannerProjectsInstancesPatch_589149; path: JsonNode;
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
  let valid = call_589165.validator(path, query, header, formData, body)
  let scheme = call_589165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589165.url(scheme.get, call_589165.host, call_589165.base,
                         call_589165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589165, url, valid)

proc call*(call_589166: Call_SpannerProjectsInstancesPatch_589149; name: string;
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
  var path_589167 = newJObject()
  var query_589168 = newJObject()
  var body_589169 = newJObject()
  add(query_589168, "upload_protocol", newJString(uploadProtocol))
  add(query_589168, "fields", newJString(fields))
  add(query_589168, "quotaUser", newJString(quotaUser))
  add(path_589167, "name", newJString(name))
  add(query_589168, "alt", newJString(alt))
  add(query_589168, "oauth_token", newJString(oauthToken))
  add(query_589168, "callback", newJString(callback))
  add(query_589168, "access_token", newJString(accessToken))
  add(query_589168, "uploadType", newJString(uploadType))
  add(query_589168, "key", newJString(key))
  add(query_589168, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589169 = body
  add(query_589168, "prettyPrint", newJBool(prettyPrint))
  result = call_589166.call(path_589167, query_589168, nil, nil, body_589169)

var spannerProjectsInstancesPatch* = Call_SpannerProjectsInstancesPatch_589149(
    name: "spannerProjectsInstancesPatch", meth: HttpMethod.HttpPatch,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesPatch_589150, base: "/",
    url: url_SpannerProjectsInstancesPatch_589151, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesOperationsDelete_589130 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesOperationsDelete_589132(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesOperationsDelete_589131(path: JsonNode;
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
  var valid_589133 = path.getOrDefault("name")
  valid_589133 = validateParameter(valid_589133, JString, required = true,
                                 default = nil)
  if valid_589133 != nil:
    section.add "name", valid_589133
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
  var valid_589134 = query.getOrDefault("upload_protocol")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "upload_protocol", valid_589134
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
  var valid_589139 = query.getOrDefault("callback")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "callback", valid_589139
  var valid_589140 = query.getOrDefault("access_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "access_token", valid_589140
  var valid_589141 = query.getOrDefault("uploadType")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "uploadType", valid_589141
  var valid_589142 = query.getOrDefault("key")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "key", valid_589142
  var valid_589143 = query.getOrDefault("$.xgafv")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = newJString("1"))
  if valid_589143 != nil:
    section.add "$.xgafv", valid_589143
  var valid_589144 = query.getOrDefault("prettyPrint")
  valid_589144 = validateParameter(valid_589144, JBool, required = false,
                                 default = newJBool(true))
  if valid_589144 != nil:
    section.add "prettyPrint", valid_589144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589145: Call_SpannerProjectsInstancesOperationsDelete_589130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_589145.validator(path, query, header, formData, body)
  let scheme = call_589145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589145.url(scheme.get, call_589145.host, call_589145.base,
                         call_589145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589145, url, valid)

proc call*(call_589146: Call_SpannerProjectsInstancesOperationsDelete_589130;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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
  var path_589147 = newJObject()
  var query_589148 = newJObject()
  add(query_589148, "upload_protocol", newJString(uploadProtocol))
  add(query_589148, "fields", newJString(fields))
  add(query_589148, "quotaUser", newJString(quotaUser))
  add(path_589147, "name", newJString(name))
  add(query_589148, "alt", newJString(alt))
  add(query_589148, "oauth_token", newJString(oauthToken))
  add(query_589148, "callback", newJString(callback))
  add(query_589148, "access_token", newJString(accessToken))
  add(query_589148, "uploadType", newJString(uploadType))
  add(query_589148, "key", newJString(key))
  add(query_589148, "$.xgafv", newJString(Xgafv))
  add(query_589148, "prettyPrint", newJBool(prettyPrint))
  result = call_589146.call(path_589147, query_589148, nil, nil, nil)

var spannerProjectsInstancesOperationsDelete* = Call_SpannerProjectsInstancesOperationsDelete_589130(
    name: "spannerProjectsInstancesOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesOperationsDelete_589131,
    base: "/", url: url_SpannerProjectsInstancesOperationsDelete_589132,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesOperationsCancel_589170 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesOperationsCancel_589172(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesOperationsCancel_589171(path: JsonNode;
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
  var valid_589173 = path.getOrDefault("name")
  valid_589173 = validateParameter(valid_589173, JString, required = true,
                                 default = nil)
  if valid_589173 != nil:
    section.add "name", valid_589173
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
  var valid_589174 = query.getOrDefault("upload_protocol")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "upload_protocol", valid_589174
  var valid_589175 = query.getOrDefault("fields")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "fields", valid_589175
  var valid_589176 = query.getOrDefault("quotaUser")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "quotaUser", valid_589176
  var valid_589177 = query.getOrDefault("alt")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("json"))
  if valid_589177 != nil:
    section.add "alt", valid_589177
  var valid_589178 = query.getOrDefault("oauth_token")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "oauth_token", valid_589178
  var valid_589179 = query.getOrDefault("callback")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "callback", valid_589179
  var valid_589180 = query.getOrDefault("access_token")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "access_token", valid_589180
  var valid_589181 = query.getOrDefault("uploadType")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "uploadType", valid_589181
  var valid_589182 = query.getOrDefault("key")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "key", valid_589182
  var valid_589183 = query.getOrDefault("$.xgafv")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("1"))
  if valid_589183 != nil:
    section.add "$.xgafv", valid_589183
  var valid_589184 = query.getOrDefault("prettyPrint")
  valid_589184 = validateParameter(valid_589184, JBool, required = false,
                                 default = newJBool(true))
  if valid_589184 != nil:
    section.add "prettyPrint", valid_589184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589185: Call_SpannerProjectsInstancesOperationsCancel_589170;
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
  let valid = call_589185.validator(path, query, header, formData, body)
  let scheme = call_589185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589185.url(scheme.get, call_589185.host, call_589185.base,
                         call_589185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589185, url, valid)

proc call*(call_589186: Call_SpannerProjectsInstancesOperationsCancel_589170;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
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
  var path_589187 = newJObject()
  var query_589188 = newJObject()
  add(query_589188, "upload_protocol", newJString(uploadProtocol))
  add(query_589188, "fields", newJString(fields))
  add(query_589188, "quotaUser", newJString(quotaUser))
  add(path_589187, "name", newJString(name))
  add(query_589188, "alt", newJString(alt))
  add(query_589188, "oauth_token", newJString(oauthToken))
  add(query_589188, "callback", newJString(callback))
  add(query_589188, "access_token", newJString(accessToken))
  add(query_589188, "uploadType", newJString(uploadType))
  add(query_589188, "key", newJString(key))
  add(query_589188, "$.xgafv", newJString(Xgafv))
  add(query_589188, "prettyPrint", newJBool(prettyPrint))
  result = call_589186.call(path_589187, query_589188, nil, nil, nil)

var spannerProjectsInstancesOperationsCancel* = Call_SpannerProjectsInstancesOperationsCancel_589170(
    name: "spannerProjectsInstancesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_SpannerProjectsInstancesOperationsCancel_589171,
    base: "/", url: url_SpannerProjectsInstancesOperationsCancel_589172,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesCreate_589210 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesCreate_589212(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesCreate_589211(path: JsonNode;
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
  var valid_589213 = path.getOrDefault("parent")
  valid_589213 = validateParameter(valid_589213, JString, required = true,
                                 default = nil)
  if valid_589213 != nil:
    section.add "parent", valid_589213
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
  var valid_589214 = query.getOrDefault("upload_protocol")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "upload_protocol", valid_589214
  var valid_589215 = query.getOrDefault("fields")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "fields", valid_589215
  var valid_589216 = query.getOrDefault("quotaUser")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "quotaUser", valid_589216
  var valid_589217 = query.getOrDefault("alt")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("json"))
  if valid_589217 != nil:
    section.add "alt", valid_589217
  var valid_589218 = query.getOrDefault("oauth_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "oauth_token", valid_589218
  var valid_589219 = query.getOrDefault("callback")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "callback", valid_589219
  var valid_589220 = query.getOrDefault("access_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "access_token", valid_589220
  var valid_589221 = query.getOrDefault("uploadType")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "uploadType", valid_589221
  var valid_589222 = query.getOrDefault("key")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "key", valid_589222
  var valid_589223 = query.getOrDefault("$.xgafv")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("1"))
  if valid_589223 != nil:
    section.add "$.xgafv", valid_589223
  var valid_589224 = query.getOrDefault("prettyPrint")
  valid_589224 = validateParameter(valid_589224, JBool, required = false,
                                 default = newJBool(true))
  if valid_589224 != nil:
    section.add "prettyPrint", valid_589224
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

proc call*(call_589226: Call_SpannerProjectsInstancesDatabasesCreate_589210;
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
  let valid = call_589226.validator(path, query, header, formData, body)
  let scheme = call_589226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589226.url(scheme.get, call_589226.host, call_589226.base,
                         call_589226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589226, url, valid)

proc call*(call_589227: Call_SpannerProjectsInstancesDatabasesCreate_589210;
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
  var path_589228 = newJObject()
  var query_589229 = newJObject()
  var body_589230 = newJObject()
  add(query_589229, "upload_protocol", newJString(uploadProtocol))
  add(query_589229, "fields", newJString(fields))
  add(query_589229, "quotaUser", newJString(quotaUser))
  add(query_589229, "alt", newJString(alt))
  add(query_589229, "oauth_token", newJString(oauthToken))
  add(query_589229, "callback", newJString(callback))
  add(query_589229, "access_token", newJString(accessToken))
  add(query_589229, "uploadType", newJString(uploadType))
  add(path_589228, "parent", newJString(parent))
  add(query_589229, "key", newJString(key))
  add(query_589229, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589230 = body
  add(query_589229, "prettyPrint", newJBool(prettyPrint))
  result = call_589227.call(path_589228, query_589229, nil, nil, body_589230)

var spannerProjectsInstancesDatabasesCreate* = Call_SpannerProjectsInstancesDatabasesCreate_589210(
    name: "spannerProjectsInstancesDatabasesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesCreate_589211, base: "/",
    url: url_SpannerProjectsInstancesDatabasesCreate_589212,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesList_589189 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesList_589191(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesList_589190(path: JsonNode;
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
  var valid_589192 = path.getOrDefault("parent")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "parent", valid_589192
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
  var valid_589193 = query.getOrDefault("upload_protocol")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "upload_protocol", valid_589193
  var valid_589194 = query.getOrDefault("fields")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "fields", valid_589194
  var valid_589195 = query.getOrDefault("pageToken")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "pageToken", valid_589195
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
  var valid_589199 = query.getOrDefault("callback")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "callback", valid_589199
  var valid_589200 = query.getOrDefault("access_token")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "access_token", valid_589200
  var valid_589201 = query.getOrDefault("uploadType")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "uploadType", valid_589201
  var valid_589202 = query.getOrDefault("key")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "key", valid_589202
  var valid_589203 = query.getOrDefault("$.xgafv")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = newJString("1"))
  if valid_589203 != nil:
    section.add "$.xgafv", valid_589203
  var valid_589204 = query.getOrDefault("pageSize")
  valid_589204 = validateParameter(valid_589204, JInt, required = false, default = nil)
  if valid_589204 != nil:
    section.add "pageSize", valid_589204
  var valid_589205 = query.getOrDefault("prettyPrint")
  valid_589205 = validateParameter(valid_589205, JBool, required = false,
                                 default = newJBool(true))
  if valid_589205 != nil:
    section.add "prettyPrint", valid_589205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589206: Call_SpannerProjectsInstancesDatabasesList_589189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Cloud Spanner databases.
  ## 
  let valid = call_589206.validator(path, query, header, formData, body)
  let scheme = call_589206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589206.url(scheme.get, call_589206.host, call_589206.base,
                         call_589206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589206, url, valid)

proc call*(call_589207: Call_SpannerProjectsInstancesDatabasesList_589189;
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
  var path_589208 = newJObject()
  var query_589209 = newJObject()
  add(query_589209, "upload_protocol", newJString(uploadProtocol))
  add(query_589209, "fields", newJString(fields))
  add(query_589209, "pageToken", newJString(pageToken))
  add(query_589209, "quotaUser", newJString(quotaUser))
  add(query_589209, "alt", newJString(alt))
  add(query_589209, "oauth_token", newJString(oauthToken))
  add(query_589209, "callback", newJString(callback))
  add(query_589209, "access_token", newJString(accessToken))
  add(query_589209, "uploadType", newJString(uploadType))
  add(path_589208, "parent", newJString(parent))
  add(query_589209, "key", newJString(key))
  add(query_589209, "$.xgafv", newJString(Xgafv))
  add(query_589209, "pageSize", newJInt(pageSize))
  add(query_589209, "prettyPrint", newJBool(prettyPrint))
  result = call_589207.call(path_589208, query_589209, nil, nil, nil)

var spannerProjectsInstancesDatabasesList* = Call_SpannerProjectsInstancesDatabasesList_589189(
    name: "spannerProjectsInstancesDatabasesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesList_589190, base: "/",
    url: url_SpannerProjectsInstancesDatabasesList_589191, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstanceConfigsList_589231 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstanceConfigsList_589233(protocol: Scheme; host: string;
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

proc validate_SpannerProjectsInstanceConfigsList_589232(path: JsonNode;
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
  var valid_589234 = path.getOrDefault("parent")
  valid_589234 = validateParameter(valid_589234, JString, required = true,
                                 default = nil)
  if valid_589234 != nil:
    section.add "parent", valid_589234
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
  var valid_589235 = query.getOrDefault("upload_protocol")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "upload_protocol", valid_589235
  var valid_589236 = query.getOrDefault("fields")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "fields", valid_589236
  var valid_589237 = query.getOrDefault("pageToken")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "pageToken", valid_589237
  var valid_589238 = query.getOrDefault("quotaUser")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "quotaUser", valid_589238
  var valid_589239 = query.getOrDefault("alt")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("json"))
  if valid_589239 != nil:
    section.add "alt", valid_589239
  var valid_589240 = query.getOrDefault("oauth_token")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "oauth_token", valid_589240
  var valid_589241 = query.getOrDefault("callback")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "callback", valid_589241
  var valid_589242 = query.getOrDefault("access_token")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "access_token", valid_589242
  var valid_589243 = query.getOrDefault("uploadType")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "uploadType", valid_589243
  var valid_589244 = query.getOrDefault("key")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "key", valid_589244
  var valid_589245 = query.getOrDefault("$.xgafv")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("1"))
  if valid_589245 != nil:
    section.add "$.xgafv", valid_589245
  var valid_589246 = query.getOrDefault("pageSize")
  valid_589246 = validateParameter(valid_589246, JInt, required = false, default = nil)
  if valid_589246 != nil:
    section.add "pageSize", valid_589246
  var valid_589247 = query.getOrDefault("prettyPrint")
  valid_589247 = validateParameter(valid_589247, JBool, required = false,
                                 default = newJBool(true))
  if valid_589247 != nil:
    section.add "prettyPrint", valid_589247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589248: Call_SpannerProjectsInstanceConfigsList_589231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the supported instance configurations for a given project.
  ## 
  let valid = call_589248.validator(path, query, header, formData, body)
  let scheme = call_589248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589248.url(scheme.get, call_589248.host, call_589248.base,
                         call_589248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589248, url, valid)

proc call*(call_589249: Call_SpannerProjectsInstanceConfigsList_589231;
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
  var path_589250 = newJObject()
  var query_589251 = newJObject()
  add(query_589251, "upload_protocol", newJString(uploadProtocol))
  add(query_589251, "fields", newJString(fields))
  add(query_589251, "pageToken", newJString(pageToken))
  add(query_589251, "quotaUser", newJString(quotaUser))
  add(query_589251, "alt", newJString(alt))
  add(query_589251, "oauth_token", newJString(oauthToken))
  add(query_589251, "callback", newJString(callback))
  add(query_589251, "access_token", newJString(accessToken))
  add(query_589251, "uploadType", newJString(uploadType))
  add(path_589250, "parent", newJString(parent))
  add(query_589251, "key", newJString(key))
  add(query_589251, "$.xgafv", newJString(Xgafv))
  add(query_589251, "pageSize", newJInt(pageSize))
  add(query_589251, "prettyPrint", newJBool(prettyPrint))
  result = call_589249.call(path_589250, query_589251, nil, nil, nil)

var spannerProjectsInstanceConfigsList* = Call_SpannerProjectsInstanceConfigsList_589231(
    name: "spannerProjectsInstanceConfigsList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instanceConfigs",
    validator: validate_SpannerProjectsInstanceConfigsList_589232, base: "/",
    url: url_SpannerProjectsInstanceConfigsList_589233, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesCreate_589274 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesCreate_589276(protocol: Scheme; host: string;
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

proc validate_SpannerProjectsInstancesCreate_589275(path: JsonNode;
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
  var valid_589277 = path.getOrDefault("parent")
  valid_589277 = validateParameter(valid_589277, JString, required = true,
                                 default = nil)
  if valid_589277 != nil:
    section.add "parent", valid_589277
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
  var valid_589278 = query.getOrDefault("upload_protocol")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "upload_protocol", valid_589278
  var valid_589279 = query.getOrDefault("fields")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "fields", valid_589279
  var valid_589280 = query.getOrDefault("quotaUser")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "quotaUser", valid_589280
  var valid_589281 = query.getOrDefault("alt")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = newJString("json"))
  if valid_589281 != nil:
    section.add "alt", valid_589281
  var valid_589282 = query.getOrDefault("oauth_token")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "oauth_token", valid_589282
  var valid_589283 = query.getOrDefault("callback")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "callback", valid_589283
  var valid_589284 = query.getOrDefault("access_token")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "access_token", valid_589284
  var valid_589285 = query.getOrDefault("uploadType")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "uploadType", valid_589285
  var valid_589286 = query.getOrDefault("key")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "key", valid_589286
  var valid_589287 = query.getOrDefault("$.xgafv")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = newJString("1"))
  if valid_589287 != nil:
    section.add "$.xgafv", valid_589287
  var valid_589288 = query.getOrDefault("prettyPrint")
  valid_589288 = validateParameter(valid_589288, JBool, required = false,
                                 default = newJBool(true))
  if valid_589288 != nil:
    section.add "prettyPrint", valid_589288
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

proc call*(call_589290: Call_SpannerProjectsInstancesCreate_589274; path: JsonNode;
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
  let valid = call_589290.validator(path, query, header, formData, body)
  let scheme = call_589290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589290.url(scheme.get, call_589290.host, call_589290.base,
                         call_589290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589290, url, valid)

proc call*(call_589291: Call_SpannerProjectsInstancesCreate_589274; parent: string;
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
  var path_589292 = newJObject()
  var query_589293 = newJObject()
  var body_589294 = newJObject()
  add(query_589293, "upload_protocol", newJString(uploadProtocol))
  add(query_589293, "fields", newJString(fields))
  add(query_589293, "quotaUser", newJString(quotaUser))
  add(query_589293, "alt", newJString(alt))
  add(query_589293, "oauth_token", newJString(oauthToken))
  add(query_589293, "callback", newJString(callback))
  add(query_589293, "access_token", newJString(accessToken))
  add(query_589293, "uploadType", newJString(uploadType))
  add(path_589292, "parent", newJString(parent))
  add(query_589293, "key", newJString(key))
  add(query_589293, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589294 = body
  add(query_589293, "prettyPrint", newJBool(prettyPrint))
  result = call_589291.call(path_589292, query_589293, nil, nil, body_589294)

var spannerProjectsInstancesCreate* = Call_SpannerProjectsInstancesCreate_589274(
    name: "spannerProjectsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesCreate_589275, base: "/",
    url: url_SpannerProjectsInstancesCreate_589276, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesList_589252 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesList_589254(protocol: Scheme; host: string;
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

proc validate_SpannerProjectsInstancesList_589253(path: JsonNode; query: JsonNode;
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
  var valid_589255 = path.getOrDefault("parent")
  valid_589255 = validateParameter(valid_589255, JString, required = true,
                                 default = nil)
  if valid_589255 != nil:
    section.add "parent", valid_589255
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
  var valid_589256 = query.getOrDefault("upload_protocol")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "upload_protocol", valid_589256
  var valid_589257 = query.getOrDefault("fields")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "fields", valid_589257
  var valid_589258 = query.getOrDefault("pageToken")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "pageToken", valid_589258
  var valid_589259 = query.getOrDefault("quotaUser")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "quotaUser", valid_589259
  var valid_589260 = query.getOrDefault("alt")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("json"))
  if valid_589260 != nil:
    section.add "alt", valid_589260
  var valid_589261 = query.getOrDefault("oauth_token")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "oauth_token", valid_589261
  var valid_589262 = query.getOrDefault("callback")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "callback", valid_589262
  var valid_589263 = query.getOrDefault("access_token")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "access_token", valid_589263
  var valid_589264 = query.getOrDefault("uploadType")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "uploadType", valid_589264
  var valid_589265 = query.getOrDefault("key")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "key", valid_589265
  var valid_589266 = query.getOrDefault("$.xgafv")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("1"))
  if valid_589266 != nil:
    section.add "$.xgafv", valid_589266
  var valid_589267 = query.getOrDefault("pageSize")
  valid_589267 = validateParameter(valid_589267, JInt, required = false, default = nil)
  if valid_589267 != nil:
    section.add "pageSize", valid_589267
  var valid_589268 = query.getOrDefault("prettyPrint")
  valid_589268 = validateParameter(valid_589268, JBool, required = false,
                                 default = newJBool(true))
  if valid_589268 != nil:
    section.add "prettyPrint", valid_589268
  var valid_589269 = query.getOrDefault("filter")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "filter", valid_589269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589270: Call_SpannerProjectsInstancesList_589252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all instances in the given project.
  ## 
  let valid = call_589270.validator(path, query, header, formData, body)
  let scheme = call_589270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589270.url(scheme.get, call_589270.host, call_589270.base,
                         call_589270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589270, url, valid)

proc call*(call_589271: Call_SpannerProjectsInstancesList_589252; parent: string;
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
  var path_589272 = newJObject()
  var query_589273 = newJObject()
  add(query_589273, "upload_protocol", newJString(uploadProtocol))
  add(query_589273, "fields", newJString(fields))
  add(query_589273, "pageToken", newJString(pageToken))
  add(query_589273, "quotaUser", newJString(quotaUser))
  add(query_589273, "alt", newJString(alt))
  add(query_589273, "oauth_token", newJString(oauthToken))
  add(query_589273, "callback", newJString(callback))
  add(query_589273, "access_token", newJString(accessToken))
  add(query_589273, "uploadType", newJString(uploadType))
  add(path_589272, "parent", newJString(parent))
  add(query_589273, "key", newJString(key))
  add(query_589273, "$.xgafv", newJString(Xgafv))
  add(query_589273, "pageSize", newJInt(pageSize))
  add(query_589273, "prettyPrint", newJBool(prettyPrint))
  add(query_589273, "filter", newJString(filter))
  result = call_589271.call(path_589272, query_589273, nil, nil, nil)

var spannerProjectsInstancesList* = Call_SpannerProjectsInstancesList_589252(
    name: "spannerProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesList_589253, base: "/",
    url: url_SpannerProjectsInstancesList_589254, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetIamPolicy_589295 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesGetIamPolicy_589297(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesGetIamPolicy_589296(
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
  var valid_589298 = path.getOrDefault("resource")
  valid_589298 = validateParameter(valid_589298, JString, required = true,
                                 default = nil)
  if valid_589298 != nil:
    section.add "resource", valid_589298
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
  var valid_589299 = query.getOrDefault("upload_protocol")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "upload_protocol", valid_589299
  var valid_589300 = query.getOrDefault("fields")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "fields", valid_589300
  var valid_589301 = query.getOrDefault("quotaUser")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "quotaUser", valid_589301
  var valid_589302 = query.getOrDefault("alt")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = newJString("json"))
  if valid_589302 != nil:
    section.add "alt", valid_589302
  var valid_589303 = query.getOrDefault("oauth_token")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "oauth_token", valid_589303
  var valid_589304 = query.getOrDefault("callback")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "callback", valid_589304
  var valid_589305 = query.getOrDefault("access_token")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "access_token", valid_589305
  var valid_589306 = query.getOrDefault("uploadType")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "uploadType", valid_589306
  var valid_589307 = query.getOrDefault("key")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "key", valid_589307
  var valid_589308 = query.getOrDefault("$.xgafv")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = newJString("1"))
  if valid_589308 != nil:
    section.add "$.xgafv", valid_589308
  var valid_589309 = query.getOrDefault("prettyPrint")
  valid_589309 = validateParameter(valid_589309, JBool, required = false,
                                 default = newJBool(true))
  if valid_589309 != nil:
    section.add "prettyPrint", valid_589309
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

proc call*(call_589311: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_589295;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ## 
  let valid = call_589311.validator(path, query, header, formData, body)
  let scheme = call_589311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589311.url(scheme.get, call_589311.host, call_589311.base,
                         call_589311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589311, url, valid)

proc call*(call_589312: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_589295;
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
  var path_589313 = newJObject()
  var query_589314 = newJObject()
  var body_589315 = newJObject()
  add(query_589314, "upload_protocol", newJString(uploadProtocol))
  add(query_589314, "fields", newJString(fields))
  add(query_589314, "quotaUser", newJString(quotaUser))
  add(query_589314, "alt", newJString(alt))
  add(query_589314, "oauth_token", newJString(oauthToken))
  add(query_589314, "callback", newJString(callback))
  add(query_589314, "access_token", newJString(accessToken))
  add(query_589314, "uploadType", newJString(uploadType))
  add(query_589314, "key", newJString(key))
  add(query_589314, "$.xgafv", newJString(Xgafv))
  add(path_589313, "resource", newJString(resource))
  if body != nil:
    body_589315 = body
  add(query_589314, "prettyPrint", newJBool(prettyPrint))
  result = call_589312.call(path_589313, query_589314, nil, nil, body_589315)

var spannerProjectsInstancesDatabasesGetIamPolicy* = Call_SpannerProjectsInstancesDatabasesGetIamPolicy_589295(
    name: "spannerProjectsInstancesDatabasesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesGetIamPolicy_589296,
    base: "/", url: url_SpannerProjectsInstancesDatabasesGetIamPolicy_589297,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSetIamPolicy_589316 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSetIamPolicy_589318(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesSetIamPolicy_589317(
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
  var valid_589319 = path.getOrDefault("resource")
  valid_589319 = validateParameter(valid_589319, JString, required = true,
                                 default = nil)
  if valid_589319 != nil:
    section.add "resource", valid_589319
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
  var valid_589320 = query.getOrDefault("upload_protocol")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "upload_protocol", valid_589320
  var valid_589321 = query.getOrDefault("fields")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "fields", valid_589321
  var valid_589322 = query.getOrDefault("quotaUser")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "quotaUser", valid_589322
  var valid_589323 = query.getOrDefault("alt")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = newJString("json"))
  if valid_589323 != nil:
    section.add "alt", valid_589323
  var valid_589324 = query.getOrDefault("oauth_token")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "oauth_token", valid_589324
  var valid_589325 = query.getOrDefault("callback")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "callback", valid_589325
  var valid_589326 = query.getOrDefault("access_token")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "access_token", valid_589326
  var valid_589327 = query.getOrDefault("uploadType")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "uploadType", valid_589327
  var valid_589328 = query.getOrDefault("key")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "key", valid_589328
  var valid_589329 = query.getOrDefault("$.xgafv")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = newJString("1"))
  if valid_589329 != nil:
    section.add "$.xgafv", valid_589329
  var valid_589330 = query.getOrDefault("prettyPrint")
  valid_589330 = validateParameter(valid_589330, JBool, required = false,
                                 default = newJBool(true))
  if valid_589330 != nil:
    section.add "prettyPrint", valid_589330
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

proc call*(call_589332: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_589316;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ## 
  let valid = call_589332.validator(path, query, header, formData, body)
  let scheme = call_589332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589332.url(scheme.get, call_589332.host, call_589332.base,
                         call_589332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589332, url, valid)

proc call*(call_589333: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_589316;
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
  var path_589334 = newJObject()
  var query_589335 = newJObject()
  var body_589336 = newJObject()
  add(query_589335, "upload_protocol", newJString(uploadProtocol))
  add(query_589335, "fields", newJString(fields))
  add(query_589335, "quotaUser", newJString(quotaUser))
  add(query_589335, "alt", newJString(alt))
  add(query_589335, "oauth_token", newJString(oauthToken))
  add(query_589335, "callback", newJString(callback))
  add(query_589335, "access_token", newJString(accessToken))
  add(query_589335, "uploadType", newJString(uploadType))
  add(query_589335, "key", newJString(key))
  add(query_589335, "$.xgafv", newJString(Xgafv))
  add(path_589334, "resource", newJString(resource))
  if body != nil:
    body_589336 = body
  add(query_589335, "prettyPrint", newJBool(prettyPrint))
  result = call_589333.call(path_589334, query_589335, nil, nil, body_589336)

var spannerProjectsInstancesDatabasesSetIamPolicy* = Call_SpannerProjectsInstancesDatabasesSetIamPolicy_589316(
    name: "spannerProjectsInstancesDatabasesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesSetIamPolicy_589317,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSetIamPolicy_589318,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesTestIamPermissions_589337 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesTestIamPermissions_589339(
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

proc validate_SpannerProjectsInstancesDatabasesTestIamPermissions_589338(
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
  var valid_589340 = path.getOrDefault("resource")
  valid_589340 = validateParameter(valid_589340, JString, required = true,
                                 default = nil)
  if valid_589340 != nil:
    section.add "resource", valid_589340
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
  var valid_589341 = query.getOrDefault("upload_protocol")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "upload_protocol", valid_589341
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
  var valid_589346 = query.getOrDefault("callback")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "callback", valid_589346
  var valid_589347 = query.getOrDefault("access_token")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "access_token", valid_589347
  var valid_589348 = query.getOrDefault("uploadType")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "uploadType", valid_589348
  var valid_589349 = query.getOrDefault("key")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "key", valid_589349
  var valid_589350 = query.getOrDefault("$.xgafv")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = newJString("1"))
  if valid_589350 != nil:
    section.add "$.xgafv", valid_589350
  var valid_589351 = query.getOrDefault("prettyPrint")
  valid_589351 = validateParameter(valid_589351, JBool, required = false,
                                 default = newJBool(true))
  if valid_589351 != nil:
    section.add "prettyPrint", valid_589351
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

proc call*(call_589353: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_589337;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ## 
  let valid = call_589353.validator(path, query, header, formData, body)
  let scheme = call_589353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589353.url(scheme.get, call_589353.host, call_589353.base,
                         call_589353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589353, url, valid)

proc call*(call_589354: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_589337;
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
  var path_589355 = newJObject()
  var query_589356 = newJObject()
  var body_589357 = newJObject()
  add(query_589356, "upload_protocol", newJString(uploadProtocol))
  add(query_589356, "fields", newJString(fields))
  add(query_589356, "quotaUser", newJString(quotaUser))
  add(query_589356, "alt", newJString(alt))
  add(query_589356, "oauth_token", newJString(oauthToken))
  add(query_589356, "callback", newJString(callback))
  add(query_589356, "access_token", newJString(accessToken))
  add(query_589356, "uploadType", newJString(uploadType))
  add(query_589356, "key", newJString(key))
  add(query_589356, "$.xgafv", newJString(Xgafv))
  add(path_589355, "resource", newJString(resource))
  if body != nil:
    body_589357 = body
  add(query_589356, "prettyPrint", newJBool(prettyPrint))
  result = call_589354.call(path_589355, query_589356, nil, nil, body_589357)

var spannerProjectsInstancesDatabasesTestIamPermissions* = Call_SpannerProjectsInstancesDatabasesTestIamPermissions_589337(
    name: "spannerProjectsInstancesDatabasesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_SpannerProjectsInstancesDatabasesTestIamPermissions_589338,
    base: "/", url: url_SpannerProjectsInstancesDatabasesTestIamPermissions_589339,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_589358 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_589360(
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

proc validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_589359(
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
  var valid_589361 = path.getOrDefault("session")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "session", valid_589361
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
  var valid_589362 = query.getOrDefault("upload_protocol")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "upload_protocol", valid_589362
  var valid_589363 = query.getOrDefault("fields")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "fields", valid_589363
  var valid_589364 = query.getOrDefault("quotaUser")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "quotaUser", valid_589364
  var valid_589365 = query.getOrDefault("alt")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = newJString("json"))
  if valid_589365 != nil:
    section.add "alt", valid_589365
  var valid_589366 = query.getOrDefault("oauth_token")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "oauth_token", valid_589366
  var valid_589367 = query.getOrDefault("callback")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "callback", valid_589367
  var valid_589368 = query.getOrDefault("access_token")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "access_token", valid_589368
  var valid_589369 = query.getOrDefault("uploadType")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "uploadType", valid_589369
  var valid_589370 = query.getOrDefault("key")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "key", valid_589370
  var valid_589371 = query.getOrDefault("$.xgafv")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = newJString("1"))
  if valid_589371 != nil:
    section.add "$.xgafv", valid_589371
  var valid_589372 = query.getOrDefault("prettyPrint")
  valid_589372 = validateParameter(valid_589372, JBool, required = false,
                                 default = newJBool(true))
  if valid_589372 != nil:
    section.add "prettyPrint", valid_589372
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

proc call*(call_589374: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_589358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ## 
  let valid = call_589374.validator(path, query, header, formData, body)
  let scheme = call_589374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589374.url(scheme.get, call_589374.host, call_589374.base,
                         call_589374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589374, url, valid)

proc call*(call_589375: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_589358;
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
  var path_589376 = newJObject()
  var query_589377 = newJObject()
  var body_589378 = newJObject()
  add(query_589377, "upload_protocol", newJString(uploadProtocol))
  add(path_589376, "session", newJString(session))
  add(query_589377, "fields", newJString(fields))
  add(query_589377, "quotaUser", newJString(quotaUser))
  add(query_589377, "alt", newJString(alt))
  add(query_589377, "oauth_token", newJString(oauthToken))
  add(query_589377, "callback", newJString(callback))
  add(query_589377, "access_token", newJString(accessToken))
  add(query_589377, "uploadType", newJString(uploadType))
  add(query_589377, "key", newJString(key))
  add(query_589377, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589378 = body
  add(query_589377, "prettyPrint", newJBool(prettyPrint))
  result = call_589375.call(path_589376, query_589377, nil, nil, body_589378)

var spannerProjectsInstancesDatabasesSessionsBeginTransaction* = Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_589358(
    name: "spannerProjectsInstancesDatabasesSessionsBeginTransaction",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:beginTransaction", validator: validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_589359,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_589360,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCommit_589379 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsCommit_589381(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesSessionsCommit_589380(
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
  var valid_589382 = path.getOrDefault("session")
  valid_589382 = validateParameter(valid_589382, JString, required = true,
                                 default = nil)
  if valid_589382 != nil:
    section.add "session", valid_589382
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
  var valid_589383 = query.getOrDefault("upload_protocol")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "upload_protocol", valid_589383
  var valid_589384 = query.getOrDefault("fields")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "fields", valid_589384
  var valid_589385 = query.getOrDefault("quotaUser")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "quotaUser", valid_589385
  var valid_589386 = query.getOrDefault("alt")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = newJString("json"))
  if valid_589386 != nil:
    section.add "alt", valid_589386
  var valid_589387 = query.getOrDefault("oauth_token")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "oauth_token", valid_589387
  var valid_589388 = query.getOrDefault("callback")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "callback", valid_589388
  var valid_589389 = query.getOrDefault("access_token")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "access_token", valid_589389
  var valid_589390 = query.getOrDefault("uploadType")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "uploadType", valid_589390
  var valid_589391 = query.getOrDefault("key")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "key", valid_589391
  var valid_589392 = query.getOrDefault("$.xgafv")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = newJString("1"))
  if valid_589392 != nil:
    section.add "$.xgafv", valid_589392
  var valid_589393 = query.getOrDefault("prettyPrint")
  valid_589393 = validateParameter(valid_589393, JBool, required = false,
                                 default = newJBool(true))
  if valid_589393 != nil:
    section.add "prettyPrint", valid_589393
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

proc call*(call_589395: Call_SpannerProjectsInstancesDatabasesSessionsCommit_589379;
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
  let valid = call_589395.validator(path, query, header, formData, body)
  let scheme = call_589395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589395.url(scheme.get, call_589395.host, call_589395.base,
                         call_589395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589395, url, valid)

proc call*(call_589396: Call_SpannerProjectsInstancesDatabasesSessionsCommit_589379;
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
  var path_589397 = newJObject()
  var query_589398 = newJObject()
  var body_589399 = newJObject()
  add(query_589398, "upload_protocol", newJString(uploadProtocol))
  add(path_589397, "session", newJString(session))
  add(query_589398, "fields", newJString(fields))
  add(query_589398, "quotaUser", newJString(quotaUser))
  add(query_589398, "alt", newJString(alt))
  add(query_589398, "oauth_token", newJString(oauthToken))
  add(query_589398, "callback", newJString(callback))
  add(query_589398, "access_token", newJString(accessToken))
  add(query_589398, "uploadType", newJString(uploadType))
  add(query_589398, "key", newJString(key))
  add(query_589398, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589399 = body
  add(query_589398, "prettyPrint", newJBool(prettyPrint))
  result = call_589396.call(path_589397, query_589398, nil, nil, body_589399)

var spannerProjectsInstancesDatabasesSessionsCommit* = Call_SpannerProjectsInstancesDatabasesSessionsCommit_589379(
    name: "spannerProjectsInstancesDatabasesSessionsCommit",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:commit",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCommit_589380,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCommit_589381,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_589400 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_589402(
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

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_589401(
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
  var valid_589403 = path.getOrDefault("session")
  valid_589403 = validateParameter(valid_589403, JString, required = true,
                                 default = nil)
  if valid_589403 != nil:
    section.add "session", valid_589403
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
  var valid_589404 = query.getOrDefault("upload_protocol")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "upload_protocol", valid_589404
  var valid_589405 = query.getOrDefault("fields")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "fields", valid_589405
  var valid_589406 = query.getOrDefault("quotaUser")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "quotaUser", valid_589406
  var valid_589407 = query.getOrDefault("alt")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = newJString("json"))
  if valid_589407 != nil:
    section.add "alt", valid_589407
  var valid_589408 = query.getOrDefault("oauth_token")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "oauth_token", valid_589408
  var valid_589409 = query.getOrDefault("callback")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "callback", valid_589409
  var valid_589410 = query.getOrDefault("access_token")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "access_token", valid_589410
  var valid_589411 = query.getOrDefault("uploadType")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "uploadType", valid_589411
  var valid_589412 = query.getOrDefault("key")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "key", valid_589412
  var valid_589413 = query.getOrDefault("$.xgafv")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = newJString("1"))
  if valid_589413 != nil:
    section.add "$.xgafv", valid_589413
  var valid_589414 = query.getOrDefault("prettyPrint")
  valid_589414 = validateParameter(valid_589414, JBool, required = false,
                                 default = newJBool(true))
  if valid_589414 != nil:
    section.add "prettyPrint", valid_589414
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

proc call*(call_589416: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_589400;
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
  let valid = call_589416.validator(path, query, header, formData, body)
  let scheme = call_589416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589416.url(scheme.get, call_589416.host, call_589416.base,
                         call_589416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589416, url, valid)

proc call*(call_589417: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_589400;
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
  var path_589418 = newJObject()
  var query_589419 = newJObject()
  var body_589420 = newJObject()
  add(query_589419, "upload_protocol", newJString(uploadProtocol))
  add(path_589418, "session", newJString(session))
  add(query_589419, "fields", newJString(fields))
  add(query_589419, "quotaUser", newJString(quotaUser))
  add(query_589419, "alt", newJString(alt))
  add(query_589419, "oauth_token", newJString(oauthToken))
  add(query_589419, "callback", newJString(callback))
  add(query_589419, "access_token", newJString(accessToken))
  add(query_589419, "uploadType", newJString(uploadType))
  add(query_589419, "key", newJString(key))
  add(query_589419, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589420 = body
  add(query_589419, "prettyPrint", newJBool(prettyPrint))
  result = call_589417.call(path_589418, query_589419, nil, nil, body_589420)

var spannerProjectsInstancesDatabasesSessionsExecuteBatchDml* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_589400(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteBatchDml",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeBatchDml", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_589401,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_589402,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_589421 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_589423(
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

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_589422(
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
  var valid_589424 = path.getOrDefault("session")
  valid_589424 = validateParameter(valid_589424, JString, required = true,
                                 default = nil)
  if valid_589424 != nil:
    section.add "session", valid_589424
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
  var valid_589425 = query.getOrDefault("upload_protocol")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "upload_protocol", valid_589425
  var valid_589426 = query.getOrDefault("fields")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "fields", valid_589426
  var valid_589427 = query.getOrDefault("quotaUser")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = nil)
  if valid_589427 != nil:
    section.add "quotaUser", valid_589427
  var valid_589428 = query.getOrDefault("alt")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = newJString("json"))
  if valid_589428 != nil:
    section.add "alt", valid_589428
  var valid_589429 = query.getOrDefault("oauth_token")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "oauth_token", valid_589429
  var valid_589430 = query.getOrDefault("callback")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "callback", valid_589430
  var valid_589431 = query.getOrDefault("access_token")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "access_token", valid_589431
  var valid_589432 = query.getOrDefault("uploadType")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "uploadType", valid_589432
  var valid_589433 = query.getOrDefault("key")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "key", valid_589433
  var valid_589434 = query.getOrDefault("$.xgafv")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = newJString("1"))
  if valid_589434 != nil:
    section.add "$.xgafv", valid_589434
  var valid_589435 = query.getOrDefault("prettyPrint")
  valid_589435 = validateParameter(valid_589435, JBool, required = false,
                                 default = newJBool(true))
  if valid_589435 != nil:
    section.add "prettyPrint", valid_589435
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

proc call*(call_589437: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_589421;
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
  let valid = call_589437.validator(path, query, header, formData, body)
  let scheme = call_589437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589437.url(scheme.get, call_589437.host, call_589437.base,
                         call_589437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589437, url, valid)

proc call*(call_589438: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_589421;
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
  var path_589439 = newJObject()
  var query_589440 = newJObject()
  var body_589441 = newJObject()
  add(query_589440, "upload_protocol", newJString(uploadProtocol))
  add(path_589439, "session", newJString(session))
  add(query_589440, "fields", newJString(fields))
  add(query_589440, "quotaUser", newJString(quotaUser))
  add(query_589440, "alt", newJString(alt))
  add(query_589440, "oauth_token", newJString(oauthToken))
  add(query_589440, "callback", newJString(callback))
  add(query_589440, "access_token", newJString(accessToken))
  add(query_589440, "uploadType", newJString(uploadType))
  add(query_589440, "key", newJString(key))
  add(query_589440, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589441 = body
  add(query_589440, "prettyPrint", newJBool(prettyPrint))
  result = call_589438.call(path_589439, query_589440, nil, nil, body_589441)

var spannerProjectsInstancesDatabasesSessionsExecuteSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_589421(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeSql",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_589422,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_589423,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_589442 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_589444(
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

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_589443(
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
  var valid_589445 = path.getOrDefault("session")
  valid_589445 = validateParameter(valid_589445, JString, required = true,
                                 default = nil)
  if valid_589445 != nil:
    section.add "session", valid_589445
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
  var valid_589446 = query.getOrDefault("upload_protocol")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "upload_protocol", valid_589446
  var valid_589447 = query.getOrDefault("fields")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "fields", valid_589447
  var valid_589448 = query.getOrDefault("quotaUser")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = nil)
  if valid_589448 != nil:
    section.add "quotaUser", valid_589448
  var valid_589449 = query.getOrDefault("alt")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = newJString("json"))
  if valid_589449 != nil:
    section.add "alt", valid_589449
  var valid_589450 = query.getOrDefault("oauth_token")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "oauth_token", valid_589450
  var valid_589451 = query.getOrDefault("callback")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "callback", valid_589451
  var valid_589452 = query.getOrDefault("access_token")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "access_token", valid_589452
  var valid_589453 = query.getOrDefault("uploadType")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "uploadType", valid_589453
  var valid_589454 = query.getOrDefault("key")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "key", valid_589454
  var valid_589455 = query.getOrDefault("$.xgafv")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = newJString("1"))
  if valid_589455 != nil:
    section.add "$.xgafv", valid_589455
  var valid_589456 = query.getOrDefault("prettyPrint")
  valid_589456 = validateParameter(valid_589456, JBool, required = false,
                                 default = newJBool(true))
  if valid_589456 != nil:
    section.add "prettyPrint", valid_589456
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

proc call*(call_589458: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_589442;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ## 
  let valid = call_589458.validator(path, query, header, formData, body)
  let scheme = call_589458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589458.url(scheme.get, call_589458.host, call_589458.base,
                         call_589458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589458, url, valid)

proc call*(call_589459: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_589442;
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
  var path_589460 = newJObject()
  var query_589461 = newJObject()
  var body_589462 = newJObject()
  add(query_589461, "upload_protocol", newJString(uploadProtocol))
  add(path_589460, "session", newJString(session))
  add(query_589461, "fields", newJString(fields))
  add(query_589461, "quotaUser", newJString(quotaUser))
  add(query_589461, "alt", newJString(alt))
  add(query_589461, "oauth_token", newJString(oauthToken))
  add(query_589461, "callback", newJString(callback))
  add(query_589461, "access_token", newJString(accessToken))
  add(query_589461, "uploadType", newJString(uploadType))
  add(query_589461, "key", newJString(key))
  add(query_589461, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589462 = body
  add(query_589461, "prettyPrint", newJBool(prettyPrint))
  result = call_589459.call(path_589460, query_589461, nil, nil, body_589462)

var spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_589442(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeStreamingSql", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_589443,
    base: "/",
    url: url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_589444,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_589463 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_589465(
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

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_589464(
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
  var valid_589466 = path.getOrDefault("session")
  valid_589466 = validateParameter(valid_589466, JString, required = true,
                                 default = nil)
  if valid_589466 != nil:
    section.add "session", valid_589466
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
  var valid_589467 = query.getOrDefault("upload_protocol")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "upload_protocol", valid_589467
  var valid_589468 = query.getOrDefault("fields")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "fields", valid_589468
  var valid_589469 = query.getOrDefault("quotaUser")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "quotaUser", valid_589469
  var valid_589470 = query.getOrDefault("alt")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = newJString("json"))
  if valid_589470 != nil:
    section.add "alt", valid_589470
  var valid_589471 = query.getOrDefault("oauth_token")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "oauth_token", valid_589471
  var valid_589472 = query.getOrDefault("callback")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "callback", valid_589472
  var valid_589473 = query.getOrDefault("access_token")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "access_token", valid_589473
  var valid_589474 = query.getOrDefault("uploadType")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "uploadType", valid_589474
  var valid_589475 = query.getOrDefault("key")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "key", valid_589475
  var valid_589476 = query.getOrDefault("$.xgafv")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = newJString("1"))
  if valid_589476 != nil:
    section.add "$.xgafv", valid_589476
  var valid_589477 = query.getOrDefault("prettyPrint")
  valid_589477 = validateParameter(valid_589477, JBool, required = false,
                                 default = newJBool(true))
  if valid_589477 != nil:
    section.add "prettyPrint", valid_589477
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

proc call*(call_589479: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_589463;
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
  let valid = call_589479.validator(path, query, header, formData, body)
  let scheme = call_589479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589479.url(scheme.get, call_589479.host, call_589479.base,
                         call_589479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589479, url, valid)

proc call*(call_589480: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_589463;
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
  var path_589481 = newJObject()
  var query_589482 = newJObject()
  var body_589483 = newJObject()
  add(query_589482, "upload_protocol", newJString(uploadProtocol))
  add(path_589481, "session", newJString(session))
  add(query_589482, "fields", newJString(fields))
  add(query_589482, "quotaUser", newJString(quotaUser))
  add(query_589482, "alt", newJString(alt))
  add(query_589482, "oauth_token", newJString(oauthToken))
  add(query_589482, "callback", newJString(callback))
  add(query_589482, "access_token", newJString(accessToken))
  add(query_589482, "uploadType", newJString(uploadType))
  add(query_589482, "key", newJString(key))
  add(query_589482, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589483 = body
  add(query_589482, "prettyPrint", newJBool(prettyPrint))
  result = call_589480.call(path_589481, query_589482, nil, nil, body_589483)

var spannerProjectsInstancesDatabasesSessionsPartitionQuery* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_589463(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionQuery",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionQuery", validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_589464,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_589465,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_589484 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_589486(
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

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_589485(
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
  var valid_589487 = path.getOrDefault("session")
  valid_589487 = validateParameter(valid_589487, JString, required = true,
                                 default = nil)
  if valid_589487 != nil:
    section.add "session", valid_589487
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
  var valid_589488 = query.getOrDefault("upload_protocol")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = nil)
  if valid_589488 != nil:
    section.add "upload_protocol", valid_589488
  var valid_589489 = query.getOrDefault("fields")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "fields", valid_589489
  var valid_589490 = query.getOrDefault("quotaUser")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "quotaUser", valid_589490
  var valid_589491 = query.getOrDefault("alt")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = newJString("json"))
  if valid_589491 != nil:
    section.add "alt", valid_589491
  var valid_589492 = query.getOrDefault("oauth_token")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = nil)
  if valid_589492 != nil:
    section.add "oauth_token", valid_589492
  var valid_589493 = query.getOrDefault("callback")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "callback", valid_589493
  var valid_589494 = query.getOrDefault("access_token")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "access_token", valid_589494
  var valid_589495 = query.getOrDefault("uploadType")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "uploadType", valid_589495
  var valid_589496 = query.getOrDefault("key")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "key", valid_589496
  var valid_589497 = query.getOrDefault("$.xgafv")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = newJString("1"))
  if valid_589497 != nil:
    section.add "$.xgafv", valid_589497
  var valid_589498 = query.getOrDefault("prettyPrint")
  valid_589498 = validateParameter(valid_589498, JBool, required = false,
                                 default = newJBool(true))
  if valid_589498 != nil:
    section.add "prettyPrint", valid_589498
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

proc call*(call_589500: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_589484;
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
  let valid = call_589500.validator(path, query, header, formData, body)
  let scheme = call_589500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589500.url(scheme.get, call_589500.host, call_589500.base,
                         call_589500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589500, url, valid)

proc call*(call_589501: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_589484;
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
  var path_589502 = newJObject()
  var query_589503 = newJObject()
  var body_589504 = newJObject()
  add(query_589503, "upload_protocol", newJString(uploadProtocol))
  add(path_589502, "session", newJString(session))
  add(query_589503, "fields", newJString(fields))
  add(query_589503, "quotaUser", newJString(quotaUser))
  add(query_589503, "alt", newJString(alt))
  add(query_589503, "oauth_token", newJString(oauthToken))
  add(query_589503, "callback", newJString(callback))
  add(query_589503, "access_token", newJString(accessToken))
  add(query_589503, "uploadType", newJString(uploadType))
  add(query_589503, "key", newJString(key))
  add(query_589503, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589504 = body
  add(query_589503, "prettyPrint", newJBool(prettyPrint))
  result = call_589501.call(path_589502, query_589503, nil, nil, body_589504)

var spannerProjectsInstancesDatabasesSessionsPartitionRead* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_589484(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_589485,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_589486,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRead_589505 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsRead_589507(protocol: Scheme;
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

proc validate_SpannerProjectsInstancesDatabasesSessionsRead_589506(
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
  var valid_589508 = path.getOrDefault("session")
  valid_589508 = validateParameter(valid_589508, JString, required = true,
                                 default = nil)
  if valid_589508 != nil:
    section.add "session", valid_589508
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
  var valid_589509 = query.getOrDefault("upload_protocol")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "upload_protocol", valid_589509
  var valid_589510 = query.getOrDefault("fields")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "fields", valid_589510
  var valid_589511 = query.getOrDefault("quotaUser")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "quotaUser", valid_589511
  var valid_589512 = query.getOrDefault("alt")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = newJString("json"))
  if valid_589512 != nil:
    section.add "alt", valid_589512
  var valid_589513 = query.getOrDefault("oauth_token")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "oauth_token", valid_589513
  var valid_589514 = query.getOrDefault("callback")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = nil)
  if valid_589514 != nil:
    section.add "callback", valid_589514
  var valid_589515 = query.getOrDefault("access_token")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "access_token", valid_589515
  var valid_589516 = query.getOrDefault("uploadType")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "uploadType", valid_589516
  var valid_589517 = query.getOrDefault("key")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "key", valid_589517
  var valid_589518 = query.getOrDefault("$.xgafv")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = newJString("1"))
  if valid_589518 != nil:
    section.add "$.xgafv", valid_589518
  var valid_589519 = query.getOrDefault("prettyPrint")
  valid_589519 = validateParameter(valid_589519, JBool, required = false,
                                 default = newJBool(true))
  if valid_589519 != nil:
    section.add "prettyPrint", valid_589519
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

proc call*(call_589521: Call_SpannerProjectsInstancesDatabasesSessionsRead_589505;
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
  let valid = call_589521.validator(path, query, header, formData, body)
  let scheme = call_589521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589521.url(scheme.get, call_589521.host, call_589521.base,
                         call_589521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589521, url, valid)

proc call*(call_589522: Call_SpannerProjectsInstancesDatabasesSessionsRead_589505;
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
  var path_589523 = newJObject()
  var query_589524 = newJObject()
  var body_589525 = newJObject()
  add(query_589524, "upload_protocol", newJString(uploadProtocol))
  add(path_589523, "session", newJString(session))
  add(query_589524, "fields", newJString(fields))
  add(query_589524, "quotaUser", newJString(quotaUser))
  add(query_589524, "alt", newJString(alt))
  add(query_589524, "oauth_token", newJString(oauthToken))
  add(query_589524, "callback", newJString(callback))
  add(query_589524, "access_token", newJString(accessToken))
  add(query_589524, "uploadType", newJString(uploadType))
  add(query_589524, "key", newJString(key))
  add(query_589524, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589525 = body
  add(query_589524, "prettyPrint", newJBool(prettyPrint))
  result = call_589522.call(path_589523, query_589524, nil, nil, body_589525)

var spannerProjectsInstancesDatabasesSessionsRead* = Call_SpannerProjectsInstancesDatabasesSessionsRead_589505(
    name: "spannerProjectsInstancesDatabasesSessionsRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:read",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRead_589506,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRead_589507,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRollback_589526 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsRollback_589528(
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

proc validate_SpannerProjectsInstancesDatabasesSessionsRollback_589527(
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
  var valid_589529 = path.getOrDefault("session")
  valid_589529 = validateParameter(valid_589529, JString, required = true,
                                 default = nil)
  if valid_589529 != nil:
    section.add "session", valid_589529
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
  var valid_589530 = query.getOrDefault("upload_protocol")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = nil)
  if valid_589530 != nil:
    section.add "upload_protocol", valid_589530
  var valid_589531 = query.getOrDefault("fields")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "fields", valid_589531
  var valid_589532 = query.getOrDefault("quotaUser")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = nil)
  if valid_589532 != nil:
    section.add "quotaUser", valid_589532
  var valid_589533 = query.getOrDefault("alt")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = newJString("json"))
  if valid_589533 != nil:
    section.add "alt", valid_589533
  var valid_589534 = query.getOrDefault("oauth_token")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "oauth_token", valid_589534
  var valid_589535 = query.getOrDefault("callback")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = nil)
  if valid_589535 != nil:
    section.add "callback", valid_589535
  var valid_589536 = query.getOrDefault("access_token")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "access_token", valid_589536
  var valid_589537 = query.getOrDefault("uploadType")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "uploadType", valid_589537
  var valid_589538 = query.getOrDefault("key")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "key", valid_589538
  var valid_589539 = query.getOrDefault("$.xgafv")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = newJString("1"))
  if valid_589539 != nil:
    section.add "$.xgafv", valid_589539
  var valid_589540 = query.getOrDefault("prettyPrint")
  valid_589540 = validateParameter(valid_589540, JBool, required = false,
                                 default = newJBool(true))
  if valid_589540 != nil:
    section.add "prettyPrint", valid_589540
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

proc call*(call_589542: Call_SpannerProjectsInstancesDatabasesSessionsRollback_589526;
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
  let valid = call_589542.validator(path, query, header, formData, body)
  let scheme = call_589542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589542.url(scheme.get, call_589542.host, call_589542.base,
                         call_589542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589542, url, valid)

proc call*(call_589543: Call_SpannerProjectsInstancesDatabasesSessionsRollback_589526;
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
  var path_589544 = newJObject()
  var query_589545 = newJObject()
  var body_589546 = newJObject()
  add(query_589545, "upload_protocol", newJString(uploadProtocol))
  add(path_589544, "session", newJString(session))
  add(query_589545, "fields", newJString(fields))
  add(query_589545, "quotaUser", newJString(quotaUser))
  add(query_589545, "alt", newJString(alt))
  add(query_589545, "oauth_token", newJString(oauthToken))
  add(query_589545, "callback", newJString(callback))
  add(query_589545, "access_token", newJString(accessToken))
  add(query_589545, "uploadType", newJString(uploadType))
  add(query_589545, "key", newJString(key))
  add(query_589545, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589546 = body
  add(query_589545, "prettyPrint", newJBool(prettyPrint))
  result = call_589543.call(path_589544, query_589545, nil, nil, body_589546)

var spannerProjectsInstancesDatabasesSessionsRollback* = Call_SpannerProjectsInstancesDatabasesSessionsRollback_589526(
    name: "spannerProjectsInstancesDatabasesSessionsRollback",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:rollback",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRollback_589527,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRollback_589528,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_589547 = ref object of OpenApiRestCall_588450
proc url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_589549(
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

proc validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_589548(
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
  var valid_589550 = path.getOrDefault("session")
  valid_589550 = validateParameter(valid_589550, JString, required = true,
                                 default = nil)
  if valid_589550 != nil:
    section.add "session", valid_589550
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
  var valid_589551 = query.getOrDefault("upload_protocol")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "upload_protocol", valid_589551
  var valid_589552 = query.getOrDefault("fields")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "fields", valid_589552
  var valid_589553 = query.getOrDefault("quotaUser")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "quotaUser", valid_589553
  var valid_589554 = query.getOrDefault("alt")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = newJString("json"))
  if valid_589554 != nil:
    section.add "alt", valid_589554
  var valid_589555 = query.getOrDefault("oauth_token")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = nil)
  if valid_589555 != nil:
    section.add "oauth_token", valid_589555
  var valid_589556 = query.getOrDefault("callback")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "callback", valid_589556
  var valid_589557 = query.getOrDefault("access_token")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "access_token", valid_589557
  var valid_589558 = query.getOrDefault("uploadType")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "uploadType", valid_589558
  var valid_589559 = query.getOrDefault("key")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "key", valid_589559
  var valid_589560 = query.getOrDefault("$.xgafv")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = newJString("1"))
  if valid_589560 != nil:
    section.add "$.xgafv", valid_589560
  var valid_589561 = query.getOrDefault("prettyPrint")
  valid_589561 = validateParameter(valid_589561, JBool, required = false,
                                 default = newJBool(true))
  if valid_589561 != nil:
    section.add "prettyPrint", valid_589561
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

proc call*(call_589563: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_589547;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ## 
  let valid = call_589563.validator(path, query, header, formData, body)
  let scheme = call_589563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589563.url(scheme.get, call_589563.host, call_589563.base,
                         call_589563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589563, url, valid)

proc call*(call_589564: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_589547;
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
  var path_589565 = newJObject()
  var query_589566 = newJObject()
  var body_589567 = newJObject()
  add(query_589566, "upload_protocol", newJString(uploadProtocol))
  add(path_589565, "session", newJString(session))
  add(query_589566, "fields", newJString(fields))
  add(query_589566, "quotaUser", newJString(quotaUser))
  add(query_589566, "alt", newJString(alt))
  add(query_589566, "oauth_token", newJString(oauthToken))
  add(query_589566, "callback", newJString(callback))
  add(query_589566, "access_token", newJString(accessToken))
  add(query_589566, "uploadType", newJString(uploadType))
  add(query_589566, "key", newJString(key))
  add(query_589566, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589567 = body
  add(query_589566, "prettyPrint", newJBool(prettyPrint))
  result = call_589564.call(path_589565, query_589566, nil, nil, body_589567)

var spannerProjectsInstancesDatabasesSessionsStreamingRead* = Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_589547(
    name: "spannerProjectsInstancesDatabasesSessionsStreamingRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:streamingRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_589548,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_589549,
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
