
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Compute Engine Instance Groups
## version: v1beta2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Resource View API allows users to create and manage logical sets of Google Compute Engine instances.
## 
## https://developers.google.com/compute/
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  gcpServiceName = "resourceviews"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ResourceviewsZoneOperationsList_588725 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneOperationsList_588727(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneOperationsList_588726(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_588853 = path.getOrDefault("zone")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "zone", valid_588853
  var valid_588854 = path.getOrDefault("project")
  valid_588854 = validateParameter(valid_588854, JString, required = true,
                                 default = nil)
  if valid_588854 != nil:
    section.add "project", valid_588854
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Optional. Filter expression for filtering listed resources.
  section = newJObject()
  var valid_588855 = query.getOrDefault("fields")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "fields", valid_588855
  var valid_588856 = query.getOrDefault("pageToken")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "pageToken", valid_588856
  var valid_588857 = query.getOrDefault("quotaUser")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "quotaUser", valid_588857
  var valid_588871 = query.getOrDefault("alt")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = newJString("json"))
  if valid_588871 != nil:
    section.add "alt", valid_588871
  var valid_588872 = query.getOrDefault("oauth_token")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "oauth_token", valid_588872
  var valid_588873 = query.getOrDefault("userIp")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "userIp", valid_588873
  var valid_588875 = query.getOrDefault("maxResults")
  valid_588875 = validateParameter(valid_588875, JInt, required = false,
                                 default = newJInt(500))
  if valid_588875 != nil:
    section.add "maxResults", valid_588875
  var valid_588876 = query.getOrDefault("key")
  valid_588876 = validateParameter(valid_588876, JString, required = false,
                                 default = nil)
  if valid_588876 != nil:
    section.add "key", valid_588876
  var valid_588877 = query.getOrDefault("prettyPrint")
  valid_588877 = validateParameter(valid_588877, JBool, required = false,
                                 default = newJBool(true))
  if valid_588877 != nil:
    section.add "prettyPrint", valid_588877
  var valid_588878 = query.getOrDefault("filter")
  valid_588878 = validateParameter(valid_588878, JString, required = false,
                                 default = nil)
  if valid_588878 != nil:
    section.add "filter", valid_588878
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588901: Call_ResourceviewsZoneOperationsList_588725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of operation resources contained within the specified zone.
  ## 
  let valid = call_588901.validator(path, query, header, formData, body)
  let scheme = call_588901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588901.url(scheme.get, call_588901.host, call_588901.base,
                         call_588901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588901, url, valid)

proc call*(call_588972: Call_ResourceviewsZoneOperationsList_588725; zone: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## resourceviewsZoneOperationsList
  ## Retrieves the list of operation resources contained within the specified zone.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. Tag returned by a previous list request truncated by maxResults. Used to continue a previous list request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Optional. Maximum count of results to be returned. Maximum value is 500 and default value is 500.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Optional. Filter expression for filtering listed resources.
  var path_588973 = newJObject()
  var query_588975 = newJObject()
  add(path_588973, "zone", newJString(zone))
  add(query_588975, "fields", newJString(fields))
  add(query_588975, "pageToken", newJString(pageToken))
  add(query_588975, "quotaUser", newJString(quotaUser))
  add(query_588975, "alt", newJString(alt))
  add(query_588975, "oauth_token", newJString(oauthToken))
  add(query_588975, "userIp", newJString(userIp))
  add(query_588975, "maxResults", newJInt(maxResults))
  add(query_588975, "key", newJString(key))
  add(path_588973, "project", newJString(project))
  add(query_588975, "prettyPrint", newJBool(prettyPrint))
  add(query_588975, "filter", newJString(filter))
  result = call_588972.call(path_588973, query_588975, nil, nil, nil)

var resourceviewsZoneOperationsList* = Call_ResourceviewsZoneOperationsList_588725(
    name: "resourceviewsZoneOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/operations",
    validator: validate_ResourceviewsZoneOperationsList_588726,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneOperationsList_588727, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneOperationsGet_589014 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneOperationsGet_589016(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneOperationsGet_589015(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : Name of the zone scoping this request.
  ##   operation: JString (required)
  ##            : Name of the operation resource to return.
  ##   project: JString (required)
  ##          : Name of the project scoping this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589017 = path.getOrDefault("zone")
  valid_589017 = validateParameter(valid_589017, JString, required = true,
                                 default = nil)
  if valid_589017 != nil:
    section.add "zone", valid_589017
  var valid_589018 = path.getOrDefault("operation")
  valid_589018 = validateParameter(valid_589018, JString, required = true,
                                 default = nil)
  if valid_589018 != nil:
    section.add "operation", valid_589018
  var valid_589019 = path.getOrDefault("project")
  valid_589019 = validateParameter(valid_589019, JString, required = true,
                                 default = nil)
  if valid_589019 != nil:
    section.add "project", valid_589019
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589020 = query.getOrDefault("fields")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "fields", valid_589020
  var valid_589021 = query.getOrDefault("quotaUser")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "quotaUser", valid_589021
  var valid_589022 = query.getOrDefault("alt")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("json"))
  if valid_589022 != nil:
    section.add "alt", valid_589022
  var valid_589023 = query.getOrDefault("oauth_token")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "oauth_token", valid_589023
  var valid_589024 = query.getOrDefault("userIp")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "userIp", valid_589024
  var valid_589025 = query.getOrDefault("key")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "key", valid_589025
  var valid_589026 = query.getOrDefault("prettyPrint")
  valid_589026 = validateParameter(valid_589026, JBool, required = false,
                                 default = newJBool(true))
  if valid_589026 != nil:
    section.add "prettyPrint", valid_589026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589027: Call_ResourceviewsZoneOperationsGet_589014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified zone-specific operation resource.
  ## 
  let valid = call_589027.validator(path, query, header, formData, body)
  let scheme = call_589027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589027.url(scheme.get, call_589027.host, call_589027.base,
                         call_589027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589027, url, valid)

proc call*(call_589028: Call_ResourceviewsZoneOperationsGet_589014; zone: string;
          operation: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneOperationsGet
  ## Retrieves the specified zone-specific operation resource.
  ##   zone: string (required)
  ##       : Name of the zone scoping this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : Name of the operation resource to return.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : Name of the project scoping this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589029 = newJObject()
  var query_589030 = newJObject()
  add(path_589029, "zone", newJString(zone))
  add(query_589030, "fields", newJString(fields))
  add(query_589030, "quotaUser", newJString(quotaUser))
  add(query_589030, "alt", newJString(alt))
  add(path_589029, "operation", newJString(operation))
  add(query_589030, "oauth_token", newJString(oauthToken))
  add(query_589030, "userIp", newJString(userIp))
  add(query_589030, "key", newJString(key))
  add(path_589029, "project", newJString(project))
  add(query_589030, "prettyPrint", newJBool(prettyPrint))
  result = call_589028.call(path_589029, query_589030, nil, nil, nil)

var resourceviewsZoneOperationsGet* = Call_ResourceviewsZoneOperationsGet_589014(
    name: "resourceviewsZoneOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/operations/{operation}",
    validator: validate_ResourceviewsZoneOperationsGet_589015,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneOperationsGet_589016, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsInsert_589049 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsInsert_589051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsInsert_589050(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589052 = path.getOrDefault("zone")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "zone", valid_589052
  var valid_589053 = path.getOrDefault("project")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "project", valid_589053
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("oauth_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "oauth_token", valid_589057
  var valid_589058 = query.getOrDefault("userIp")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "userIp", valid_589058
  var valid_589059 = query.getOrDefault("key")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "key", valid_589059
  var valid_589060 = query.getOrDefault("prettyPrint")
  valid_589060 = validateParameter(valid_589060, JBool, required = false,
                                 default = newJBool(true))
  if valid_589060 != nil:
    section.add "prettyPrint", valid_589060
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

proc call*(call_589062: Call_ResourceviewsZoneViewsInsert_589049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource view.
  ## 
  let valid = call_589062.validator(path, query, header, formData, body)
  let scheme = call_589062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589062.url(scheme.get, call_589062.host, call_589062.base,
                         call_589062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589062, url, valid)

proc call*(call_589063: Call_ResourceviewsZoneViewsInsert_589049; zone: string;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsInsert
  ## Create a resource view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589064 = newJObject()
  var query_589065 = newJObject()
  var body_589066 = newJObject()
  add(path_589064, "zone", newJString(zone))
  add(query_589065, "fields", newJString(fields))
  add(query_589065, "quotaUser", newJString(quotaUser))
  add(query_589065, "alt", newJString(alt))
  add(query_589065, "oauth_token", newJString(oauthToken))
  add(query_589065, "userIp", newJString(userIp))
  add(query_589065, "key", newJString(key))
  add(path_589064, "project", newJString(project))
  if body != nil:
    body_589066 = body
  add(query_589065, "prettyPrint", newJBool(prettyPrint))
  result = call_589063.call(path_589064, query_589065, nil, nil, body_589066)

var resourceviewsZoneViewsInsert* = Call_ResourceviewsZoneViewsInsert_589049(
    name: "resourceviewsZoneViewsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsInsert_589050,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsInsert_589051, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsList_589031 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsList_589033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsList_589032(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List resource views.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589034 = path.getOrDefault("zone")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "zone", valid_589034
  var valid_589035 = path.getOrDefault("project")
  valid_589035 = validateParameter(valid_589035, JString, required = true,
                                 default = nil)
  if valid_589035 != nil:
    section.add "project", valid_589035
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589036 = query.getOrDefault("fields")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "fields", valid_589036
  var valid_589037 = query.getOrDefault("pageToken")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "pageToken", valid_589037
  var valid_589038 = query.getOrDefault("quotaUser")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "quotaUser", valid_589038
  var valid_589039 = query.getOrDefault("alt")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("json"))
  if valid_589039 != nil:
    section.add "alt", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("userIp")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "userIp", valid_589041
  var valid_589042 = query.getOrDefault("maxResults")
  valid_589042 = validateParameter(valid_589042, JInt, required = false,
                                 default = newJInt(5000))
  if valid_589042 != nil:
    section.add "maxResults", valid_589042
  var valid_589043 = query.getOrDefault("key")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "key", valid_589043
  var valid_589044 = query.getOrDefault("prettyPrint")
  valid_589044 = validateParameter(valid_589044, JBool, required = false,
                                 default = newJBool(true))
  if valid_589044 != nil:
    section.add "prettyPrint", valid_589044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589045: Call_ResourceviewsZoneViewsList_589031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List resource views.
  ## 
  let valid = call_589045.validator(path, query, header, formData, body)
  let scheme = call_589045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589045.url(scheme.get, call_589045.host, call_589045.base,
                         call_589045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589045, url, valid)

proc call*(call_589046: Call_ResourceviewsZoneViewsList_589031; zone: string;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 5000; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsList
  ## List resource views.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589047 = newJObject()
  var query_589048 = newJObject()
  add(path_589047, "zone", newJString(zone))
  add(query_589048, "fields", newJString(fields))
  add(query_589048, "pageToken", newJString(pageToken))
  add(query_589048, "quotaUser", newJString(quotaUser))
  add(query_589048, "alt", newJString(alt))
  add(query_589048, "oauth_token", newJString(oauthToken))
  add(query_589048, "userIp", newJString(userIp))
  add(query_589048, "maxResults", newJInt(maxResults))
  add(query_589048, "key", newJString(key))
  add(path_589047, "project", newJString(project))
  add(query_589048, "prettyPrint", newJBool(prettyPrint))
  result = call_589046.call(path_589047, query_589048, nil, nil, nil)

var resourceviewsZoneViewsList* = Call_ResourceviewsZoneViewsList_589031(
    name: "resourceviewsZoneViewsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/resourceViews",
    validator: validate_ResourceviewsZoneViewsList_589032,
    base: "/resourceviews/v1beta2/projects", url: url_ResourceviewsZoneViewsList_589033,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsGet_589067 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsGet_589069(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsGet_589068(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the information of a zonal resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589070 = path.getOrDefault("zone")
  valid_589070 = validateParameter(valid_589070, JString, required = true,
                                 default = nil)
  if valid_589070 != nil:
    section.add "zone", valid_589070
  var valid_589071 = path.getOrDefault("project")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "project", valid_589071
  var valid_589072 = path.getOrDefault("resourceView")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "resourceView", valid_589072
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("userIp")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "userIp", valid_589077
  var valid_589078 = query.getOrDefault("key")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "key", valid_589078
  var valid_589079 = query.getOrDefault("prettyPrint")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(true))
  if valid_589079 != nil:
    section.add "prettyPrint", valid_589079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589080: Call_ResourceviewsZoneViewsGet_589067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information of a zonal resource view.
  ## 
  let valid = call_589080.validator(path, query, header, formData, body)
  let scheme = call_589080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589080.url(scheme.get, call_589080.host, call_589080.base,
                         call_589080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589080, url, valid)

proc call*(call_589081: Call_ResourceviewsZoneViewsGet_589067; zone: string;
          project: string; resourceView: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsGet
  ## Get the information of a zonal resource view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_589082 = newJObject()
  var query_589083 = newJObject()
  add(path_589082, "zone", newJString(zone))
  add(query_589083, "fields", newJString(fields))
  add(query_589083, "quotaUser", newJString(quotaUser))
  add(query_589083, "alt", newJString(alt))
  add(query_589083, "oauth_token", newJString(oauthToken))
  add(query_589083, "userIp", newJString(userIp))
  add(query_589083, "key", newJString(key))
  add(path_589082, "project", newJString(project))
  add(query_589083, "prettyPrint", newJBool(prettyPrint))
  add(path_589082, "resourceView", newJString(resourceView))
  result = call_589081.call(path_589082, query_589083, nil, nil, nil)

var resourceviewsZoneViewsGet* = Call_ResourceviewsZoneViewsGet_589067(
    name: "resourceviewsZoneViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}",
    validator: validate_ResourceviewsZoneViewsGet_589068,
    base: "/resourceviews/v1beta2/projects", url: url_ResourceviewsZoneViewsGet_589069,
    schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsDelete_589084 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsDelete_589086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsDelete_589085(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589087 = path.getOrDefault("zone")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "zone", valid_589087
  var valid_589088 = path.getOrDefault("project")
  valid_589088 = validateParameter(valid_589088, JString, required = true,
                                 default = nil)
  if valid_589088 != nil:
    section.add "project", valid_589088
  var valid_589089 = path.getOrDefault("resourceView")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "resourceView", valid_589089
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589090 = query.getOrDefault("fields")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "fields", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("userIp")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "userIp", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589097: Call_ResourceviewsZoneViewsDelete_589084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a resource view.
  ## 
  let valid = call_589097.validator(path, query, header, formData, body)
  let scheme = call_589097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589097.url(scheme.get, call_589097.host, call_589097.base,
                         call_589097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589097, url, valid)

proc call*(call_589098: Call_ResourceviewsZoneViewsDelete_589084; zone: string;
          project: string; resourceView: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsDelete
  ## Delete a resource view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_589099 = newJObject()
  var query_589100 = newJObject()
  add(path_589099, "zone", newJString(zone))
  add(query_589100, "fields", newJString(fields))
  add(query_589100, "quotaUser", newJString(quotaUser))
  add(query_589100, "alt", newJString(alt))
  add(query_589100, "oauth_token", newJString(oauthToken))
  add(query_589100, "userIp", newJString(userIp))
  add(query_589100, "key", newJString(key))
  add(path_589099, "project", newJString(project))
  add(query_589100, "prettyPrint", newJBool(prettyPrint))
  add(path_589099, "resourceView", newJString(resourceView))
  result = call_589098.call(path_589099, query_589100, nil, nil, nil)

var resourceviewsZoneViewsDelete* = Call_ResourceviewsZoneViewsDelete_589084(
    name: "resourceviewsZoneViewsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}",
    validator: validate_ResourceviewsZoneViewsDelete_589085,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsDelete_589086, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsAddResources_589101 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsAddResources_589103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/addResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsAddResources_589102(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add resources to the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589104 = path.getOrDefault("zone")
  valid_589104 = validateParameter(valid_589104, JString, required = true,
                                 default = nil)
  if valid_589104 != nil:
    section.add "zone", valid_589104
  var valid_589105 = path.getOrDefault("project")
  valid_589105 = validateParameter(valid_589105, JString, required = true,
                                 default = nil)
  if valid_589105 != nil:
    section.add "project", valid_589105
  var valid_589106 = path.getOrDefault("resourceView")
  valid_589106 = validateParameter(valid_589106, JString, required = true,
                                 default = nil)
  if valid_589106 != nil:
    section.add "resourceView", valid_589106
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589107 = query.getOrDefault("fields")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "fields", valid_589107
  var valid_589108 = query.getOrDefault("quotaUser")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "quotaUser", valid_589108
  var valid_589109 = query.getOrDefault("alt")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = newJString("json"))
  if valid_589109 != nil:
    section.add "alt", valid_589109
  var valid_589110 = query.getOrDefault("oauth_token")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "oauth_token", valid_589110
  var valid_589111 = query.getOrDefault("userIp")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "userIp", valid_589111
  var valid_589112 = query.getOrDefault("key")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "key", valid_589112
  var valid_589113 = query.getOrDefault("prettyPrint")
  valid_589113 = validateParameter(valid_589113, JBool, required = false,
                                 default = newJBool(true))
  if valid_589113 != nil:
    section.add "prettyPrint", valid_589113
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

proc call*(call_589115: Call_ResourceviewsZoneViewsAddResources_589101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add resources to the view.
  ## 
  let valid = call_589115.validator(path, query, header, formData, body)
  let scheme = call_589115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589115.url(scheme.get, call_589115.host, call_589115.base,
                         call_589115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589115, url, valid)

proc call*(call_589116: Call_ResourceviewsZoneViewsAddResources_589101;
          zone: string; project: string; resourceView: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsAddResources
  ## Add resources to the view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_589117 = newJObject()
  var query_589118 = newJObject()
  var body_589119 = newJObject()
  add(path_589117, "zone", newJString(zone))
  add(query_589118, "fields", newJString(fields))
  add(query_589118, "quotaUser", newJString(quotaUser))
  add(query_589118, "alt", newJString(alt))
  add(query_589118, "oauth_token", newJString(oauthToken))
  add(query_589118, "userIp", newJString(userIp))
  add(query_589118, "key", newJString(key))
  add(path_589117, "project", newJString(project))
  if body != nil:
    body_589119 = body
  add(query_589118, "prettyPrint", newJBool(prettyPrint))
  add(path_589117, "resourceView", newJString(resourceView))
  result = call_589116.call(path_589117, query_589118, nil, nil, body_589119)

var resourceviewsZoneViewsAddResources* = Call_ResourceviewsZoneViewsAddResources_589101(
    name: "resourceviewsZoneViewsAddResources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}/addResources",
    validator: validate_ResourceviewsZoneViewsAddResources_589102,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsAddResources_589103, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsGetService_589120 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsGetService_589122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/getService")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsGetService_589121(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the service information of a resource view or a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589123 = path.getOrDefault("zone")
  valid_589123 = validateParameter(valid_589123, JString, required = true,
                                 default = nil)
  if valid_589123 != nil:
    section.add "zone", valid_589123
  var valid_589124 = path.getOrDefault("project")
  valid_589124 = validateParameter(valid_589124, JString, required = true,
                                 default = nil)
  if valid_589124 != nil:
    section.add "project", valid_589124
  var valid_589125 = path.getOrDefault("resourceView")
  valid_589125 = validateParameter(valid_589125, JString, required = true,
                                 default = nil)
  if valid_589125 != nil:
    section.add "resourceView", valid_589125
  result.add "path", section
  ## parameters in `query` object:
  ##   resourceName: JString
  ##               : The name of the resource if user wants to get the service information of the resource.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589126 = query.getOrDefault("resourceName")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "resourceName", valid_589126
  var valid_589127 = query.getOrDefault("fields")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "fields", valid_589127
  var valid_589128 = query.getOrDefault("quotaUser")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "quotaUser", valid_589128
  var valid_589129 = query.getOrDefault("alt")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("json"))
  if valid_589129 != nil:
    section.add "alt", valid_589129
  var valid_589130 = query.getOrDefault("oauth_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "oauth_token", valid_589130
  var valid_589131 = query.getOrDefault("userIp")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "userIp", valid_589131
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

proc call*(call_589134: Call_ResourceviewsZoneViewsGetService_589120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the service information of a resource view or a resource.
  ## 
  let valid = call_589134.validator(path, query, header, formData, body)
  let scheme = call_589134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589134.url(scheme.get, call_589134.host, call_589134.base,
                         call_589134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589134, url, valid)

proc call*(call_589135: Call_ResourceviewsZoneViewsGetService_589120; zone: string;
          project: string; resourceView: string; resourceName: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsGetService
  ## Get the service information of a resource view or a resource.
  ##   resourceName: string
  ##               : The name of the resource if user wants to get the service information of the resource.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_589136 = newJObject()
  var query_589137 = newJObject()
  add(query_589137, "resourceName", newJString(resourceName))
  add(path_589136, "zone", newJString(zone))
  add(query_589137, "fields", newJString(fields))
  add(query_589137, "quotaUser", newJString(quotaUser))
  add(query_589137, "alt", newJString(alt))
  add(query_589137, "oauth_token", newJString(oauthToken))
  add(query_589137, "userIp", newJString(userIp))
  add(query_589137, "key", newJString(key))
  add(path_589136, "project", newJString(project))
  add(query_589137, "prettyPrint", newJBool(prettyPrint))
  add(path_589136, "resourceView", newJString(resourceView))
  result = call_589135.call(path_589136, query_589137, nil, nil, nil)

var resourceviewsZoneViewsGetService* = Call_ResourceviewsZoneViewsGetService_589120(
    name: "resourceviewsZoneViewsGetService", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}/getService",
    validator: validate_ResourceviewsZoneViewsGetService_589121,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsGetService_589122, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsRemoveResources_589138 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsRemoveResources_589140(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/removeResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsRemoveResources_589139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove resources from the view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589141 = path.getOrDefault("zone")
  valid_589141 = validateParameter(valid_589141, JString, required = true,
                                 default = nil)
  if valid_589141 != nil:
    section.add "zone", valid_589141
  var valid_589142 = path.getOrDefault("project")
  valid_589142 = validateParameter(valid_589142, JString, required = true,
                                 default = nil)
  if valid_589142 != nil:
    section.add "project", valid_589142
  var valid_589143 = path.getOrDefault("resourceView")
  valid_589143 = validateParameter(valid_589143, JString, required = true,
                                 default = nil)
  if valid_589143 != nil:
    section.add "resourceView", valid_589143
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589144 = query.getOrDefault("fields")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "fields", valid_589144
  var valid_589145 = query.getOrDefault("quotaUser")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "quotaUser", valid_589145
  var valid_589146 = query.getOrDefault("alt")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("json"))
  if valid_589146 != nil:
    section.add "alt", valid_589146
  var valid_589147 = query.getOrDefault("oauth_token")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "oauth_token", valid_589147
  var valid_589148 = query.getOrDefault("userIp")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "userIp", valid_589148
  var valid_589149 = query.getOrDefault("key")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "key", valid_589149
  var valid_589150 = query.getOrDefault("prettyPrint")
  valid_589150 = validateParameter(valid_589150, JBool, required = false,
                                 default = newJBool(true))
  if valid_589150 != nil:
    section.add "prettyPrint", valid_589150
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

proc call*(call_589152: Call_ResourceviewsZoneViewsRemoveResources_589138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Remove resources from the view.
  ## 
  let valid = call_589152.validator(path, query, header, formData, body)
  let scheme = call_589152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589152.url(scheme.get, call_589152.host, call_589152.base,
                         call_589152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589152, url, valid)

proc call*(call_589153: Call_ResourceviewsZoneViewsRemoveResources_589138;
          zone: string; project: string; resourceView: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsRemoveResources
  ## Remove resources from the view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_589154 = newJObject()
  var query_589155 = newJObject()
  var body_589156 = newJObject()
  add(path_589154, "zone", newJString(zone))
  add(query_589155, "fields", newJString(fields))
  add(query_589155, "quotaUser", newJString(quotaUser))
  add(query_589155, "alt", newJString(alt))
  add(query_589155, "oauth_token", newJString(oauthToken))
  add(query_589155, "userIp", newJString(userIp))
  add(query_589155, "key", newJString(key))
  add(path_589154, "project", newJString(project))
  if body != nil:
    body_589156 = body
  add(query_589155, "prettyPrint", newJBool(prettyPrint))
  add(path_589154, "resourceView", newJString(resourceView))
  result = call_589153.call(path_589154, query_589155, nil, nil, body_589156)

var resourceviewsZoneViewsRemoveResources* = Call_ResourceviewsZoneViewsRemoveResources_589138(
    name: "resourceviewsZoneViewsRemoveResources", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/zones/{zone}/resourceViews/{resourceView}/removeResources",
    validator: validate_ResourceviewsZoneViewsRemoveResources_589139,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsRemoveResources_589140, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsListResources_589157 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsListResources_589159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsListResources_589158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the resources of the resource view.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589160 = path.getOrDefault("zone")
  valid_589160 = validateParameter(valid_589160, JString, required = true,
                                 default = nil)
  if valid_589160 != nil:
    section.add "zone", valid_589160
  var valid_589161 = path.getOrDefault("project")
  valid_589161 = validateParameter(valid_589161, JString, required = true,
                                 default = nil)
  if valid_589161 != nil:
    section.add "project", valid_589161
  var valid_589162 = path.getOrDefault("resourceView")
  valid_589162 = validateParameter(valid_589162, JString, required = true,
                                 default = nil)
  if valid_589162 != nil:
    section.add "resourceView", valid_589162
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   serviceName: JString
  ##              : The service name to return in the response. It is optional and if it is not set, all the service end points will be returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   listState: JString
  ##            : The state of the instance to list. By default, it lists all instances.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   format: JString
  ##         : The requested format of the return value. It can be URL or URL_PORT. A JSON object will be included in the response based on the format. The default format is NONE, which results in no JSON in the response.
  section = newJObject()
  var valid_589163 = query.getOrDefault("fields")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "fields", valid_589163
  var valid_589164 = query.getOrDefault("pageToken")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "pageToken", valid_589164
  var valid_589165 = query.getOrDefault("quotaUser")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "quotaUser", valid_589165
  var valid_589166 = query.getOrDefault("alt")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = newJString("json"))
  if valid_589166 != nil:
    section.add "alt", valid_589166
  var valid_589167 = query.getOrDefault("serviceName")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "serviceName", valid_589167
  var valid_589168 = query.getOrDefault("oauth_token")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "oauth_token", valid_589168
  var valid_589169 = query.getOrDefault("userIp")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "userIp", valid_589169
  var valid_589170 = query.getOrDefault("maxResults")
  valid_589170 = validateParameter(valid_589170, JInt, required = false,
                                 default = newJInt(5000))
  if valid_589170 != nil:
    section.add "maxResults", valid_589170
  var valid_589171 = query.getOrDefault("listState")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = newJString("ALL"))
  if valid_589171 != nil:
    section.add "listState", valid_589171
  var valid_589172 = query.getOrDefault("key")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "key", valid_589172
  var valid_589173 = query.getOrDefault("prettyPrint")
  valid_589173 = validateParameter(valid_589173, JBool, required = false,
                                 default = newJBool(true))
  if valid_589173 != nil:
    section.add "prettyPrint", valid_589173
  var valid_589174 = query.getOrDefault("format")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = newJString("NONE"))
  if valid_589174 != nil:
    section.add "format", valid_589174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589175: Call_ResourceviewsZoneViewsListResources_589157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the resources of the resource view.
  ## 
  let valid = call_589175.validator(path, query, header, formData, body)
  let scheme = call_589175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589175.url(scheme.get, call_589175.host, call_589175.base,
                         call_589175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589175, url, valid)

proc call*(call_589176: Call_ResourceviewsZoneViewsListResources_589157;
          zone: string; project: string; resourceView: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          serviceName: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5000; listState: string = "ALL"; key: string = "";
          prettyPrint: bool = true; format: string = "NONE"): Recallable =
  ## resourceviewsZoneViewsListResources
  ## List the resources of the resource view.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a nextPageToken returned by a previous list request. This token can be used to request the next page of results from a previous list request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   serviceName: string
  ##              : The service name to return in the response. It is optional and if it is not set, all the service end points will be returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Maximum count of results to be returned. Acceptable values are 0 to 5000, inclusive. (Default: 5000)
  ##   listState: string
  ##            : The state of the instance to list. By default, it lists all instances.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   format: string
  ##         : The requested format of the return value. It can be URL or URL_PORT. A JSON object will be included in the response based on the format. The default format is NONE, which results in no JSON in the response.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_589177 = newJObject()
  var query_589178 = newJObject()
  add(path_589177, "zone", newJString(zone))
  add(query_589178, "fields", newJString(fields))
  add(query_589178, "pageToken", newJString(pageToken))
  add(query_589178, "quotaUser", newJString(quotaUser))
  add(query_589178, "alt", newJString(alt))
  add(query_589178, "serviceName", newJString(serviceName))
  add(query_589178, "oauth_token", newJString(oauthToken))
  add(query_589178, "userIp", newJString(userIp))
  add(query_589178, "maxResults", newJInt(maxResults))
  add(query_589178, "listState", newJString(listState))
  add(query_589178, "key", newJString(key))
  add(path_589177, "project", newJString(project))
  add(query_589178, "prettyPrint", newJBool(prettyPrint))
  add(query_589178, "format", newJString(format))
  add(path_589177, "resourceView", newJString(resourceView))
  result = call_589176.call(path_589177, query_589178, nil, nil, nil)

var resourceviewsZoneViewsListResources* = Call_ResourceviewsZoneViewsListResources_589157(
    name: "resourceviewsZoneViewsListResources", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}/resources",
    validator: validate_ResourceviewsZoneViewsListResources_589158,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsListResources_589159, schemes: {Scheme.Https})
type
  Call_ResourceviewsZoneViewsSetService_589179 = ref object of OpenApiRestCall_588457
proc url_ResourceviewsZoneViewsSetService_589181(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "zone" in path, "`zone` is a required path parameter"
  assert "resourceView" in path, "`resourceView` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/zones/"),
               (kind: VariableSegment, value: "zone"),
               (kind: ConstantSegment, value: "/resourceViews/"),
               (kind: VariableSegment, value: "resourceView"),
               (kind: ConstantSegment, value: "/setService")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceviewsZoneViewsSetService_589180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the service information of a resource view or a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   zone: JString (required)
  ##       : The zone name of the resource view.
  ##   project: JString (required)
  ##          : The project name of the resource view.
  ##   resourceView: JString (required)
  ##               : The name of the resource view.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `zone` field"
  var valid_589182 = path.getOrDefault("zone")
  valid_589182 = validateParameter(valid_589182, JString, required = true,
                                 default = nil)
  if valid_589182 != nil:
    section.add "zone", valid_589182
  var valid_589183 = path.getOrDefault("project")
  valid_589183 = validateParameter(valid_589183, JString, required = true,
                                 default = nil)
  if valid_589183 != nil:
    section.add "project", valid_589183
  var valid_589184 = path.getOrDefault("resourceView")
  valid_589184 = validateParameter(valid_589184, JString, required = true,
                                 default = nil)
  if valid_589184 != nil:
    section.add "resourceView", valid_589184
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589185 = query.getOrDefault("fields")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "fields", valid_589185
  var valid_589186 = query.getOrDefault("quotaUser")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "quotaUser", valid_589186
  var valid_589187 = query.getOrDefault("alt")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = newJString("json"))
  if valid_589187 != nil:
    section.add "alt", valid_589187
  var valid_589188 = query.getOrDefault("oauth_token")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "oauth_token", valid_589188
  var valid_589189 = query.getOrDefault("userIp")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "userIp", valid_589189
  var valid_589190 = query.getOrDefault("key")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "key", valid_589190
  var valid_589191 = query.getOrDefault("prettyPrint")
  valid_589191 = validateParameter(valid_589191, JBool, required = false,
                                 default = newJBool(true))
  if valid_589191 != nil:
    section.add "prettyPrint", valid_589191
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

proc call*(call_589193: Call_ResourceviewsZoneViewsSetService_589179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update the service information of a resource view or a resource.
  ## 
  let valid = call_589193.validator(path, query, header, formData, body)
  let scheme = call_589193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589193.url(scheme.get, call_589193.host, call_589193.base,
                         call_589193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589193, url, valid)

proc call*(call_589194: Call_ResourceviewsZoneViewsSetService_589179; zone: string;
          project: string; resourceView: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## resourceviewsZoneViewsSetService
  ## Update the service information of a resource view or a resource.
  ##   zone: string (required)
  ##       : The zone name of the resource view.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project name of the resource view.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   resourceView: string (required)
  ##               : The name of the resource view.
  var path_589195 = newJObject()
  var query_589196 = newJObject()
  var body_589197 = newJObject()
  add(path_589195, "zone", newJString(zone))
  add(query_589196, "fields", newJString(fields))
  add(query_589196, "quotaUser", newJString(quotaUser))
  add(query_589196, "alt", newJString(alt))
  add(query_589196, "oauth_token", newJString(oauthToken))
  add(query_589196, "userIp", newJString(userIp))
  add(query_589196, "key", newJString(key))
  add(path_589195, "project", newJString(project))
  if body != nil:
    body_589197 = body
  add(query_589196, "prettyPrint", newJBool(prettyPrint))
  add(path_589195, "resourceView", newJString(resourceView))
  result = call_589194.call(path_589195, query_589196, nil, nil, body_589197)

var resourceviewsZoneViewsSetService* = Call_ResourceviewsZoneViewsSetService_589179(
    name: "resourceviewsZoneViewsSetService", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/zones/{zone}/resourceViews/{resourceView}/setService",
    validator: validate_ResourceviewsZoneViewsSetService_589180,
    base: "/resourceviews/v1beta2/projects",
    url: url_ResourceviewsZoneViewsSetService_589181, schemes: {Scheme.Https})
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
