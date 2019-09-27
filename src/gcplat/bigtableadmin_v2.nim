
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigtableadminProjectsInstancesClustersUpdate_597979 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesClustersUpdate_597981(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersUpdate_597980(path: JsonNode;
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
  var valid_597982 = path.getOrDefault("name")
  valid_597982 = validateParameter(valid_597982, JString, required = true,
                                 default = nil)
  if valid_597982 != nil:
    section.add "name", valid_597982
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
  var valid_597983 = query.getOrDefault("upload_protocol")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "upload_protocol", valid_597983
  var valid_597984 = query.getOrDefault("fields")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "fields", valid_597984
  var valid_597985 = query.getOrDefault("quotaUser")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "quotaUser", valid_597985
  var valid_597986 = query.getOrDefault("alt")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = newJString("json"))
  if valid_597986 != nil:
    section.add "alt", valid_597986
  var valid_597987 = query.getOrDefault("oauth_token")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = nil)
  if valid_597987 != nil:
    section.add "oauth_token", valid_597987
  var valid_597988 = query.getOrDefault("callback")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "callback", valid_597988
  var valid_597989 = query.getOrDefault("access_token")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "access_token", valid_597989
  var valid_597990 = query.getOrDefault("uploadType")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "uploadType", valid_597990
  var valid_597991 = query.getOrDefault("key")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "key", valid_597991
  var valid_597992 = query.getOrDefault("$.xgafv")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = newJString("1"))
  if valid_597992 != nil:
    section.add "$.xgafv", valid_597992
  var valid_597993 = query.getOrDefault("prettyPrint")
  valid_597993 = validateParameter(valid_597993, JBool, required = false,
                                 default = newJBool(true))
  if valid_597993 != nil:
    section.add "prettyPrint", valid_597993
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

proc call*(call_597995: Call_BigtableadminProjectsInstancesClustersUpdate_597979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster within an instance.
  ## 
  let valid = call_597995.validator(path, query, header, formData, body)
  let scheme = call_597995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597995.url(scheme.get, call_597995.host, call_597995.base,
                         call_597995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597995, url, valid)

proc call*(call_597996: Call_BigtableadminProjectsInstancesClustersUpdate_597979;
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
  var path_597997 = newJObject()
  var query_597998 = newJObject()
  var body_597999 = newJObject()
  add(query_597998, "upload_protocol", newJString(uploadProtocol))
  add(query_597998, "fields", newJString(fields))
  add(query_597998, "quotaUser", newJString(quotaUser))
  add(path_597997, "name", newJString(name))
  add(query_597998, "alt", newJString(alt))
  add(query_597998, "oauth_token", newJString(oauthToken))
  add(query_597998, "callback", newJString(callback))
  add(query_597998, "access_token", newJString(accessToken))
  add(query_597998, "uploadType", newJString(uploadType))
  add(query_597998, "key", newJString(key))
  add(query_597998, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597999 = body
  add(query_597998, "prettyPrint", newJBool(prettyPrint))
  result = call_597996.call(path_597997, query_597998, nil, nil, body_597999)

var bigtableadminProjectsInstancesClustersUpdate* = Call_BigtableadminProjectsInstancesClustersUpdate_597979(
    name: "bigtableadminProjectsInstancesClustersUpdate",
    meth: HttpMethod.HttpPut, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}",
    validator: validate_BigtableadminProjectsInstancesClustersUpdate_597980,
    base: "/", url: url_BigtableadminProjectsInstancesClustersUpdate_597981,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsGet_597690 = ref object of OpenApiRestCall_597421
proc url_BigtableadminOperationsGet_597692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsGet_597691(path: JsonNode; query: JsonNode;
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
  var valid_597818 = path.getOrDefault("name")
  valid_597818 = validateParameter(valid_597818, JString, required = true,
                                 default = nil)
  if valid_597818 != nil:
    section.add "name", valid_597818
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
  var valid_597819 = query.getOrDefault("upload_protocol")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "upload_protocol", valid_597819
  var valid_597820 = query.getOrDefault("fields")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "fields", valid_597820
  var valid_597834 = query.getOrDefault("view")
  valid_597834 = validateParameter(valid_597834, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_597834 != nil:
    section.add "view", valid_597834
  var valid_597835 = query.getOrDefault("quotaUser")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = nil)
  if valid_597835 != nil:
    section.add "quotaUser", valid_597835
  var valid_597836 = query.getOrDefault("alt")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = newJString("json"))
  if valid_597836 != nil:
    section.add "alt", valid_597836
  var valid_597837 = query.getOrDefault("oauth_token")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = nil)
  if valid_597837 != nil:
    section.add "oauth_token", valid_597837
  var valid_597838 = query.getOrDefault("callback")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = nil)
  if valid_597838 != nil:
    section.add "callback", valid_597838
  var valid_597839 = query.getOrDefault("access_token")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "access_token", valid_597839
  var valid_597840 = query.getOrDefault("uploadType")
  valid_597840 = validateParameter(valid_597840, JString, required = false,
                                 default = nil)
  if valid_597840 != nil:
    section.add "uploadType", valid_597840
  var valid_597841 = query.getOrDefault("key")
  valid_597841 = validateParameter(valid_597841, JString, required = false,
                                 default = nil)
  if valid_597841 != nil:
    section.add "key", valid_597841
  var valid_597842 = query.getOrDefault("$.xgafv")
  valid_597842 = validateParameter(valid_597842, JString, required = false,
                                 default = newJString("1"))
  if valid_597842 != nil:
    section.add "$.xgafv", valid_597842
  var valid_597843 = query.getOrDefault("prettyPrint")
  valid_597843 = validateParameter(valid_597843, JBool, required = false,
                                 default = newJBool(true))
  if valid_597843 != nil:
    section.add "prettyPrint", valid_597843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597866: Call_BigtableadminOperationsGet_597690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_597866.validator(path, query, header, formData, body)
  let scheme = call_597866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597866.url(scheme.get, call_597866.host, call_597866.base,
                         call_597866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597866, url, valid)

proc call*(call_597937: Call_BigtableadminOperationsGet_597690; name: string;
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
  var path_597938 = newJObject()
  var query_597940 = newJObject()
  add(query_597940, "upload_protocol", newJString(uploadProtocol))
  add(query_597940, "fields", newJString(fields))
  add(query_597940, "view", newJString(view))
  add(query_597940, "quotaUser", newJString(quotaUser))
  add(path_597938, "name", newJString(name))
  add(query_597940, "alt", newJString(alt))
  add(query_597940, "oauth_token", newJString(oauthToken))
  add(query_597940, "callback", newJString(callback))
  add(query_597940, "access_token", newJString(accessToken))
  add(query_597940, "uploadType", newJString(uploadType))
  add(query_597940, "key", newJString(key))
  add(query_597940, "$.xgafv", newJString(Xgafv))
  add(query_597940, "prettyPrint", newJBool(prettyPrint))
  result = call_597937.call(path_597938, query_597940, nil, nil, nil)

var bigtableadminOperationsGet* = Call_BigtableadminOperationsGet_597690(
    name: "bigtableadminOperationsGet", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}",
    validator: validate_BigtableadminOperationsGet_597691, base: "/",
    url: url_BigtableadminOperationsGet_597692, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesPatch_598020 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesAppProfilesPatch_598022(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesPatch_598021(
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
  var valid_598023 = path.getOrDefault("name")
  valid_598023 = validateParameter(valid_598023, JString, required = true,
                                 default = nil)
  if valid_598023 != nil:
    section.add "name", valid_598023
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
  var valid_598024 = query.getOrDefault("upload_protocol")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "upload_protocol", valid_598024
  var valid_598025 = query.getOrDefault("fields")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "fields", valid_598025
  var valid_598026 = query.getOrDefault("quotaUser")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "quotaUser", valid_598026
  var valid_598027 = query.getOrDefault("alt")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = newJString("json"))
  if valid_598027 != nil:
    section.add "alt", valid_598027
  var valid_598028 = query.getOrDefault("ignoreWarnings")
  valid_598028 = validateParameter(valid_598028, JBool, required = false, default = nil)
  if valid_598028 != nil:
    section.add "ignoreWarnings", valid_598028
  var valid_598029 = query.getOrDefault("oauth_token")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "oauth_token", valid_598029
  var valid_598030 = query.getOrDefault("callback")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "callback", valid_598030
  var valid_598031 = query.getOrDefault("access_token")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "access_token", valid_598031
  var valid_598032 = query.getOrDefault("uploadType")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "uploadType", valid_598032
  var valid_598033 = query.getOrDefault("key")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "key", valid_598033
  var valid_598034 = query.getOrDefault("$.xgafv")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = newJString("1"))
  if valid_598034 != nil:
    section.add "$.xgafv", valid_598034
  var valid_598035 = query.getOrDefault("prettyPrint")
  valid_598035 = validateParameter(valid_598035, JBool, required = false,
                                 default = newJBool(true))
  if valid_598035 != nil:
    section.add "prettyPrint", valid_598035
  var valid_598036 = query.getOrDefault("updateMask")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "updateMask", valid_598036
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

proc call*(call_598038: Call_BigtableadminProjectsInstancesAppProfilesPatch_598020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an app profile within an instance.
  ## 
  let valid = call_598038.validator(path, query, header, formData, body)
  let scheme = call_598038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598038.url(scheme.get, call_598038.host, call_598038.base,
                         call_598038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598038, url, valid)

proc call*(call_598039: Call_BigtableadminProjectsInstancesAppProfilesPatch_598020;
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
  var path_598040 = newJObject()
  var query_598041 = newJObject()
  var body_598042 = newJObject()
  add(query_598041, "upload_protocol", newJString(uploadProtocol))
  add(query_598041, "fields", newJString(fields))
  add(query_598041, "quotaUser", newJString(quotaUser))
  add(path_598040, "name", newJString(name))
  add(query_598041, "alt", newJString(alt))
  add(query_598041, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_598041, "oauth_token", newJString(oauthToken))
  add(query_598041, "callback", newJString(callback))
  add(query_598041, "access_token", newJString(accessToken))
  add(query_598041, "uploadType", newJString(uploadType))
  add(query_598041, "key", newJString(key))
  add(query_598041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598042 = body
  add(query_598041, "prettyPrint", newJBool(prettyPrint))
  add(query_598041, "updateMask", newJString(updateMask))
  result = call_598039.call(path_598040, query_598041, nil, nil, body_598042)

var bigtableadminProjectsInstancesAppProfilesPatch* = Call_BigtableadminProjectsInstancesAppProfilesPatch_598020(
    name: "bigtableadminProjectsInstancesAppProfilesPatch",
    meth: HttpMethod.HttpPatch, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}",
    validator: validate_BigtableadminProjectsInstancesAppProfilesPatch_598021,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesPatch_598022,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsDelete_598000 = ref object of OpenApiRestCall_597421
proc url_BigtableadminOperationsDelete_598002(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsDelete_598001(path: JsonNode; query: JsonNode;
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
  var valid_598003 = path.getOrDefault("name")
  valid_598003 = validateParameter(valid_598003, JString, required = true,
                                 default = nil)
  if valid_598003 != nil:
    section.add "name", valid_598003
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
  var valid_598004 = query.getOrDefault("upload_protocol")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "upload_protocol", valid_598004
  var valid_598005 = query.getOrDefault("fields")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "fields", valid_598005
  var valid_598006 = query.getOrDefault("quotaUser")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "quotaUser", valid_598006
  var valid_598007 = query.getOrDefault("alt")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = newJString("json"))
  if valid_598007 != nil:
    section.add "alt", valid_598007
  var valid_598008 = query.getOrDefault("ignoreWarnings")
  valid_598008 = validateParameter(valid_598008, JBool, required = false, default = nil)
  if valid_598008 != nil:
    section.add "ignoreWarnings", valid_598008
  var valid_598009 = query.getOrDefault("oauth_token")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "oauth_token", valid_598009
  var valid_598010 = query.getOrDefault("callback")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "callback", valid_598010
  var valid_598011 = query.getOrDefault("access_token")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "access_token", valid_598011
  var valid_598012 = query.getOrDefault("uploadType")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "uploadType", valid_598012
  var valid_598013 = query.getOrDefault("key")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "key", valid_598013
  var valid_598014 = query.getOrDefault("$.xgafv")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("1"))
  if valid_598014 != nil:
    section.add "$.xgafv", valid_598014
  var valid_598015 = query.getOrDefault("prettyPrint")
  valid_598015 = validateParameter(valid_598015, JBool, required = false,
                                 default = newJBool(true))
  if valid_598015 != nil:
    section.add "prettyPrint", valid_598015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598016: Call_BigtableadminOperationsDelete_598000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_598016.validator(path, query, header, formData, body)
  let scheme = call_598016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598016.url(scheme.get, call_598016.host, call_598016.base,
                         call_598016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598016, url, valid)

proc call*(call_598017: Call_BigtableadminOperationsDelete_598000; name: string;
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
  var path_598018 = newJObject()
  var query_598019 = newJObject()
  add(query_598019, "upload_protocol", newJString(uploadProtocol))
  add(query_598019, "fields", newJString(fields))
  add(query_598019, "quotaUser", newJString(quotaUser))
  add(path_598018, "name", newJString(name))
  add(query_598019, "alt", newJString(alt))
  add(query_598019, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_598019, "oauth_token", newJString(oauthToken))
  add(query_598019, "callback", newJString(callback))
  add(query_598019, "access_token", newJString(accessToken))
  add(query_598019, "uploadType", newJString(uploadType))
  add(query_598019, "key", newJString(key))
  add(query_598019, "$.xgafv", newJString(Xgafv))
  add(query_598019, "prettyPrint", newJBool(prettyPrint))
  result = call_598017.call(path_598018, query_598019, nil, nil, nil)

var bigtableadminOperationsDelete* = Call_BigtableadminOperationsDelete_598000(
    name: "bigtableadminOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}",
    validator: validate_BigtableadminOperationsDelete_598001, base: "/",
    url: url_BigtableadminOperationsDelete_598002, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsLocationsList_598043 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsLocationsList_598045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsLocationsList_598044(path: JsonNode;
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
  var valid_598046 = path.getOrDefault("name")
  valid_598046 = validateParameter(valid_598046, JString, required = true,
                                 default = nil)
  if valid_598046 != nil:
    section.add "name", valid_598046
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
  var valid_598047 = query.getOrDefault("upload_protocol")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "upload_protocol", valid_598047
  var valid_598048 = query.getOrDefault("fields")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = nil)
  if valid_598048 != nil:
    section.add "fields", valid_598048
  var valid_598049 = query.getOrDefault("pageToken")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "pageToken", valid_598049
  var valid_598050 = query.getOrDefault("quotaUser")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "quotaUser", valid_598050
  var valid_598051 = query.getOrDefault("alt")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = newJString("json"))
  if valid_598051 != nil:
    section.add "alt", valid_598051
  var valid_598052 = query.getOrDefault("oauth_token")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "oauth_token", valid_598052
  var valid_598053 = query.getOrDefault("callback")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "callback", valid_598053
  var valid_598054 = query.getOrDefault("access_token")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "access_token", valid_598054
  var valid_598055 = query.getOrDefault("uploadType")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "uploadType", valid_598055
  var valid_598056 = query.getOrDefault("key")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "key", valid_598056
  var valid_598057 = query.getOrDefault("$.xgafv")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = newJString("1"))
  if valid_598057 != nil:
    section.add "$.xgafv", valid_598057
  var valid_598058 = query.getOrDefault("pageSize")
  valid_598058 = validateParameter(valid_598058, JInt, required = false, default = nil)
  if valid_598058 != nil:
    section.add "pageSize", valid_598058
  var valid_598059 = query.getOrDefault("prettyPrint")
  valid_598059 = validateParameter(valid_598059, JBool, required = false,
                                 default = newJBool(true))
  if valid_598059 != nil:
    section.add "prettyPrint", valid_598059
  var valid_598060 = query.getOrDefault("filter")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "filter", valid_598060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598061: Call_BigtableadminProjectsLocationsList_598043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598061.validator(path, query, header, formData, body)
  let scheme = call_598061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598061.url(scheme.get, call_598061.host, call_598061.base,
                         call_598061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598061, url, valid)

proc call*(call_598062: Call_BigtableadminProjectsLocationsList_598043;
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
  var path_598063 = newJObject()
  var query_598064 = newJObject()
  add(query_598064, "upload_protocol", newJString(uploadProtocol))
  add(query_598064, "fields", newJString(fields))
  add(query_598064, "pageToken", newJString(pageToken))
  add(query_598064, "quotaUser", newJString(quotaUser))
  add(path_598063, "name", newJString(name))
  add(query_598064, "alt", newJString(alt))
  add(query_598064, "oauth_token", newJString(oauthToken))
  add(query_598064, "callback", newJString(callback))
  add(query_598064, "access_token", newJString(accessToken))
  add(query_598064, "uploadType", newJString(uploadType))
  add(query_598064, "key", newJString(key))
  add(query_598064, "$.xgafv", newJString(Xgafv))
  add(query_598064, "pageSize", newJInt(pageSize))
  add(query_598064, "prettyPrint", newJBool(prettyPrint))
  add(query_598064, "filter", newJString(filter))
  result = call_598062.call(path_598063, query_598064, nil, nil, nil)

var bigtableadminProjectsLocationsList* = Call_BigtableadminProjectsLocationsList_598043(
    name: "bigtableadminProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}/locations",
    validator: validate_BigtableadminProjectsLocationsList_598044, base: "/",
    url: url_BigtableadminProjectsLocationsList_598045, schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsProjectsOperationsList_598065 = ref object of OpenApiRestCall_597421
proc url_BigtableadminOperationsProjectsOperationsList_598067(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminOperationsProjectsOperationsList_598066(
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
  var valid_598068 = path.getOrDefault("name")
  valid_598068 = validateParameter(valid_598068, JString, required = true,
                                 default = nil)
  if valid_598068 != nil:
    section.add "name", valid_598068
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
  var valid_598069 = query.getOrDefault("upload_protocol")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "upload_protocol", valid_598069
  var valid_598070 = query.getOrDefault("fields")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "fields", valid_598070
  var valid_598071 = query.getOrDefault("pageToken")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "pageToken", valid_598071
  var valid_598072 = query.getOrDefault("quotaUser")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "quotaUser", valid_598072
  var valid_598073 = query.getOrDefault("alt")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = newJString("json"))
  if valid_598073 != nil:
    section.add "alt", valid_598073
  var valid_598074 = query.getOrDefault("oauth_token")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "oauth_token", valid_598074
  var valid_598075 = query.getOrDefault("callback")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "callback", valid_598075
  var valid_598076 = query.getOrDefault("access_token")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "access_token", valid_598076
  var valid_598077 = query.getOrDefault("uploadType")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "uploadType", valid_598077
  var valid_598078 = query.getOrDefault("key")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "key", valid_598078
  var valid_598079 = query.getOrDefault("$.xgafv")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = newJString("1"))
  if valid_598079 != nil:
    section.add "$.xgafv", valid_598079
  var valid_598080 = query.getOrDefault("pageSize")
  valid_598080 = validateParameter(valid_598080, JInt, required = false, default = nil)
  if valid_598080 != nil:
    section.add "pageSize", valid_598080
  var valid_598081 = query.getOrDefault("prettyPrint")
  valid_598081 = validateParameter(valid_598081, JBool, required = false,
                                 default = newJBool(true))
  if valid_598081 != nil:
    section.add "prettyPrint", valid_598081
  var valid_598082 = query.getOrDefault("filter")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "filter", valid_598082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598083: Call_BigtableadminOperationsProjectsOperationsList_598065;
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
  let valid = call_598083.validator(path, query, header, formData, body)
  let scheme = call_598083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598083.url(scheme.get, call_598083.host, call_598083.base,
                         call_598083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598083, url, valid)

proc call*(call_598084: Call_BigtableadminOperationsProjectsOperationsList_598065;
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
  var path_598085 = newJObject()
  var query_598086 = newJObject()
  add(query_598086, "upload_protocol", newJString(uploadProtocol))
  add(query_598086, "fields", newJString(fields))
  add(query_598086, "pageToken", newJString(pageToken))
  add(query_598086, "quotaUser", newJString(quotaUser))
  add(path_598085, "name", newJString(name))
  add(query_598086, "alt", newJString(alt))
  add(query_598086, "oauth_token", newJString(oauthToken))
  add(query_598086, "callback", newJString(callback))
  add(query_598086, "access_token", newJString(accessToken))
  add(query_598086, "uploadType", newJString(uploadType))
  add(query_598086, "key", newJString(key))
  add(query_598086, "$.xgafv", newJString(Xgafv))
  add(query_598086, "pageSize", newJInt(pageSize))
  add(query_598086, "prettyPrint", newJBool(prettyPrint))
  add(query_598086, "filter", newJString(filter))
  result = call_598084.call(path_598085, query_598086, nil, nil, nil)

var bigtableadminOperationsProjectsOperationsList* = Call_BigtableadminOperationsProjectsOperationsList_598065(
    name: "bigtableadminOperationsProjectsOperationsList",
    meth: HttpMethod.HttpGet, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}/operations",
    validator: validate_BigtableadminOperationsProjectsOperationsList_598066,
    base: "/", url: url_BigtableadminOperationsProjectsOperationsList_598067,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsCancel_598087 = ref object of OpenApiRestCall_597421
proc url_BigtableadminOperationsCancel_598089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminOperationsCancel_598088(path: JsonNode; query: JsonNode;
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
  var valid_598090 = path.getOrDefault("name")
  valid_598090 = validateParameter(valid_598090, JString, required = true,
                                 default = nil)
  if valid_598090 != nil:
    section.add "name", valid_598090
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
  var valid_598091 = query.getOrDefault("upload_protocol")
  valid_598091 = validateParameter(valid_598091, JString, required = false,
                                 default = nil)
  if valid_598091 != nil:
    section.add "upload_protocol", valid_598091
  var valid_598092 = query.getOrDefault("fields")
  valid_598092 = validateParameter(valid_598092, JString, required = false,
                                 default = nil)
  if valid_598092 != nil:
    section.add "fields", valid_598092
  var valid_598093 = query.getOrDefault("quotaUser")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "quotaUser", valid_598093
  var valid_598094 = query.getOrDefault("alt")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = newJString("json"))
  if valid_598094 != nil:
    section.add "alt", valid_598094
  var valid_598095 = query.getOrDefault("oauth_token")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "oauth_token", valid_598095
  var valid_598096 = query.getOrDefault("callback")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "callback", valid_598096
  var valid_598097 = query.getOrDefault("access_token")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "access_token", valid_598097
  var valid_598098 = query.getOrDefault("uploadType")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "uploadType", valid_598098
  var valid_598099 = query.getOrDefault("key")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "key", valid_598099
  var valid_598100 = query.getOrDefault("$.xgafv")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = newJString("1"))
  if valid_598100 != nil:
    section.add "$.xgafv", valid_598100
  var valid_598101 = query.getOrDefault("prettyPrint")
  valid_598101 = validateParameter(valid_598101, JBool, required = false,
                                 default = newJBool(true))
  if valid_598101 != nil:
    section.add "prettyPrint", valid_598101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598102: Call_BigtableadminOperationsCancel_598087; path: JsonNode;
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
  let valid = call_598102.validator(path, query, header, formData, body)
  let scheme = call_598102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598102.url(scheme.get, call_598102.host, call_598102.base,
                         call_598102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598102, url, valid)

proc call*(call_598103: Call_BigtableadminOperationsCancel_598087; name: string;
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
  var path_598104 = newJObject()
  var query_598105 = newJObject()
  add(query_598105, "upload_protocol", newJString(uploadProtocol))
  add(query_598105, "fields", newJString(fields))
  add(query_598105, "quotaUser", newJString(quotaUser))
  add(path_598104, "name", newJString(name))
  add(query_598105, "alt", newJString(alt))
  add(query_598105, "oauth_token", newJString(oauthToken))
  add(query_598105, "callback", newJString(callback))
  add(query_598105, "access_token", newJString(accessToken))
  add(query_598105, "uploadType", newJString(uploadType))
  add(query_598105, "key", newJString(key))
  add(query_598105, "$.xgafv", newJString(Xgafv))
  add(query_598105, "prettyPrint", newJBool(prettyPrint))
  result = call_598103.call(path_598104, query_598105, nil, nil, nil)

var bigtableadminOperationsCancel* = Call_BigtableadminOperationsCancel_598087(
    name: "bigtableadminOperationsCancel", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}:cancel",
    validator: validate_BigtableadminOperationsCancel_598088, base: "/",
    url: url_BigtableadminOperationsCancel_598089, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesCheckConsistency_598106 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesTablesCheckConsistency_598108(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesTablesCheckConsistency_598107(
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
  var valid_598109 = path.getOrDefault("name")
  valid_598109 = validateParameter(valid_598109, JString, required = true,
                                 default = nil)
  if valid_598109 != nil:
    section.add "name", valid_598109
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
  var valid_598110 = query.getOrDefault("upload_protocol")
  valid_598110 = validateParameter(valid_598110, JString, required = false,
                                 default = nil)
  if valid_598110 != nil:
    section.add "upload_protocol", valid_598110
  var valid_598111 = query.getOrDefault("fields")
  valid_598111 = validateParameter(valid_598111, JString, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "fields", valid_598111
  var valid_598112 = query.getOrDefault("quotaUser")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "quotaUser", valid_598112
  var valid_598113 = query.getOrDefault("alt")
  valid_598113 = validateParameter(valid_598113, JString, required = false,
                                 default = newJString("json"))
  if valid_598113 != nil:
    section.add "alt", valid_598113
  var valid_598114 = query.getOrDefault("oauth_token")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "oauth_token", valid_598114
  var valid_598115 = query.getOrDefault("callback")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "callback", valid_598115
  var valid_598116 = query.getOrDefault("access_token")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "access_token", valid_598116
  var valid_598117 = query.getOrDefault("uploadType")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "uploadType", valid_598117
  var valid_598118 = query.getOrDefault("key")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "key", valid_598118
  var valid_598119 = query.getOrDefault("$.xgafv")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = newJString("1"))
  if valid_598119 != nil:
    section.add "$.xgafv", valid_598119
  var valid_598120 = query.getOrDefault("prettyPrint")
  valid_598120 = validateParameter(valid_598120, JBool, required = false,
                                 default = newJBool(true))
  if valid_598120 != nil:
    section.add "prettyPrint", valid_598120
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

proc call*(call_598122: Call_BigtableadminProjectsInstancesTablesCheckConsistency_598106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
  ## 
  let valid = call_598122.validator(path, query, header, formData, body)
  let scheme = call_598122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598122.url(scheme.get, call_598122.host, call_598122.base,
                         call_598122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598122, url, valid)

proc call*(call_598123: Call_BigtableadminProjectsInstancesTablesCheckConsistency_598106;
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
  var path_598124 = newJObject()
  var query_598125 = newJObject()
  var body_598126 = newJObject()
  add(query_598125, "upload_protocol", newJString(uploadProtocol))
  add(query_598125, "fields", newJString(fields))
  add(query_598125, "quotaUser", newJString(quotaUser))
  add(path_598124, "name", newJString(name))
  add(query_598125, "alt", newJString(alt))
  add(query_598125, "oauth_token", newJString(oauthToken))
  add(query_598125, "callback", newJString(callback))
  add(query_598125, "access_token", newJString(accessToken))
  add(query_598125, "uploadType", newJString(uploadType))
  add(query_598125, "key", newJString(key))
  add(query_598125, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598126 = body
  add(query_598125, "prettyPrint", newJBool(prettyPrint))
  result = call_598123.call(path_598124, query_598125, nil, nil, body_598126)

var bigtableadminProjectsInstancesTablesCheckConsistency* = Call_BigtableadminProjectsInstancesTablesCheckConsistency_598106(
    name: "bigtableadminProjectsInstancesTablesCheckConsistency",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:checkConsistency",
    validator: validate_BigtableadminProjectsInstancesTablesCheckConsistency_598107,
    base: "/", url: url_BigtableadminProjectsInstancesTablesCheckConsistency_598108,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesDropRowRange_598127 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesTablesDropRowRange_598129(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesTablesDropRowRange_598128(
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
  var valid_598130 = path.getOrDefault("name")
  valid_598130 = validateParameter(valid_598130, JString, required = true,
                                 default = nil)
  if valid_598130 != nil:
    section.add "name", valid_598130
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
  var valid_598131 = query.getOrDefault("upload_protocol")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "upload_protocol", valid_598131
  var valid_598132 = query.getOrDefault("fields")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = nil)
  if valid_598132 != nil:
    section.add "fields", valid_598132
  var valid_598133 = query.getOrDefault("quotaUser")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "quotaUser", valid_598133
  var valid_598134 = query.getOrDefault("alt")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = newJString("json"))
  if valid_598134 != nil:
    section.add "alt", valid_598134
  var valid_598135 = query.getOrDefault("oauth_token")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "oauth_token", valid_598135
  var valid_598136 = query.getOrDefault("callback")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "callback", valid_598136
  var valid_598137 = query.getOrDefault("access_token")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "access_token", valid_598137
  var valid_598138 = query.getOrDefault("uploadType")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "uploadType", valid_598138
  var valid_598139 = query.getOrDefault("key")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "key", valid_598139
  var valid_598140 = query.getOrDefault("$.xgafv")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = newJString("1"))
  if valid_598140 != nil:
    section.add "$.xgafv", valid_598140
  var valid_598141 = query.getOrDefault("prettyPrint")
  valid_598141 = validateParameter(valid_598141, JBool, required = false,
                                 default = newJBool(true))
  if valid_598141 != nil:
    section.add "prettyPrint", valid_598141
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

proc call*(call_598143: Call_BigtableadminProjectsInstancesTablesDropRowRange_598127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
  ## 
  let valid = call_598143.validator(path, query, header, formData, body)
  let scheme = call_598143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598143.url(scheme.get, call_598143.host, call_598143.base,
                         call_598143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598143, url, valid)

proc call*(call_598144: Call_BigtableadminProjectsInstancesTablesDropRowRange_598127;
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
  var path_598145 = newJObject()
  var query_598146 = newJObject()
  var body_598147 = newJObject()
  add(query_598146, "upload_protocol", newJString(uploadProtocol))
  add(query_598146, "fields", newJString(fields))
  add(query_598146, "quotaUser", newJString(quotaUser))
  add(path_598145, "name", newJString(name))
  add(query_598146, "alt", newJString(alt))
  add(query_598146, "oauth_token", newJString(oauthToken))
  add(query_598146, "callback", newJString(callback))
  add(query_598146, "access_token", newJString(accessToken))
  add(query_598146, "uploadType", newJString(uploadType))
  add(query_598146, "key", newJString(key))
  add(query_598146, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598147 = body
  add(query_598146, "prettyPrint", newJBool(prettyPrint))
  result = call_598144.call(path_598145, query_598146, nil, nil, body_598147)

var bigtableadminProjectsInstancesTablesDropRowRange* = Call_BigtableadminProjectsInstancesTablesDropRowRange_598127(
    name: "bigtableadminProjectsInstancesTablesDropRowRange",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:dropRowRange",
    validator: validate_BigtableadminProjectsInstancesTablesDropRowRange_598128,
    base: "/", url: url_BigtableadminProjectsInstancesTablesDropRowRange_598129,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_598148 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_598150(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_598149(
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
  var valid_598151 = path.getOrDefault("name")
  valid_598151 = validateParameter(valid_598151, JString, required = true,
                                 default = nil)
  if valid_598151 != nil:
    section.add "name", valid_598151
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
  var valid_598152 = query.getOrDefault("upload_protocol")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "upload_protocol", valid_598152
  var valid_598153 = query.getOrDefault("fields")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "fields", valid_598153
  var valid_598154 = query.getOrDefault("quotaUser")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "quotaUser", valid_598154
  var valid_598155 = query.getOrDefault("alt")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = newJString("json"))
  if valid_598155 != nil:
    section.add "alt", valid_598155
  var valid_598156 = query.getOrDefault("oauth_token")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "oauth_token", valid_598156
  var valid_598157 = query.getOrDefault("callback")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "callback", valid_598157
  var valid_598158 = query.getOrDefault("access_token")
  valid_598158 = validateParameter(valid_598158, JString, required = false,
                                 default = nil)
  if valid_598158 != nil:
    section.add "access_token", valid_598158
  var valid_598159 = query.getOrDefault("uploadType")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "uploadType", valid_598159
  var valid_598160 = query.getOrDefault("key")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "key", valid_598160
  var valid_598161 = query.getOrDefault("$.xgafv")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = newJString("1"))
  if valid_598161 != nil:
    section.add "$.xgafv", valid_598161
  var valid_598162 = query.getOrDefault("prettyPrint")
  valid_598162 = validateParameter(valid_598162, JBool, required = false,
                                 default = newJBool(true))
  if valid_598162 != nil:
    section.add "prettyPrint", valid_598162
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

proc call*(call_598164: Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_598148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
  ## 
  let valid = call_598164.validator(path, query, header, formData, body)
  let scheme = call_598164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598164.url(scheme.get, call_598164.host, call_598164.base,
                         call_598164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598164, url, valid)

proc call*(call_598165: Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_598148;
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
  var path_598166 = newJObject()
  var query_598167 = newJObject()
  var body_598168 = newJObject()
  add(query_598167, "upload_protocol", newJString(uploadProtocol))
  add(query_598167, "fields", newJString(fields))
  add(query_598167, "quotaUser", newJString(quotaUser))
  add(path_598166, "name", newJString(name))
  add(query_598167, "alt", newJString(alt))
  add(query_598167, "oauth_token", newJString(oauthToken))
  add(query_598167, "callback", newJString(callback))
  add(query_598167, "access_token", newJString(accessToken))
  add(query_598167, "uploadType", newJString(uploadType))
  add(query_598167, "key", newJString(key))
  add(query_598167, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598168 = body
  add(query_598167, "prettyPrint", newJBool(prettyPrint))
  result = call_598165.call(path_598166, query_598167, nil, nil, body_598168)

var bigtableadminProjectsInstancesTablesGenerateConsistencyToken* = Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_598148(
    name: "bigtableadminProjectsInstancesTablesGenerateConsistencyToken",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:generateConsistencyToken", validator: validate_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_598149,
    base: "/",
    url: url_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_598150,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_598169 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesTablesModifyColumnFamilies_598171(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesTablesModifyColumnFamilies_598170(
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
  var valid_598172 = path.getOrDefault("name")
  valid_598172 = validateParameter(valid_598172, JString, required = true,
                                 default = nil)
  if valid_598172 != nil:
    section.add "name", valid_598172
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
  var valid_598173 = query.getOrDefault("upload_protocol")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "upload_protocol", valid_598173
  var valid_598174 = query.getOrDefault("fields")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "fields", valid_598174
  var valid_598175 = query.getOrDefault("quotaUser")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "quotaUser", valid_598175
  var valid_598176 = query.getOrDefault("alt")
  valid_598176 = validateParameter(valid_598176, JString, required = false,
                                 default = newJString("json"))
  if valid_598176 != nil:
    section.add "alt", valid_598176
  var valid_598177 = query.getOrDefault("oauth_token")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "oauth_token", valid_598177
  var valid_598178 = query.getOrDefault("callback")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "callback", valid_598178
  var valid_598179 = query.getOrDefault("access_token")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "access_token", valid_598179
  var valid_598180 = query.getOrDefault("uploadType")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "uploadType", valid_598180
  var valid_598181 = query.getOrDefault("key")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = nil)
  if valid_598181 != nil:
    section.add "key", valid_598181
  var valid_598182 = query.getOrDefault("$.xgafv")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = newJString("1"))
  if valid_598182 != nil:
    section.add "$.xgafv", valid_598182
  var valid_598183 = query.getOrDefault("prettyPrint")
  valid_598183 = validateParameter(valid_598183, JBool, required = false,
                                 default = newJBool(true))
  if valid_598183 != nil:
    section.add "prettyPrint", valid_598183
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

proc call*(call_598185: Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_598169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
  ## 
  let valid = call_598185.validator(path, query, header, formData, body)
  let scheme = call_598185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598185.url(scheme.get, call_598185.host, call_598185.base,
                         call_598185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598185, url, valid)

proc call*(call_598186: Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_598169;
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
  var path_598187 = newJObject()
  var query_598188 = newJObject()
  var body_598189 = newJObject()
  add(query_598188, "upload_protocol", newJString(uploadProtocol))
  add(query_598188, "fields", newJString(fields))
  add(query_598188, "quotaUser", newJString(quotaUser))
  add(path_598187, "name", newJString(name))
  add(query_598188, "alt", newJString(alt))
  add(query_598188, "oauth_token", newJString(oauthToken))
  add(query_598188, "callback", newJString(callback))
  add(query_598188, "access_token", newJString(accessToken))
  add(query_598188, "uploadType", newJString(uploadType))
  add(query_598188, "key", newJString(key))
  add(query_598188, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598189 = body
  add(query_598188, "prettyPrint", newJBool(prettyPrint))
  result = call_598186.call(path_598187, query_598188, nil, nil, body_598189)

var bigtableadminProjectsInstancesTablesModifyColumnFamilies* = Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_598169(
    name: "bigtableadminProjectsInstancesTablesModifyColumnFamilies",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:modifyColumnFamilies", validator: validate_BigtableadminProjectsInstancesTablesModifyColumnFamilies_598170,
    base: "/", url: url_BigtableadminProjectsInstancesTablesModifyColumnFamilies_598171,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesCreate_598211 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesAppProfilesCreate_598213(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesAppProfilesCreate_598212(
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
  var valid_598214 = path.getOrDefault("parent")
  valid_598214 = validateParameter(valid_598214, JString, required = true,
                                 default = nil)
  if valid_598214 != nil:
    section.add "parent", valid_598214
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
  var valid_598215 = query.getOrDefault("upload_protocol")
  valid_598215 = validateParameter(valid_598215, JString, required = false,
                                 default = nil)
  if valid_598215 != nil:
    section.add "upload_protocol", valid_598215
  var valid_598216 = query.getOrDefault("fields")
  valid_598216 = validateParameter(valid_598216, JString, required = false,
                                 default = nil)
  if valid_598216 != nil:
    section.add "fields", valid_598216
  var valid_598217 = query.getOrDefault("quotaUser")
  valid_598217 = validateParameter(valid_598217, JString, required = false,
                                 default = nil)
  if valid_598217 != nil:
    section.add "quotaUser", valid_598217
  var valid_598218 = query.getOrDefault("alt")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = newJString("json"))
  if valid_598218 != nil:
    section.add "alt", valid_598218
  var valid_598219 = query.getOrDefault("ignoreWarnings")
  valid_598219 = validateParameter(valid_598219, JBool, required = false, default = nil)
  if valid_598219 != nil:
    section.add "ignoreWarnings", valid_598219
  var valid_598220 = query.getOrDefault("oauth_token")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "oauth_token", valid_598220
  var valid_598221 = query.getOrDefault("callback")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "callback", valid_598221
  var valid_598222 = query.getOrDefault("access_token")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "access_token", valid_598222
  var valid_598223 = query.getOrDefault("uploadType")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "uploadType", valid_598223
  var valid_598224 = query.getOrDefault("key")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "key", valid_598224
  var valid_598225 = query.getOrDefault("appProfileId")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "appProfileId", valid_598225
  var valid_598226 = query.getOrDefault("$.xgafv")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = newJString("1"))
  if valid_598226 != nil:
    section.add "$.xgafv", valid_598226
  var valid_598227 = query.getOrDefault("prettyPrint")
  valid_598227 = validateParameter(valid_598227, JBool, required = false,
                                 default = newJBool(true))
  if valid_598227 != nil:
    section.add "prettyPrint", valid_598227
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

proc call*(call_598229: Call_BigtableadminProjectsInstancesAppProfilesCreate_598211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an app profile within an instance.
  ## 
  let valid = call_598229.validator(path, query, header, formData, body)
  let scheme = call_598229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598229.url(scheme.get, call_598229.host, call_598229.base,
                         call_598229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598229, url, valid)

proc call*(call_598230: Call_BigtableadminProjectsInstancesAppProfilesCreate_598211;
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
  var path_598231 = newJObject()
  var query_598232 = newJObject()
  var body_598233 = newJObject()
  add(query_598232, "upload_protocol", newJString(uploadProtocol))
  add(query_598232, "fields", newJString(fields))
  add(query_598232, "quotaUser", newJString(quotaUser))
  add(query_598232, "alt", newJString(alt))
  add(query_598232, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_598232, "oauth_token", newJString(oauthToken))
  add(query_598232, "callback", newJString(callback))
  add(query_598232, "access_token", newJString(accessToken))
  add(query_598232, "uploadType", newJString(uploadType))
  add(path_598231, "parent", newJString(parent))
  add(query_598232, "key", newJString(key))
  add(query_598232, "appProfileId", newJString(appProfileId))
  add(query_598232, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598233 = body
  add(query_598232, "prettyPrint", newJBool(prettyPrint))
  result = call_598230.call(path_598231, query_598232, nil, nil, body_598233)

var bigtableadminProjectsInstancesAppProfilesCreate* = Call_BigtableadminProjectsInstancesAppProfilesCreate_598211(
    name: "bigtableadminProjectsInstancesAppProfilesCreate",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/appProfiles",
    validator: validate_BigtableadminProjectsInstancesAppProfilesCreate_598212,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesCreate_598213,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesList_598190 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesAppProfilesList_598192(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesAppProfilesList_598191(
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
  var valid_598193 = path.getOrDefault("parent")
  valid_598193 = validateParameter(valid_598193, JString, required = true,
                                 default = nil)
  if valid_598193 != nil:
    section.add "parent", valid_598193
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
  var valid_598194 = query.getOrDefault("upload_protocol")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "upload_protocol", valid_598194
  var valid_598195 = query.getOrDefault("fields")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "fields", valid_598195
  var valid_598196 = query.getOrDefault("pageToken")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = nil)
  if valid_598196 != nil:
    section.add "pageToken", valid_598196
  var valid_598197 = query.getOrDefault("quotaUser")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "quotaUser", valid_598197
  var valid_598198 = query.getOrDefault("alt")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = newJString("json"))
  if valid_598198 != nil:
    section.add "alt", valid_598198
  var valid_598199 = query.getOrDefault("oauth_token")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "oauth_token", valid_598199
  var valid_598200 = query.getOrDefault("callback")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "callback", valid_598200
  var valid_598201 = query.getOrDefault("access_token")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "access_token", valid_598201
  var valid_598202 = query.getOrDefault("uploadType")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "uploadType", valid_598202
  var valid_598203 = query.getOrDefault("key")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "key", valid_598203
  var valid_598204 = query.getOrDefault("$.xgafv")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = newJString("1"))
  if valid_598204 != nil:
    section.add "$.xgafv", valid_598204
  var valid_598205 = query.getOrDefault("pageSize")
  valid_598205 = validateParameter(valid_598205, JInt, required = false, default = nil)
  if valid_598205 != nil:
    section.add "pageSize", valid_598205
  var valid_598206 = query.getOrDefault("prettyPrint")
  valid_598206 = validateParameter(valid_598206, JBool, required = false,
                                 default = newJBool(true))
  if valid_598206 != nil:
    section.add "prettyPrint", valid_598206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598207: Call_BigtableadminProjectsInstancesAppProfilesList_598190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about app profiles in an instance.
  ## 
  let valid = call_598207.validator(path, query, header, formData, body)
  let scheme = call_598207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598207.url(scheme.get, call_598207.host, call_598207.base,
                         call_598207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598207, url, valid)

proc call*(call_598208: Call_BigtableadminProjectsInstancesAppProfilesList_598190;
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
  var path_598209 = newJObject()
  var query_598210 = newJObject()
  add(query_598210, "upload_protocol", newJString(uploadProtocol))
  add(query_598210, "fields", newJString(fields))
  add(query_598210, "pageToken", newJString(pageToken))
  add(query_598210, "quotaUser", newJString(quotaUser))
  add(query_598210, "alt", newJString(alt))
  add(query_598210, "oauth_token", newJString(oauthToken))
  add(query_598210, "callback", newJString(callback))
  add(query_598210, "access_token", newJString(accessToken))
  add(query_598210, "uploadType", newJString(uploadType))
  add(path_598209, "parent", newJString(parent))
  add(query_598210, "key", newJString(key))
  add(query_598210, "$.xgafv", newJString(Xgafv))
  add(query_598210, "pageSize", newJInt(pageSize))
  add(query_598210, "prettyPrint", newJBool(prettyPrint))
  result = call_598208.call(path_598209, query_598210, nil, nil, nil)

var bigtableadminProjectsInstancesAppProfilesList* = Call_BigtableadminProjectsInstancesAppProfilesList_598190(
    name: "bigtableadminProjectsInstancesAppProfilesList",
    meth: HttpMethod.HttpGet, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/appProfiles",
    validator: validate_BigtableadminProjectsInstancesAppProfilesList_598191,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesList_598192,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesClustersCreate_598254 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesClustersCreate_598256(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesClustersCreate_598255(path: JsonNode;
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
  var valid_598257 = path.getOrDefault("parent")
  valid_598257 = validateParameter(valid_598257, JString, required = true,
                                 default = nil)
  if valid_598257 != nil:
    section.add "parent", valid_598257
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
  var valid_598258 = query.getOrDefault("upload_protocol")
  valid_598258 = validateParameter(valid_598258, JString, required = false,
                                 default = nil)
  if valid_598258 != nil:
    section.add "upload_protocol", valid_598258
  var valid_598259 = query.getOrDefault("fields")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = nil)
  if valid_598259 != nil:
    section.add "fields", valid_598259
  var valid_598260 = query.getOrDefault("quotaUser")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = nil)
  if valid_598260 != nil:
    section.add "quotaUser", valid_598260
  var valid_598261 = query.getOrDefault("alt")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = newJString("json"))
  if valid_598261 != nil:
    section.add "alt", valid_598261
  var valid_598262 = query.getOrDefault("oauth_token")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "oauth_token", valid_598262
  var valid_598263 = query.getOrDefault("callback")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = nil)
  if valid_598263 != nil:
    section.add "callback", valid_598263
  var valid_598264 = query.getOrDefault("access_token")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "access_token", valid_598264
  var valid_598265 = query.getOrDefault("uploadType")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "uploadType", valid_598265
  var valid_598266 = query.getOrDefault("key")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "key", valid_598266
  var valid_598267 = query.getOrDefault("$.xgafv")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = newJString("1"))
  if valid_598267 != nil:
    section.add "$.xgafv", valid_598267
  var valid_598268 = query.getOrDefault("prettyPrint")
  valid_598268 = validateParameter(valid_598268, JBool, required = false,
                                 default = newJBool(true))
  if valid_598268 != nil:
    section.add "prettyPrint", valid_598268
  var valid_598269 = query.getOrDefault("clusterId")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "clusterId", valid_598269
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

proc call*(call_598271: Call_BigtableadminProjectsInstancesClustersCreate_598254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster within an instance.
  ## 
  let valid = call_598271.validator(path, query, header, formData, body)
  let scheme = call_598271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598271.url(scheme.get, call_598271.host, call_598271.base,
                         call_598271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598271, url, valid)

proc call*(call_598272: Call_BigtableadminProjectsInstancesClustersCreate_598254;
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
  var path_598273 = newJObject()
  var query_598274 = newJObject()
  var body_598275 = newJObject()
  add(query_598274, "upload_protocol", newJString(uploadProtocol))
  add(query_598274, "fields", newJString(fields))
  add(query_598274, "quotaUser", newJString(quotaUser))
  add(query_598274, "alt", newJString(alt))
  add(query_598274, "oauth_token", newJString(oauthToken))
  add(query_598274, "callback", newJString(callback))
  add(query_598274, "access_token", newJString(accessToken))
  add(query_598274, "uploadType", newJString(uploadType))
  add(path_598273, "parent", newJString(parent))
  add(query_598274, "key", newJString(key))
  add(query_598274, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598275 = body
  add(query_598274, "prettyPrint", newJBool(prettyPrint))
  add(query_598274, "clusterId", newJString(clusterId))
  result = call_598272.call(path_598273, query_598274, nil, nil, body_598275)

var bigtableadminProjectsInstancesClustersCreate* = Call_BigtableadminProjectsInstancesClustersCreate_598254(
    name: "bigtableadminProjectsInstancesClustersCreate",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/clusters",
    validator: validate_BigtableadminProjectsInstancesClustersCreate_598255,
    base: "/", url: url_BigtableadminProjectsInstancesClustersCreate_598256,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesClustersList_598234 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesClustersList_598236(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesClustersList_598235(path: JsonNode;
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
  var valid_598237 = path.getOrDefault("parent")
  valid_598237 = validateParameter(valid_598237, JString, required = true,
                                 default = nil)
  if valid_598237 != nil:
    section.add "parent", valid_598237
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
  var valid_598238 = query.getOrDefault("upload_protocol")
  valid_598238 = validateParameter(valid_598238, JString, required = false,
                                 default = nil)
  if valid_598238 != nil:
    section.add "upload_protocol", valid_598238
  var valid_598239 = query.getOrDefault("fields")
  valid_598239 = validateParameter(valid_598239, JString, required = false,
                                 default = nil)
  if valid_598239 != nil:
    section.add "fields", valid_598239
  var valid_598240 = query.getOrDefault("pageToken")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "pageToken", valid_598240
  var valid_598241 = query.getOrDefault("quotaUser")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = nil)
  if valid_598241 != nil:
    section.add "quotaUser", valid_598241
  var valid_598242 = query.getOrDefault("alt")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = newJString("json"))
  if valid_598242 != nil:
    section.add "alt", valid_598242
  var valid_598243 = query.getOrDefault("oauth_token")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = nil)
  if valid_598243 != nil:
    section.add "oauth_token", valid_598243
  var valid_598244 = query.getOrDefault("callback")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "callback", valid_598244
  var valid_598245 = query.getOrDefault("access_token")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "access_token", valid_598245
  var valid_598246 = query.getOrDefault("uploadType")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "uploadType", valid_598246
  var valid_598247 = query.getOrDefault("key")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "key", valid_598247
  var valid_598248 = query.getOrDefault("$.xgafv")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = newJString("1"))
  if valid_598248 != nil:
    section.add "$.xgafv", valid_598248
  var valid_598249 = query.getOrDefault("prettyPrint")
  valid_598249 = validateParameter(valid_598249, JBool, required = false,
                                 default = newJBool(true))
  if valid_598249 != nil:
    section.add "prettyPrint", valid_598249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598250: Call_BigtableadminProjectsInstancesClustersList_598234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about clusters in an instance.
  ## 
  let valid = call_598250.validator(path, query, header, formData, body)
  let scheme = call_598250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598250.url(scheme.get, call_598250.host, call_598250.base,
                         call_598250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598250, url, valid)

proc call*(call_598251: Call_BigtableadminProjectsInstancesClustersList_598234;
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
  var path_598252 = newJObject()
  var query_598253 = newJObject()
  add(query_598253, "upload_protocol", newJString(uploadProtocol))
  add(query_598253, "fields", newJString(fields))
  add(query_598253, "pageToken", newJString(pageToken))
  add(query_598253, "quotaUser", newJString(quotaUser))
  add(query_598253, "alt", newJString(alt))
  add(query_598253, "oauth_token", newJString(oauthToken))
  add(query_598253, "callback", newJString(callback))
  add(query_598253, "access_token", newJString(accessToken))
  add(query_598253, "uploadType", newJString(uploadType))
  add(path_598252, "parent", newJString(parent))
  add(query_598253, "key", newJString(key))
  add(query_598253, "$.xgafv", newJString(Xgafv))
  add(query_598253, "prettyPrint", newJBool(prettyPrint))
  result = call_598251.call(path_598252, query_598253, nil, nil, nil)

var bigtableadminProjectsInstancesClustersList* = Call_BigtableadminProjectsInstancesClustersList_598234(
    name: "bigtableadminProjectsInstancesClustersList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/clusters",
    validator: validate_BigtableadminProjectsInstancesClustersList_598235,
    base: "/", url: url_BigtableadminProjectsInstancesClustersList_598236,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesCreate_598296 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesCreate_598298(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesCreate_598297(path: JsonNode;
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
  var valid_598299 = path.getOrDefault("parent")
  valid_598299 = validateParameter(valid_598299, JString, required = true,
                                 default = nil)
  if valid_598299 != nil:
    section.add "parent", valid_598299
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
  var valid_598300 = query.getOrDefault("upload_protocol")
  valid_598300 = validateParameter(valid_598300, JString, required = false,
                                 default = nil)
  if valid_598300 != nil:
    section.add "upload_protocol", valid_598300
  var valid_598301 = query.getOrDefault("fields")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = nil)
  if valid_598301 != nil:
    section.add "fields", valid_598301
  var valid_598302 = query.getOrDefault("quotaUser")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "quotaUser", valid_598302
  var valid_598303 = query.getOrDefault("alt")
  valid_598303 = validateParameter(valid_598303, JString, required = false,
                                 default = newJString("json"))
  if valid_598303 != nil:
    section.add "alt", valid_598303
  var valid_598304 = query.getOrDefault("oauth_token")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = nil)
  if valid_598304 != nil:
    section.add "oauth_token", valid_598304
  var valid_598305 = query.getOrDefault("callback")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = nil)
  if valid_598305 != nil:
    section.add "callback", valid_598305
  var valid_598306 = query.getOrDefault("access_token")
  valid_598306 = validateParameter(valid_598306, JString, required = false,
                                 default = nil)
  if valid_598306 != nil:
    section.add "access_token", valid_598306
  var valid_598307 = query.getOrDefault("uploadType")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = nil)
  if valid_598307 != nil:
    section.add "uploadType", valid_598307
  var valid_598308 = query.getOrDefault("key")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "key", valid_598308
  var valid_598309 = query.getOrDefault("$.xgafv")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = newJString("1"))
  if valid_598309 != nil:
    section.add "$.xgafv", valid_598309
  var valid_598310 = query.getOrDefault("prettyPrint")
  valid_598310 = validateParameter(valid_598310, JBool, required = false,
                                 default = newJBool(true))
  if valid_598310 != nil:
    section.add "prettyPrint", valid_598310
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

proc call*(call_598312: Call_BigtableadminProjectsInstancesCreate_598296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an instance within a project.
  ## 
  let valid = call_598312.validator(path, query, header, formData, body)
  let scheme = call_598312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598312.url(scheme.get, call_598312.host, call_598312.base,
                         call_598312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598312, url, valid)

proc call*(call_598313: Call_BigtableadminProjectsInstancesCreate_598296;
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
  var path_598314 = newJObject()
  var query_598315 = newJObject()
  var body_598316 = newJObject()
  add(query_598315, "upload_protocol", newJString(uploadProtocol))
  add(query_598315, "fields", newJString(fields))
  add(query_598315, "quotaUser", newJString(quotaUser))
  add(query_598315, "alt", newJString(alt))
  add(query_598315, "oauth_token", newJString(oauthToken))
  add(query_598315, "callback", newJString(callback))
  add(query_598315, "access_token", newJString(accessToken))
  add(query_598315, "uploadType", newJString(uploadType))
  add(path_598314, "parent", newJString(parent))
  add(query_598315, "key", newJString(key))
  add(query_598315, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598316 = body
  add(query_598315, "prettyPrint", newJBool(prettyPrint))
  result = call_598313.call(path_598314, query_598315, nil, nil, body_598316)

var bigtableadminProjectsInstancesCreate* = Call_BigtableadminProjectsInstancesCreate_598296(
    name: "bigtableadminProjectsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/instances",
    validator: validate_BigtableadminProjectsInstancesCreate_598297, base: "/",
    url: url_BigtableadminProjectsInstancesCreate_598298, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesList_598276 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesList_598278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesList_598277(path: JsonNode;
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
  var valid_598279 = path.getOrDefault("parent")
  valid_598279 = validateParameter(valid_598279, JString, required = true,
                                 default = nil)
  if valid_598279 != nil:
    section.add "parent", valid_598279
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
  var valid_598280 = query.getOrDefault("upload_protocol")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = nil)
  if valid_598280 != nil:
    section.add "upload_protocol", valid_598280
  var valid_598281 = query.getOrDefault("fields")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = nil)
  if valid_598281 != nil:
    section.add "fields", valid_598281
  var valid_598282 = query.getOrDefault("pageToken")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "pageToken", valid_598282
  var valid_598283 = query.getOrDefault("quotaUser")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "quotaUser", valid_598283
  var valid_598284 = query.getOrDefault("alt")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = newJString("json"))
  if valid_598284 != nil:
    section.add "alt", valid_598284
  var valid_598285 = query.getOrDefault("oauth_token")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "oauth_token", valid_598285
  var valid_598286 = query.getOrDefault("callback")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "callback", valid_598286
  var valid_598287 = query.getOrDefault("access_token")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "access_token", valid_598287
  var valid_598288 = query.getOrDefault("uploadType")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "uploadType", valid_598288
  var valid_598289 = query.getOrDefault("key")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "key", valid_598289
  var valid_598290 = query.getOrDefault("$.xgafv")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = newJString("1"))
  if valid_598290 != nil:
    section.add "$.xgafv", valid_598290
  var valid_598291 = query.getOrDefault("prettyPrint")
  valid_598291 = validateParameter(valid_598291, JBool, required = false,
                                 default = newJBool(true))
  if valid_598291 != nil:
    section.add "prettyPrint", valid_598291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598292: Call_BigtableadminProjectsInstancesList_598276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about instances in a project.
  ## 
  let valid = call_598292.validator(path, query, header, formData, body)
  let scheme = call_598292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598292.url(scheme.get, call_598292.host, call_598292.base,
                         call_598292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598292, url, valid)

proc call*(call_598293: Call_BigtableadminProjectsInstancesList_598276;
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
  var path_598294 = newJObject()
  var query_598295 = newJObject()
  add(query_598295, "upload_protocol", newJString(uploadProtocol))
  add(query_598295, "fields", newJString(fields))
  add(query_598295, "pageToken", newJString(pageToken))
  add(query_598295, "quotaUser", newJString(quotaUser))
  add(query_598295, "alt", newJString(alt))
  add(query_598295, "oauth_token", newJString(oauthToken))
  add(query_598295, "callback", newJString(callback))
  add(query_598295, "access_token", newJString(accessToken))
  add(query_598295, "uploadType", newJString(uploadType))
  add(path_598294, "parent", newJString(parent))
  add(query_598295, "key", newJString(key))
  add(query_598295, "$.xgafv", newJString(Xgafv))
  add(query_598295, "prettyPrint", newJBool(prettyPrint))
  result = call_598293.call(path_598294, query_598295, nil, nil, nil)

var bigtableadminProjectsInstancesList* = Call_BigtableadminProjectsInstancesList_598276(
    name: "bigtableadminProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/instances",
    validator: validate_BigtableadminProjectsInstancesList_598277, base: "/",
    url: url_BigtableadminProjectsInstancesList_598278, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesCreate_598339 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesTablesCreate_598341(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesTablesCreate_598340(path: JsonNode;
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
  var valid_598342 = path.getOrDefault("parent")
  valid_598342 = validateParameter(valid_598342, JString, required = true,
                                 default = nil)
  if valid_598342 != nil:
    section.add "parent", valid_598342
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
  var valid_598343 = query.getOrDefault("upload_protocol")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = nil)
  if valid_598343 != nil:
    section.add "upload_protocol", valid_598343
  var valid_598344 = query.getOrDefault("fields")
  valid_598344 = validateParameter(valid_598344, JString, required = false,
                                 default = nil)
  if valid_598344 != nil:
    section.add "fields", valid_598344
  var valid_598345 = query.getOrDefault("quotaUser")
  valid_598345 = validateParameter(valid_598345, JString, required = false,
                                 default = nil)
  if valid_598345 != nil:
    section.add "quotaUser", valid_598345
  var valid_598346 = query.getOrDefault("alt")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = newJString("json"))
  if valid_598346 != nil:
    section.add "alt", valid_598346
  var valid_598347 = query.getOrDefault("oauth_token")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = nil)
  if valid_598347 != nil:
    section.add "oauth_token", valid_598347
  var valid_598348 = query.getOrDefault("callback")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = nil)
  if valid_598348 != nil:
    section.add "callback", valid_598348
  var valid_598349 = query.getOrDefault("access_token")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "access_token", valid_598349
  var valid_598350 = query.getOrDefault("uploadType")
  valid_598350 = validateParameter(valid_598350, JString, required = false,
                                 default = nil)
  if valid_598350 != nil:
    section.add "uploadType", valid_598350
  var valid_598351 = query.getOrDefault("key")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "key", valid_598351
  var valid_598352 = query.getOrDefault("$.xgafv")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = newJString("1"))
  if valid_598352 != nil:
    section.add "$.xgafv", valid_598352
  var valid_598353 = query.getOrDefault("prettyPrint")
  valid_598353 = validateParameter(valid_598353, JBool, required = false,
                                 default = newJBool(true))
  if valid_598353 != nil:
    section.add "prettyPrint", valid_598353
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

proc call*(call_598355: Call_BigtableadminProjectsInstancesTablesCreate_598339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
  ## 
  let valid = call_598355.validator(path, query, header, formData, body)
  let scheme = call_598355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598355.url(scheme.get, call_598355.host, call_598355.base,
                         call_598355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598355, url, valid)

proc call*(call_598356: Call_BigtableadminProjectsInstancesTablesCreate_598339;
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
  var path_598357 = newJObject()
  var query_598358 = newJObject()
  var body_598359 = newJObject()
  add(query_598358, "upload_protocol", newJString(uploadProtocol))
  add(query_598358, "fields", newJString(fields))
  add(query_598358, "quotaUser", newJString(quotaUser))
  add(query_598358, "alt", newJString(alt))
  add(query_598358, "oauth_token", newJString(oauthToken))
  add(query_598358, "callback", newJString(callback))
  add(query_598358, "access_token", newJString(accessToken))
  add(query_598358, "uploadType", newJString(uploadType))
  add(path_598357, "parent", newJString(parent))
  add(query_598358, "key", newJString(key))
  add(query_598358, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598359 = body
  add(query_598358, "prettyPrint", newJBool(prettyPrint))
  result = call_598356.call(path_598357, query_598358, nil, nil, body_598359)

var bigtableadminProjectsInstancesTablesCreate* = Call_BigtableadminProjectsInstancesTablesCreate_598339(
    name: "bigtableadminProjectsInstancesTablesCreate", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/tables",
    validator: validate_BigtableadminProjectsInstancesTablesCreate_598340,
    base: "/", url: url_BigtableadminProjectsInstancesTablesCreate_598341,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesList_598317 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesTablesList_598319(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesTablesList_598318(path: JsonNode;
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
  var valid_598320 = path.getOrDefault("parent")
  valid_598320 = validateParameter(valid_598320, JString, required = true,
                                 default = nil)
  if valid_598320 != nil:
    section.add "parent", valid_598320
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
  var valid_598321 = query.getOrDefault("upload_protocol")
  valid_598321 = validateParameter(valid_598321, JString, required = false,
                                 default = nil)
  if valid_598321 != nil:
    section.add "upload_protocol", valid_598321
  var valid_598322 = query.getOrDefault("fields")
  valid_598322 = validateParameter(valid_598322, JString, required = false,
                                 default = nil)
  if valid_598322 != nil:
    section.add "fields", valid_598322
  var valid_598323 = query.getOrDefault("pageToken")
  valid_598323 = validateParameter(valid_598323, JString, required = false,
                                 default = nil)
  if valid_598323 != nil:
    section.add "pageToken", valid_598323
  var valid_598324 = query.getOrDefault("quotaUser")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = nil)
  if valid_598324 != nil:
    section.add "quotaUser", valid_598324
  var valid_598325 = query.getOrDefault("view")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_598325 != nil:
    section.add "view", valid_598325
  var valid_598326 = query.getOrDefault("alt")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = newJString("json"))
  if valid_598326 != nil:
    section.add "alt", valid_598326
  var valid_598327 = query.getOrDefault("oauth_token")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "oauth_token", valid_598327
  var valid_598328 = query.getOrDefault("callback")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = nil)
  if valid_598328 != nil:
    section.add "callback", valid_598328
  var valid_598329 = query.getOrDefault("access_token")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "access_token", valid_598329
  var valid_598330 = query.getOrDefault("uploadType")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "uploadType", valid_598330
  var valid_598331 = query.getOrDefault("key")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "key", valid_598331
  var valid_598332 = query.getOrDefault("$.xgafv")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = newJString("1"))
  if valid_598332 != nil:
    section.add "$.xgafv", valid_598332
  var valid_598333 = query.getOrDefault("pageSize")
  valid_598333 = validateParameter(valid_598333, JInt, required = false, default = nil)
  if valid_598333 != nil:
    section.add "pageSize", valid_598333
  var valid_598334 = query.getOrDefault("prettyPrint")
  valid_598334 = validateParameter(valid_598334, JBool, required = false,
                                 default = newJBool(true))
  if valid_598334 != nil:
    section.add "prettyPrint", valid_598334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598335: Call_BigtableadminProjectsInstancesTablesList_598317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all tables served from a specified instance.
  ## 
  let valid = call_598335.validator(path, query, header, formData, body)
  let scheme = call_598335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598335.url(scheme.get, call_598335.host, call_598335.base,
                         call_598335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598335, url, valid)

proc call*(call_598336: Call_BigtableadminProjectsInstancesTablesList_598317;
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
  var path_598337 = newJObject()
  var query_598338 = newJObject()
  add(query_598338, "upload_protocol", newJString(uploadProtocol))
  add(query_598338, "fields", newJString(fields))
  add(query_598338, "pageToken", newJString(pageToken))
  add(query_598338, "quotaUser", newJString(quotaUser))
  add(query_598338, "view", newJString(view))
  add(query_598338, "alt", newJString(alt))
  add(query_598338, "oauth_token", newJString(oauthToken))
  add(query_598338, "callback", newJString(callback))
  add(query_598338, "access_token", newJString(accessToken))
  add(query_598338, "uploadType", newJString(uploadType))
  add(path_598337, "parent", newJString(parent))
  add(query_598338, "key", newJString(key))
  add(query_598338, "$.xgafv", newJString(Xgafv))
  add(query_598338, "pageSize", newJInt(pageSize))
  add(query_598338, "prettyPrint", newJBool(prettyPrint))
  result = call_598336.call(path_598337, query_598338, nil, nil, nil)

var bigtableadminProjectsInstancesTablesList* = Call_BigtableadminProjectsInstancesTablesList_598317(
    name: "bigtableadminProjectsInstancesTablesList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/tables",
    validator: validate_BigtableadminProjectsInstancesTablesList_598318,
    base: "/", url: url_BigtableadminProjectsInstancesTablesList_598319,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesGetIamPolicy_598360 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesGetIamPolicy_598362(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesGetIamPolicy_598361(path: JsonNode;
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
  var valid_598363 = path.getOrDefault("resource")
  valid_598363 = validateParameter(valid_598363, JString, required = true,
                                 default = nil)
  if valid_598363 != nil:
    section.add "resource", valid_598363
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
  var valid_598364 = query.getOrDefault("upload_protocol")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "upload_protocol", valid_598364
  var valid_598365 = query.getOrDefault("fields")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "fields", valid_598365
  var valid_598366 = query.getOrDefault("quotaUser")
  valid_598366 = validateParameter(valid_598366, JString, required = false,
                                 default = nil)
  if valid_598366 != nil:
    section.add "quotaUser", valid_598366
  var valid_598367 = query.getOrDefault("alt")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = newJString("json"))
  if valid_598367 != nil:
    section.add "alt", valid_598367
  var valid_598368 = query.getOrDefault("oauth_token")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "oauth_token", valid_598368
  var valid_598369 = query.getOrDefault("callback")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = nil)
  if valid_598369 != nil:
    section.add "callback", valid_598369
  var valid_598370 = query.getOrDefault("access_token")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = nil)
  if valid_598370 != nil:
    section.add "access_token", valid_598370
  var valid_598371 = query.getOrDefault("uploadType")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "uploadType", valid_598371
  var valid_598372 = query.getOrDefault("key")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "key", valid_598372
  var valid_598373 = query.getOrDefault("$.xgafv")
  valid_598373 = validateParameter(valid_598373, JString, required = false,
                                 default = newJString("1"))
  if valid_598373 != nil:
    section.add "$.xgafv", valid_598373
  var valid_598374 = query.getOrDefault("prettyPrint")
  valid_598374 = validateParameter(valid_598374, JBool, required = false,
                                 default = newJBool(true))
  if valid_598374 != nil:
    section.add "prettyPrint", valid_598374
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

proc call*(call_598376: Call_BigtableadminProjectsInstancesGetIamPolicy_598360;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
  ## 
  let valid = call_598376.validator(path, query, header, formData, body)
  let scheme = call_598376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598376.url(scheme.get, call_598376.host, call_598376.base,
                         call_598376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598376, url, valid)

proc call*(call_598377: Call_BigtableadminProjectsInstancesGetIamPolicy_598360;
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
  var path_598378 = newJObject()
  var query_598379 = newJObject()
  var body_598380 = newJObject()
  add(query_598379, "upload_protocol", newJString(uploadProtocol))
  add(query_598379, "fields", newJString(fields))
  add(query_598379, "quotaUser", newJString(quotaUser))
  add(query_598379, "alt", newJString(alt))
  add(query_598379, "oauth_token", newJString(oauthToken))
  add(query_598379, "callback", newJString(callback))
  add(query_598379, "access_token", newJString(accessToken))
  add(query_598379, "uploadType", newJString(uploadType))
  add(query_598379, "key", newJString(key))
  add(query_598379, "$.xgafv", newJString(Xgafv))
  add(path_598378, "resource", newJString(resource))
  if body != nil:
    body_598380 = body
  add(query_598379, "prettyPrint", newJBool(prettyPrint))
  result = call_598377.call(path_598378, query_598379, nil, nil, body_598380)

var bigtableadminProjectsInstancesGetIamPolicy* = Call_BigtableadminProjectsInstancesGetIamPolicy_598360(
    name: "bigtableadminProjectsInstancesGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{resource}:getIamPolicy",
    validator: validate_BigtableadminProjectsInstancesGetIamPolicy_598361,
    base: "/", url: url_BigtableadminProjectsInstancesGetIamPolicy_598362,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesSetIamPolicy_598381 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesSetIamPolicy_598383(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesSetIamPolicy_598382(path: JsonNode;
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
  var valid_598384 = path.getOrDefault("resource")
  valid_598384 = validateParameter(valid_598384, JString, required = true,
                                 default = nil)
  if valid_598384 != nil:
    section.add "resource", valid_598384
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
  var valid_598385 = query.getOrDefault("upload_protocol")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "upload_protocol", valid_598385
  var valid_598386 = query.getOrDefault("fields")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = nil)
  if valid_598386 != nil:
    section.add "fields", valid_598386
  var valid_598387 = query.getOrDefault("quotaUser")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "quotaUser", valid_598387
  var valid_598388 = query.getOrDefault("alt")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = newJString("json"))
  if valid_598388 != nil:
    section.add "alt", valid_598388
  var valid_598389 = query.getOrDefault("oauth_token")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "oauth_token", valid_598389
  var valid_598390 = query.getOrDefault("callback")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = nil)
  if valid_598390 != nil:
    section.add "callback", valid_598390
  var valid_598391 = query.getOrDefault("access_token")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = nil)
  if valid_598391 != nil:
    section.add "access_token", valid_598391
  var valid_598392 = query.getOrDefault("uploadType")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = nil)
  if valid_598392 != nil:
    section.add "uploadType", valid_598392
  var valid_598393 = query.getOrDefault("key")
  valid_598393 = validateParameter(valid_598393, JString, required = false,
                                 default = nil)
  if valid_598393 != nil:
    section.add "key", valid_598393
  var valid_598394 = query.getOrDefault("$.xgafv")
  valid_598394 = validateParameter(valid_598394, JString, required = false,
                                 default = newJString("1"))
  if valid_598394 != nil:
    section.add "$.xgafv", valid_598394
  var valid_598395 = query.getOrDefault("prettyPrint")
  valid_598395 = validateParameter(valid_598395, JBool, required = false,
                                 default = newJBool(true))
  if valid_598395 != nil:
    section.add "prettyPrint", valid_598395
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

proc call*(call_598397: Call_BigtableadminProjectsInstancesSetIamPolicy_598381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_598397.validator(path, query, header, formData, body)
  let scheme = call_598397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598397.url(scheme.get, call_598397.host, call_598397.base,
                         call_598397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598397, url, valid)

proc call*(call_598398: Call_BigtableadminProjectsInstancesSetIamPolicy_598381;
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
  var path_598399 = newJObject()
  var query_598400 = newJObject()
  var body_598401 = newJObject()
  add(query_598400, "upload_protocol", newJString(uploadProtocol))
  add(query_598400, "fields", newJString(fields))
  add(query_598400, "quotaUser", newJString(quotaUser))
  add(query_598400, "alt", newJString(alt))
  add(query_598400, "oauth_token", newJString(oauthToken))
  add(query_598400, "callback", newJString(callback))
  add(query_598400, "access_token", newJString(accessToken))
  add(query_598400, "uploadType", newJString(uploadType))
  add(query_598400, "key", newJString(key))
  add(query_598400, "$.xgafv", newJString(Xgafv))
  add(path_598399, "resource", newJString(resource))
  if body != nil:
    body_598401 = body
  add(query_598400, "prettyPrint", newJBool(prettyPrint))
  result = call_598398.call(path_598399, query_598400, nil, nil, body_598401)

var bigtableadminProjectsInstancesSetIamPolicy* = Call_BigtableadminProjectsInstancesSetIamPolicy_598381(
    name: "bigtableadminProjectsInstancesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{resource}:setIamPolicy",
    validator: validate_BigtableadminProjectsInstancesSetIamPolicy_598382,
    base: "/", url: url_BigtableadminProjectsInstancesSetIamPolicy_598383,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTestIamPermissions_598402 = ref object of OpenApiRestCall_597421
proc url_BigtableadminProjectsInstancesTestIamPermissions_598404(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigtableadminProjectsInstancesTestIamPermissions_598403(
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
  var valid_598405 = path.getOrDefault("resource")
  valid_598405 = validateParameter(valid_598405, JString, required = true,
                                 default = nil)
  if valid_598405 != nil:
    section.add "resource", valid_598405
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
  var valid_598406 = query.getOrDefault("upload_protocol")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "upload_protocol", valid_598406
  var valid_598407 = query.getOrDefault("fields")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "fields", valid_598407
  var valid_598408 = query.getOrDefault("quotaUser")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "quotaUser", valid_598408
  var valid_598409 = query.getOrDefault("alt")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = newJString("json"))
  if valid_598409 != nil:
    section.add "alt", valid_598409
  var valid_598410 = query.getOrDefault("oauth_token")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "oauth_token", valid_598410
  var valid_598411 = query.getOrDefault("callback")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = nil)
  if valid_598411 != nil:
    section.add "callback", valid_598411
  var valid_598412 = query.getOrDefault("access_token")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = nil)
  if valid_598412 != nil:
    section.add "access_token", valid_598412
  var valid_598413 = query.getOrDefault("uploadType")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "uploadType", valid_598413
  var valid_598414 = query.getOrDefault("key")
  valid_598414 = validateParameter(valid_598414, JString, required = false,
                                 default = nil)
  if valid_598414 != nil:
    section.add "key", valid_598414
  var valid_598415 = query.getOrDefault("$.xgafv")
  valid_598415 = validateParameter(valid_598415, JString, required = false,
                                 default = newJString("1"))
  if valid_598415 != nil:
    section.add "$.xgafv", valid_598415
  var valid_598416 = query.getOrDefault("prettyPrint")
  valid_598416 = validateParameter(valid_598416, JBool, required = false,
                                 default = newJBool(true))
  if valid_598416 != nil:
    section.add "prettyPrint", valid_598416
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

proc call*(call_598418: Call_BigtableadminProjectsInstancesTestIamPermissions_598402;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that the caller has on the specified instance resource.
  ## 
  let valid = call_598418.validator(path, query, header, formData, body)
  let scheme = call_598418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598418.url(scheme.get, call_598418.host, call_598418.base,
                         call_598418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598418, url, valid)

proc call*(call_598419: Call_BigtableadminProjectsInstancesTestIamPermissions_598402;
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
  var path_598420 = newJObject()
  var query_598421 = newJObject()
  var body_598422 = newJObject()
  add(query_598421, "upload_protocol", newJString(uploadProtocol))
  add(query_598421, "fields", newJString(fields))
  add(query_598421, "quotaUser", newJString(quotaUser))
  add(query_598421, "alt", newJString(alt))
  add(query_598421, "oauth_token", newJString(oauthToken))
  add(query_598421, "callback", newJString(callback))
  add(query_598421, "access_token", newJString(accessToken))
  add(query_598421, "uploadType", newJString(uploadType))
  add(query_598421, "key", newJString(key))
  add(query_598421, "$.xgafv", newJString(Xgafv))
  add(path_598420, "resource", newJString(resource))
  if body != nil:
    body_598422 = body
  add(query_598421, "prettyPrint", newJBool(prettyPrint))
  result = call_598419.call(path_598420, query_598421, nil, nil, body_598422)

var bigtableadminProjectsInstancesTestIamPermissions* = Call_BigtableadminProjectsInstancesTestIamPermissions_598402(
    name: "bigtableadminProjectsInstancesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_BigtableadminProjectsInstancesTestIamPermissions_598403,
    base: "/", url: url_BigtableadminProjectsInstancesTestIamPermissions_598404,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
