
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud TPU
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## TPU API provides customers with access to Google TPU technology.
## 
## https://cloud.google.com/tpu/
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "tpu"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TpuProjectsLocationsNodesGet_593677 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsNodesGet_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsNodesGet_593678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593805 = path.getOrDefault("name")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "name", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593852: Call_TpuProjectsLocationsNodesGet_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of a node.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_TpuProjectsLocationsNodesGet_593677; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## tpuProjectsLocationsNodesGet
  ## Gets the details of a node.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name.
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
  var path_593924 = newJObject()
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(path_593924, "name", newJString(name))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(path_593924, query_593926, nil, nil, nil)

var tpuProjectsLocationsNodesGet* = Call_TpuProjectsLocationsNodesGet_593677(
    name: "tpuProjectsLocationsNodesGet", meth: HttpMethod.HttpGet,
    host: "tpu.googleapis.com", route: "/v1/{name}",
    validator: validate_TpuProjectsLocationsNodesGet_593678, base: "/",
    url: url_TpuProjectsLocationsNodesGet_593679, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsNodesDelete_593965 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsNodesDelete_593967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsNodesDelete_593966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593968 = path.getOrDefault("name")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "name", valid_593968
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
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("quotaUser")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "quotaUser", valid_593971
  var valid_593972 = query.getOrDefault("alt")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("json"))
  if valid_593972 != nil:
    section.add "alt", valid_593972
  var valid_593973 = query.getOrDefault("oauth_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "oauth_token", valid_593973
  var valid_593974 = query.getOrDefault("callback")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "callback", valid_593974
  var valid_593975 = query.getOrDefault("access_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "access_token", valid_593975
  var valid_593976 = query.getOrDefault("uploadType")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "uploadType", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("$.xgafv")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("1"))
  if valid_593978 != nil:
    section.add "$.xgafv", valid_593978
  var valid_593979 = query.getOrDefault("prettyPrint")
  valid_593979 = validateParameter(valid_593979, JBool, required = false,
                                 default = newJBool(true))
  if valid_593979 != nil:
    section.add "prettyPrint", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_TpuProjectsLocationsNodesDelete_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a node.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_TpuProjectsLocationsNodesDelete_593965; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## tpuProjectsLocationsNodesDelete
  ## Deletes a node.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name.
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
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(query_593983, "upload_protocol", newJString(uploadProtocol))
  add(query_593983, "fields", newJString(fields))
  add(query_593983, "quotaUser", newJString(quotaUser))
  add(path_593982, "name", newJString(name))
  add(query_593983, "alt", newJString(alt))
  add(query_593983, "oauth_token", newJString(oauthToken))
  add(query_593983, "callback", newJString(callback))
  add(query_593983, "access_token", newJString(accessToken))
  add(query_593983, "uploadType", newJString(uploadType))
  add(query_593983, "key", newJString(key))
  add(query_593983, "$.xgafv", newJString(Xgafv))
  add(query_593983, "prettyPrint", newJBool(prettyPrint))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var tpuProjectsLocationsNodesDelete* = Call_TpuProjectsLocationsNodesDelete_593965(
    name: "tpuProjectsLocationsNodesDelete", meth: HttpMethod.HttpDelete,
    host: "tpu.googleapis.com", route: "/v1/{name}",
    validator: validate_TpuProjectsLocationsNodesDelete_593966, base: "/",
    url: url_TpuProjectsLocationsNodesDelete_593967, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsList_593984 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsList_593986(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsList_593985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593987 = path.getOrDefault("name")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "name", valid_593987
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
  var valid_593988 = query.getOrDefault("upload_protocol")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "upload_protocol", valid_593988
  var valid_593989 = query.getOrDefault("fields")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "fields", valid_593989
  var valid_593990 = query.getOrDefault("pageToken")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "pageToken", valid_593990
  var valid_593991 = query.getOrDefault("quotaUser")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "quotaUser", valid_593991
  var valid_593992 = query.getOrDefault("alt")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = newJString("json"))
  if valid_593992 != nil:
    section.add "alt", valid_593992
  var valid_593993 = query.getOrDefault("oauth_token")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "oauth_token", valid_593993
  var valid_593994 = query.getOrDefault("callback")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "callback", valid_593994
  var valid_593995 = query.getOrDefault("access_token")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "access_token", valid_593995
  var valid_593996 = query.getOrDefault("uploadType")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "uploadType", valid_593996
  var valid_593997 = query.getOrDefault("key")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "key", valid_593997
  var valid_593998 = query.getOrDefault("$.xgafv")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = newJString("1"))
  if valid_593998 != nil:
    section.add "$.xgafv", valid_593998
  var valid_593999 = query.getOrDefault("pageSize")
  valid_593999 = validateParameter(valid_593999, JInt, required = false, default = nil)
  if valid_593999 != nil:
    section.add "pageSize", valid_593999
  var valid_594000 = query.getOrDefault("prettyPrint")
  valid_594000 = validateParameter(valid_594000, JBool, required = false,
                                 default = newJBool(true))
  if valid_594000 != nil:
    section.add "prettyPrint", valid_594000
  var valid_594001 = query.getOrDefault("filter")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "filter", valid_594001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_TpuProjectsLocationsList_593984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_TpuProjectsLocationsList_593984; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## tpuProjectsLocationsList
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
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  add(query_594005, "upload_protocol", newJString(uploadProtocol))
  add(query_594005, "fields", newJString(fields))
  add(query_594005, "pageToken", newJString(pageToken))
  add(query_594005, "quotaUser", newJString(quotaUser))
  add(path_594004, "name", newJString(name))
  add(query_594005, "alt", newJString(alt))
  add(query_594005, "oauth_token", newJString(oauthToken))
  add(query_594005, "callback", newJString(callback))
  add(query_594005, "access_token", newJString(accessToken))
  add(query_594005, "uploadType", newJString(uploadType))
  add(query_594005, "key", newJString(key))
  add(query_594005, "$.xgafv", newJString(Xgafv))
  add(query_594005, "pageSize", newJInt(pageSize))
  add(query_594005, "prettyPrint", newJBool(prettyPrint))
  add(query_594005, "filter", newJString(filter))
  result = call_594003.call(path_594004, query_594005, nil, nil, nil)

var tpuProjectsLocationsList* = Call_TpuProjectsLocationsList_593984(
    name: "tpuProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "tpu.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_TpuProjectsLocationsList_593985, base: "/",
    url: url_TpuProjectsLocationsList_593986, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsOperationsList_594006 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsOperationsList_594008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsOperationsList_594007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_594009 = path.getOrDefault("name")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "name", valid_594009
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
  var valid_594010 = query.getOrDefault("upload_protocol")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "upload_protocol", valid_594010
  var valid_594011 = query.getOrDefault("fields")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "fields", valid_594011
  var valid_594012 = query.getOrDefault("pageToken")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "pageToken", valid_594012
  var valid_594013 = query.getOrDefault("quotaUser")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "quotaUser", valid_594013
  var valid_594014 = query.getOrDefault("alt")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("json"))
  if valid_594014 != nil:
    section.add "alt", valid_594014
  var valid_594015 = query.getOrDefault("oauth_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "oauth_token", valid_594015
  var valid_594016 = query.getOrDefault("callback")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "callback", valid_594016
  var valid_594017 = query.getOrDefault("access_token")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "access_token", valid_594017
  var valid_594018 = query.getOrDefault("uploadType")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "uploadType", valid_594018
  var valid_594019 = query.getOrDefault("key")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "key", valid_594019
  var valid_594020 = query.getOrDefault("$.xgafv")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = newJString("1"))
  if valid_594020 != nil:
    section.add "$.xgafv", valid_594020
  var valid_594021 = query.getOrDefault("pageSize")
  valid_594021 = validateParameter(valid_594021, JInt, required = false, default = nil)
  if valid_594021 != nil:
    section.add "pageSize", valid_594021
  var valid_594022 = query.getOrDefault("prettyPrint")
  valid_594022 = validateParameter(valid_594022, JBool, required = false,
                                 default = newJBool(true))
  if valid_594022 != nil:
    section.add "prettyPrint", valid_594022
  var valid_594023 = query.getOrDefault("filter")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "filter", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_TpuProjectsLocationsOperationsList_594006;
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
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_TpuProjectsLocationsOperationsList_594006;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## tpuProjectsLocationsOperationsList
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
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "upload_protocol", newJString(uploadProtocol))
  add(query_594027, "fields", newJString(fields))
  add(query_594027, "pageToken", newJString(pageToken))
  add(query_594027, "quotaUser", newJString(quotaUser))
  add(path_594026, "name", newJString(name))
  add(query_594027, "alt", newJString(alt))
  add(query_594027, "oauth_token", newJString(oauthToken))
  add(query_594027, "callback", newJString(callback))
  add(query_594027, "access_token", newJString(accessToken))
  add(query_594027, "uploadType", newJString(uploadType))
  add(query_594027, "key", newJString(key))
  add(query_594027, "$.xgafv", newJString(Xgafv))
  add(query_594027, "pageSize", newJInt(pageSize))
  add(query_594027, "prettyPrint", newJBool(prettyPrint))
  add(query_594027, "filter", newJString(filter))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var tpuProjectsLocationsOperationsList* = Call_TpuProjectsLocationsOperationsList_594006(
    name: "tpuProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "tpu.googleapis.com", route: "/v1/{name}/operations",
    validator: validate_TpuProjectsLocationsOperationsList_594007, base: "/",
    url: url_TpuProjectsLocationsOperationsList_594008, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsOperationsCancel_594028 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsOperationsCancel_594030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_TpuProjectsLocationsOperationsCancel_594029(path: JsonNode;
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
  var valid_594031 = path.getOrDefault("name")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "name", valid_594031
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
  var valid_594032 = query.getOrDefault("upload_protocol")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "upload_protocol", valid_594032
  var valid_594033 = query.getOrDefault("fields")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "fields", valid_594033
  var valid_594034 = query.getOrDefault("quotaUser")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "quotaUser", valid_594034
  var valid_594035 = query.getOrDefault("alt")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("json"))
  if valid_594035 != nil:
    section.add "alt", valid_594035
  var valid_594036 = query.getOrDefault("oauth_token")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "oauth_token", valid_594036
  var valid_594037 = query.getOrDefault("callback")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "callback", valid_594037
  var valid_594038 = query.getOrDefault("access_token")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "access_token", valid_594038
  var valid_594039 = query.getOrDefault("uploadType")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "uploadType", valid_594039
  var valid_594040 = query.getOrDefault("key")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "key", valid_594040
  var valid_594041 = query.getOrDefault("$.xgafv")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = newJString("1"))
  if valid_594041 != nil:
    section.add "$.xgafv", valid_594041
  var valid_594042 = query.getOrDefault("prettyPrint")
  valid_594042 = validateParameter(valid_594042, JBool, required = false,
                                 default = newJBool(true))
  if valid_594042 != nil:
    section.add "prettyPrint", valid_594042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_TpuProjectsLocationsOperationsCancel_594028;
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
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_TpuProjectsLocationsOperationsCancel_594028;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## tpuProjectsLocationsOperationsCancel
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
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  add(query_594046, "upload_protocol", newJString(uploadProtocol))
  add(query_594046, "fields", newJString(fields))
  add(query_594046, "quotaUser", newJString(quotaUser))
  add(path_594045, "name", newJString(name))
  add(query_594046, "alt", newJString(alt))
  add(query_594046, "oauth_token", newJString(oauthToken))
  add(query_594046, "callback", newJString(callback))
  add(query_594046, "access_token", newJString(accessToken))
  add(query_594046, "uploadType", newJString(uploadType))
  add(query_594046, "key", newJString(key))
  add(query_594046, "$.xgafv", newJString(Xgafv))
  add(query_594046, "prettyPrint", newJBool(prettyPrint))
  result = call_594044.call(path_594045, query_594046, nil, nil, nil)

var tpuProjectsLocationsOperationsCancel* = Call_TpuProjectsLocationsOperationsCancel_594028(
    name: "tpuProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "tpu.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_TpuProjectsLocationsOperationsCancel_594029, base: "/",
    url: url_TpuProjectsLocationsOperationsCancel_594030, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsNodesReimage_594047 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsNodesReimage_594049(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":reimage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsNodesReimage_594048(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages a node's OS.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594050 = path.getOrDefault("name")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "name", valid_594050
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
  var valid_594051 = query.getOrDefault("upload_protocol")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "upload_protocol", valid_594051
  var valid_594052 = query.getOrDefault("fields")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "fields", valid_594052
  var valid_594053 = query.getOrDefault("quotaUser")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "quotaUser", valid_594053
  var valid_594054 = query.getOrDefault("alt")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = newJString("json"))
  if valid_594054 != nil:
    section.add "alt", valid_594054
  var valid_594055 = query.getOrDefault("oauth_token")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "oauth_token", valid_594055
  var valid_594056 = query.getOrDefault("callback")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "callback", valid_594056
  var valid_594057 = query.getOrDefault("access_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "access_token", valid_594057
  var valid_594058 = query.getOrDefault("uploadType")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "uploadType", valid_594058
  var valid_594059 = query.getOrDefault("key")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "key", valid_594059
  var valid_594060 = query.getOrDefault("$.xgafv")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = newJString("1"))
  if valid_594060 != nil:
    section.add "$.xgafv", valid_594060
  var valid_594061 = query.getOrDefault("prettyPrint")
  valid_594061 = validateParameter(valid_594061, JBool, required = false,
                                 default = newJBool(true))
  if valid_594061 != nil:
    section.add "prettyPrint", valid_594061
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

proc call*(call_594063: Call_TpuProjectsLocationsNodesReimage_594047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages a node's OS.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_TpuProjectsLocationsNodesReimage_594047; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tpuProjectsLocationsNodesReimage
  ## Reimages a node's OS.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name.
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
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  var body_594067 = newJObject()
  add(query_594066, "upload_protocol", newJString(uploadProtocol))
  add(query_594066, "fields", newJString(fields))
  add(query_594066, "quotaUser", newJString(quotaUser))
  add(path_594065, "name", newJString(name))
  add(query_594066, "alt", newJString(alt))
  add(query_594066, "oauth_token", newJString(oauthToken))
  add(query_594066, "callback", newJString(callback))
  add(query_594066, "access_token", newJString(accessToken))
  add(query_594066, "uploadType", newJString(uploadType))
  add(query_594066, "key", newJString(key))
  add(query_594066, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594067 = body
  add(query_594066, "prettyPrint", newJBool(prettyPrint))
  result = call_594064.call(path_594065, query_594066, nil, nil, body_594067)

var tpuProjectsLocationsNodesReimage* = Call_TpuProjectsLocationsNodesReimage_594047(
    name: "tpuProjectsLocationsNodesReimage", meth: HttpMethod.HttpPost,
    host: "tpu.googleapis.com", route: "/v1/{name}:reimage",
    validator: validate_TpuProjectsLocationsNodesReimage_594048, base: "/",
    url: url_TpuProjectsLocationsNodesReimage_594049, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsNodesStart_594068 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsNodesStart_594070(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsNodesStart_594069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594071 = path.getOrDefault("name")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "name", valid_594071
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
  var valid_594072 = query.getOrDefault("upload_protocol")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "upload_protocol", valid_594072
  var valid_594073 = query.getOrDefault("fields")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "fields", valid_594073
  var valid_594074 = query.getOrDefault("quotaUser")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "quotaUser", valid_594074
  var valid_594075 = query.getOrDefault("alt")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = newJString("json"))
  if valid_594075 != nil:
    section.add "alt", valid_594075
  var valid_594076 = query.getOrDefault("oauth_token")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "oauth_token", valid_594076
  var valid_594077 = query.getOrDefault("callback")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "callback", valid_594077
  var valid_594078 = query.getOrDefault("access_token")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "access_token", valid_594078
  var valid_594079 = query.getOrDefault("uploadType")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "uploadType", valid_594079
  var valid_594080 = query.getOrDefault("key")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "key", valid_594080
  var valid_594081 = query.getOrDefault("$.xgafv")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = newJString("1"))
  if valid_594081 != nil:
    section.add "$.xgafv", valid_594081
  var valid_594082 = query.getOrDefault("prettyPrint")
  valid_594082 = validateParameter(valid_594082, JBool, required = false,
                                 default = newJBool(true))
  if valid_594082 != nil:
    section.add "prettyPrint", valid_594082
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

proc call*(call_594084: Call_TpuProjectsLocationsNodesStart_594068; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a node.
  ## 
  let valid = call_594084.validator(path, query, header, formData, body)
  let scheme = call_594084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594084.url(scheme.get, call_594084.host, call_594084.base,
                         call_594084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594084, url, valid)

proc call*(call_594085: Call_TpuProjectsLocationsNodesStart_594068; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tpuProjectsLocationsNodesStart
  ## Starts a node.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name.
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
  var path_594086 = newJObject()
  var query_594087 = newJObject()
  var body_594088 = newJObject()
  add(query_594087, "upload_protocol", newJString(uploadProtocol))
  add(query_594087, "fields", newJString(fields))
  add(query_594087, "quotaUser", newJString(quotaUser))
  add(path_594086, "name", newJString(name))
  add(query_594087, "alt", newJString(alt))
  add(query_594087, "oauth_token", newJString(oauthToken))
  add(query_594087, "callback", newJString(callback))
  add(query_594087, "access_token", newJString(accessToken))
  add(query_594087, "uploadType", newJString(uploadType))
  add(query_594087, "key", newJString(key))
  add(query_594087, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594088 = body
  add(query_594087, "prettyPrint", newJBool(prettyPrint))
  result = call_594085.call(path_594086, query_594087, nil, nil, body_594088)

var tpuProjectsLocationsNodesStart* = Call_TpuProjectsLocationsNodesStart_594068(
    name: "tpuProjectsLocationsNodesStart", meth: HttpMethod.HttpPost,
    host: "tpu.googleapis.com", route: "/v1/{name}:start",
    validator: validate_TpuProjectsLocationsNodesStart_594069, base: "/",
    url: url_TpuProjectsLocationsNodesStart_594070, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsNodesStop_594089 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsNodesStop_594091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsNodesStop_594090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594092 = path.getOrDefault("name")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "name", valid_594092
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
  var valid_594093 = query.getOrDefault("upload_protocol")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "upload_protocol", valid_594093
  var valid_594094 = query.getOrDefault("fields")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "fields", valid_594094
  var valid_594095 = query.getOrDefault("quotaUser")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "quotaUser", valid_594095
  var valid_594096 = query.getOrDefault("alt")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = newJString("json"))
  if valid_594096 != nil:
    section.add "alt", valid_594096
  var valid_594097 = query.getOrDefault("oauth_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "oauth_token", valid_594097
  var valid_594098 = query.getOrDefault("callback")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "callback", valid_594098
  var valid_594099 = query.getOrDefault("access_token")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "access_token", valid_594099
  var valid_594100 = query.getOrDefault("uploadType")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "uploadType", valid_594100
  var valid_594101 = query.getOrDefault("key")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "key", valid_594101
  var valid_594102 = query.getOrDefault("$.xgafv")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = newJString("1"))
  if valid_594102 != nil:
    section.add "$.xgafv", valid_594102
  var valid_594103 = query.getOrDefault("prettyPrint")
  valid_594103 = validateParameter(valid_594103, JBool, required = false,
                                 default = newJBool(true))
  if valid_594103 != nil:
    section.add "prettyPrint", valid_594103
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

proc call*(call_594105: Call_TpuProjectsLocationsNodesStop_594089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a node.
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_TpuProjectsLocationsNodesStop_594089; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tpuProjectsLocationsNodesStop
  ## Stops a node.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name.
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
  var path_594107 = newJObject()
  var query_594108 = newJObject()
  var body_594109 = newJObject()
  add(query_594108, "upload_protocol", newJString(uploadProtocol))
  add(query_594108, "fields", newJString(fields))
  add(query_594108, "quotaUser", newJString(quotaUser))
  add(path_594107, "name", newJString(name))
  add(query_594108, "alt", newJString(alt))
  add(query_594108, "oauth_token", newJString(oauthToken))
  add(query_594108, "callback", newJString(callback))
  add(query_594108, "access_token", newJString(accessToken))
  add(query_594108, "uploadType", newJString(uploadType))
  add(query_594108, "key", newJString(key))
  add(query_594108, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594109 = body
  add(query_594108, "prettyPrint", newJBool(prettyPrint))
  result = call_594106.call(path_594107, query_594108, nil, nil, body_594109)

var tpuProjectsLocationsNodesStop* = Call_TpuProjectsLocationsNodesStop_594089(
    name: "tpuProjectsLocationsNodesStop", meth: HttpMethod.HttpPost,
    host: "tpu.googleapis.com", route: "/v1/{name}:stop",
    validator: validate_TpuProjectsLocationsNodesStop_594090, base: "/",
    url: url_TpuProjectsLocationsNodesStop_594091, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsAcceleratorTypesList_594110 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsAcceleratorTypesList_594112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/acceleratorTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsAcceleratorTypesList_594111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists accelerator types supported by this API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594113 = path.getOrDefault("parent")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "parent", valid_594113
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   orderBy: JString
  ##          : Sort results.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : List filter.
  section = newJObject()
  var valid_594114 = query.getOrDefault("upload_protocol")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "upload_protocol", valid_594114
  var valid_594115 = query.getOrDefault("fields")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "fields", valid_594115
  var valid_594116 = query.getOrDefault("pageToken")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "pageToken", valid_594116
  var valid_594117 = query.getOrDefault("quotaUser")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "quotaUser", valid_594117
  var valid_594118 = query.getOrDefault("alt")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = newJString("json"))
  if valid_594118 != nil:
    section.add "alt", valid_594118
  var valid_594119 = query.getOrDefault("oauth_token")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "oauth_token", valid_594119
  var valid_594120 = query.getOrDefault("callback")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "callback", valid_594120
  var valid_594121 = query.getOrDefault("access_token")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "access_token", valid_594121
  var valid_594122 = query.getOrDefault("uploadType")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "uploadType", valid_594122
  var valid_594123 = query.getOrDefault("orderBy")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "orderBy", valid_594123
  var valid_594124 = query.getOrDefault("key")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "key", valid_594124
  var valid_594125 = query.getOrDefault("$.xgafv")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = newJString("1"))
  if valid_594125 != nil:
    section.add "$.xgafv", valid_594125
  var valid_594126 = query.getOrDefault("pageSize")
  valid_594126 = validateParameter(valid_594126, JInt, required = false, default = nil)
  if valid_594126 != nil:
    section.add "pageSize", valid_594126
  var valid_594127 = query.getOrDefault("prettyPrint")
  valid_594127 = validateParameter(valid_594127, JBool, required = false,
                                 default = newJBool(true))
  if valid_594127 != nil:
    section.add "prettyPrint", valid_594127
  var valid_594128 = query.getOrDefault("filter")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "filter", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_TpuProjectsLocationsAcceleratorTypesList_594110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists accelerator types supported by this API.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_TpuProjectsLocationsAcceleratorTypesList_594110;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## tpuProjectsLocationsAcceleratorTypesList
  ## Lists accelerator types supported by this API.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##         : The parent resource name.
  ##   orderBy: string
  ##          : Sort results.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : List filter.
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(query_594132, "upload_protocol", newJString(uploadProtocol))
  add(query_594132, "fields", newJString(fields))
  add(query_594132, "pageToken", newJString(pageToken))
  add(query_594132, "quotaUser", newJString(quotaUser))
  add(query_594132, "alt", newJString(alt))
  add(query_594132, "oauth_token", newJString(oauthToken))
  add(query_594132, "callback", newJString(callback))
  add(query_594132, "access_token", newJString(accessToken))
  add(query_594132, "uploadType", newJString(uploadType))
  add(path_594131, "parent", newJString(parent))
  add(query_594132, "orderBy", newJString(orderBy))
  add(query_594132, "key", newJString(key))
  add(query_594132, "$.xgafv", newJString(Xgafv))
  add(query_594132, "pageSize", newJInt(pageSize))
  add(query_594132, "prettyPrint", newJBool(prettyPrint))
  add(query_594132, "filter", newJString(filter))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var tpuProjectsLocationsAcceleratorTypesList* = Call_TpuProjectsLocationsAcceleratorTypesList_594110(
    name: "tpuProjectsLocationsAcceleratorTypesList", meth: HttpMethod.HttpGet,
    host: "tpu.googleapis.com", route: "/v1/{parent}/acceleratorTypes",
    validator: validate_TpuProjectsLocationsAcceleratorTypesList_594111,
    base: "/", url: url_TpuProjectsLocationsAcceleratorTypesList_594112,
    schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsNodesCreate_594154 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsNodesCreate_594156(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsNodesCreate_594155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594157 = path.getOrDefault("parent")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "parent", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   nodeId: JString
  ##         : The unqualified resource name.
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
  var valid_594158 = query.getOrDefault("upload_protocol")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "upload_protocol", valid_594158
  var valid_594159 = query.getOrDefault("nodeId")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "nodeId", valid_594159
  var valid_594160 = query.getOrDefault("fields")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "fields", valid_594160
  var valid_594161 = query.getOrDefault("quotaUser")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "quotaUser", valid_594161
  var valid_594162 = query.getOrDefault("alt")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = newJString("json"))
  if valid_594162 != nil:
    section.add "alt", valid_594162
  var valid_594163 = query.getOrDefault("oauth_token")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "oauth_token", valid_594163
  var valid_594164 = query.getOrDefault("callback")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "callback", valid_594164
  var valid_594165 = query.getOrDefault("access_token")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "access_token", valid_594165
  var valid_594166 = query.getOrDefault("uploadType")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "uploadType", valid_594166
  var valid_594167 = query.getOrDefault("key")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "key", valid_594167
  var valid_594168 = query.getOrDefault("$.xgafv")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = newJString("1"))
  if valid_594168 != nil:
    section.add "$.xgafv", valid_594168
  var valid_594169 = query.getOrDefault("prettyPrint")
  valid_594169 = validateParameter(valid_594169, JBool, required = false,
                                 default = newJBool(true))
  if valid_594169 != nil:
    section.add "prettyPrint", valid_594169
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

proc call*(call_594171: Call_TpuProjectsLocationsNodesCreate_594154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a node.
  ## 
  let valid = call_594171.validator(path, query, header, formData, body)
  let scheme = call_594171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594171.url(scheme.get, call_594171.host, call_594171.base,
                         call_594171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594171, url, valid)

proc call*(call_594172: Call_TpuProjectsLocationsNodesCreate_594154;
          parent: string; uploadProtocol: string = ""; nodeId: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## tpuProjectsLocationsNodesCreate
  ## Creates a node.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   nodeId: string
  ##         : The unqualified resource name.
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
  ##         : The parent resource name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594173 = newJObject()
  var query_594174 = newJObject()
  var body_594175 = newJObject()
  add(query_594174, "upload_protocol", newJString(uploadProtocol))
  add(query_594174, "nodeId", newJString(nodeId))
  add(query_594174, "fields", newJString(fields))
  add(query_594174, "quotaUser", newJString(quotaUser))
  add(query_594174, "alt", newJString(alt))
  add(query_594174, "oauth_token", newJString(oauthToken))
  add(query_594174, "callback", newJString(callback))
  add(query_594174, "access_token", newJString(accessToken))
  add(query_594174, "uploadType", newJString(uploadType))
  add(path_594173, "parent", newJString(parent))
  add(query_594174, "key", newJString(key))
  add(query_594174, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594175 = body
  add(query_594174, "prettyPrint", newJBool(prettyPrint))
  result = call_594172.call(path_594173, query_594174, nil, nil, body_594175)

var tpuProjectsLocationsNodesCreate* = Call_TpuProjectsLocationsNodesCreate_594154(
    name: "tpuProjectsLocationsNodesCreate", meth: HttpMethod.HttpPost,
    host: "tpu.googleapis.com", route: "/v1/{parent}/nodes",
    validator: validate_TpuProjectsLocationsNodesCreate_594155, base: "/",
    url: url_TpuProjectsLocationsNodesCreate_594156, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsNodesList_594133 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsNodesList_594135(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/nodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsNodesList_594134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists nodes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594136 = path.getOrDefault("parent")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "parent", valid_594136
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594137 = query.getOrDefault("upload_protocol")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "upload_protocol", valid_594137
  var valid_594138 = query.getOrDefault("fields")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "fields", valid_594138
  var valid_594139 = query.getOrDefault("pageToken")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "pageToken", valid_594139
  var valid_594140 = query.getOrDefault("quotaUser")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "quotaUser", valid_594140
  var valid_594141 = query.getOrDefault("alt")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = newJString("json"))
  if valid_594141 != nil:
    section.add "alt", valid_594141
  var valid_594142 = query.getOrDefault("oauth_token")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "oauth_token", valid_594142
  var valid_594143 = query.getOrDefault("callback")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "callback", valid_594143
  var valid_594144 = query.getOrDefault("access_token")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "access_token", valid_594144
  var valid_594145 = query.getOrDefault("uploadType")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "uploadType", valid_594145
  var valid_594146 = query.getOrDefault("key")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "key", valid_594146
  var valid_594147 = query.getOrDefault("$.xgafv")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = newJString("1"))
  if valid_594147 != nil:
    section.add "$.xgafv", valid_594147
  var valid_594148 = query.getOrDefault("pageSize")
  valid_594148 = validateParameter(valid_594148, JInt, required = false, default = nil)
  if valid_594148 != nil:
    section.add "pageSize", valid_594148
  var valid_594149 = query.getOrDefault("prettyPrint")
  valid_594149 = validateParameter(valid_594149, JBool, required = false,
                                 default = newJBool(true))
  if valid_594149 != nil:
    section.add "prettyPrint", valid_594149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594150: Call_TpuProjectsLocationsNodesList_594133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists nodes.
  ## 
  let valid = call_594150.validator(path, query, header, formData, body)
  let scheme = call_594150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594150.url(scheme.get, call_594150.host, call_594150.base,
                         call_594150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594150, url, valid)

proc call*(call_594151: Call_TpuProjectsLocationsNodesList_594133; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## tpuProjectsLocationsNodesList
  ## Lists nodes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##         : The parent resource name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594152 = newJObject()
  var query_594153 = newJObject()
  add(query_594153, "upload_protocol", newJString(uploadProtocol))
  add(query_594153, "fields", newJString(fields))
  add(query_594153, "pageToken", newJString(pageToken))
  add(query_594153, "quotaUser", newJString(quotaUser))
  add(query_594153, "alt", newJString(alt))
  add(query_594153, "oauth_token", newJString(oauthToken))
  add(query_594153, "callback", newJString(callback))
  add(query_594153, "access_token", newJString(accessToken))
  add(query_594153, "uploadType", newJString(uploadType))
  add(path_594152, "parent", newJString(parent))
  add(query_594153, "key", newJString(key))
  add(query_594153, "$.xgafv", newJString(Xgafv))
  add(query_594153, "pageSize", newJInt(pageSize))
  add(query_594153, "prettyPrint", newJBool(prettyPrint))
  result = call_594151.call(path_594152, query_594153, nil, nil, nil)

var tpuProjectsLocationsNodesList* = Call_TpuProjectsLocationsNodesList_594133(
    name: "tpuProjectsLocationsNodesList", meth: HttpMethod.HttpGet,
    host: "tpu.googleapis.com", route: "/v1/{parent}/nodes",
    validator: validate_TpuProjectsLocationsNodesList_594134, base: "/",
    url: url_TpuProjectsLocationsNodesList_594135, schemes: {Scheme.Https})
type
  Call_TpuProjectsLocationsTensorflowVersionsList_594176 = ref object of OpenApiRestCall_593408
proc url_TpuProjectsLocationsTensorflowVersionsList_594178(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tensorflowVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TpuProjectsLocationsTensorflowVersionsList_594177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List TensorFlow versions supported by this API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594179 = path.getOrDefault("parent")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "parent", valid_594179
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   orderBy: JString
  ##          : Sort results.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : List filter.
  section = newJObject()
  var valid_594180 = query.getOrDefault("upload_protocol")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "upload_protocol", valid_594180
  var valid_594181 = query.getOrDefault("fields")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "fields", valid_594181
  var valid_594182 = query.getOrDefault("pageToken")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "pageToken", valid_594182
  var valid_594183 = query.getOrDefault("quotaUser")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "quotaUser", valid_594183
  var valid_594184 = query.getOrDefault("alt")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = newJString("json"))
  if valid_594184 != nil:
    section.add "alt", valid_594184
  var valid_594185 = query.getOrDefault("oauth_token")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "oauth_token", valid_594185
  var valid_594186 = query.getOrDefault("callback")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "callback", valid_594186
  var valid_594187 = query.getOrDefault("access_token")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "access_token", valid_594187
  var valid_594188 = query.getOrDefault("uploadType")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "uploadType", valid_594188
  var valid_594189 = query.getOrDefault("orderBy")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "orderBy", valid_594189
  var valid_594190 = query.getOrDefault("key")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "key", valid_594190
  var valid_594191 = query.getOrDefault("$.xgafv")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = newJString("1"))
  if valid_594191 != nil:
    section.add "$.xgafv", valid_594191
  var valid_594192 = query.getOrDefault("pageSize")
  valid_594192 = validateParameter(valid_594192, JInt, required = false, default = nil)
  if valid_594192 != nil:
    section.add "pageSize", valid_594192
  var valid_594193 = query.getOrDefault("prettyPrint")
  valid_594193 = validateParameter(valid_594193, JBool, required = false,
                                 default = newJBool(true))
  if valid_594193 != nil:
    section.add "prettyPrint", valid_594193
  var valid_594194 = query.getOrDefault("filter")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "filter", valid_594194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594195: Call_TpuProjectsLocationsTensorflowVersionsList_594176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List TensorFlow versions supported by this API.
  ## 
  let valid = call_594195.validator(path, query, header, formData, body)
  let scheme = call_594195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594195.url(scheme.get, call_594195.host, call_594195.base,
                         call_594195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594195, url, valid)

proc call*(call_594196: Call_TpuProjectsLocationsTensorflowVersionsList_594176;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## tpuProjectsLocationsTensorflowVersionsList
  ## List TensorFlow versions supported by this API.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##         : The parent resource name.
  ##   orderBy: string
  ##          : Sort results.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : List filter.
  var path_594197 = newJObject()
  var query_594198 = newJObject()
  add(query_594198, "upload_protocol", newJString(uploadProtocol))
  add(query_594198, "fields", newJString(fields))
  add(query_594198, "pageToken", newJString(pageToken))
  add(query_594198, "quotaUser", newJString(quotaUser))
  add(query_594198, "alt", newJString(alt))
  add(query_594198, "oauth_token", newJString(oauthToken))
  add(query_594198, "callback", newJString(callback))
  add(query_594198, "access_token", newJString(accessToken))
  add(query_594198, "uploadType", newJString(uploadType))
  add(path_594197, "parent", newJString(parent))
  add(query_594198, "orderBy", newJString(orderBy))
  add(query_594198, "key", newJString(key))
  add(query_594198, "$.xgafv", newJString(Xgafv))
  add(query_594198, "pageSize", newJInt(pageSize))
  add(query_594198, "prettyPrint", newJBool(prettyPrint))
  add(query_594198, "filter", newJString(filter))
  result = call_594196.call(path_594197, query_594198, nil, nil, nil)

var tpuProjectsLocationsTensorflowVersionsList* = Call_TpuProjectsLocationsTensorflowVersionsList_594176(
    name: "tpuProjectsLocationsTensorflowVersionsList", meth: HttpMethod.HttpGet,
    host: "tpu.googleapis.com", route: "/v1/{parent}/tensorflowVersions",
    validator: validate_TpuProjectsLocationsTensorflowVersionsList_594177,
    base: "/", url: url_TpuProjectsLocationsTensorflowVersionsList_594178,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
