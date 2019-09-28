
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Bigtable Admin
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Administer your Cloud Bigtable tables and instances.
## 
## https://cloud.google.com/bigtable/
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
  gcpServiceName = "bigtableadmin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigtableadminProjectsInstancesClustersUpdate_579979 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesClustersUpdate_579981(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersUpdate_579980(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a cluster within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : (`OutputOnly`)
  ## The unique name of the cluster. Values are of the form
  ## `projects/<project>/instances/<instance>/clusters/a-z*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579982 = path.getOrDefault("name")
  valid_579982 = validateParameter(valid_579982, JString, required = true,
                                 default = nil)
  if valid_579982 != nil:
    section.add "name", valid_579982
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
  var valid_579983 = query.getOrDefault("upload_protocol")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "upload_protocol", valid_579983
  var valid_579984 = query.getOrDefault("fields")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "fields", valid_579984
  var valid_579985 = query.getOrDefault("quotaUser")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "quotaUser", valid_579985
  var valid_579986 = query.getOrDefault("alt")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("json"))
  if valid_579986 != nil:
    section.add "alt", valid_579986
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("callback")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "callback", valid_579988
  var valid_579989 = query.getOrDefault("access_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "access_token", valid_579989
  var valid_579990 = query.getOrDefault("uploadType")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "uploadType", valid_579990
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("$.xgafv")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("1"))
  if valid_579992 != nil:
    section.add "$.xgafv", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
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

proc call*(call_579995: Call_BigtableadminProjectsInstancesClustersUpdate_579979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster within an instance.
  ## 
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_BigtableadminProjectsInstancesClustersUpdate_579979;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesClustersUpdate
  ## Updates a cluster within an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : (`OutputOnly`)
  ## The unique name of the cluster. Values are of the form
  ## `projects/<project>/instances/<instance>/clusters/a-z*`.
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
  var path_579997 = newJObject()
  var query_579998 = newJObject()
  var body_579999 = newJObject()
  add(query_579998, "upload_protocol", newJString(uploadProtocol))
  add(query_579998, "fields", newJString(fields))
  add(query_579998, "quotaUser", newJString(quotaUser))
  add(path_579997, "name", newJString(name))
  add(query_579998, "alt", newJString(alt))
  add(query_579998, "oauth_token", newJString(oauthToken))
  add(query_579998, "callback", newJString(callback))
  add(query_579998, "access_token", newJString(accessToken))
  add(query_579998, "uploadType", newJString(uploadType))
  add(query_579998, "key", newJString(key))
  add(query_579998, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579999 = body
  add(query_579998, "prettyPrint", newJBool(prettyPrint))
  result = call_579996.call(path_579997, query_579998, nil, nil, body_579999)

var bigtableadminProjectsInstancesClustersUpdate* = Call_BigtableadminProjectsInstancesClustersUpdate_579979(
    name: "bigtableadminProjectsInstancesClustersUpdate",
    meth: HttpMethod.HttpPut, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}",
    validator: validate_BigtableadminProjectsInstancesClustersUpdate_579980,
    base: "/", url: url_BigtableadminProjectsInstancesClustersUpdate_579981,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsGet_579690 = ref object of OpenApiRestCall_579421
proc url_BigtableadminOperationsGet_579692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsGet_579691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579818 = path.getOrDefault("name")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "name", valid_579818
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The view to be applied to the returned table's fields.
  ## Defaults to `SCHEMA_VIEW` if unspecified.
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
  var valid_579834 = query.getOrDefault("view")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_579834 != nil:
    section.add "view", valid_579834
  var valid_579835 = query.getOrDefault("quotaUser")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "quotaUser", valid_579835
  var valid_579836 = query.getOrDefault("alt")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = newJString("json"))
  if valid_579836 != nil:
    section.add "alt", valid_579836
  var valid_579837 = query.getOrDefault("oauth_token")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "oauth_token", valid_579837
  var valid_579838 = query.getOrDefault("callback")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "callback", valid_579838
  var valid_579839 = query.getOrDefault("access_token")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "access_token", valid_579839
  var valid_579840 = query.getOrDefault("uploadType")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "uploadType", valid_579840
  var valid_579841 = query.getOrDefault("key")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "key", valid_579841
  var valid_579842 = query.getOrDefault("$.xgafv")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = newJString("1"))
  if valid_579842 != nil:
    section.add "$.xgafv", valid_579842
  var valid_579843 = query.getOrDefault("prettyPrint")
  valid_579843 = validateParameter(valid_579843, JBool, required = false,
                                 default = newJBool(true))
  if valid_579843 != nil:
    section.add "prettyPrint", valid_579843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579866: Call_BigtableadminOperationsGet_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579866.validator(path, query, header, formData, body)
  let scheme = call_579866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579866.url(scheme.get, call_579866.host, call_579866.base,
                         call_579866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579866, url, valid)

proc call*(call_579937: Call_BigtableadminOperationsGet_579690; name: string;
          uploadProtocol: string = ""; fields: string = "";
          view: string = "VIEW_UNSPECIFIED"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigtableadminOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The view to be applied to the returned table's fields.
  ## Defaults to `SCHEMA_VIEW` if unspecified.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_579938 = newJObject()
  var query_579940 = newJObject()
  add(query_579940, "upload_protocol", newJString(uploadProtocol))
  add(query_579940, "fields", newJString(fields))
  add(query_579940, "view", newJString(view))
  add(query_579940, "quotaUser", newJString(quotaUser))
  add(path_579938, "name", newJString(name))
  add(query_579940, "alt", newJString(alt))
  add(query_579940, "oauth_token", newJString(oauthToken))
  add(query_579940, "callback", newJString(callback))
  add(query_579940, "access_token", newJString(accessToken))
  add(query_579940, "uploadType", newJString(uploadType))
  add(query_579940, "key", newJString(key))
  add(query_579940, "$.xgafv", newJString(Xgafv))
  add(query_579940, "prettyPrint", newJBool(prettyPrint))
  result = call_579937.call(path_579938, query_579940, nil, nil, nil)

var bigtableadminOperationsGet* = Call_BigtableadminOperationsGet_579690(
    name: "bigtableadminOperationsGet", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}",
    validator: validate_BigtableadminOperationsGet_579691, base: "/",
    url: url_BigtableadminOperationsGet_579692, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesPatch_580020 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesAppProfilesPatch_580022(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesPatch_580021(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an app profile within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : (`OutputOnly`)
  ## The unique name of the app profile. Values are of the form
  ## `projects/<project>/instances/<instance>/appProfiles/_a-zA-Z0-9*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580023 = path.getOrDefault("name")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "name", valid_580023
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
  ##   ignoreWarnings: JBool
  ##                 : If true, ignore safety checks when updating the app profile.
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
  ##   updateMask: JString
  ##             : The subset of app profile fields which should be replaced.
  ## If unset, all fields will be replaced.
  section = newJObject()
  var valid_580024 = query.getOrDefault("upload_protocol")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "upload_protocol", valid_580024
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("ignoreWarnings")
  valid_580028 = validateParameter(valid_580028, JBool, required = false, default = nil)
  if valid_580028 != nil:
    section.add "ignoreWarnings", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("callback")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "callback", valid_580030
  var valid_580031 = query.getOrDefault("access_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "access_token", valid_580031
  var valid_580032 = query.getOrDefault("uploadType")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "uploadType", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("$.xgafv")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("1"))
  if valid_580034 != nil:
    section.add "$.xgafv", valid_580034
  var valid_580035 = query.getOrDefault("prettyPrint")
  valid_580035 = validateParameter(valid_580035, JBool, required = false,
                                 default = newJBool(true))
  if valid_580035 != nil:
    section.add "prettyPrint", valid_580035
  var valid_580036 = query.getOrDefault("updateMask")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "updateMask", valid_580036
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

proc call*(call_580038: Call_BigtableadminProjectsInstancesAppProfilesPatch_580020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an app profile within an instance.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_BigtableadminProjectsInstancesAppProfilesPatch_580020;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; ignoreWarnings: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## bigtableadminProjectsInstancesAppProfilesPatch
  ## Updates an app profile within an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : (`OutputOnly`)
  ## The unique name of the app profile. Values are of the form
  ## `projects/<project>/instances/<instance>/appProfiles/_a-zA-Z0-9*`.
  ##   alt: string
  ##      : Data format for response.
  ##   ignoreWarnings: bool
  ##                 : If true, ignore safety checks when updating the app profile.
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
  ##   updateMask: string
  ##             : The subset of app profile fields which should be replaced.
  ## If unset, all fields will be replaced.
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  var body_580042 = newJObject()
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(path_580040, "name", newJString(name))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "key", newJString(key))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580042 = body
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  add(query_580041, "updateMask", newJString(updateMask))
  result = call_580039.call(path_580040, query_580041, nil, nil, body_580042)

var bigtableadminProjectsInstancesAppProfilesPatch* = Call_BigtableadminProjectsInstancesAppProfilesPatch_580020(
    name: "bigtableadminProjectsInstancesAppProfilesPatch",
    meth: HttpMethod.HttpPatch, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}",
    validator: validate_BigtableadminProjectsInstancesAppProfilesPatch_580021,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesPatch_580022,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsDelete_580000 = ref object of OpenApiRestCall_579421
proc url_BigtableadminOperationsDelete_580002(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsDelete_580001(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_580003 = path.getOrDefault("name")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "name", valid_580003
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
  ##   ignoreWarnings: JBool
  ##                 : If true, ignore safety checks when deleting the app profile.
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
  var valid_580004 = query.getOrDefault("upload_protocol")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "upload_protocol", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("quotaUser")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "quotaUser", valid_580006
  var valid_580007 = query.getOrDefault("alt")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("json"))
  if valid_580007 != nil:
    section.add "alt", valid_580007
  var valid_580008 = query.getOrDefault("ignoreWarnings")
  valid_580008 = validateParameter(valid_580008, JBool, required = false, default = nil)
  if valid_580008 != nil:
    section.add "ignoreWarnings", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("callback")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "callback", valid_580010
  var valid_580011 = query.getOrDefault("access_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "access_token", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("$.xgafv")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("1"))
  if valid_580014 != nil:
    section.add "$.xgafv", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580016: Call_BigtableadminOperationsDelete_580000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_580016.validator(path, query, header, formData, body)
  let scheme = call_580016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580016.url(scheme.get, call_580016.host, call_580016.base,
                         call_580016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580016, url, valid)

proc call*(call_580017: Call_BigtableadminOperationsDelete_580000; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; ignoreWarnings: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigtableadminOperationsDelete
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
  ##   ignoreWarnings: bool
  ##                 : If true, ignore safety checks when deleting the app profile.
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
  var path_580018 = newJObject()
  var query_580019 = newJObject()
  add(query_580019, "upload_protocol", newJString(uploadProtocol))
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(path_580018, "name", newJString(name))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "callback", newJString(callback))
  add(query_580019, "access_token", newJString(accessToken))
  add(query_580019, "uploadType", newJString(uploadType))
  add(query_580019, "key", newJString(key))
  add(query_580019, "$.xgafv", newJString(Xgafv))
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580017.call(path_580018, query_580019, nil, nil, nil)

var bigtableadminOperationsDelete* = Call_BigtableadminOperationsDelete_580000(
    name: "bigtableadminOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}",
    validator: validate_BigtableadminOperationsDelete_580001, base: "/",
    url: url_BigtableadminOperationsDelete_580002, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsLocationsList_580043 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsLocationsList_580045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsLocationsList_580044(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580046 = path.getOrDefault("name")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "name", valid_580046
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_580047 = query.getOrDefault("upload_protocol")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "upload_protocol", valid_580047
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("pageToken")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "pageToken", valid_580049
  var valid_580050 = query.getOrDefault("quotaUser")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "quotaUser", valid_580050
  var valid_580051 = query.getOrDefault("alt")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("json"))
  if valid_580051 != nil:
    section.add "alt", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("callback")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "callback", valid_580053
  var valid_580054 = query.getOrDefault("access_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "access_token", valid_580054
  var valid_580055 = query.getOrDefault("uploadType")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "uploadType", valid_580055
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("$.xgafv")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("1"))
  if valid_580057 != nil:
    section.add "$.xgafv", valid_580057
  var valid_580058 = query.getOrDefault("pageSize")
  valid_580058 = validateParameter(valid_580058, JInt, required = false, default = nil)
  if valid_580058 != nil:
    section.add "pageSize", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  var valid_580060 = query.getOrDefault("filter")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "filter", valid_580060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580061: Call_BigtableadminProjectsLocationsList_580043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_BigtableadminProjectsLocationsList_580043;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## bigtableadminProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_580063 = newJObject()
  var query_580064 = newJObject()
  add(query_580064, "upload_protocol", newJString(uploadProtocol))
  add(query_580064, "fields", newJString(fields))
  add(query_580064, "pageToken", newJString(pageToken))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(path_580063, "name", newJString(name))
  add(query_580064, "alt", newJString(alt))
  add(query_580064, "oauth_token", newJString(oauthToken))
  add(query_580064, "callback", newJString(callback))
  add(query_580064, "access_token", newJString(accessToken))
  add(query_580064, "uploadType", newJString(uploadType))
  add(query_580064, "key", newJString(key))
  add(query_580064, "$.xgafv", newJString(Xgafv))
  add(query_580064, "pageSize", newJInt(pageSize))
  add(query_580064, "prettyPrint", newJBool(prettyPrint))
  add(query_580064, "filter", newJString(filter))
  result = call_580062.call(path_580063, query_580064, nil, nil, nil)

var bigtableadminProjectsLocationsList* = Call_BigtableadminProjectsLocationsList_580043(
    name: "bigtableadminProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}/locations",
    validator: validate_BigtableadminProjectsLocationsList_580044, base: "/",
    url: url_BigtableadminProjectsLocationsList_580045, schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsProjectsOperationsList_580065 = ref object of OpenApiRestCall_579421
proc url_BigtableadminOperationsProjectsOperationsList_580067(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsProjectsOperationsList_580066(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580068 = path.getOrDefault("name")
  valid_580068 = validateParameter(valid_580068, JString, required = true,
                                 default = nil)
  if valid_580068 != nil:
    section.add "name", valid_580068
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_580069 = query.getOrDefault("upload_protocol")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "upload_protocol", valid_580069
  var valid_580070 = query.getOrDefault("fields")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "fields", valid_580070
  var valid_580071 = query.getOrDefault("pageToken")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "pageToken", valid_580071
  var valid_580072 = query.getOrDefault("quotaUser")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "quotaUser", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("callback")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "callback", valid_580075
  var valid_580076 = query.getOrDefault("access_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "access_token", valid_580076
  var valid_580077 = query.getOrDefault("uploadType")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "uploadType", valid_580077
  var valid_580078 = query.getOrDefault("key")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "key", valid_580078
  var valid_580079 = query.getOrDefault("$.xgafv")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("1"))
  if valid_580079 != nil:
    section.add "$.xgafv", valid_580079
  var valid_580080 = query.getOrDefault("pageSize")
  valid_580080 = validateParameter(valid_580080, JInt, required = false, default = nil)
  if valid_580080 != nil:
    section.add "pageSize", valid_580080
  var valid_580081 = query.getOrDefault("prettyPrint")
  valid_580081 = validateParameter(valid_580081, JBool, required = false,
                                 default = newJBool(true))
  if valid_580081 != nil:
    section.add "prettyPrint", valid_580081
  var valid_580082 = query.getOrDefault("filter")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "filter", valid_580082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580083: Call_BigtableadminOperationsProjectsOperationsList_580065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_BigtableadminOperationsProjectsOperationsList_580065;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## bigtableadminOperationsProjectsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_580085 = newJObject()
  var query_580086 = newJObject()
  add(query_580086, "upload_protocol", newJString(uploadProtocol))
  add(query_580086, "fields", newJString(fields))
  add(query_580086, "pageToken", newJString(pageToken))
  add(query_580086, "quotaUser", newJString(quotaUser))
  add(path_580085, "name", newJString(name))
  add(query_580086, "alt", newJString(alt))
  add(query_580086, "oauth_token", newJString(oauthToken))
  add(query_580086, "callback", newJString(callback))
  add(query_580086, "access_token", newJString(accessToken))
  add(query_580086, "uploadType", newJString(uploadType))
  add(query_580086, "key", newJString(key))
  add(query_580086, "$.xgafv", newJString(Xgafv))
  add(query_580086, "pageSize", newJInt(pageSize))
  add(query_580086, "prettyPrint", newJBool(prettyPrint))
  add(query_580086, "filter", newJString(filter))
  result = call_580084.call(path_580085, query_580086, nil, nil, nil)

var bigtableadminOperationsProjectsOperationsList* = Call_BigtableadminOperationsProjectsOperationsList_580065(
    name: "bigtableadminOperationsProjectsOperationsList",
    meth: HttpMethod.HttpGet, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}/operations",
    validator: validate_BigtableadminOperationsProjectsOperationsList_580066,
    base: "/", url: url_BigtableadminOperationsProjectsOperationsList_580067,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsCancel_580087 = ref object of OpenApiRestCall_579421
proc url_BigtableadminOperationsCancel_580089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsCancel_580088(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_580090 = path.getOrDefault("name")
  valid_580090 = validateParameter(valid_580090, JString, required = true,
                                 default = nil)
  if valid_580090 != nil:
    section.add "name", valid_580090
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
  var valid_580091 = query.getOrDefault("upload_protocol")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "upload_protocol", valid_580091
  var valid_580092 = query.getOrDefault("fields")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "fields", valid_580092
  var valid_580093 = query.getOrDefault("quotaUser")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "quotaUser", valid_580093
  var valid_580094 = query.getOrDefault("alt")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("json"))
  if valid_580094 != nil:
    section.add "alt", valid_580094
  var valid_580095 = query.getOrDefault("oauth_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "oauth_token", valid_580095
  var valid_580096 = query.getOrDefault("callback")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "callback", valid_580096
  var valid_580097 = query.getOrDefault("access_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "access_token", valid_580097
  var valid_580098 = query.getOrDefault("uploadType")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "uploadType", valid_580098
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("$.xgafv")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("1"))
  if valid_580100 != nil:
    section.add "$.xgafv", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580102: Call_BigtableadminOperationsCancel_580087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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
  let valid = call_580102.validator(path, query, header, formData, body)
  let scheme = call_580102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580102.url(scheme.get, call_580102.host, call_580102.base,
                         call_580102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580102, url, valid)

proc call*(call_580103: Call_BigtableadminOperationsCancel_580087; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigtableadminOperationsCancel
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
  var path_580104 = newJObject()
  var query_580105 = newJObject()
  add(query_580105, "upload_protocol", newJString(uploadProtocol))
  add(query_580105, "fields", newJString(fields))
  add(query_580105, "quotaUser", newJString(quotaUser))
  add(path_580104, "name", newJString(name))
  add(query_580105, "alt", newJString(alt))
  add(query_580105, "oauth_token", newJString(oauthToken))
  add(query_580105, "callback", newJString(callback))
  add(query_580105, "access_token", newJString(accessToken))
  add(query_580105, "uploadType", newJString(uploadType))
  add(query_580105, "key", newJString(key))
  add(query_580105, "$.xgafv", newJString(Xgafv))
  add(query_580105, "prettyPrint", newJBool(prettyPrint))
  result = call_580103.call(path_580104, query_580105, nil, nil, nil)

var bigtableadminOperationsCancel* = Call_BigtableadminOperationsCancel_580087(
    name: "bigtableadminOperationsCancel", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}:cancel",
    validator: validate_BigtableadminOperationsCancel_580088, base: "/",
    url: url_BigtableadminOperationsCancel_580089, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesCheckConsistency_580106 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesTablesCheckConsistency_580108(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":checkConsistency")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesCheckConsistency_580107(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the Table for which to check replication consistency.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580109 = path.getOrDefault("name")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "name", valid_580109
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
  var valid_580110 = query.getOrDefault("upload_protocol")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "upload_protocol", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("callback")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "callback", valid_580115
  var valid_580116 = query.getOrDefault("access_token")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "access_token", valid_580116
  var valid_580117 = query.getOrDefault("uploadType")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "uploadType", valid_580117
  var valid_580118 = query.getOrDefault("key")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "key", valid_580118
  var valid_580119 = query.getOrDefault("$.xgafv")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("1"))
  if valid_580119 != nil:
    section.add "$.xgafv", valid_580119
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

proc call*(call_580122: Call_BigtableadminProjectsInstancesTablesCheckConsistency_580106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
  ## 
  let valid = call_580122.validator(path, query, header, formData, body)
  let scheme = call_580122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580122.url(scheme.get, call_580122.host, call_580122.base,
                         call_580122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580122, url, valid)

proc call*(call_580123: Call_BigtableadminProjectsInstancesTablesCheckConsistency_580106;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesCheckConsistency
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique name of the Table for which to check replication consistency.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
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
  var path_580124 = newJObject()
  var query_580125 = newJObject()
  var body_580126 = newJObject()
  add(query_580125, "upload_protocol", newJString(uploadProtocol))
  add(query_580125, "fields", newJString(fields))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(path_580124, "name", newJString(name))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(query_580125, "callback", newJString(callback))
  add(query_580125, "access_token", newJString(accessToken))
  add(query_580125, "uploadType", newJString(uploadType))
  add(query_580125, "key", newJString(key))
  add(query_580125, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580126 = body
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  result = call_580123.call(path_580124, query_580125, nil, nil, body_580126)

var bigtableadminProjectsInstancesTablesCheckConsistency* = Call_BigtableadminProjectsInstancesTablesCheckConsistency_580106(
    name: "bigtableadminProjectsInstancesTablesCheckConsistency",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:checkConsistency",
    validator: validate_BigtableadminProjectsInstancesTablesCheckConsistency_580107,
    base: "/", url: url_BigtableadminProjectsInstancesTablesCheckConsistency_580108,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesDropRowRange_580127 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesTablesDropRowRange_580129(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":dropRowRange")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesDropRowRange_580128(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the table on which to drop a range of rows.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580130 = path.getOrDefault("name")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "name", valid_580130
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
  var valid_580131 = query.getOrDefault("upload_protocol")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "upload_protocol", valid_580131
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("oauth_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "oauth_token", valid_580135
  var valid_580136 = query.getOrDefault("callback")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "callback", valid_580136
  var valid_580137 = query.getOrDefault("access_token")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "access_token", valid_580137
  var valid_580138 = query.getOrDefault("uploadType")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "uploadType", valid_580138
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("$.xgafv")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("1"))
  if valid_580140 != nil:
    section.add "$.xgafv", valid_580140
  var valid_580141 = query.getOrDefault("prettyPrint")
  valid_580141 = validateParameter(valid_580141, JBool, required = false,
                                 default = newJBool(true))
  if valid_580141 != nil:
    section.add "prettyPrint", valid_580141
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

proc call*(call_580143: Call_BigtableadminProjectsInstancesTablesDropRowRange_580127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
  ## 
  let valid = call_580143.validator(path, query, header, formData, body)
  let scheme = call_580143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580143.url(scheme.get, call_580143.host, call_580143.base,
                         call_580143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580143, url, valid)

proc call*(call_580144: Call_BigtableadminProjectsInstancesTablesDropRowRange_580127;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesDropRowRange
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique name of the table on which to drop a range of rows.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
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
  var path_580145 = newJObject()
  var query_580146 = newJObject()
  var body_580147 = newJObject()
  add(query_580146, "upload_protocol", newJString(uploadProtocol))
  add(query_580146, "fields", newJString(fields))
  add(query_580146, "quotaUser", newJString(quotaUser))
  add(path_580145, "name", newJString(name))
  add(query_580146, "alt", newJString(alt))
  add(query_580146, "oauth_token", newJString(oauthToken))
  add(query_580146, "callback", newJString(callback))
  add(query_580146, "access_token", newJString(accessToken))
  add(query_580146, "uploadType", newJString(uploadType))
  add(query_580146, "key", newJString(key))
  add(query_580146, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580147 = body
  add(query_580146, "prettyPrint", newJBool(prettyPrint))
  result = call_580144.call(path_580145, query_580146, nil, nil, body_580147)

var bigtableadminProjectsInstancesTablesDropRowRange* = Call_BigtableadminProjectsInstancesTablesDropRowRange_580127(
    name: "bigtableadminProjectsInstancesTablesDropRowRange",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:dropRowRange",
    validator: validate_BigtableadminProjectsInstancesTablesDropRowRange_580128,
    base: "/", url: url_BigtableadminProjectsInstancesTablesDropRowRange_580129,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_580148 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_580150(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":generateConsistencyToken")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_580149(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the Table for which to create a consistency token.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580151 = path.getOrDefault("name")
  valid_580151 = validateParameter(valid_580151, JString, required = true,
                                 default = nil)
  if valid_580151 != nil:
    section.add "name", valid_580151
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
  var valid_580152 = query.getOrDefault("upload_protocol")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "upload_protocol", valid_580152
  var valid_580153 = query.getOrDefault("fields")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "fields", valid_580153
  var valid_580154 = query.getOrDefault("quotaUser")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "quotaUser", valid_580154
  var valid_580155 = query.getOrDefault("alt")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("json"))
  if valid_580155 != nil:
    section.add "alt", valid_580155
  var valid_580156 = query.getOrDefault("oauth_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "oauth_token", valid_580156
  var valid_580157 = query.getOrDefault("callback")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "callback", valid_580157
  var valid_580158 = query.getOrDefault("access_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "access_token", valid_580158
  var valid_580159 = query.getOrDefault("uploadType")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "uploadType", valid_580159
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("$.xgafv")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("1"))
  if valid_580161 != nil:
    section.add "$.xgafv", valid_580161
  var valid_580162 = query.getOrDefault("prettyPrint")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(true))
  if valid_580162 != nil:
    section.add "prettyPrint", valid_580162
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

proc call*(call_580164: Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_580148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
  ## 
  let valid = call_580164.validator(path, query, header, formData, body)
  let scheme = call_580164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580164.url(scheme.get, call_580164.host, call_580164.base,
                         call_580164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580164, url, valid)

proc call*(call_580165: Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_580148;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesGenerateConsistencyToken
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique name of the Table for which to create a consistency token.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
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
  var path_580166 = newJObject()
  var query_580167 = newJObject()
  var body_580168 = newJObject()
  add(query_580167, "upload_protocol", newJString(uploadProtocol))
  add(query_580167, "fields", newJString(fields))
  add(query_580167, "quotaUser", newJString(quotaUser))
  add(path_580166, "name", newJString(name))
  add(query_580167, "alt", newJString(alt))
  add(query_580167, "oauth_token", newJString(oauthToken))
  add(query_580167, "callback", newJString(callback))
  add(query_580167, "access_token", newJString(accessToken))
  add(query_580167, "uploadType", newJString(uploadType))
  add(query_580167, "key", newJString(key))
  add(query_580167, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580168 = body
  add(query_580167, "prettyPrint", newJBool(prettyPrint))
  result = call_580165.call(path_580166, query_580167, nil, nil, body_580168)

var bigtableadminProjectsInstancesTablesGenerateConsistencyToken* = Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_580148(
    name: "bigtableadminProjectsInstancesTablesGenerateConsistencyToken",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:generateConsistencyToken", validator: validate_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_580149,
    base: "/",
    url: url_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_580150,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_580169 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesTablesModifyColumnFamilies_580171(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":modifyColumnFamilies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesModifyColumnFamilies_580170(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the table whose families should be modified.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580172 = path.getOrDefault("name")
  valid_580172 = validateParameter(valid_580172, JString, required = true,
                                 default = nil)
  if valid_580172 != nil:
    section.add "name", valid_580172
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
  var valid_580173 = query.getOrDefault("upload_protocol")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "upload_protocol", valid_580173
  var valid_580174 = query.getOrDefault("fields")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "fields", valid_580174
  var valid_580175 = query.getOrDefault("quotaUser")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "quotaUser", valid_580175
  var valid_580176 = query.getOrDefault("alt")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("json"))
  if valid_580176 != nil:
    section.add "alt", valid_580176
  var valid_580177 = query.getOrDefault("oauth_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "oauth_token", valid_580177
  var valid_580178 = query.getOrDefault("callback")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "callback", valid_580178
  var valid_580179 = query.getOrDefault("access_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "access_token", valid_580179
  var valid_580180 = query.getOrDefault("uploadType")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "uploadType", valid_580180
  var valid_580181 = query.getOrDefault("key")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "key", valid_580181
  var valid_580182 = query.getOrDefault("$.xgafv")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("1"))
  if valid_580182 != nil:
    section.add "$.xgafv", valid_580182
  var valid_580183 = query.getOrDefault("prettyPrint")
  valid_580183 = validateParameter(valid_580183, JBool, required = false,
                                 default = newJBool(true))
  if valid_580183 != nil:
    section.add "prettyPrint", valid_580183
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

proc call*(call_580185: Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_580169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
  ## 
  let valid = call_580185.validator(path, query, header, formData, body)
  let scheme = call_580185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580185.url(scheme.get, call_580185.host, call_580185.base,
                         call_580185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580185, url, valid)

proc call*(call_580186: Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_580169;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesModifyColumnFamilies
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique name of the table whose families should be modified.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
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
  var path_580187 = newJObject()
  var query_580188 = newJObject()
  var body_580189 = newJObject()
  add(query_580188, "upload_protocol", newJString(uploadProtocol))
  add(query_580188, "fields", newJString(fields))
  add(query_580188, "quotaUser", newJString(quotaUser))
  add(path_580187, "name", newJString(name))
  add(query_580188, "alt", newJString(alt))
  add(query_580188, "oauth_token", newJString(oauthToken))
  add(query_580188, "callback", newJString(callback))
  add(query_580188, "access_token", newJString(accessToken))
  add(query_580188, "uploadType", newJString(uploadType))
  add(query_580188, "key", newJString(key))
  add(query_580188, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580189 = body
  add(query_580188, "prettyPrint", newJBool(prettyPrint))
  result = call_580186.call(path_580187, query_580188, nil, nil, body_580189)

var bigtableadminProjectsInstancesTablesModifyColumnFamilies* = Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_580169(
    name: "bigtableadminProjectsInstancesTablesModifyColumnFamilies",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:modifyColumnFamilies", validator: validate_BigtableadminProjectsInstancesTablesModifyColumnFamilies_580170,
    base: "/", url: url_BigtableadminProjectsInstancesTablesModifyColumnFamilies_580171,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesCreate_580211 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesAppProfilesCreate_580213(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/appProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesCreate_580212(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an app profile within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance in which to create the new app profile.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580214 = path.getOrDefault("parent")
  valid_580214 = validateParameter(valid_580214, JString, required = true,
                                 default = nil)
  if valid_580214 != nil:
    section.add "parent", valid_580214
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
  ##   ignoreWarnings: JBool
  ##                 : If true, ignore safety checks when creating the app profile.
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
  ##   appProfileId: JString
  ##               : The ID to be used when referring to the new app profile within its
  ## instance, e.g., just `myprofile` rather than
  ## `projects/myproject/instances/myinstance/appProfiles/myprofile`.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580215 = query.getOrDefault("upload_protocol")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "upload_protocol", valid_580215
  var valid_580216 = query.getOrDefault("fields")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "fields", valid_580216
  var valid_580217 = query.getOrDefault("quotaUser")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "quotaUser", valid_580217
  var valid_580218 = query.getOrDefault("alt")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("json"))
  if valid_580218 != nil:
    section.add "alt", valid_580218
  var valid_580219 = query.getOrDefault("ignoreWarnings")
  valid_580219 = validateParameter(valid_580219, JBool, required = false, default = nil)
  if valid_580219 != nil:
    section.add "ignoreWarnings", valid_580219
  var valid_580220 = query.getOrDefault("oauth_token")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "oauth_token", valid_580220
  var valid_580221 = query.getOrDefault("callback")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "callback", valid_580221
  var valid_580222 = query.getOrDefault("access_token")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "access_token", valid_580222
  var valid_580223 = query.getOrDefault("uploadType")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "uploadType", valid_580223
  var valid_580224 = query.getOrDefault("key")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "key", valid_580224
  var valid_580225 = query.getOrDefault("appProfileId")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "appProfileId", valid_580225
  var valid_580226 = query.getOrDefault("$.xgafv")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = newJString("1"))
  if valid_580226 != nil:
    section.add "$.xgafv", valid_580226
  var valid_580227 = query.getOrDefault("prettyPrint")
  valid_580227 = validateParameter(valid_580227, JBool, required = false,
                                 default = newJBool(true))
  if valid_580227 != nil:
    section.add "prettyPrint", valid_580227
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

proc call*(call_580229: Call_BigtableadminProjectsInstancesAppProfilesCreate_580211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an app profile within an instance.
  ## 
  let valid = call_580229.validator(path, query, header, formData, body)
  let scheme = call_580229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580229.url(scheme.get, call_580229.host, call_580229.base,
                         call_580229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580229, url, valid)

proc call*(call_580230: Call_BigtableadminProjectsInstancesAppProfilesCreate_580211;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; ignoreWarnings: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; appProfileId: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesAppProfilesCreate
  ## Creates an app profile within an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   ignoreWarnings: bool
  ##                 : If true, ignore safety checks when creating the app profile.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The unique name of the instance in which to create the new app profile.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   appProfileId: string
  ##               : The ID to be used when referring to the new app profile within its
  ## instance, e.g., just `myprofile` rather than
  ## `projects/myproject/instances/myinstance/appProfiles/myprofile`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580231 = newJObject()
  var query_580232 = newJObject()
  var body_580233 = newJObject()
  add(query_580232, "upload_protocol", newJString(uploadProtocol))
  add(query_580232, "fields", newJString(fields))
  add(query_580232, "quotaUser", newJString(quotaUser))
  add(query_580232, "alt", newJString(alt))
  add(query_580232, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_580232, "oauth_token", newJString(oauthToken))
  add(query_580232, "callback", newJString(callback))
  add(query_580232, "access_token", newJString(accessToken))
  add(query_580232, "uploadType", newJString(uploadType))
  add(path_580231, "parent", newJString(parent))
  add(query_580232, "key", newJString(key))
  add(query_580232, "appProfileId", newJString(appProfileId))
  add(query_580232, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580233 = body
  add(query_580232, "prettyPrint", newJBool(prettyPrint))
  result = call_580230.call(path_580231, query_580232, nil, nil, body_580233)

var bigtableadminProjectsInstancesAppProfilesCreate* = Call_BigtableadminProjectsInstancesAppProfilesCreate_580211(
    name: "bigtableadminProjectsInstancesAppProfilesCreate",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/appProfiles",
    validator: validate_BigtableadminProjectsInstancesAppProfilesCreate_580212,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesCreate_580213,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesList_580190 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesAppProfilesList_580192(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/appProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesList_580191(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists information about app profiles in an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance for which a list of app profiles is
  ## requested. Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list AppProfiles for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580193 = path.getOrDefault("parent")
  valid_580193 = validateParameter(valid_580193, JString, required = true,
                                 default = nil)
  if valid_580193 != nil:
    section.add "parent", valid_580193
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value of `next_page_token` returned by a previous call.
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
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580194 = query.getOrDefault("upload_protocol")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "upload_protocol", valid_580194
  var valid_580195 = query.getOrDefault("fields")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "fields", valid_580195
  var valid_580196 = query.getOrDefault("pageToken")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "pageToken", valid_580196
  var valid_580197 = query.getOrDefault("quotaUser")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "quotaUser", valid_580197
  var valid_580198 = query.getOrDefault("alt")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = newJString("json"))
  if valid_580198 != nil:
    section.add "alt", valid_580198
  var valid_580199 = query.getOrDefault("oauth_token")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "oauth_token", valid_580199
  var valid_580200 = query.getOrDefault("callback")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "callback", valid_580200
  var valid_580201 = query.getOrDefault("access_token")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "access_token", valid_580201
  var valid_580202 = query.getOrDefault("uploadType")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "uploadType", valid_580202
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
  var valid_580204 = query.getOrDefault("$.xgafv")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("1"))
  if valid_580204 != nil:
    section.add "$.xgafv", valid_580204
  var valid_580205 = query.getOrDefault("pageSize")
  valid_580205 = validateParameter(valid_580205, JInt, required = false, default = nil)
  if valid_580205 != nil:
    section.add "pageSize", valid_580205
  var valid_580206 = query.getOrDefault("prettyPrint")
  valid_580206 = validateParameter(valid_580206, JBool, required = false,
                                 default = newJBool(true))
  if valid_580206 != nil:
    section.add "prettyPrint", valid_580206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580207: Call_BigtableadminProjectsInstancesAppProfilesList_580190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about app profiles in an instance.
  ## 
  let valid = call_580207.validator(path, query, header, formData, body)
  let scheme = call_580207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580207.url(scheme.get, call_580207.host, call_580207.base,
                         call_580207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580207, url, valid)

proc call*(call_580208: Call_BigtableadminProjectsInstancesAppProfilesList_580190;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesAppProfilesList
  ## Lists information about app profiles in an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of `next_page_token` returned by a previous call.
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
  ##         : The unique name of the instance for which a list of app profiles is
  ## requested. Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list AppProfiles for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580209 = newJObject()
  var query_580210 = newJObject()
  add(query_580210, "upload_protocol", newJString(uploadProtocol))
  add(query_580210, "fields", newJString(fields))
  add(query_580210, "pageToken", newJString(pageToken))
  add(query_580210, "quotaUser", newJString(quotaUser))
  add(query_580210, "alt", newJString(alt))
  add(query_580210, "oauth_token", newJString(oauthToken))
  add(query_580210, "callback", newJString(callback))
  add(query_580210, "access_token", newJString(accessToken))
  add(query_580210, "uploadType", newJString(uploadType))
  add(path_580209, "parent", newJString(parent))
  add(query_580210, "key", newJString(key))
  add(query_580210, "$.xgafv", newJString(Xgafv))
  add(query_580210, "pageSize", newJInt(pageSize))
  add(query_580210, "prettyPrint", newJBool(prettyPrint))
  result = call_580208.call(path_580209, query_580210, nil, nil, nil)

var bigtableadminProjectsInstancesAppProfilesList* = Call_BigtableadminProjectsInstancesAppProfilesList_580190(
    name: "bigtableadminProjectsInstancesAppProfilesList",
    meth: HttpMethod.HttpGet, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/appProfiles",
    validator: validate_BigtableadminProjectsInstancesAppProfilesList_580191,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesList_580192,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesClustersCreate_580254 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesClustersCreate_580256(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersCreate_580255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance in which to create the new cluster.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580257 = path.getOrDefault("parent")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "parent", valid_580257
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
  ##   clusterId: JString
  ##            : The ID to be used when referring to the new cluster within its instance,
  ## e.g., just `mycluster` rather than
  ## `projects/myproject/instances/myinstance/clusters/mycluster`.
  section = newJObject()
  var valid_580258 = query.getOrDefault("upload_protocol")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "upload_protocol", valid_580258
  var valid_580259 = query.getOrDefault("fields")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "fields", valid_580259
  var valid_580260 = query.getOrDefault("quotaUser")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "quotaUser", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  var valid_580262 = query.getOrDefault("oauth_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "oauth_token", valid_580262
  var valid_580263 = query.getOrDefault("callback")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "callback", valid_580263
  var valid_580264 = query.getOrDefault("access_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "access_token", valid_580264
  var valid_580265 = query.getOrDefault("uploadType")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "uploadType", valid_580265
  var valid_580266 = query.getOrDefault("key")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "key", valid_580266
  var valid_580267 = query.getOrDefault("$.xgafv")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = newJString("1"))
  if valid_580267 != nil:
    section.add "$.xgafv", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(true))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
  var valid_580269 = query.getOrDefault("clusterId")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "clusterId", valid_580269
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

proc call*(call_580271: Call_BigtableadminProjectsInstancesClustersCreate_580254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster within an instance.
  ## 
  let valid = call_580271.validator(path, query, header, formData, body)
  let scheme = call_580271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580271.url(scheme.get, call_580271.host, call_580271.base,
                         call_580271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580271, url, valid)

proc call*(call_580272: Call_BigtableadminProjectsInstancesClustersCreate_580254;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; clusterId: string = ""): Recallable =
  ## bigtableadminProjectsInstancesClustersCreate
  ## Creates a cluster within an instance.
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
  ##         : The unique name of the instance in which to create the new cluster.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string
  ##            : The ID to be used when referring to the new cluster within its instance,
  ## e.g., just `mycluster` rather than
  ## `projects/myproject/instances/myinstance/clusters/mycluster`.
  var path_580273 = newJObject()
  var query_580274 = newJObject()
  var body_580275 = newJObject()
  add(query_580274, "upload_protocol", newJString(uploadProtocol))
  add(query_580274, "fields", newJString(fields))
  add(query_580274, "quotaUser", newJString(quotaUser))
  add(query_580274, "alt", newJString(alt))
  add(query_580274, "oauth_token", newJString(oauthToken))
  add(query_580274, "callback", newJString(callback))
  add(query_580274, "access_token", newJString(accessToken))
  add(query_580274, "uploadType", newJString(uploadType))
  add(path_580273, "parent", newJString(parent))
  add(query_580274, "key", newJString(key))
  add(query_580274, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580275 = body
  add(query_580274, "prettyPrint", newJBool(prettyPrint))
  add(query_580274, "clusterId", newJString(clusterId))
  result = call_580272.call(path_580273, query_580274, nil, nil, body_580275)

var bigtableadminProjectsInstancesClustersCreate* = Call_BigtableadminProjectsInstancesClustersCreate_580254(
    name: "bigtableadminProjectsInstancesClustersCreate",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/clusters",
    validator: validate_BigtableadminProjectsInstancesClustersCreate_580255,
    base: "/", url: url_BigtableadminProjectsInstancesClustersCreate_580256,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesClustersList_580234 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesClustersList_580236(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersList_580235(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about clusters in an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance for which a list of clusters is requested.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list Clusters for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580237 = path.getOrDefault("parent")
  valid_580237 = validateParameter(valid_580237, JString, required = true,
                                 default = nil)
  if valid_580237 != nil:
    section.add "parent", valid_580237
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : DEPRECATED: This field is unused and ignored.
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
  var valid_580238 = query.getOrDefault("upload_protocol")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "upload_protocol", valid_580238
  var valid_580239 = query.getOrDefault("fields")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "fields", valid_580239
  var valid_580240 = query.getOrDefault("pageToken")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "pageToken", valid_580240
  var valid_580241 = query.getOrDefault("quotaUser")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "quotaUser", valid_580241
  var valid_580242 = query.getOrDefault("alt")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = newJString("json"))
  if valid_580242 != nil:
    section.add "alt", valid_580242
  var valid_580243 = query.getOrDefault("oauth_token")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "oauth_token", valid_580243
  var valid_580244 = query.getOrDefault("callback")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "callback", valid_580244
  var valid_580245 = query.getOrDefault("access_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "access_token", valid_580245
  var valid_580246 = query.getOrDefault("uploadType")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "uploadType", valid_580246
  var valid_580247 = query.getOrDefault("key")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "key", valid_580247
  var valid_580248 = query.getOrDefault("$.xgafv")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("1"))
  if valid_580248 != nil:
    section.add "$.xgafv", valid_580248
  var valid_580249 = query.getOrDefault("prettyPrint")
  valid_580249 = validateParameter(valid_580249, JBool, required = false,
                                 default = newJBool(true))
  if valid_580249 != nil:
    section.add "prettyPrint", valid_580249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580250: Call_BigtableadminProjectsInstancesClustersList_580234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about clusters in an instance.
  ## 
  let valid = call_580250.validator(path, query, header, formData, body)
  let scheme = call_580250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580250.url(scheme.get, call_580250.host, call_580250.base,
                         call_580250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580250, url, valid)

proc call*(call_580251: Call_BigtableadminProjectsInstancesClustersList_580234;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesClustersList
  ## Lists information about clusters in an instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : DEPRECATED: This field is unused and ignored.
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
  ##         : The unique name of the instance for which a list of clusters is requested.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list Clusters for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580252 = newJObject()
  var query_580253 = newJObject()
  add(query_580253, "upload_protocol", newJString(uploadProtocol))
  add(query_580253, "fields", newJString(fields))
  add(query_580253, "pageToken", newJString(pageToken))
  add(query_580253, "quotaUser", newJString(quotaUser))
  add(query_580253, "alt", newJString(alt))
  add(query_580253, "oauth_token", newJString(oauthToken))
  add(query_580253, "callback", newJString(callback))
  add(query_580253, "access_token", newJString(accessToken))
  add(query_580253, "uploadType", newJString(uploadType))
  add(path_580252, "parent", newJString(parent))
  add(query_580253, "key", newJString(key))
  add(query_580253, "$.xgafv", newJString(Xgafv))
  add(query_580253, "prettyPrint", newJBool(prettyPrint))
  result = call_580251.call(path_580252, query_580253, nil, nil, nil)

var bigtableadminProjectsInstancesClustersList* = Call_BigtableadminProjectsInstancesClustersList_580234(
    name: "bigtableadminProjectsInstancesClustersList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/clusters",
    validator: validate_BigtableadminProjectsInstancesClustersList_580235,
    base: "/", url: url_BigtableadminProjectsInstancesClustersList_580236,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesCreate_580296 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesCreate_580298(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesCreate_580297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an instance within a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the project in which to create the new instance.
  ## Values are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580299 = path.getOrDefault("parent")
  valid_580299 = validateParameter(valid_580299, JString, required = true,
                                 default = nil)
  if valid_580299 != nil:
    section.add "parent", valid_580299
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
  var valid_580300 = query.getOrDefault("upload_protocol")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "upload_protocol", valid_580300
  var valid_580301 = query.getOrDefault("fields")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "fields", valid_580301
  var valid_580302 = query.getOrDefault("quotaUser")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "quotaUser", valid_580302
  var valid_580303 = query.getOrDefault("alt")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = newJString("json"))
  if valid_580303 != nil:
    section.add "alt", valid_580303
  var valid_580304 = query.getOrDefault("oauth_token")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "oauth_token", valid_580304
  var valid_580305 = query.getOrDefault("callback")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "callback", valid_580305
  var valid_580306 = query.getOrDefault("access_token")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "access_token", valid_580306
  var valid_580307 = query.getOrDefault("uploadType")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "uploadType", valid_580307
  var valid_580308 = query.getOrDefault("key")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "key", valid_580308
  var valid_580309 = query.getOrDefault("$.xgafv")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = newJString("1"))
  if valid_580309 != nil:
    section.add "$.xgafv", valid_580309
  var valid_580310 = query.getOrDefault("prettyPrint")
  valid_580310 = validateParameter(valid_580310, JBool, required = false,
                                 default = newJBool(true))
  if valid_580310 != nil:
    section.add "prettyPrint", valid_580310
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

proc call*(call_580312: Call_BigtableadminProjectsInstancesCreate_580296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an instance within a project.
  ## 
  let valid = call_580312.validator(path, query, header, formData, body)
  let scheme = call_580312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580312.url(scheme.get, call_580312.host, call_580312.base,
                         call_580312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580312, url, valid)

proc call*(call_580313: Call_BigtableadminProjectsInstancesCreate_580296;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesCreate
  ## Create an instance within a project.
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
  ##         : The unique name of the project in which to create the new instance.
  ## Values are of the form `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580314 = newJObject()
  var query_580315 = newJObject()
  var body_580316 = newJObject()
  add(query_580315, "upload_protocol", newJString(uploadProtocol))
  add(query_580315, "fields", newJString(fields))
  add(query_580315, "quotaUser", newJString(quotaUser))
  add(query_580315, "alt", newJString(alt))
  add(query_580315, "oauth_token", newJString(oauthToken))
  add(query_580315, "callback", newJString(callback))
  add(query_580315, "access_token", newJString(accessToken))
  add(query_580315, "uploadType", newJString(uploadType))
  add(path_580314, "parent", newJString(parent))
  add(query_580315, "key", newJString(key))
  add(query_580315, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580316 = body
  add(query_580315, "prettyPrint", newJBool(prettyPrint))
  result = call_580313.call(path_580314, query_580315, nil, nil, body_580316)

var bigtableadminProjectsInstancesCreate* = Call_BigtableadminProjectsInstancesCreate_580296(
    name: "bigtableadminProjectsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/instances",
    validator: validate_BigtableadminProjectsInstancesCreate_580297, base: "/",
    url: url_BigtableadminProjectsInstancesCreate_580298, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesList_580276 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesList_580278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesList_580277(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about instances in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the project for which a list of instances is requested.
  ## Values are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580279 = path.getOrDefault("parent")
  valid_580279 = validateParameter(valid_580279, JString, required = true,
                                 default = nil)
  if valid_580279 != nil:
    section.add "parent", valid_580279
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : DEPRECATED: This field is unused and ignored.
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
  var valid_580280 = query.getOrDefault("upload_protocol")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "upload_protocol", valid_580280
  var valid_580281 = query.getOrDefault("fields")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "fields", valid_580281
  var valid_580282 = query.getOrDefault("pageToken")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "pageToken", valid_580282
  var valid_580283 = query.getOrDefault("quotaUser")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "quotaUser", valid_580283
  var valid_580284 = query.getOrDefault("alt")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("json"))
  if valid_580284 != nil:
    section.add "alt", valid_580284
  var valid_580285 = query.getOrDefault("oauth_token")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "oauth_token", valid_580285
  var valid_580286 = query.getOrDefault("callback")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "callback", valid_580286
  var valid_580287 = query.getOrDefault("access_token")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "access_token", valid_580287
  var valid_580288 = query.getOrDefault("uploadType")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "uploadType", valid_580288
  var valid_580289 = query.getOrDefault("key")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "key", valid_580289
  var valid_580290 = query.getOrDefault("$.xgafv")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = newJString("1"))
  if valid_580290 != nil:
    section.add "$.xgafv", valid_580290
  var valid_580291 = query.getOrDefault("prettyPrint")
  valid_580291 = validateParameter(valid_580291, JBool, required = false,
                                 default = newJBool(true))
  if valid_580291 != nil:
    section.add "prettyPrint", valid_580291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580292: Call_BigtableadminProjectsInstancesList_580276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about instances in a project.
  ## 
  let valid = call_580292.validator(path, query, header, formData, body)
  let scheme = call_580292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580292.url(scheme.get, call_580292.host, call_580292.base,
                         call_580292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580292, url, valid)

proc call*(call_580293: Call_BigtableadminProjectsInstancesList_580276;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesList
  ## Lists information about instances in a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : DEPRECATED: This field is unused and ignored.
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
  ##         : The unique name of the project for which a list of instances is requested.
  ## Values are of the form `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580294 = newJObject()
  var query_580295 = newJObject()
  add(query_580295, "upload_protocol", newJString(uploadProtocol))
  add(query_580295, "fields", newJString(fields))
  add(query_580295, "pageToken", newJString(pageToken))
  add(query_580295, "quotaUser", newJString(quotaUser))
  add(query_580295, "alt", newJString(alt))
  add(query_580295, "oauth_token", newJString(oauthToken))
  add(query_580295, "callback", newJString(callback))
  add(query_580295, "access_token", newJString(accessToken))
  add(query_580295, "uploadType", newJString(uploadType))
  add(path_580294, "parent", newJString(parent))
  add(query_580295, "key", newJString(key))
  add(query_580295, "$.xgafv", newJString(Xgafv))
  add(query_580295, "prettyPrint", newJBool(prettyPrint))
  result = call_580293.call(path_580294, query_580295, nil, nil, nil)

var bigtableadminProjectsInstancesList* = Call_BigtableadminProjectsInstancesList_580276(
    name: "bigtableadminProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/instances",
    validator: validate_BigtableadminProjectsInstancesList_580277, base: "/",
    url: url_BigtableadminProjectsInstancesList_580278, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesCreate_580339 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesTablesCreate_580341(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesCreate_580340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance in which to create the table.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580342 = path.getOrDefault("parent")
  valid_580342 = validateParameter(valid_580342, JString, required = true,
                                 default = nil)
  if valid_580342 != nil:
    section.add "parent", valid_580342
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
  var valid_580343 = query.getOrDefault("upload_protocol")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "upload_protocol", valid_580343
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
  var valid_580348 = query.getOrDefault("callback")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "callback", valid_580348
  var valid_580349 = query.getOrDefault("access_token")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "access_token", valid_580349
  var valid_580350 = query.getOrDefault("uploadType")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "uploadType", valid_580350
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("$.xgafv")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = newJString("1"))
  if valid_580352 != nil:
    section.add "$.xgafv", valid_580352
  var valid_580353 = query.getOrDefault("prettyPrint")
  valid_580353 = validateParameter(valid_580353, JBool, required = false,
                                 default = newJBool(true))
  if valid_580353 != nil:
    section.add "prettyPrint", valid_580353
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

proc call*(call_580355: Call_BigtableadminProjectsInstancesTablesCreate_580339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
  ## 
  let valid = call_580355.validator(path, query, header, formData, body)
  let scheme = call_580355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580355.url(scheme.get, call_580355.host, call_580355.base,
                         call_580355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580355, url, valid)

proc call*(call_580356: Call_BigtableadminProjectsInstancesTablesCreate_580339;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesCreate
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
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
  ##         : The unique name of the instance in which to create the table.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580357 = newJObject()
  var query_580358 = newJObject()
  var body_580359 = newJObject()
  add(query_580358, "upload_protocol", newJString(uploadProtocol))
  add(query_580358, "fields", newJString(fields))
  add(query_580358, "quotaUser", newJString(quotaUser))
  add(query_580358, "alt", newJString(alt))
  add(query_580358, "oauth_token", newJString(oauthToken))
  add(query_580358, "callback", newJString(callback))
  add(query_580358, "access_token", newJString(accessToken))
  add(query_580358, "uploadType", newJString(uploadType))
  add(path_580357, "parent", newJString(parent))
  add(query_580358, "key", newJString(key))
  add(query_580358, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580359 = body
  add(query_580358, "prettyPrint", newJBool(prettyPrint))
  result = call_580356.call(path_580357, query_580358, nil, nil, body_580359)

var bigtableadminProjectsInstancesTablesCreate* = Call_BigtableadminProjectsInstancesTablesCreate_580339(
    name: "bigtableadminProjectsInstancesTablesCreate", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/tables",
    validator: validate_BigtableadminProjectsInstancesTablesCreate_580340,
    base: "/", url: url_BigtableadminProjectsInstancesTablesCreate_580341,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesList_580317 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesTablesList_580319(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesList_580318(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all tables served from a specified instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance for which tables should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580320 = path.getOrDefault("parent")
  valid_580320 = validateParameter(valid_580320, JString, required = true,
                                 default = nil)
  if valid_580320 != nil:
    section.add "parent", valid_580320
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value of `next_page_token` returned by a previous call.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : The view to be applied to the returned tables' fields.
  ## Defaults to `NAME_ONLY` if unspecified; no others are currently supported.
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
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580321 = query.getOrDefault("upload_protocol")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "upload_protocol", valid_580321
  var valid_580322 = query.getOrDefault("fields")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "fields", valid_580322
  var valid_580323 = query.getOrDefault("pageToken")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "pageToken", valid_580323
  var valid_580324 = query.getOrDefault("quotaUser")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "quotaUser", valid_580324
  var valid_580325 = query.getOrDefault("view")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_580325 != nil:
    section.add "view", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("oauth_token")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "oauth_token", valid_580327
  var valid_580328 = query.getOrDefault("callback")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "callback", valid_580328
  var valid_580329 = query.getOrDefault("access_token")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "access_token", valid_580329
  var valid_580330 = query.getOrDefault("uploadType")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "uploadType", valid_580330
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("$.xgafv")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = newJString("1"))
  if valid_580332 != nil:
    section.add "$.xgafv", valid_580332
  var valid_580333 = query.getOrDefault("pageSize")
  valid_580333 = validateParameter(valid_580333, JInt, required = false, default = nil)
  if valid_580333 != nil:
    section.add "pageSize", valid_580333
  var valid_580334 = query.getOrDefault("prettyPrint")
  valid_580334 = validateParameter(valid_580334, JBool, required = false,
                                 default = newJBool(true))
  if valid_580334 != nil:
    section.add "prettyPrint", valid_580334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580335: Call_BigtableadminProjectsInstancesTablesList_580317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all tables served from a specified instance.
  ## 
  let valid = call_580335.validator(path, query, header, formData, body)
  let scheme = call_580335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580335.url(scheme.get, call_580335.host, call_580335.base,
                         call_580335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580335, url, valid)

proc call*(call_580336: Call_BigtableadminProjectsInstancesTablesList_580317;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = "";
          view: string = "VIEW_UNSPECIFIED"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTablesList
  ## Lists all tables served from a specified instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value of `next_page_token` returned by a previous call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : The view to be applied to the returned tables' fields.
  ## Defaults to `NAME_ONLY` if unspecified; no others are currently supported.
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
  ##         : The unique name of the instance for which tables should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580337 = newJObject()
  var query_580338 = newJObject()
  add(query_580338, "upload_protocol", newJString(uploadProtocol))
  add(query_580338, "fields", newJString(fields))
  add(query_580338, "pageToken", newJString(pageToken))
  add(query_580338, "quotaUser", newJString(quotaUser))
  add(query_580338, "view", newJString(view))
  add(query_580338, "alt", newJString(alt))
  add(query_580338, "oauth_token", newJString(oauthToken))
  add(query_580338, "callback", newJString(callback))
  add(query_580338, "access_token", newJString(accessToken))
  add(query_580338, "uploadType", newJString(uploadType))
  add(path_580337, "parent", newJString(parent))
  add(query_580338, "key", newJString(key))
  add(query_580338, "$.xgafv", newJString(Xgafv))
  add(query_580338, "pageSize", newJInt(pageSize))
  add(query_580338, "prettyPrint", newJBool(prettyPrint))
  result = call_580336.call(path_580337, query_580338, nil, nil, nil)

var bigtableadminProjectsInstancesTablesList* = Call_BigtableadminProjectsInstancesTablesList_580317(
    name: "bigtableadminProjectsInstancesTablesList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/tables",
    validator: validate_BigtableadminProjectsInstancesTablesList_580318,
    base: "/", url: url_BigtableadminProjectsInstancesTablesList_580319,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesGetIamPolicy_580360 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesGetIamPolicy_580362(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesGetIamPolicy_580361(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580363 = path.getOrDefault("resource")
  valid_580363 = validateParameter(valid_580363, JString, required = true,
                                 default = nil)
  if valid_580363 != nil:
    section.add "resource", valid_580363
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
  var valid_580364 = query.getOrDefault("upload_protocol")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "upload_protocol", valid_580364
  var valid_580365 = query.getOrDefault("fields")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "fields", valid_580365
  var valid_580366 = query.getOrDefault("quotaUser")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "quotaUser", valid_580366
  var valid_580367 = query.getOrDefault("alt")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = newJString("json"))
  if valid_580367 != nil:
    section.add "alt", valid_580367
  var valid_580368 = query.getOrDefault("oauth_token")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "oauth_token", valid_580368
  var valid_580369 = query.getOrDefault("callback")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "callback", valid_580369
  var valid_580370 = query.getOrDefault("access_token")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "access_token", valid_580370
  var valid_580371 = query.getOrDefault("uploadType")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "uploadType", valid_580371
  var valid_580372 = query.getOrDefault("key")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "key", valid_580372
  var valid_580373 = query.getOrDefault("$.xgafv")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = newJString("1"))
  if valid_580373 != nil:
    section.add "$.xgafv", valid_580373
  var valid_580374 = query.getOrDefault("prettyPrint")
  valid_580374 = validateParameter(valid_580374, JBool, required = false,
                                 default = newJBool(true))
  if valid_580374 != nil:
    section.add "prettyPrint", valid_580374
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

proc call*(call_580376: Call_BigtableadminProjectsInstancesGetIamPolicy_580360;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
  ## 
  let valid = call_580376.validator(path, query, header, formData, body)
  let scheme = call_580376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580376.url(scheme.get, call_580376.host, call_580376.base,
                         call_580376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580376, url, valid)

proc call*(call_580377: Call_BigtableadminProjectsInstancesGetIamPolicy_580360;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesGetIamPolicy
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
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
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580378 = newJObject()
  var query_580379 = newJObject()
  var body_580380 = newJObject()
  add(query_580379, "upload_protocol", newJString(uploadProtocol))
  add(query_580379, "fields", newJString(fields))
  add(query_580379, "quotaUser", newJString(quotaUser))
  add(query_580379, "alt", newJString(alt))
  add(query_580379, "oauth_token", newJString(oauthToken))
  add(query_580379, "callback", newJString(callback))
  add(query_580379, "access_token", newJString(accessToken))
  add(query_580379, "uploadType", newJString(uploadType))
  add(query_580379, "key", newJString(key))
  add(query_580379, "$.xgafv", newJString(Xgafv))
  add(path_580378, "resource", newJString(resource))
  if body != nil:
    body_580380 = body
  add(query_580379, "prettyPrint", newJBool(prettyPrint))
  result = call_580377.call(path_580378, query_580379, nil, nil, body_580380)

var bigtableadminProjectsInstancesGetIamPolicy* = Call_BigtableadminProjectsInstancesGetIamPolicy_580360(
    name: "bigtableadminProjectsInstancesGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{resource}:getIamPolicy",
    validator: validate_BigtableadminProjectsInstancesGetIamPolicy_580361,
    base: "/", url: url_BigtableadminProjectsInstancesGetIamPolicy_580362,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesSetIamPolicy_580381 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesSetIamPolicy_580383(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesSetIamPolicy_580382(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580384 = path.getOrDefault("resource")
  valid_580384 = validateParameter(valid_580384, JString, required = true,
                                 default = nil)
  if valid_580384 != nil:
    section.add "resource", valid_580384
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
  var valid_580385 = query.getOrDefault("upload_protocol")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "upload_protocol", valid_580385
  var valid_580386 = query.getOrDefault("fields")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "fields", valid_580386
  var valid_580387 = query.getOrDefault("quotaUser")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "quotaUser", valid_580387
  var valid_580388 = query.getOrDefault("alt")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("json"))
  if valid_580388 != nil:
    section.add "alt", valid_580388
  var valid_580389 = query.getOrDefault("oauth_token")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "oauth_token", valid_580389
  var valid_580390 = query.getOrDefault("callback")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "callback", valid_580390
  var valid_580391 = query.getOrDefault("access_token")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "access_token", valid_580391
  var valid_580392 = query.getOrDefault("uploadType")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "uploadType", valid_580392
  var valid_580393 = query.getOrDefault("key")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "key", valid_580393
  var valid_580394 = query.getOrDefault("$.xgafv")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = newJString("1"))
  if valid_580394 != nil:
    section.add "$.xgafv", valid_580394
  var valid_580395 = query.getOrDefault("prettyPrint")
  valid_580395 = validateParameter(valid_580395, JBool, required = false,
                                 default = newJBool(true))
  if valid_580395 != nil:
    section.add "prettyPrint", valid_580395
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

proc call*(call_580397: Call_BigtableadminProjectsInstancesSetIamPolicy_580381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580397.validator(path, query, header, formData, body)
  let scheme = call_580397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580397.url(scheme.get, call_580397.host, call_580397.base,
                         call_580397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580397, url, valid)

proc call*(call_580398: Call_BigtableadminProjectsInstancesSetIamPolicy_580381;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesSetIamPolicy
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
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
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580399 = newJObject()
  var query_580400 = newJObject()
  var body_580401 = newJObject()
  add(query_580400, "upload_protocol", newJString(uploadProtocol))
  add(query_580400, "fields", newJString(fields))
  add(query_580400, "quotaUser", newJString(quotaUser))
  add(query_580400, "alt", newJString(alt))
  add(query_580400, "oauth_token", newJString(oauthToken))
  add(query_580400, "callback", newJString(callback))
  add(query_580400, "access_token", newJString(accessToken))
  add(query_580400, "uploadType", newJString(uploadType))
  add(query_580400, "key", newJString(key))
  add(query_580400, "$.xgafv", newJString(Xgafv))
  add(path_580399, "resource", newJString(resource))
  if body != nil:
    body_580401 = body
  add(query_580400, "prettyPrint", newJBool(prettyPrint))
  result = call_580398.call(path_580399, query_580400, nil, nil, body_580401)

var bigtableadminProjectsInstancesSetIamPolicy* = Call_BigtableadminProjectsInstancesSetIamPolicy_580381(
    name: "bigtableadminProjectsInstancesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{resource}:setIamPolicy",
    validator: validate_BigtableadminProjectsInstancesSetIamPolicy_580382,
    base: "/", url: url_BigtableadminProjectsInstancesSetIamPolicy_580383,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTestIamPermissions_580402 = ref object of OpenApiRestCall_579421
proc url_BigtableadminProjectsInstancesTestIamPermissions_580404(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTestIamPermissions_580403(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that the caller has on the specified instance resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580405 = path.getOrDefault("resource")
  valid_580405 = validateParameter(valid_580405, JString, required = true,
                                 default = nil)
  if valid_580405 != nil:
    section.add "resource", valid_580405
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
  var valid_580406 = query.getOrDefault("upload_protocol")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "upload_protocol", valid_580406
  var valid_580407 = query.getOrDefault("fields")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "fields", valid_580407
  var valid_580408 = query.getOrDefault("quotaUser")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "quotaUser", valid_580408
  var valid_580409 = query.getOrDefault("alt")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = newJString("json"))
  if valid_580409 != nil:
    section.add "alt", valid_580409
  var valid_580410 = query.getOrDefault("oauth_token")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "oauth_token", valid_580410
  var valid_580411 = query.getOrDefault("callback")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "callback", valid_580411
  var valid_580412 = query.getOrDefault("access_token")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "access_token", valid_580412
  var valid_580413 = query.getOrDefault("uploadType")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "uploadType", valid_580413
  var valid_580414 = query.getOrDefault("key")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "key", valid_580414
  var valid_580415 = query.getOrDefault("$.xgafv")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = newJString("1"))
  if valid_580415 != nil:
    section.add "$.xgafv", valid_580415
  var valid_580416 = query.getOrDefault("prettyPrint")
  valid_580416 = validateParameter(valid_580416, JBool, required = false,
                                 default = newJBool(true))
  if valid_580416 != nil:
    section.add "prettyPrint", valid_580416
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

proc call*(call_580418: Call_BigtableadminProjectsInstancesTestIamPermissions_580402;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that the caller has on the specified instance resource.
  ## 
  let valid = call_580418.validator(path, query, header, formData, body)
  let scheme = call_580418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580418.url(scheme.get, call_580418.host, call_580418.base,
                         call_580418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580418, url, valid)

proc call*(call_580419: Call_BigtableadminProjectsInstancesTestIamPermissions_580402;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigtableadminProjectsInstancesTestIamPermissions
  ## Returns permissions that the caller has on the specified instance resource.
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
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580420 = newJObject()
  var query_580421 = newJObject()
  var body_580422 = newJObject()
  add(query_580421, "upload_protocol", newJString(uploadProtocol))
  add(query_580421, "fields", newJString(fields))
  add(query_580421, "quotaUser", newJString(quotaUser))
  add(query_580421, "alt", newJString(alt))
  add(query_580421, "oauth_token", newJString(oauthToken))
  add(query_580421, "callback", newJString(callback))
  add(query_580421, "access_token", newJString(accessToken))
  add(query_580421, "uploadType", newJString(uploadType))
  add(query_580421, "key", newJString(key))
  add(query_580421, "$.xgafv", newJString(Xgafv))
  add(path_580420, "resource", newJString(resource))
  if body != nil:
    body_580422 = body
  add(query_580421, "prettyPrint", newJBool(prettyPrint))
  result = call_580419.call(path_580420, query_580421, nil, nil, body_580422)

var bigtableadminProjectsInstancesTestIamPermissions* = Call_BigtableadminProjectsInstancesTestIamPermissions_580402(
    name: "bigtableadminProjectsInstancesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_BigtableadminProjectsInstancesTestIamPermissions_580403,
    base: "/", url: url_BigtableadminProjectsInstancesTestIamPermissions_580404,
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
