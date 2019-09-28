
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Run
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Deploy and manage user provided container images that scale automatically based on HTTP traffic.
## 
## https://cloud.google.com/run/
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
  gcpServiceName = "run"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunNamespacesDomainmappingsReplaceDomainMapping_579978 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesDomainmappingsReplaceDomainMapping_579980(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsReplaceDomainMapping_579979(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579981 = path.getOrDefault("name")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "name", valid_579981
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579994: Call_RunNamespacesDomainmappingsReplaceDomainMapping_579978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_579994.validator(path, query, header, formData, body)
  let scheme = call_579994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579994.url(scheme.get, call_579994.host, call_579994.base,
                         call_579994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579994, url, valid)

proc call*(call_579995: Call_RunNamespacesDomainmappingsReplaceDomainMapping_579978;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesDomainmappingsReplaceDomainMapping
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_579996 = newJObject()
  var query_579997 = newJObject()
  var body_579998 = newJObject()
  add(query_579997, "upload_protocol", newJString(uploadProtocol))
  add(query_579997, "fields", newJString(fields))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(path_579996, "name", newJString(name))
  add(query_579997, "alt", newJString(alt))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "callback", newJString(callback))
  add(query_579997, "access_token", newJString(accessToken))
  add(query_579997, "uploadType", newJString(uploadType))
  add(query_579997, "key", newJString(key))
  add(query_579997, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579998 = body
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  result = call_579995.call(path_579996, query_579997, nil, nil, body_579998)

var runNamespacesDomainmappingsReplaceDomainMapping* = Call_RunNamespacesDomainmappingsReplaceDomainMapping_579978(
    name: "runNamespacesDomainmappingsReplaceDomainMapping",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsReplaceDomainMapping_579979,
    base: "/", url: url_RunNamespacesDomainmappingsReplaceDomainMapping_579980,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsGet_579690 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesDomainmappingsGet_579692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsGet_579691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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

proc call*(call_579865: Call_RunNamespacesDomainmappingsGet_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a domain mapping.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579936: Call_RunNamespacesDomainmappingsGet_579690; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runNamespacesDomainmappingsGet
  ## Get information about a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_579937 = newJObject()
  var query_579939 = newJObject()
  add(query_579939, "upload_protocol", newJString(uploadProtocol))
  add(query_579939, "fields", newJString(fields))
  add(query_579939, "quotaUser", newJString(quotaUser))
  add(path_579937, "name", newJString(name))
  add(query_579939, "alt", newJString(alt))
  add(query_579939, "oauth_token", newJString(oauthToken))
  add(query_579939, "callback", newJString(callback))
  add(query_579939, "access_token", newJString(accessToken))
  add(query_579939, "uploadType", newJString(uploadType))
  add(query_579939, "key", newJString(key))
  add(query_579939, "$.xgafv", newJString(Xgafv))
  add(query_579939, "prettyPrint", newJBool(prettyPrint))
  result = call_579936.call(path_579937, query_579939, nil, nil, nil)

var runNamespacesDomainmappingsGet* = Call_RunNamespacesDomainmappingsGet_579690(
    name: "runNamespacesDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsGet_579691, base: "/",
    url: url_RunNamespacesDomainmappingsGet_579692, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsDelete_579999 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesDomainmappingsDelete_580001(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsDelete_580000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580002 = path.getOrDefault("name")
  valid_580002 = validateParameter(valid_580002, JString, required = true,
                                 default = nil)
  if valid_580002 != nil:
    section.add "name", valid_580002
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
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  section = newJObject()
  var valid_580003 = query.getOrDefault("upload_protocol")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "upload_protocol", valid_580003
  var valid_580004 = query.getOrDefault("fields")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "fields", valid_580004
  var valid_580005 = query.getOrDefault("quotaUser")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "quotaUser", valid_580005
  var valid_580006 = query.getOrDefault("alt")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("json"))
  if valid_580006 != nil:
    section.add "alt", valid_580006
  var valid_580007 = query.getOrDefault("oauth_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "oauth_token", valid_580007
  var valid_580008 = query.getOrDefault("callback")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "callback", valid_580008
  var valid_580009 = query.getOrDefault("access_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "access_token", valid_580009
  var valid_580010 = query.getOrDefault("uploadType")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "uploadType", valid_580010
  var valid_580011 = query.getOrDefault("kind")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "kind", valid_580011
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("$.xgafv")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("1"))
  if valid_580013 != nil:
    section.add "$.xgafv", valid_580013
  var valid_580014 = query.getOrDefault("prettyPrint")
  valid_580014 = validateParameter(valid_580014, JBool, required = false,
                                 default = newJBool(true))
  if valid_580014 != nil:
    section.add "prettyPrint", valid_580014
  var valid_580015 = query.getOrDefault("propagationPolicy")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "propagationPolicy", valid_580015
  var valid_580016 = query.getOrDefault("apiVersion")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "apiVersion", valid_580016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580017: Call_RunNamespacesDomainmappingsDelete_579999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a domain mapping.
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_RunNamespacesDomainmappingsDelete_579999;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runNamespacesDomainmappingsDelete
  ## Delete a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_580019 = newJObject()
  var query_580020 = newJObject()
  add(query_580020, "upload_protocol", newJString(uploadProtocol))
  add(query_580020, "fields", newJString(fields))
  add(query_580020, "quotaUser", newJString(quotaUser))
  add(path_580019, "name", newJString(name))
  add(query_580020, "alt", newJString(alt))
  add(query_580020, "oauth_token", newJString(oauthToken))
  add(query_580020, "callback", newJString(callback))
  add(query_580020, "access_token", newJString(accessToken))
  add(query_580020, "uploadType", newJString(uploadType))
  add(query_580020, "kind", newJString(kind))
  add(query_580020, "key", newJString(key))
  add(query_580020, "$.xgafv", newJString(Xgafv))
  add(query_580020, "prettyPrint", newJBool(prettyPrint))
  add(query_580020, "propagationPolicy", newJString(propagationPolicy))
  add(query_580020, "apiVersion", newJString(apiVersion))
  result = call_580018.call(path_580019, query_580020, nil, nil, nil)

var runNamespacesDomainmappingsDelete* = Call_RunNamespacesDomainmappingsDelete_579999(
    name: "runNamespacesDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsDelete_580000, base: "/",
    url: url_RunNamespacesDomainmappingsDelete_580001, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_580021 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesAuthorizeddomainsList_580023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/authorizeddomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesAuthorizeddomainsList_580022(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580024 = path.getOrDefault("parent")
  valid_580024 = validateParameter(valid_580024, JString, required = true,
                                 default = nil)
  if valid_580024 != nil:
    section.add "parent", valid_580024
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
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
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580025 = query.getOrDefault("upload_protocol")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "upload_protocol", valid_580025
  var valid_580026 = query.getOrDefault("fields")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "fields", valid_580026
  var valid_580027 = query.getOrDefault("pageToken")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "pageToken", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("callback")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "callback", valid_580031
  var valid_580032 = query.getOrDefault("access_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "access_token", valid_580032
  var valid_580033 = query.getOrDefault("uploadType")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "uploadType", valid_580033
  var valid_580034 = query.getOrDefault("key")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "key", valid_580034
  var valid_580035 = query.getOrDefault("$.xgafv")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("1"))
  if valid_580035 != nil:
    section.add "$.xgafv", valid_580035
  var valid_580036 = query.getOrDefault("pageSize")
  valid_580036 = validateParameter(valid_580036, JInt, required = false, default = nil)
  if valid_580036 != nil:
    section.add "pageSize", valid_580036
  var valid_580037 = query.getOrDefault("prettyPrint")
  valid_580037 = validateParameter(valid_580037, JBool, required = false,
                                 default = newJBool(true))
  if valid_580037 != nil:
    section.add "prettyPrint", valid_580037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580038: Call_RunNamespacesAuthorizeddomainsList_580021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_RunNamespacesAuthorizeddomainsList_580021;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesAuthorizeddomainsList
  ## List authorized domains.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
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
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "pageToken", newJString(pageToken))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "uploadType", newJString(uploadType))
  add(path_580040, "parent", newJString(parent))
  add(query_580041, "key", newJString(key))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  add(query_580041, "pageSize", newJInt(pageSize))
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  result = call_580039.call(path_580040, query_580041, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_580021(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_580022, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_580023, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsCreate_580068 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesAutodomainmappingsCreate_580070(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesAutodomainmappingsCreate_580069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new auto domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580071 = path.getOrDefault("parent")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "parent", valid_580071
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
  var valid_580072 = query.getOrDefault("upload_protocol")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "upload_protocol", valid_580072
  var valid_580073 = query.getOrDefault("fields")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "fields", valid_580073
  var valid_580074 = query.getOrDefault("quotaUser")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "quotaUser", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("oauth_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "oauth_token", valid_580076
  var valid_580077 = query.getOrDefault("callback")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "callback", valid_580077
  var valid_580078 = query.getOrDefault("access_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "access_token", valid_580078
  var valid_580079 = query.getOrDefault("uploadType")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "uploadType", valid_580079
  var valid_580080 = query.getOrDefault("key")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "key", valid_580080
  var valid_580081 = query.getOrDefault("$.xgafv")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("1"))
  if valid_580081 != nil:
    section.add "$.xgafv", valid_580081
  var valid_580082 = query.getOrDefault("prettyPrint")
  valid_580082 = validateParameter(valid_580082, JBool, required = false,
                                 default = newJBool(true))
  if valid_580082 != nil:
    section.add "prettyPrint", valid_580082
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

proc call*(call_580084: Call_RunNamespacesAutodomainmappingsCreate_580068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_580084.validator(path, query, header, formData, body)
  let scheme = call_580084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580084.url(scheme.get, call_580084.host, call_580084.base,
                         call_580084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580084, url, valid)

proc call*(call_580085: Call_RunNamespacesAutodomainmappingsCreate_580068;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesAutodomainmappingsCreate
  ## Creates a new auto domain mapping.
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
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580086 = newJObject()
  var query_580087 = newJObject()
  var body_580088 = newJObject()
  add(query_580087, "upload_protocol", newJString(uploadProtocol))
  add(query_580087, "fields", newJString(fields))
  add(query_580087, "quotaUser", newJString(quotaUser))
  add(query_580087, "alt", newJString(alt))
  add(query_580087, "oauth_token", newJString(oauthToken))
  add(query_580087, "callback", newJString(callback))
  add(query_580087, "access_token", newJString(accessToken))
  add(query_580087, "uploadType", newJString(uploadType))
  add(path_580086, "parent", newJString(parent))
  add(query_580087, "key", newJString(key))
  add(query_580087, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580088 = body
  add(query_580087, "prettyPrint", newJBool(prettyPrint))
  result = call_580085.call(path_580086, query_580087, nil, nil, body_580088)

var runNamespacesAutodomainmappingsCreate* = Call_RunNamespacesAutodomainmappingsCreate_580068(
    name: "runNamespacesAutodomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsCreate_580069, base: "/",
    url: url_RunNamespacesAutodomainmappingsCreate_580070, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsList_580042 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesAutodomainmappingsList_580044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesAutodomainmappingsList_580043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List auto domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580045 = path.getOrDefault("parent")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "parent", valid_580045
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580046 = query.getOrDefault("upload_protocol")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "upload_protocol", valid_580046
  var valid_580047 = query.getOrDefault("fields")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "fields", valid_580047
  var valid_580048 = query.getOrDefault("quotaUser")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "quotaUser", valid_580048
  var valid_580049 = query.getOrDefault("includeUninitialized")
  valid_580049 = validateParameter(valid_580049, JBool, required = false, default = nil)
  if valid_580049 != nil:
    section.add "includeUninitialized", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("continue")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "continue", valid_580051
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
  var valid_580056 = query.getOrDefault("resourceVersion")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "resourceVersion", valid_580056
  var valid_580057 = query.getOrDefault("watch")
  valid_580057 = validateParameter(valid_580057, JBool, required = false, default = nil)
  if valid_580057 != nil:
    section.add "watch", valid_580057
  var valid_580058 = query.getOrDefault("key")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "key", valid_580058
  var valid_580059 = query.getOrDefault("$.xgafv")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("1"))
  if valid_580059 != nil:
    section.add "$.xgafv", valid_580059
  var valid_580060 = query.getOrDefault("labelSelector")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "labelSelector", valid_580060
  var valid_580061 = query.getOrDefault("prettyPrint")
  valid_580061 = validateParameter(valid_580061, JBool, required = false,
                                 default = newJBool(true))
  if valid_580061 != nil:
    section.add "prettyPrint", valid_580061
  var valid_580062 = query.getOrDefault("fieldSelector")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "fieldSelector", valid_580062
  var valid_580063 = query.getOrDefault("limit")
  valid_580063 = validateParameter(valid_580063, JInt, required = false, default = nil)
  if valid_580063 != nil:
    section.add "limit", valid_580063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580064: Call_RunNamespacesAutodomainmappingsList_580042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_RunNamespacesAutodomainmappingsList_580042;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesAutodomainmappingsList
  ## List auto domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  add(query_580067, "upload_protocol", newJString(uploadProtocol))
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(query_580067, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "continue", newJString(`continue`))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(query_580067, "callback", newJString(callback))
  add(query_580067, "access_token", newJString(accessToken))
  add(query_580067, "uploadType", newJString(uploadType))
  add(path_580066, "parent", newJString(parent))
  add(query_580067, "resourceVersion", newJString(resourceVersion))
  add(query_580067, "watch", newJBool(watch))
  add(query_580067, "key", newJString(key))
  add(query_580067, "$.xgafv", newJString(Xgafv))
  add(query_580067, "labelSelector", newJString(labelSelector))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  add(query_580067, "fieldSelector", newJString(fieldSelector))
  add(query_580067, "limit", newJInt(limit))
  result = call_580065.call(path_580066, query_580067, nil, nil, nil)

var runNamespacesAutodomainmappingsList* = Call_RunNamespacesAutodomainmappingsList_580042(
    name: "runNamespacesAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsList_580043, base: "/",
    url: url_RunNamespacesAutodomainmappingsList_580044, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_580115 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesDomainmappingsCreate_580117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsCreate_580116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580118 = path.getOrDefault("parent")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "parent", valid_580118
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
  var valid_580119 = query.getOrDefault("upload_protocol")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "upload_protocol", valid_580119
  var valid_580120 = query.getOrDefault("fields")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "fields", valid_580120
  var valid_580121 = query.getOrDefault("quotaUser")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "quotaUser", valid_580121
  var valid_580122 = query.getOrDefault("alt")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("json"))
  if valid_580122 != nil:
    section.add "alt", valid_580122
  var valid_580123 = query.getOrDefault("oauth_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "oauth_token", valid_580123
  var valid_580124 = query.getOrDefault("callback")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "callback", valid_580124
  var valid_580125 = query.getOrDefault("access_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "access_token", valid_580125
  var valid_580126 = query.getOrDefault("uploadType")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "uploadType", valid_580126
  var valid_580127 = query.getOrDefault("key")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "key", valid_580127
  var valid_580128 = query.getOrDefault("$.xgafv")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = newJString("1"))
  if valid_580128 != nil:
    section.add "$.xgafv", valid_580128
  var valid_580129 = query.getOrDefault("prettyPrint")
  valid_580129 = validateParameter(valid_580129, JBool, required = false,
                                 default = newJBool(true))
  if valid_580129 != nil:
    section.add "prettyPrint", valid_580129
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

proc call*(call_580131: Call_RunNamespacesDomainmappingsCreate_580115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_RunNamespacesDomainmappingsCreate_580115;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesDomainmappingsCreate
  ## Create a new domain mapping.
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
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580133 = newJObject()
  var query_580134 = newJObject()
  var body_580135 = newJObject()
  add(query_580134, "upload_protocol", newJString(uploadProtocol))
  add(query_580134, "fields", newJString(fields))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(query_580134, "alt", newJString(alt))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "callback", newJString(callback))
  add(query_580134, "access_token", newJString(accessToken))
  add(query_580134, "uploadType", newJString(uploadType))
  add(path_580133, "parent", newJString(parent))
  add(query_580134, "key", newJString(key))
  add(query_580134, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580135 = body
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  result = call_580132.call(path_580133, query_580134, nil, nil, body_580135)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_580115(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_580116, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_580117, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_580089 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesDomainmappingsList_580091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/domains.cloudrun.com/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsList_580090(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580092 = path.getOrDefault("parent")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "parent", valid_580092
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580093 = query.getOrDefault("upload_protocol")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "upload_protocol", valid_580093
  var valid_580094 = query.getOrDefault("fields")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "fields", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("includeUninitialized")
  valid_580096 = validateParameter(valid_580096, JBool, required = false, default = nil)
  if valid_580096 != nil:
    section.add "includeUninitialized", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("continue")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "continue", valid_580098
  var valid_580099 = query.getOrDefault("oauth_token")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "oauth_token", valid_580099
  var valid_580100 = query.getOrDefault("callback")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "callback", valid_580100
  var valid_580101 = query.getOrDefault("access_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "access_token", valid_580101
  var valid_580102 = query.getOrDefault("uploadType")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "uploadType", valid_580102
  var valid_580103 = query.getOrDefault("resourceVersion")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "resourceVersion", valid_580103
  var valid_580104 = query.getOrDefault("watch")
  valid_580104 = validateParameter(valid_580104, JBool, required = false, default = nil)
  if valid_580104 != nil:
    section.add "watch", valid_580104
  var valid_580105 = query.getOrDefault("key")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "key", valid_580105
  var valid_580106 = query.getOrDefault("$.xgafv")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("1"))
  if valid_580106 != nil:
    section.add "$.xgafv", valid_580106
  var valid_580107 = query.getOrDefault("labelSelector")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "labelSelector", valid_580107
  var valid_580108 = query.getOrDefault("prettyPrint")
  valid_580108 = validateParameter(valid_580108, JBool, required = false,
                                 default = newJBool(true))
  if valid_580108 != nil:
    section.add "prettyPrint", valid_580108
  var valid_580109 = query.getOrDefault("fieldSelector")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "fieldSelector", valid_580109
  var valid_580110 = query.getOrDefault("limit")
  valid_580110 = validateParameter(valid_580110, JInt, required = false, default = nil)
  if valid_580110 != nil:
    section.add "limit", valid_580110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580111: Call_RunNamespacesDomainmappingsList_580089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_580111.validator(path, query, header, formData, body)
  let scheme = call_580111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580111.url(scheme.get, call_580111.host, call_580111.base,
                         call_580111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580111, url, valid)

proc call*(call_580112: Call_RunNamespacesDomainmappingsList_580089;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesDomainmappingsList
  ## List domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580113 = newJObject()
  var query_580114 = newJObject()
  add(query_580114, "upload_protocol", newJString(uploadProtocol))
  add(query_580114, "fields", newJString(fields))
  add(query_580114, "quotaUser", newJString(quotaUser))
  add(query_580114, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580114, "alt", newJString(alt))
  add(query_580114, "continue", newJString(`continue`))
  add(query_580114, "oauth_token", newJString(oauthToken))
  add(query_580114, "callback", newJString(callback))
  add(query_580114, "access_token", newJString(accessToken))
  add(query_580114, "uploadType", newJString(uploadType))
  add(path_580113, "parent", newJString(parent))
  add(query_580114, "resourceVersion", newJString(resourceVersion))
  add(query_580114, "watch", newJBool(watch))
  add(query_580114, "key", newJString(key))
  add(query_580114, "$.xgafv", newJString(Xgafv))
  add(query_580114, "labelSelector", newJString(labelSelector))
  add(query_580114, "prettyPrint", newJBool(prettyPrint))
  add(query_580114, "fieldSelector", newJString(fieldSelector))
  add(query_580114, "limit", newJInt(limit))
  result = call_580112.call(path_580113, query_580114, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_580089(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_580090, base: "/",
    url: url_RunNamespacesDomainmappingsList_580091, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsReplaceConfiguration_580155 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesConfigurationsReplaceConfiguration_580157(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsReplaceConfiguration_580156(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580158 = path.getOrDefault("name")
  valid_580158 = validateParameter(valid_580158, JString, required = true,
                                 default = nil)
  if valid_580158 != nil:
    section.add "name", valid_580158
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
  var valid_580159 = query.getOrDefault("upload_protocol")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "upload_protocol", valid_580159
  var valid_580160 = query.getOrDefault("fields")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "fields", valid_580160
  var valid_580161 = query.getOrDefault("quotaUser")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "quotaUser", valid_580161
  var valid_580162 = query.getOrDefault("alt")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = newJString("json"))
  if valid_580162 != nil:
    section.add "alt", valid_580162
  var valid_580163 = query.getOrDefault("oauth_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "oauth_token", valid_580163
  var valid_580164 = query.getOrDefault("callback")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "callback", valid_580164
  var valid_580165 = query.getOrDefault("access_token")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "access_token", valid_580165
  var valid_580166 = query.getOrDefault("uploadType")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "uploadType", valid_580166
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("$.xgafv")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("1"))
  if valid_580168 != nil:
    section.add "$.xgafv", valid_580168
  var valid_580169 = query.getOrDefault("prettyPrint")
  valid_580169 = validateParameter(valid_580169, JBool, required = false,
                                 default = newJBool(true))
  if valid_580169 != nil:
    section.add "prettyPrint", valid_580169
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

proc call*(call_580171: Call_RunNamespacesConfigurationsReplaceConfiguration_580155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_580171.validator(path, query, header, formData, body)
  let scheme = call_580171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580171.url(scheme.get, call_580171.host, call_580171.base,
                         call_580171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580171, url, valid)

proc call*(call_580172: Call_RunNamespacesConfigurationsReplaceConfiguration_580155;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesConfigurationsReplaceConfiguration
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580173 = newJObject()
  var query_580174 = newJObject()
  var body_580175 = newJObject()
  add(query_580174, "upload_protocol", newJString(uploadProtocol))
  add(query_580174, "fields", newJString(fields))
  add(query_580174, "quotaUser", newJString(quotaUser))
  add(path_580173, "name", newJString(name))
  add(query_580174, "alt", newJString(alt))
  add(query_580174, "oauth_token", newJString(oauthToken))
  add(query_580174, "callback", newJString(callback))
  add(query_580174, "access_token", newJString(accessToken))
  add(query_580174, "uploadType", newJString(uploadType))
  add(query_580174, "key", newJString(key))
  add(query_580174, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580175 = body
  add(query_580174, "prettyPrint", newJBool(prettyPrint))
  result = call_580172.call(path_580173, query_580174, nil, nil, body_580175)

var runNamespacesConfigurationsReplaceConfiguration* = Call_RunNamespacesConfigurationsReplaceConfiguration_580155(
    name: "runNamespacesConfigurationsReplaceConfiguration",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsReplaceConfiguration_580156,
    base: "/", url: url_RunNamespacesConfigurationsReplaceConfiguration_580157,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsGet_580136 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesConfigurationsGet_580138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsGet_580137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580139 = path.getOrDefault("name")
  valid_580139 = validateParameter(valid_580139, JString, required = true,
                                 default = nil)
  if valid_580139 != nil:
    section.add "name", valid_580139
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
  var valid_580140 = query.getOrDefault("upload_protocol")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "upload_protocol", valid_580140
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("callback")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "callback", valid_580145
  var valid_580146 = query.getOrDefault("access_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "access_token", valid_580146
  var valid_580147 = query.getOrDefault("uploadType")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "uploadType", valid_580147
  var valid_580148 = query.getOrDefault("key")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "key", valid_580148
  var valid_580149 = query.getOrDefault("$.xgafv")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("1"))
  if valid_580149 != nil:
    section.add "$.xgafv", valid_580149
  var valid_580150 = query.getOrDefault("prettyPrint")
  valid_580150 = validateParameter(valid_580150, JBool, required = false,
                                 default = newJBool(true))
  if valid_580150 != nil:
    section.add "prettyPrint", valid_580150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580151: Call_RunNamespacesConfigurationsGet_580136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a configuration.
  ## 
  let valid = call_580151.validator(path, query, header, formData, body)
  let scheme = call_580151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580151.url(scheme.get, call_580151.host, call_580151.base,
                         call_580151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580151, url, valid)

proc call*(call_580152: Call_RunNamespacesConfigurationsGet_580136; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runNamespacesConfigurationsGet
  ## Get information about a configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580153 = newJObject()
  var query_580154 = newJObject()
  add(query_580154, "upload_protocol", newJString(uploadProtocol))
  add(query_580154, "fields", newJString(fields))
  add(query_580154, "quotaUser", newJString(quotaUser))
  add(path_580153, "name", newJString(name))
  add(query_580154, "alt", newJString(alt))
  add(query_580154, "oauth_token", newJString(oauthToken))
  add(query_580154, "callback", newJString(callback))
  add(query_580154, "access_token", newJString(accessToken))
  add(query_580154, "uploadType", newJString(uploadType))
  add(query_580154, "key", newJString(key))
  add(query_580154, "$.xgafv", newJString(Xgafv))
  add(query_580154, "prettyPrint", newJBool(prettyPrint))
  result = call_580152.call(path_580153, query_580154, nil, nil, nil)

var runNamespacesConfigurationsGet* = Call_RunNamespacesConfigurationsGet_580136(
    name: "runNamespacesConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsGet_580137, base: "/",
    url: url_RunNamespacesConfigurationsGet_580138, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsDelete_580176 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesConfigurationsDelete_580178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsDelete_580177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the configuration being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580179 = path.getOrDefault("name")
  valid_580179 = validateParameter(valid_580179, JString, required = true,
                                 default = nil)
  if valid_580179 != nil:
    section.add "name", valid_580179
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
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  section = newJObject()
  var valid_580180 = query.getOrDefault("upload_protocol")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "upload_protocol", valid_580180
  var valid_580181 = query.getOrDefault("fields")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "fields", valid_580181
  var valid_580182 = query.getOrDefault("quotaUser")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "quotaUser", valid_580182
  var valid_580183 = query.getOrDefault("alt")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("json"))
  if valid_580183 != nil:
    section.add "alt", valid_580183
  var valid_580184 = query.getOrDefault("oauth_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "oauth_token", valid_580184
  var valid_580185 = query.getOrDefault("callback")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "callback", valid_580185
  var valid_580186 = query.getOrDefault("access_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "access_token", valid_580186
  var valid_580187 = query.getOrDefault("uploadType")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "uploadType", valid_580187
  var valid_580188 = query.getOrDefault("kind")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "kind", valid_580188
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("$.xgafv")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = newJString("1"))
  if valid_580190 != nil:
    section.add "$.xgafv", valid_580190
  var valid_580191 = query.getOrDefault("prettyPrint")
  valid_580191 = validateParameter(valid_580191, JBool, required = false,
                                 default = newJBool(true))
  if valid_580191 != nil:
    section.add "prettyPrint", valid_580191
  var valid_580192 = query.getOrDefault("propagationPolicy")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "propagationPolicy", valid_580192
  var valid_580193 = query.getOrDefault("apiVersion")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "apiVersion", valid_580193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580194: Call_RunNamespacesConfigurationsDelete_580176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ## 
  let valid = call_580194.validator(path, query, header, formData, body)
  let scheme = call_580194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580194.url(scheme.get, call_580194.host, call_580194.base,
                         call_580194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580194, url, valid)

proc call*(call_580195: Call_RunNamespacesConfigurationsDelete_580176;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runNamespacesConfigurationsDelete
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the configuration being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_580196 = newJObject()
  var query_580197 = newJObject()
  add(query_580197, "upload_protocol", newJString(uploadProtocol))
  add(query_580197, "fields", newJString(fields))
  add(query_580197, "quotaUser", newJString(quotaUser))
  add(path_580196, "name", newJString(name))
  add(query_580197, "alt", newJString(alt))
  add(query_580197, "oauth_token", newJString(oauthToken))
  add(query_580197, "callback", newJString(callback))
  add(query_580197, "access_token", newJString(accessToken))
  add(query_580197, "uploadType", newJString(uploadType))
  add(query_580197, "kind", newJString(kind))
  add(query_580197, "key", newJString(key))
  add(query_580197, "$.xgafv", newJString(Xgafv))
  add(query_580197, "prettyPrint", newJBool(prettyPrint))
  add(query_580197, "propagationPolicy", newJString(propagationPolicy))
  add(query_580197, "apiVersion", newJString(apiVersion))
  result = call_580195.call(path_580196, query_580197, nil, nil, nil)

var runNamespacesConfigurationsDelete* = Call_RunNamespacesConfigurationsDelete_580176(
    name: "runNamespacesConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsDelete_580177, base: "/",
    url: url_RunNamespacesConfigurationsDelete_580178, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsCreate_580224 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesConfigurationsCreate_580226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsCreate_580225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this configuration should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580227 = path.getOrDefault("parent")
  valid_580227 = validateParameter(valid_580227, JString, required = true,
                                 default = nil)
  if valid_580227 != nil:
    section.add "parent", valid_580227
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
  var valid_580228 = query.getOrDefault("upload_protocol")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "upload_protocol", valid_580228
  var valid_580229 = query.getOrDefault("fields")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "fields", valid_580229
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
  var valid_580238 = query.getOrDefault("prettyPrint")
  valid_580238 = validateParameter(valid_580238, JBool, required = false,
                                 default = newJBool(true))
  if valid_580238 != nil:
    section.add "prettyPrint", valid_580238
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

proc call*(call_580240: Call_RunNamespacesConfigurationsCreate_580224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_580240.validator(path, query, header, formData, body)
  let scheme = call_580240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580240.url(scheme.get, call_580240.host, call_580240.base,
                         call_580240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580240, url, valid)

proc call*(call_580241: Call_RunNamespacesConfigurationsCreate_580224;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesConfigurationsCreate
  ## Create a configuration.
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
  ##         : The project ID or project number in which this configuration should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580242 = newJObject()
  var query_580243 = newJObject()
  var body_580244 = newJObject()
  add(query_580243, "upload_protocol", newJString(uploadProtocol))
  add(query_580243, "fields", newJString(fields))
  add(query_580243, "quotaUser", newJString(quotaUser))
  add(query_580243, "alt", newJString(alt))
  add(query_580243, "oauth_token", newJString(oauthToken))
  add(query_580243, "callback", newJString(callback))
  add(query_580243, "access_token", newJString(accessToken))
  add(query_580243, "uploadType", newJString(uploadType))
  add(path_580242, "parent", newJString(parent))
  add(query_580243, "key", newJString(key))
  add(query_580243, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580244 = body
  add(query_580243, "prettyPrint", newJBool(prettyPrint))
  result = call_580241.call(path_580242, query_580243, nil, nil, body_580244)

var runNamespacesConfigurationsCreate* = Call_RunNamespacesConfigurationsCreate_580224(
    name: "runNamespacesConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsCreate_580225, base: "/",
    url: url_RunNamespacesConfigurationsCreate_580226, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_580198 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesConfigurationsList_580200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsList_580199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580201 = path.getOrDefault("parent")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "parent", valid_580201
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580202 = query.getOrDefault("upload_protocol")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "upload_protocol", valid_580202
  var valid_580203 = query.getOrDefault("fields")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "fields", valid_580203
  var valid_580204 = query.getOrDefault("quotaUser")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "quotaUser", valid_580204
  var valid_580205 = query.getOrDefault("includeUninitialized")
  valid_580205 = validateParameter(valid_580205, JBool, required = false, default = nil)
  if valid_580205 != nil:
    section.add "includeUninitialized", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("continue")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "continue", valid_580207
  var valid_580208 = query.getOrDefault("oauth_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "oauth_token", valid_580208
  var valid_580209 = query.getOrDefault("callback")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "callback", valid_580209
  var valid_580210 = query.getOrDefault("access_token")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "access_token", valid_580210
  var valid_580211 = query.getOrDefault("uploadType")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "uploadType", valid_580211
  var valid_580212 = query.getOrDefault("resourceVersion")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "resourceVersion", valid_580212
  var valid_580213 = query.getOrDefault("watch")
  valid_580213 = validateParameter(valid_580213, JBool, required = false, default = nil)
  if valid_580213 != nil:
    section.add "watch", valid_580213
  var valid_580214 = query.getOrDefault("key")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "key", valid_580214
  var valid_580215 = query.getOrDefault("$.xgafv")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = newJString("1"))
  if valid_580215 != nil:
    section.add "$.xgafv", valid_580215
  var valid_580216 = query.getOrDefault("labelSelector")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "labelSelector", valid_580216
  var valid_580217 = query.getOrDefault("prettyPrint")
  valid_580217 = validateParameter(valid_580217, JBool, required = false,
                                 default = newJBool(true))
  if valid_580217 != nil:
    section.add "prettyPrint", valid_580217
  var valid_580218 = query.getOrDefault("fieldSelector")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "fieldSelector", valid_580218
  var valid_580219 = query.getOrDefault("limit")
  valid_580219 = validateParameter(valid_580219, JInt, required = false, default = nil)
  if valid_580219 != nil:
    section.add "limit", valid_580219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580220: Call_RunNamespacesConfigurationsList_580198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_580220.validator(path, query, header, formData, body)
  let scheme = call_580220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580220.url(scheme.get, call_580220.host, call_580220.base,
                         call_580220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580220, url, valid)

proc call*(call_580221: Call_RunNamespacesConfigurationsList_580198;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesConfigurationsList
  ## List configurations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580222 = newJObject()
  var query_580223 = newJObject()
  add(query_580223, "upload_protocol", newJString(uploadProtocol))
  add(query_580223, "fields", newJString(fields))
  add(query_580223, "quotaUser", newJString(quotaUser))
  add(query_580223, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580223, "alt", newJString(alt))
  add(query_580223, "continue", newJString(`continue`))
  add(query_580223, "oauth_token", newJString(oauthToken))
  add(query_580223, "callback", newJString(callback))
  add(query_580223, "access_token", newJString(accessToken))
  add(query_580223, "uploadType", newJString(uploadType))
  add(path_580222, "parent", newJString(parent))
  add(query_580223, "resourceVersion", newJString(resourceVersion))
  add(query_580223, "watch", newJBool(watch))
  add(query_580223, "key", newJString(key))
  add(query_580223, "$.xgafv", newJString(Xgafv))
  add(query_580223, "labelSelector", newJString(labelSelector))
  add(query_580223, "prettyPrint", newJBool(prettyPrint))
  add(query_580223, "fieldSelector", newJString(fieldSelector))
  add(query_580223, "limit", newJInt(limit))
  result = call_580221.call(path_580222, query_580223, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_580198(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_580199, base: "/",
    url: url_RunNamespacesConfigurationsList_580200, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_580245 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesRevisionsList_580247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesRevisionsList_580246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the revisions should be listed.
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
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
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
  var valid_580252 = query.getOrDefault("includeUninitialized")
  valid_580252 = validateParameter(valid_580252, JBool, required = false, default = nil)
  if valid_580252 != nil:
    section.add "includeUninitialized", valid_580252
  var valid_580253 = query.getOrDefault("alt")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("json"))
  if valid_580253 != nil:
    section.add "alt", valid_580253
  var valid_580254 = query.getOrDefault("continue")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "continue", valid_580254
  var valid_580255 = query.getOrDefault("oauth_token")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "oauth_token", valid_580255
  var valid_580256 = query.getOrDefault("callback")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "callback", valid_580256
  var valid_580257 = query.getOrDefault("access_token")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "access_token", valid_580257
  var valid_580258 = query.getOrDefault("uploadType")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "uploadType", valid_580258
  var valid_580259 = query.getOrDefault("resourceVersion")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "resourceVersion", valid_580259
  var valid_580260 = query.getOrDefault("watch")
  valid_580260 = validateParameter(valid_580260, JBool, required = false, default = nil)
  if valid_580260 != nil:
    section.add "watch", valid_580260
  var valid_580261 = query.getOrDefault("key")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "key", valid_580261
  var valid_580262 = query.getOrDefault("$.xgafv")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = newJString("1"))
  if valid_580262 != nil:
    section.add "$.xgafv", valid_580262
  var valid_580263 = query.getOrDefault("labelSelector")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "labelSelector", valid_580263
  var valid_580264 = query.getOrDefault("prettyPrint")
  valid_580264 = validateParameter(valid_580264, JBool, required = false,
                                 default = newJBool(true))
  if valid_580264 != nil:
    section.add "prettyPrint", valid_580264
  var valid_580265 = query.getOrDefault("fieldSelector")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "fieldSelector", valid_580265
  var valid_580266 = query.getOrDefault("limit")
  valid_580266 = validateParameter(valid_580266, JInt, required = false, default = nil)
  if valid_580266 != nil:
    section.add "limit", valid_580266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580267: Call_RunNamespacesRevisionsList_580245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_580267.validator(path, query, header, formData, body)
  let scheme = call_580267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580267.url(scheme.get, call_580267.host, call_580267.base,
                         call_580267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580267, url, valid)

proc call*(call_580268: Call_RunNamespacesRevisionsList_580245; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesRevisionsList
  ## List revisions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the revisions should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580269 = newJObject()
  var query_580270 = newJObject()
  add(query_580270, "upload_protocol", newJString(uploadProtocol))
  add(query_580270, "fields", newJString(fields))
  add(query_580270, "quotaUser", newJString(quotaUser))
  add(query_580270, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580270, "alt", newJString(alt))
  add(query_580270, "continue", newJString(`continue`))
  add(query_580270, "oauth_token", newJString(oauthToken))
  add(query_580270, "callback", newJString(callback))
  add(query_580270, "access_token", newJString(accessToken))
  add(query_580270, "uploadType", newJString(uploadType))
  add(path_580269, "parent", newJString(parent))
  add(query_580270, "resourceVersion", newJString(resourceVersion))
  add(query_580270, "watch", newJBool(watch))
  add(query_580270, "key", newJString(key))
  add(query_580270, "$.xgafv", newJString(Xgafv))
  add(query_580270, "labelSelector", newJString(labelSelector))
  add(query_580270, "prettyPrint", newJBool(prettyPrint))
  add(query_580270, "fieldSelector", newJString(fieldSelector))
  add(query_580270, "limit", newJInt(limit))
  result = call_580268.call(path_580269, query_580270, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_580245(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_580246, base: "/",
    url: url_RunNamespacesRevisionsList_580247, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesCreate_580297 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesRoutesCreate_580299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesRoutesCreate_580298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a route.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this route should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580300 = path.getOrDefault("parent")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "parent", valid_580300
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
  var valid_580301 = query.getOrDefault("upload_protocol")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "upload_protocol", valid_580301
  var valid_580302 = query.getOrDefault("fields")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "fields", valid_580302
  var valid_580303 = query.getOrDefault("quotaUser")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "quotaUser", valid_580303
  var valid_580304 = query.getOrDefault("alt")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("json"))
  if valid_580304 != nil:
    section.add "alt", valid_580304
  var valid_580305 = query.getOrDefault("oauth_token")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "oauth_token", valid_580305
  var valid_580306 = query.getOrDefault("callback")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "callback", valid_580306
  var valid_580307 = query.getOrDefault("access_token")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "access_token", valid_580307
  var valid_580308 = query.getOrDefault("uploadType")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "uploadType", valid_580308
  var valid_580309 = query.getOrDefault("key")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "key", valid_580309
  var valid_580310 = query.getOrDefault("$.xgafv")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("1"))
  if valid_580310 != nil:
    section.add "$.xgafv", valid_580310
  var valid_580311 = query.getOrDefault("prettyPrint")
  valid_580311 = validateParameter(valid_580311, JBool, required = false,
                                 default = newJBool(true))
  if valid_580311 != nil:
    section.add "prettyPrint", valid_580311
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

proc call*(call_580313: Call_RunNamespacesRoutesCreate_580297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_580313.validator(path, query, header, formData, body)
  let scheme = call_580313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580313.url(scheme.get, call_580313.host, call_580313.base,
                         call_580313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580313, url, valid)

proc call*(call_580314: Call_RunNamespacesRoutesCreate_580297; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runNamespacesRoutesCreate
  ## Create a route.
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
  ##         : The project ID or project number in which this route should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580315 = newJObject()
  var query_580316 = newJObject()
  var body_580317 = newJObject()
  add(query_580316, "upload_protocol", newJString(uploadProtocol))
  add(query_580316, "fields", newJString(fields))
  add(query_580316, "quotaUser", newJString(quotaUser))
  add(query_580316, "alt", newJString(alt))
  add(query_580316, "oauth_token", newJString(oauthToken))
  add(query_580316, "callback", newJString(callback))
  add(query_580316, "access_token", newJString(accessToken))
  add(query_580316, "uploadType", newJString(uploadType))
  add(path_580315, "parent", newJString(parent))
  add(query_580316, "key", newJString(key))
  add(query_580316, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580317 = body
  add(query_580316, "prettyPrint", newJBool(prettyPrint))
  result = call_580314.call(path_580315, query_580316, nil, nil, body_580317)

var runNamespacesRoutesCreate* = Call_RunNamespacesRoutesCreate_580297(
    name: "runNamespacesRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesCreate_580298, base: "/",
    url: url_RunNamespacesRoutesCreate_580299, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_580271 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesRoutesList_580273(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesRoutesList_580272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the routes should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580274 = path.getOrDefault("parent")
  valid_580274 = validateParameter(valid_580274, JString, required = true,
                                 default = nil)
  if valid_580274 != nil:
    section.add "parent", valid_580274
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580275 = query.getOrDefault("upload_protocol")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "upload_protocol", valid_580275
  var valid_580276 = query.getOrDefault("fields")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "fields", valid_580276
  var valid_580277 = query.getOrDefault("quotaUser")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "quotaUser", valid_580277
  var valid_580278 = query.getOrDefault("includeUninitialized")
  valid_580278 = validateParameter(valid_580278, JBool, required = false, default = nil)
  if valid_580278 != nil:
    section.add "includeUninitialized", valid_580278
  var valid_580279 = query.getOrDefault("alt")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = newJString("json"))
  if valid_580279 != nil:
    section.add "alt", valid_580279
  var valid_580280 = query.getOrDefault("continue")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "continue", valid_580280
  var valid_580281 = query.getOrDefault("oauth_token")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "oauth_token", valid_580281
  var valid_580282 = query.getOrDefault("callback")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "callback", valid_580282
  var valid_580283 = query.getOrDefault("access_token")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "access_token", valid_580283
  var valid_580284 = query.getOrDefault("uploadType")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "uploadType", valid_580284
  var valid_580285 = query.getOrDefault("resourceVersion")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "resourceVersion", valid_580285
  var valid_580286 = query.getOrDefault("watch")
  valid_580286 = validateParameter(valid_580286, JBool, required = false, default = nil)
  if valid_580286 != nil:
    section.add "watch", valid_580286
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("$.xgafv")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("1"))
  if valid_580288 != nil:
    section.add "$.xgafv", valid_580288
  var valid_580289 = query.getOrDefault("labelSelector")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "labelSelector", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
  var valid_580291 = query.getOrDefault("fieldSelector")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "fieldSelector", valid_580291
  var valid_580292 = query.getOrDefault("limit")
  valid_580292 = validateParameter(valid_580292, JInt, required = false, default = nil)
  if valid_580292 != nil:
    section.add "limit", valid_580292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580293: Call_RunNamespacesRoutesList_580271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_580293.validator(path, query, header, formData, body)
  let scheme = call_580293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580293.url(scheme.get, call_580293.host, call_580293.base,
                         call_580293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580293, url, valid)

proc call*(call_580294: Call_RunNamespacesRoutesList_580271; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesRoutesList
  ## List routes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the routes should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580295 = newJObject()
  var query_580296 = newJObject()
  add(query_580296, "upload_protocol", newJString(uploadProtocol))
  add(query_580296, "fields", newJString(fields))
  add(query_580296, "quotaUser", newJString(quotaUser))
  add(query_580296, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580296, "alt", newJString(alt))
  add(query_580296, "continue", newJString(`continue`))
  add(query_580296, "oauth_token", newJString(oauthToken))
  add(query_580296, "callback", newJString(callback))
  add(query_580296, "access_token", newJString(accessToken))
  add(query_580296, "uploadType", newJString(uploadType))
  add(path_580295, "parent", newJString(parent))
  add(query_580296, "resourceVersion", newJString(resourceVersion))
  add(query_580296, "watch", newJBool(watch))
  add(query_580296, "key", newJString(key))
  add(query_580296, "$.xgafv", newJString(Xgafv))
  add(query_580296, "labelSelector", newJString(labelSelector))
  add(query_580296, "prettyPrint", newJBool(prettyPrint))
  add(query_580296, "fieldSelector", newJString(fieldSelector))
  add(query_580296, "limit", newJInt(limit))
  result = call_580294.call(path_580295, query_580296, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_580271(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_580272, base: "/",
    url: url_RunNamespacesRoutesList_580273, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_580344 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesServicesCreate_580346(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesCreate_580345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this service should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580347 = path.getOrDefault("parent")
  valid_580347 = validateParameter(valid_580347, JString, required = true,
                                 default = nil)
  if valid_580347 != nil:
    section.add "parent", valid_580347
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
  var valid_580348 = query.getOrDefault("upload_protocol")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "upload_protocol", valid_580348
  var valid_580349 = query.getOrDefault("fields")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "fields", valid_580349
  var valid_580350 = query.getOrDefault("quotaUser")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "quotaUser", valid_580350
  var valid_580351 = query.getOrDefault("alt")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = newJString("json"))
  if valid_580351 != nil:
    section.add "alt", valid_580351
  var valid_580352 = query.getOrDefault("oauth_token")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "oauth_token", valid_580352
  var valid_580353 = query.getOrDefault("callback")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "callback", valid_580353
  var valid_580354 = query.getOrDefault("access_token")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "access_token", valid_580354
  var valid_580355 = query.getOrDefault("uploadType")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "uploadType", valid_580355
  var valid_580356 = query.getOrDefault("key")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "key", valid_580356
  var valid_580357 = query.getOrDefault("$.xgafv")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = newJString("1"))
  if valid_580357 != nil:
    section.add "$.xgafv", valid_580357
  var valid_580358 = query.getOrDefault("prettyPrint")
  valid_580358 = validateParameter(valid_580358, JBool, required = false,
                                 default = newJBool(true))
  if valid_580358 != nil:
    section.add "prettyPrint", valid_580358
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

proc call*(call_580360: Call_RunNamespacesServicesCreate_580344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_580360.validator(path, query, header, formData, body)
  let scheme = call_580360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580360.url(scheme.get, call_580360.host, call_580360.base,
                         call_580360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580360, url, valid)

proc call*(call_580361: Call_RunNamespacesServicesCreate_580344; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runNamespacesServicesCreate
  ## Create a service.
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
  ##         : The project ID or project number in which this service should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580362 = newJObject()
  var query_580363 = newJObject()
  var body_580364 = newJObject()
  add(query_580363, "upload_protocol", newJString(uploadProtocol))
  add(query_580363, "fields", newJString(fields))
  add(query_580363, "quotaUser", newJString(quotaUser))
  add(query_580363, "alt", newJString(alt))
  add(query_580363, "oauth_token", newJString(oauthToken))
  add(query_580363, "callback", newJString(callback))
  add(query_580363, "access_token", newJString(accessToken))
  add(query_580363, "uploadType", newJString(uploadType))
  add(path_580362, "parent", newJString(parent))
  add(query_580363, "key", newJString(key))
  add(query_580363, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580364 = body
  add(query_580363, "prettyPrint", newJBool(prettyPrint))
  result = call_580361.call(path_580362, query_580363, nil, nil, body_580364)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_580344(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_580345, base: "/",
    url: url_RunNamespacesServicesCreate_580346, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_580318 = ref object of OpenApiRestCall_579421
proc url_RunNamespacesServicesList_580320(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/apis/serving.knative.dev/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesList_580319(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the services should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580321 = path.getOrDefault("parent")
  valid_580321 = validateParameter(valid_580321, JString, required = true,
                                 default = nil)
  if valid_580321 != nil:
    section.add "parent", valid_580321
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580322 = query.getOrDefault("upload_protocol")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "upload_protocol", valid_580322
  var valid_580323 = query.getOrDefault("fields")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "fields", valid_580323
  var valid_580324 = query.getOrDefault("quotaUser")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "quotaUser", valid_580324
  var valid_580325 = query.getOrDefault("includeUninitialized")
  valid_580325 = validateParameter(valid_580325, JBool, required = false, default = nil)
  if valid_580325 != nil:
    section.add "includeUninitialized", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("continue")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "continue", valid_580327
  var valid_580328 = query.getOrDefault("oauth_token")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "oauth_token", valid_580328
  var valid_580329 = query.getOrDefault("callback")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "callback", valid_580329
  var valid_580330 = query.getOrDefault("access_token")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "access_token", valid_580330
  var valid_580331 = query.getOrDefault("uploadType")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "uploadType", valid_580331
  var valid_580332 = query.getOrDefault("resourceVersion")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "resourceVersion", valid_580332
  var valid_580333 = query.getOrDefault("watch")
  valid_580333 = validateParameter(valid_580333, JBool, required = false, default = nil)
  if valid_580333 != nil:
    section.add "watch", valid_580333
  var valid_580334 = query.getOrDefault("key")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "key", valid_580334
  var valid_580335 = query.getOrDefault("$.xgafv")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("1"))
  if valid_580335 != nil:
    section.add "$.xgafv", valid_580335
  var valid_580336 = query.getOrDefault("labelSelector")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "labelSelector", valid_580336
  var valid_580337 = query.getOrDefault("prettyPrint")
  valid_580337 = validateParameter(valid_580337, JBool, required = false,
                                 default = newJBool(true))
  if valid_580337 != nil:
    section.add "prettyPrint", valid_580337
  var valid_580338 = query.getOrDefault("fieldSelector")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fieldSelector", valid_580338
  var valid_580339 = query.getOrDefault("limit")
  valid_580339 = validateParameter(valid_580339, JInt, required = false, default = nil)
  if valid_580339 != nil:
    section.add "limit", valid_580339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580340: Call_RunNamespacesServicesList_580318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_580340.validator(path, query, header, formData, body)
  let scheme = call_580340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580340.url(scheme.get, call_580340.host, call_580340.base,
                         call_580340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580340, url, valid)

proc call*(call_580341: Call_RunNamespacesServicesList_580318; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesServicesList
  ## List services.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the services should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580342 = newJObject()
  var query_580343 = newJObject()
  add(query_580343, "upload_protocol", newJString(uploadProtocol))
  add(query_580343, "fields", newJString(fields))
  add(query_580343, "quotaUser", newJString(quotaUser))
  add(query_580343, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580343, "alt", newJString(alt))
  add(query_580343, "continue", newJString(`continue`))
  add(query_580343, "oauth_token", newJString(oauthToken))
  add(query_580343, "callback", newJString(callback))
  add(query_580343, "access_token", newJString(accessToken))
  add(query_580343, "uploadType", newJString(uploadType))
  add(path_580342, "parent", newJString(parent))
  add(query_580343, "resourceVersion", newJString(resourceVersion))
  add(query_580343, "watch", newJBool(watch))
  add(query_580343, "key", newJString(key))
  add(query_580343, "$.xgafv", newJString(Xgafv))
  add(query_580343, "labelSelector", newJString(labelSelector))
  add(query_580343, "prettyPrint", newJBool(prettyPrint))
  add(query_580343, "fieldSelector", newJString(fieldSelector))
  add(query_580343, "limit", newJInt(limit))
  result = call_580341.call(path_580342, query_580343, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_580318(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesList_580319, base: "/",
    url: url_RunNamespacesServicesList_580320, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580384 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580386(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580385(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580387 = path.getOrDefault("name")
  valid_580387 = validateParameter(valid_580387, JString, required = true,
                                 default = nil)
  if valid_580387 != nil:
    section.add "name", valid_580387
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
  var valid_580388 = query.getOrDefault("upload_protocol")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "upload_protocol", valid_580388
  var valid_580389 = query.getOrDefault("fields")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "fields", valid_580389
  var valid_580390 = query.getOrDefault("quotaUser")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "quotaUser", valid_580390
  var valid_580391 = query.getOrDefault("alt")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = newJString("json"))
  if valid_580391 != nil:
    section.add "alt", valid_580391
  var valid_580392 = query.getOrDefault("oauth_token")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "oauth_token", valid_580392
  var valid_580393 = query.getOrDefault("callback")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "callback", valid_580393
  var valid_580394 = query.getOrDefault("access_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "access_token", valid_580394
  var valid_580395 = query.getOrDefault("uploadType")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "uploadType", valid_580395
  var valid_580396 = query.getOrDefault("key")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "key", valid_580396
  var valid_580397 = query.getOrDefault("$.xgafv")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = newJString("1"))
  if valid_580397 != nil:
    section.add "$.xgafv", valid_580397
  var valid_580398 = query.getOrDefault("prettyPrint")
  valid_580398 = validateParameter(valid_580398, JBool, required = false,
                                 default = newJBool(true))
  if valid_580398 != nil:
    section.add "prettyPrint", valid_580398
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

proc call*(call_580400: Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_580400.validator(path, query, header, formData, body)
  let scheme = call_580400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580400.url(scheme.get, call_580400.host, call_580400.base,
                         call_580400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580400, url, valid)

proc call*(call_580401: Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580384;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsReplaceDomainMapping
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580402 = newJObject()
  var query_580403 = newJObject()
  var body_580404 = newJObject()
  add(query_580403, "upload_protocol", newJString(uploadProtocol))
  add(query_580403, "fields", newJString(fields))
  add(query_580403, "quotaUser", newJString(quotaUser))
  add(path_580402, "name", newJString(name))
  add(query_580403, "alt", newJString(alt))
  add(query_580403, "oauth_token", newJString(oauthToken))
  add(query_580403, "callback", newJString(callback))
  add(query_580403, "access_token", newJString(accessToken))
  add(query_580403, "uploadType", newJString(uploadType))
  add(query_580403, "key", newJString(key))
  add(query_580403, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580404 = body
  add(query_580403, "prettyPrint", newJBool(prettyPrint))
  result = call_580401.call(path_580402, query_580403, nil, nil, body_580404)

var runProjectsLocationsDomainmappingsReplaceDomainMapping* = Call_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580384(
    name: "runProjectsLocationsDomainmappingsReplaceDomainMapping",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580385,
    base: "/", url: url_RunProjectsLocationsDomainmappingsReplaceDomainMapping_580386,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsGet_580365 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsDomainmappingsGet_580367(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsGet_580366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580368 = path.getOrDefault("name")
  valid_580368 = validateParameter(valid_580368, JString, required = true,
                                 default = nil)
  if valid_580368 != nil:
    section.add "name", valid_580368
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
  var valid_580369 = query.getOrDefault("upload_protocol")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "upload_protocol", valid_580369
  var valid_580370 = query.getOrDefault("fields")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "fields", valid_580370
  var valid_580371 = query.getOrDefault("quotaUser")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "quotaUser", valid_580371
  var valid_580372 = query.getOrDefault("alt")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = newJString("json"))
  if valid_580372 != nil:
    section.add "alt", valid_580372
  var valid_580373 = query.getOrDefault("oauth_token")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "oauth_token", valid_580373
  var valid_580374 = query.getOrDefault("callback")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "callback", valid_580374
  var valid_580375 = query.getOrDefault("access_token")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "access_token", valid_580375
  var valid_580376 = query.getOrDefault("uploadType")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "uploadType", valid_580376
  var valid_580377 = query.getOrDefault("key")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "key", valid_580377
  var valid_580378 = query.getOrDefault("$.xgafv")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = newJString("1"))
  if valid_580378 != nil:
    section.add "$.xgafv", valid_580378
  var valid_580379 = query.getOrDefault("prettyPrint")
  valid_580379 = validateParameter(valid_580379, JBool, required = false,
                                 default = newJBool(true))
  if valid_580379 != nil:
    section.add "prettyPrint", valid_580379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580380: Call_RunProjectsLocationsDomainmappingsGet_580365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a domain mapping.
  ## 
  let valid = call_580380.validator(path, query, header, formData, body)
  let scheme = call_580380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580380.url(scheme.get, call_580380.host, call_580380.base,
                         call_580380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580380, url, valid)

proc call*(call_580381: Call_RunProjectsLocationsDomainmappingsGet_580365;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsGet
  ## Get information about a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
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
  var path_580382 = newJObject()
  var query_580383 = newJObject()
  add(query_580383, "upload_protocol", newJString(uploadProtocol))
  add(query_580383, "fields", newJString(fields))
  add(query_580383, "quotaUser", newJString(quotaUser))
  add(path_580382, "name", newJString(name))
  add(query_580383, "alt", newJString(alt))
  add(query_580383, "oauth_token", newJString(oauthToken))
  add(query_580383, "callback", newJString(callback))
  add(query_580383, "access_token", newJString(accessToken))
  add(query_580383, "uploadType", newJString(uploadType))
  add(query_580383, "key", newJString(key))
  add(query_580383, "$.xgafv", newJString(Xgafv))
  add(query_580383, "prettyPrint", newJBool(prettyPrint))
  result = call_580381.call(path_580382, query_580383, nil, nil, nil)

var runProjectsLocationsDomainmappingsGet* = Call_RunProjectsLocationsDomainmappingsGet_580365(
    name: "runProjectsLocationsDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsGet_580366, base: "/",
    url: url_RunProjectsLocationsDomainmappingsGet_580367, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsDelete_580405 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsDomainmappingsDelete_580407(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsDelete_580406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580408 = path.getOrDefault("name")
  valid_580408 = validateParameter(valid_580408, JString, required = true,
                                 default = nil)
  if valid_580408 != nil:
    section.add "name", valid_580408
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
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  section = newJObject()
  var valid_580409 = query.getOrDefault("upload_protocol")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "upload_protocol", valid_580409
  var valid_580410 = query.getOrDefault("fields")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "fields", valid_580410
  var valid_580411 = query.getOrDefault("quotaUser")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "quotaUser", valid_580411
  var valid_580412 = query.getOrDefault("alt")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = newJString("json"))
  if valid_580412 != nil:
    section.add "alt", valid_580412
  var valid_580413 = query.getOrDefault("oauth_token")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "oauth_token", valid_580413
  var valid_580414 = query.getOrDefault("callback")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "callback", valid_580414
  var valid_580415 = query.getOrDefault("access_token")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "access_token", valid_580415
  var valid_580416 = query.getOrDefault("uploadType")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "uploadType", valid_580416
  var valid_580417 = query.getOrDefault("kind")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "kind", valid_580417
  var valid_580418 = query.getOrDefault("key")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "key", valid_580418
  var valid_580419 = query.getOrDefault("$.xgafv")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = newJString("1"))
  if valid_580419 != nil:
    section.add "$.xgafv", valid_580419
  var valid_580420 = query.getOrDefault("prettyPrint")
  valid_580420 = validateParameter(valid_580420, JBool, required = false,
                                 default = newJBool(true))
  if valid_580420 != nil:
    section.add "prettyPrint", valid_580420
  var valid_580421 = query.getOrDefault("propagationPolicy")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "propagationPolicy", valid_580421
  var valid_580422 = query.getOrDefault("apiVersion")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "apiVersion", valid_580422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580423: Call_RunProjectsLocationsDomainmappingsDelete_580405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a domain mapping.
  ## 
  let valid = call_580423.validator(path, query, header, formData, body)
  let scheme = call_580423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580423.url(scheme.get, call_580423.host, call_580423.base,
                         call_580423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580423, url, valid)

proc call*(call_580424: Call_RunProjectsLocationsDomainmappingsDelete_580405;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsDelete
  ## Delete a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
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
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  var path_580425 = newJObject()
  var query_580426 = newJObject()
  add(query_580426, "upload_protocol", newJString(uploadProtocol))
  add(query_580426, "fields", newJString(fields))
  add(query_580426, "quotaUser", newJString(quotaUser))
  add(path_580425, "name", newJString(name))
  add(query_580426, "alt", newJString(alt))
  add(query_580426, "oauth_token", newJString(oauthToken))
  add(query_580426, "callback", newJString(callback))
  add(query_580426, "access_token", newJString(accessToken))
  add(query_580426, "uploadType", newJString(uploadType))
  add(query_580426, "kind", newJString(kind))
  add(query_580426, "key", newJString(key))
  add(query_580426, "$.xgafv", newJString(Xgafv))
  add(query_580426, "prettyPrint", newJBool(prettyPrint))
  add(query_580426, "propagationPolicy", newJString(propagationPolicy))
  add(query_580426, "apiVersion", newJString(apiVersion))
  result = call_580424.call(path_580425, query_580426, nil, nil, nil)

var runProjectsLocationsDomainmappingsDelete* = Call_RunProjectsLocationsDomainmappingsDelete_580405(
    name: "runProjectsLocationsDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsDelete_580406,
    base: "/", url: url_RunProjectsLocationsDomainmappingsDelete_580407,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_580427 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsList_580429(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_RunProjectsLocationsList_580428(path: JsonNode; query: JsonNode;
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
  var valid_580430 = path.getOrDefault("name")
  valid_580430 = validateParameter(valid_580430, JString, required = true,
                                 default = nil)
  if valid_580430 != nil:
    section.add "name", valid_580430
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
  var valid_580431 = query.getOrDefault("upload_protocol")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "upload_protocol", valid_580431
  var valid_580432 = query.getOrDefault("fields")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "fields", valid_580432
  var valid_580433 = query.getOrDefault("pageToken")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "pageToken", valid_580433
  var valid_580434 = query.getOrDefault("quotaUser")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "quotaUser", valid_580434
  var valid_580435 = query.getOrDefault("alt")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = newJString("json"))
  if valid_580435 != nil:
    section.add "alt", valid_580435
  var valid_580436 = query.getOrDefault("oauth_token")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "oauth_token", valid_580436
  var valid_580437 = query.getOrDefault("callback")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "callback", valid_580437
  var valid_580438 = query.getOrDefault("access_token")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "access_token", valid_580438
  var valid_580439 = query.getOrDefault("uploadType")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "uploadType", valid_580439
  var valid_580440 = query.getOrDefault("key")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "key", valid_580440
  var valid_580441 = query.getOrDefault("$.xgafv")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = newJString("1"))
  if valid_580441 != nil:
    section.add "$.xgafv", valid_580441
  var valid_580442 = query.getOrDefault("pageSize")
  valid_580442 = validateParameter(valid_580442, JInt, required = false, default = nil)
  if valid_580442 != nil:
    section.add "pageSize", valid_580442
  var valid_580443 = query.getOrDefault("prettyPrint")
  valid_580443 = validateParameter(valid_580443, JBool, required = false,
                                 default = newJBool(true))
  if valid_580443 != nil:
    section.add "prettyPrint", valid_580443
  var valid_580444 = query.getOrDefault("filter")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "filter", valid_580444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580445: Call_RunProjectsLocationsList_580427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580445.validator(path, query, header, formData, body)
  let scheme = call_580445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580445.url(scheme.get, call_580445.host, call_580445.base,
                         call_580445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580445, url, valid)

proc call*(call_580446: Call_RunProjectsLocationsList_580427; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## runProjectsLocationsList
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
  var path_580447 = newJObject()
  var query_580448 = newJObject()
  add(query_580448, "upload_protocol", newJString(uploadProtocol))
  add(query_580448, "fields", newJString(fields))
  add(query_580448, "pageToken", newJString(pageToken))
  add(query_580448, "quotaUser", newJString(quotaUser))
  add(path_580447, "name", newJString(name))
  add(query_580448, "alt", newJString(alt))
  add(query_580448, "oauth_token", newJString(oauthToken))
  add(query_580448, "callback", newJString(callback))
  add(query_580448, "access_token", newJString(accessToken))
  add(query_580448, "uploadType", newJString(uploadType))
  add(query_580448, "key", newJString(key))
  add(query_580448, "$.xgafv", newJString(Xgafv))
  add(query_580448, "pageSize", newJInt(pageSize))
  add(query_580448, "prettyPrint", newJBool(prettyPrint))
  add(query_580448, "filter", newJString(filter))
  result = call_580446.call(path_580447, query_580448, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_580427(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_RunProjectsLocationsList_580428, base: "/",
    url: url_RunProjectsLocationsList_580429, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_580449 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsAuthorizeddomainsList_580451(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/authorizeddomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsAuthorizeddomainsList_580450(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580452 = path.getOrDefault("parent")
  valid_580452 = validateParameter(valid_580452, JString, required = true,
                                 default = nil)
  if valid_580452 != nil:
    section.add "parent", valid_580452
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
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
  ##           : Maximum results to return per page.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580453 = query.getOrDefault("upload_protocol")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "upload_protocol", valid_580453
  var valid_580454 = query.getOrDefault("fields")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "fields", valid_580454
  var valid_580455 = query.getOrDefault("pageToken")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "pageToken", valid_580455
  var valid_580456 = query.getOrDefault("quotaUser")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "quotaUser", valid_580456
  var valid_580457 = query.getOrDefault("alt")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = newJString("json"))
  if valid_580457 != nil:
    section.add "alt", valid_580457
  var valid_580458 = query.getOrDefault("oauth_token")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "oauth_token", valid_580458
  var valid_580459 = query.getOrDefault("callback")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "callback", valid_580459
  var valid_580460 = query.getOrDefault("access_token")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "access_token", valid_580460
  var valid_580461 = query.getOrDefault("uploadType")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "uploadType", valid_580461
  var valid_580462 = query.getOrDefault("key")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "key", valid_580462
  var valid_580463 = query.getOrDefault("$.xgafv")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = newJString("1"))
  if valid_580463 != nil:
    section.add "$.xgafv", valid_580463
  var valid_580464 = query.getOrDefault("pageSize")
  valid_580464 = validateParameter(valid_580464, JInt, required = false, default = nil)
  if valid_580464 != nil:
    section.add "pageSize", valid_580464
  var valid_580465 = query.getOrDefault("prettyPrint")
  valid_580465 = validateParameter(valid_580465, JBool, required = false,
                                 default = newJBool(true))
  if valid_580465 != nil:
    section.add "prettyPrint", valid_580465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580466: Call_RunProjectsLocationsAuthorizeddomainsList_580449;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_580466.validator(path, query, header, formData, body)
  let scheme = call_580466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580466.url(scheme.get, call_580466.host, call_580466.base,
                         call_580466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580466, url, valid)

proc call*(call_580467: Call_RunProjectsLocationsAuthorizeddomainsList_580449;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsAuthorizeddomainsList
  ## List authorized domains.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
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
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580468 = newJObject()
  var query_580469 = newJObject()
  add(query_580469, "upload_protocol", newJString(uploadProtocol))
  add(query_580469, "fields", newJString(fields))
  add(query_580469, "pageToken", newJString(pageToken))
  add(query_580469, "quotaUser", newJString(quotaUser))
  add(query_580469, "alt", newJString(alt))
  add(query_580469, "oauth_token", newJString(oauthToken))
  add(query_580469, "callback", newJString(callback))
  add(query_580469, "access_token", newJString(accessToken))
  add(query_580469, "uploadType", newJString(uploadType))
  add(path_580468, "parent", newJString(parent))
  add(query_580469, "key", newJString(key))
  add(query_580469, "$.xgafv", newJString(Xgafv))
  add(query_580469, "pageSize", newJInt(pageSize))
  add(query_580469, "prettyPrint", newJBool(prettyPrint))
  result = call_580467.call(path_580468, query_580469, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_580449(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_580450,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_580451,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsCreate_580496 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsAutodomainmappingsCreate_580498(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsAutodomainmappingsCreate_580497(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new auto domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580499 = path.getOrDefault("parent")
  valid_580499 = validateParameter(valid_580499, JString, required = true,
                                 default = nil)
  if valid_580499 != nil:
    section.add "parent", valid_580499
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
  var valid_580500 = query.getOrDefault("upload_protocol")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "upload_protocol", valid_580500
  var valid_580501 = query.getOrDefault("fields")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "fields", valid_580501
  var valid_580502 = query.getOrDefault("quotaUser")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "quotaUser", valid_580502
  var valid_580503 = query.getOrDefault("alt")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = newJString("json"))
  if valid_580503 != nil:
    section.add "alt", valid_580503
  var valid_580504 = query.getOrDefault("oauth_token")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "oauth_token", valid_580504
  var valid_580505 = query.getOrDefault("callback")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "callback", valid_580505
  var valid_580506 = query.getOrDefault("access_token")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "access_token", valid_580506
  var valid_580507 = query.getOrDefault("uploadType")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "uploadType", valid_580507
  var valid_580508 = query.getOrDefault("key")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "key", valid_580508
  var valid_580509 = query.getOrDefault("$.xgafv")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = newJString("1"))
  if valid_580509 != nil:
    section.add "$.xgafv", valid_580509
  var valid_580510 = query.getOrDefault("prettyPrint")
  valid_580510 = validateParameter(valid_580510, JBool, required = false,
                                 default = newJBool(true))
  if valid_580510 != nil:
    section.add "prettyPrint", valid_580510
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

proc call*(call_580512: Call_RunProjectsLocationsAutodomainmappingsCreate_580496;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_580512.validator(path, query, header, formData, body)
  let scheme = call_580512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580512.url(scheme.get, call_580512.host, call_580512.base,
                         call_580512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580512, url, valid)

proc call*(call_580513: Call_RunProjectsLocationsAutodomainmappingsCreate_580496;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsAutodomainmappingsCreate
  ## Creates a new auto domain mapping.
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
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580514 = newJObject()
  var query_580515 = newJObject()
  var body_580516 = newJObject()
  add(query_580515, "upload_protocol", newJString(uploadProtocol))
  add(query_580515, "fields", newJString(fields))
  add(query_580515, "quotaUser", newJString(quotaUser))
  add(query_580515, "alt", newJString(alt))
  add(query_580515, "oauth_token", newJString(oauthToken))
  add(query_580515, "callback", newJString(callback))
  add(query_580515, "access_token", newJString(accessToken))
  add(query_580515, "uploadType", newJString(uploadType))
  add(path_580514, "parent", newJString(parent))
  add(query_580515, "key", newJString(key))
  add(query_580515, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580516 = body
  add(query_580515, "prettyPrint", newJBool(prettyPrint))
  result = call_580513.call(path_580514, query_580515, nil, nil, body_580516)

var runProjectsLocationsAutodomainmappingsCreate* = Call_RunProjectsLocationsAutodomainmappingsCreate_580496(
    name: "runProjectsLocationsAutodomainmappingsCreate",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsCreate_580497,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsCreate_580498,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsList_580470 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsAutodomainmappingsList_580472(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/autodomainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsAutodomainmappingsList_580471(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List auto domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580473 = path.getOrDefault("parent")
  valid_580473 = validateParameter(valid_580473, JString, required = true,
                                 default = nil)
  if valid_580473 != nil:
    section.add "parent", valid_580473
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580474 = query.getOrDefault("upload_protocol")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "upload_protocol", valid_580474
  var valid_580475 = query.getOrDefault("fields")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "fields", valid_580475
  var valid_580476 = query.getOrDefault("quotaUser")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "quotaUser", valid_580476
  var valid_580477 = query.getOrDefault("includeUninitialized")
  valid_580477 = validateParameter(valid_580477, JBool, required = false, default = nil)
  if valid_580477 != nil:
    section.add "includeUninitialized", valid_580477
  var valid_580478 = query.getOrDefault("alt")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = newJString("json"))
  if valid_580478 != nil:
    section.add "alt", valid_580478
  var valid_580479 = query.getOrDefault("continue")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "continue", valid_580479
  var valid_580480 = query.getOrDefault("oauth_token")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "oauth_token", valid_580480
  var valid_580481 = query.getOrDefault("callback")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "callback", valid_580481
  var valid_580482 = query.getOrDefault("access_token")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "access_token", valid_580482
  var valid_580483 = query.getOrDefault("uploadType")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "uploadType", valid_580483
  var valid_580484 = query.getOrDefault("resourceVersion")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "resourceVersion", valid_580484
  var valid_580485 = query.getOrDefault("watch")
  valid_580485 = validateParameter(valid_580485, JBool, required = false, default = nil)
  if valid_580485 != nil:
    section.add "watch", valid_580485
  var valid_580486 = query.getOrDefault("key")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "key", valid_580486
  var valid_580487 = query.getOrDefault("$.xgafv")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = newJString("1"))
  if valid_580487 != nil:
    section.add "$.xgafv", valid_580487
  var valid_580488 = query.getOrDefault("labelSelector")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "labelSelector", valid_580488
  var valid_580489 = query.getOrDefault("prettyPrint")
  valid_580489 = validateParameter(valid_580489, JBool, required = false,
                                 default = newJBool(true))
  if valid_580489 != nil:
    section.add "prettyPrint", valid_580489
  var valid_580490 = query.getOrDefault("fieldSelector")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "fieldSelector", valid_580490
  var valid_580491 = query.getOrDefault("limit")
  valid_580491 = validateParameter(valid_580491, JInt, required = false, default = nil)
  if valid_580491 != nil:
    section.add "limit", valid_580491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580492: Call_RunProjectsLocationsAutodomainmappingsList_580470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_580492.validator(path, query, header, formData, body)
  let scheme = call_580492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580492.url(scheme.get, call_580492.host, call_580492.base,
                         call_580492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580492, url, valid)

proc call*(call_580493: Call_RunProjectsLocationsAutodomainmappingsList_580470;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsAutodomainmappingsList
  ## List auto domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580494 = newJObject()
  var query_580495 = newJObject()
  add(query_580495, "upload_protocol", newJString(uploadProtocol))
  add(query_580495, "fields", newJString(fields))
  add(query_580495, "quotaUser", newJString(quotaUser))
  add(query_580495, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580495, "alt", newJString(alt))
  add(query_580495, "continue", newJString(`continue`))
  add(query_580495, "oauth_token", newJString(oauthToken))
  add(query_580495, "callback", newJString(callback))
  add(query_580495, "access_token", newJString(accessToken))
  add(query_580495, "uploadType", newJString(uploadType))
  add(path_580494, "parent", newJString(parent))
  add(query_580495, "resourceVersion", newJString(resourceVersion))
  add(query_580495, "watch", newJBool(watch))
  add(query_580495, "key", newJString(key))
  add(query_580495, "$.xgafv", newJString(Xgafv))
  add(query_580495, "labelSelector", newJString(labelSelector))
  add(query_580495, "prettyPrint", newJBool(prettyPrint))
  add(query_580495, "fieldSelector", newJString(fieldSelector))
  add(query_580495, "limit", newJInt(limit))
  result = call_580493.call(path_580494, query_580495, nil, nil, nil)

var runProjectsLocationsAutodomainmappingsList* = Call_RunProjectsLocationsAutodomainmappingsList_580470(
    name: "runProjectsLocationsAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsList_580471,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsList_580472,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsCreate_580543 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsConfigurationsCreate_580545(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsConfigurationsCreate_580544(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this configuration should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580546 = path.getOrDefault("parent")
  valid_580546 = validateParameter(valid_580546, JString, required = true,
                                 default = nil)
  if valid_580546 != nil:
    section.add "parent", valid_580546
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
  var valid_580547 = query.getOrDefault("upload_protocol")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "upload_protocol", valid_580547
  var valid_580548 = query.getOrDefault("fields")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "fields", valid_580548
  var valid_580549 = query.getOrDefault("quotaUser")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "quotaUser", valid_580549
  var valid_580550 = query.getOrDefault("alt")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = newJString("json"))
  if valid_580550 != nil:
    section.add "alt", valid_580550
  var valid_580551 = query.getOrDefault("oauth_token")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "oauth_token", valid_580551
  var valid_580552 = query.getOrDefault("callback")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "callback", valid_580552
  var valid_580553 = query.getOrDefault("access_token")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "access_token", valid_580553
  var valid_580554 = query.getOrDefault("uploadType")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "uploadType", valid_580554
  var valid_580555 = query.getOrDefault("key")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "key", valid_580555
  var valid_580556 = query.getOrDefault("$.xgafv")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = newJString("1"))
  if valid_580556 != nil:
    section.add "$.xgafv", valid_580556
  var valid_580557 = query.getOrDefault("prettyPrint")
  valid_580557 = validateParameter(valid_580557, JBool, required = false,
                                 default = newJBool(true))
  if valid_580557 != nil:
    section.add "prettyPrint", valid_580557
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

proc call*(call_580559: Call_RunProjectsLocationsConfigurationsCreate_580543;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_580559.validator(path, query, header, formData, body)
  let scheme = call_580559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580559.url(scheme.get, call_580559.host, call_580559.base,
                         call_580559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580559, url, valid)

proc call*(call_580560: Call_RunProjectsLocationsConfigurationsCreate_580543;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsConfigurationsCreate
  ## Create a configuration.
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
  ##         : The project ID or project number in which this configuration should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580561 = newJObject()
  var query_580562 = newJObject()
  var body_580563 = newJObject()
  add(query_580562, "upload_protocol", newJString(uploadProtocol))
  add(query_580562, "fields", newJString(fields))
  add(query_580562, "quotaUser", newJString(quotaUser))
  add(query_580562, "alt", newJString(alt))
  add(query_580562, "oauth_token", newJString(oauthToken))
  add(query_580562, "callback", newJString(callback))
  add(query_580562, "access_token", newJString(accessToken))
  add(query_580562, "uploadType", newJString(uploadType))
  add(path_580561, "parent", newJString(parent))
  add(query_580562, "key", newJString(key))
  add(query_580562, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580563 = body
  add(query_580562, "prettyPrint", newJBool(prettyPrint))
  result = call_580560.call(path_580561, query_580562, nil, nil, body_580563)

var runProjectsLocationsConfigurationsCreate* = Call_RunProjectsLocationsConfigurationsCreate_580543(
    name: "runProjectsLocationsConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsCreate_580544,
    base: "/", url: url_RunProjectsLocationsConfigurationsCreate_580545,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_580517 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsConfigurationsList_580519(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsConfigurationsList_580518(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580520 = path.getOrDefault("parent")
  valid_580520 = validateParameter(valid_580520, JString, required = true,
                                 default = nil)
  if valid_580520 != nil:
    section.add "parent", valid_580520
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580521 = query.getOrDefault("upload_protocol")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "upload_protocol", valid_580521
  var valid_580522 = query.getOrDefault("fields")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "fields", valid_580522
  var valid_580523 = query.getOrDefault("quotaUser")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "quotaUser", valid_580523
  var valid_580524 = query.getOrDefault("includeUninitialized")
  valid_580524 = validateParameter(valid_580524, JBool, required = false, default = nil)
  if valid_580524 != nil:
    section.add "includeUninitialized", valid_580524
  var valid_580525 = query.getOrDefault("alt")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = newJString("json"))
  if valid_580525 != nil:
    section.add "alt", valid_580525
  var valid_580526 = query.getOrDefault("continue")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "continue", valid_580526
  var valid_580527 = query.getOrDefault("oauth_token")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "oauth_token", valid_580527
  var valid_580528 = query.getOrDefault("callback")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "callback", valid_580528
  var valid_580529 = query.getOrDefault("access_token")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "access_token", valid_580529
  var valid_580530 = query.getOrDefault("uploadType")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "uploadType", valid_580530
  var valid_580531 = query.getOrDefault("resourceVersion")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "resourceVersion", valid_580531
  var valid_580532 = query.getOrDefault("watch")
  valid_580532 = validateParameter(valid_580532, JBool, required = false, default = nil)
  if valid_580532 != nil:
    section.add "watch", valid_580532
  var valid_580533 = query.getOrDefault("key")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "key", valid_580533
  var valid_580534 = query.getOrDefault("$.xgafv")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = newJString("1"))
  if valid_580534 != nil:
    section.add "$.xgafv", valid_580534
  var valid_580535 = query.getOrDefault("labelSelector")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "labelSelector", valid_580535
  var valid_580536 = query.getOrDefault("prettyPrint")
  valid_580536 = validateParameter(valid_580536, JBool, required = false,
                                 default = newJBool(true))
  if valid_580536 != nil:
    section.add "prettyPrint", valid_580536
  var valid_580537 = query.getOrDefault("fieldSelector")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "fieldSelector", valid_580537
  var valid_580538 = query.getOrDefault("limit")
  valid_580538 = validateParameter(valid_580538, JInt, required = false, default = nil)
  if valid_580538 != nil:
    section.add "limit", valid_580538
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580539: Call_RunProjectsLocationsConfigurationsList_580517;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_580539.validator(path, query, header, formData, body)
  let scheme = call_580539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580539.url(scheme.get, call_580539.host, call_580539.base,
                         call_580539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580539, url, valid)

proc call*(call_580540: Call_RunProjectsLocationsConfigurationsList_580517;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsConfigurationsList
  ## List configurations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580541 = newJObject()
  var query_580542 = newJObject()
  add(query_580542, "upload_protocol", newJString(uploadProtocol))
  add(query_580542, "fields", newJString(fields))
  add(query_580542, "quotaUser", newJString(quotaUser))
  add(query_580542, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580542, "alt", newJString(alt))
  add(query_580542, "continue", newJString(`continue`))
  add(query_580542, "oauth_token", newJString(oauthToken))
  add(query_580542, "callback", newJString(callback))
  add(query_580542, "access_token", newJString(accessToken))
  add(query_580542, "uploadType", newJString(uploadType))
  add(path_580541, "parent", newJString(parent))
  add(query_580542, "resourceVersion", newJString(resourceVersion))
  add(query_580542, "watch", newJBool(watch))
  add(query_580542, "key", newJString(key))
  add(query_580542, "$.xgafv", newJString(Xgafv))
  add(query_580542, "labelSelector", newJString(labelSelector))
  add(query_580542, "prettyPrint", newJBool(prettyPrint))
  add(query_580542, "fieldSelector", newJString(fieldSelector))
  add(query_580542, "limit", newJInt(limit))
  result = call_580540.call(path_580541, query_580542, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_580517(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_580518, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_580519,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_580590 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsDomainmappingsCreate_580592(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsCreate_580591(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580593 = path.getOrDefault("parent")
  valid_580593 = validateParameter(valid_580593, JString, required = true,
                                 default = nil)
  if valid_580593 != nil:
    section.add "parent", valid_580593
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
  var valid_580594 = query.getOrDefault("upload_protocol")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "upload_protocol", valid_580594
  var valid_580595 = query.getOrDefault("fields")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "fields", valid_580595
  var valid_580596 = query.getOrDefault("quotaUser")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "quotaUser", valid_580596
  var valid_580597 = query.getOrDefault("alt")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = newJString("json"))
  if valid_580597 != nil:
    section.add "alt", valid_580597
  var valid_580598 = query.getOrDefault("oauth_token")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "oauth_token", valid_580598
  var valid_580599 = query.getOrDefault("callback")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "callback", valid_580599
  var valid_580600 = query.getOrDefault("access_token")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "access_token", valid_580600
  var valid_580601 = query.getOrDefault("uploadType")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "uploadType", valid_580601
  var valid_580602 = query.getOrDefault("key")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = nil)
  if valid_580602 != nil:
    section.add "key", valid_580602
  var valid_580603 = query.getOrDefault("$.xgafv")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = newJString("1"))
  if valid_580603 != nil:
    section.add "$.xgafv", valid_580603
  var valid_580604 = query.getOrDefault("prettyPrint")
  valid_580604 = validateParameter(valid_580604, JBool, required = false,
                                 default = newJBool(true))
  if valid_580604 != nil:
    section.add "prettyPrint", valid_580604
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

proc call*(call_580606: Call_RunProjectsLocationsDomainmappingsCreate_580590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_580606.validator(path, query, header, formData, body)
  let scheme = call_580606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580606.url(scheme.get, call_580606.host, call_580606.base,
                         call_580606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580606, url, valid)

proc call*(call_580607: Call_RunProjectsLocationsDomainmappingsCreate_580590;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsCreate
  ## Create a new domain mapping.
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
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580608 = newJObject()
  var query_580609 = newJObject()
  var body_580610 = newJObject()
  add(query_580609, "upload_protocol", newJString(uploadProtocol))
  add(query_580609, "fields", newJString(fields))
  add(query_580609, "quotaUser", newJString(quotaUser))
  add(query_580609, "alt", newJString(alt))
  add(query_580609, "oauth_token", newJString(oauthToken))
  add(query_580609, "callback", newJString(callback))
  add(query_580609, "access_token", newJString(accessToken))
  add(query_580609, "uploadType", newJString(uploadType))
  add(path_580608, "parent", newJString(parent))
  add(query_580609, "key", newJString(key))
  add(query_580609, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580610 = body
  add(query_580609, "prettyPrint", newJBool(prettyPrint))
  result = call_580607.call(path_580608, query_580609, nil, nil, body_580610)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_580590(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_580591,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_580592,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_580564 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsDomainmappingsList_580566(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsList_580565(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580567 = path.getOrDefault("parent")
  valid_580567 = validateParameter(valid_580567, JString, required = true,
                                 default = nil)
  if valid_580567 != nil:
    section.add "parent", valid_580567
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580568 = query.getOrDefault("upload_protocol")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "upload_protocol", valid_580568
  var valid_580569 = query.getOrDefault("fields")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "fields", valid_580569
  var valid_580570 = query.getOrDefault("quotaUser")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "quotaUser", valid_580570
  var valid_580571 = query.getOrDefault("includeUninitialized")
  valid_580571 = validateParameter(valid_580571, JBool, required = false, default = nil)
  if valid_580571 != nil:
    section.add "includeUninitialized", valid_580571
  var valid_580572 = query.getOrDefault("alt")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = newJString("json"))
  if valid_580572 != nil:
    section.add "alt", valid_580572
  var valid_580573 = query.getOrDefault("continue")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = nil)
  if valid_580573 != nil:
    section.add "continue", valid_580573
  var valid_580574 = query.getOrDefault("oauth_token")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "oauth_token", valid_580574
  var valid_580575 = query.getOrDefault("callback")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "callback", valid_580575
  var valid_580576 = query.getOrDefault("access_token")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "access_token", valid_580576
  var valid_580577 = query.getOrDefault("uploadType")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "uploadType", valid_580577
  var valid_580578 = query.getOrDefault("resourceVersion")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "resourceVersion", valid_580578
  var valid_580579 = query.getOrDefault("watch")
  valid_580579 = validateParameter(valid_580579, JBool, required = false, default = nil)
  if valid_580579 != nil:
    section.add "watch", valid_580579
  var valid_580580 = query.getOrDefault("key")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "key", valid_580580
  var valid_580581 = query.getOrDefault("$.xgafv")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = newJString("1"))
  if valid_580581 != nil:
    section.add "$.xgafv", valid_580581
  var valid_580582 = query.getOrDefault("labelSelector")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "labelSelector", valid_580582
  var valid_580583 = query.getOrDefault("prettyPrint")
  valid_580583 = validateParameter(valid_580583, JBool, required = false,
                                 default = newJBool(true))
  if valid_580583 != nil:
    section.add "prettyPrint", valid_580583
  var valid_580584 = query.getOrDefault("fieldSelector")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "fieldSelector", valid_580584
  var valid_580585 = query.getOrDefault("limit")
  valid_580585 = validateParameter(valid_580585, JInt, required = false, default = nil)
  if valid_580585 != nil:
    section.add "limit", valid_580585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580586: Call_RunProjectsLocationsDomainmappingsList_580564;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_580586.validator(path, query, header, formData, body)
  let scheme = call_580586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580586.url(scheme.get, call_580586.host, call_580586.base,
                         call_580586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580586, url, valid)

proc call*(call_580587: Call_RunProjectsLocationsDomainmappingsList_580564;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsDomainmappingsList
  ## List domain mappings.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580588 = newJObject()
  var query_580589 = newJObject()
  add(query_580589, "upload_protocol", newJString(uploadProtocol))
  add(query_580589, "fields", newJString(fields))
  add(query_580589, "quotaUser", newJString(quotaUser))
  add(query_580589, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580589, "alt", newJString(alt))
  add(query_580589, "continue", newJString(`continue`))
  add(query_580589, "oauth_token", newJString(oauthToken))
  add(query_580589, "callback", newJString(callback))
  add(query_580589, "access_token", newJString(accessToken))
  add(query_580589, "uploadType", newJString(uploadType))
  add(path_580588, "parent", newJString(parent))
  add(query_580589, "resourceVersion", newJString(resourceVersion))
  add(query_580589, "watch", newJBool(watch))
  add(query_580589, "key", newJString(key))
  add(query_580589, "$.xgafv", newJString(Xgafv))
  add(query_580589, "labelSelector", newJString(labelSelector))
  add(query_580589, "prettyPrint", newJBool(prettyPrint))
  add(query_580589, "fieldSelector", newJString(fieldSelector))
  add(query_580589, "limit", newJInt(limit))
  result = call_580587.call(path_580588, query_580589, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_580564(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_580565, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_580566,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_580611 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsRevisionsList_580613(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRevisionsList_580612(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the revisions should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580614 = path.getOrDefault("parent")
  valid_580614 = validateParameter(valid_580614, JString, required = true,
                                 default = nil)
  if valid_580614 != nil:
    section.add "parent", valid_580614
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580615 = query.getOrDefault("upload_protocol")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "upload_protocol", valid_580615
  var valid_580616 = query.getOrDefault("fields")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = nil)
  if valid_580616 != nil:
    section.add "fields", valid_580616
  var valid_580617 = query.getOrDefault("quotaUser")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "quotaUser", valid_580617
  var valid_580618 = query.getOrDefault("includeUninitialized")
  valid_580618 = validateParameter(valid_580618, JBool, required = false, default = nil)
  if valid_580618 != nil:
    section.add "includeUninitialized", valid_580618
  var valid_580619 = query.getOrDefault("alt")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = newJString("json"))
  if valid_580619 != nil:
    section.add "alt", valid_580619
  var valid_580620 = query.getOrDefault("continue")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "continue", valid_580620
  var valid_580621 = query.getOrDefault("oauth_token")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "oauth_token", valid_580621
  var valid_580622 = query.getOrDefault("callback")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "callback", valid_580622
  var valid_580623 = query.getOrDefault("access_token")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "access_token", valid_580623
  var valid_580624 = query.getOrDefault("uploadType")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "uploadType", valid_580624
  var valid_580625 = query.getOrDefault("resourceVersion")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "resourceVersion", valid_580625
  var valid_580626 = query.getOrDefault("watch")
  valid_580626 = validateParameter(valid_580626, JBool, required = false, default = nil)
  if valid_580626 != nil:
    section.add "watch", valid_580626
  var valid_580627 = query.getOrDefault("key")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "key", valid_580627
  var valid_580628 = query.getOrDefault("$.xgafv")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = newJString("1"))
  if valid_580628 != nil:
    section.add "$.xgafv", valid_580628
  var valid_580629 = query.getOrDefault("labelSelector")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "labelSelector", valid_580629
  var valid_580630 = query.getOrDefault("prettyPrint")
  valid_580630 = validateParameter(valid_580630, JBool, required = false,
                                 default = newJBool(true))
  if valid_580630 != nil:
    section.add "prettyPrint", valid_580630
  var valid_580631 = query.getOrDefault("fieldSelector")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "fieldSelector", valid_580631
  var valid_580632 = query.getOrDefault("limit")
  valid_580632 = validateParameter(valid_580632, JInt, required = false, default = nil)
  if valid_580632 != nil:
    section.add "limit", valid_580632
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580633: Call_RunProjectsLocationsRevisionsList_580611;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_580633.validator(path, query, header, formData, body)
  let scheme = call_580633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580633.url(scheme.get, call_580633.host, call_580633.base,
                         call_580633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580633, url, valid)

proc call*(call_580634: Call_RunProjectsLocationsRevisionsList_580611;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsRevisionsList
  ## List revisions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the revisions should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580635 = newJObject()
  var query_580636 = newJObject()
  add(query_580636, "upload_protocol", newJString(uploadProtocol))
  add(query_580636, "fields", newJString(fields))
  add(query_580636, "quotaUser", newJString(quotaUser))
  add(query_580636, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580636, "alt", newJString(alt))
  add(query_580636, "continue", newJString(`continue`))
  add(query_580636, "oauth_token", newJString(oauthToken))
  add(query_580636, "callback", newJString(callback))
  add(query_580636, "access_token", newJString(accessToken))
  add(query_580636, "uploadType", newJString(uploadType))
  add(path_580635, "parent", newJString(parent))
  add(query_580636, "resourceVersion", newJString(resourceVersion))
  add(query_580636, "watch", newJBool(watch))
  add(query_580636, "key", newJString(key))
  add(query_580636, "$.xgafv", newJString(Xgafv))
  add(query_580636, "labelSelector", newJString(labelSelector))
  add(query_580636, "prettyPrint", newJBool(prettyPrint))
  add(query_580636, "fieldSelector", newJString(fieldSelector))
  add(query_580636, "limit", newJInt(limit))
  result = call_580634.call(path_580635, query_580636, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_580611(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_580612, base: "/",
    url: url_RunProjectsLocationsRevisionsList_580613, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesCreate_580663 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsRoutesCreate_580665(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRoutesCreate_580664(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a route.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this route should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580666 = path.getOrDefault("parent")
  valid_580666 = validateParameter(valid_580666, JString, required = true,
                                 default = nil)
  if valid_580666 != nil:
    section.add "parent", valid_580666
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
  var valid_580667 = query.getOrDefault("upload_protocol")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "upload_protocol", valid_580667
  var valid_580668 = query.getOrDefault("fields")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "fields", valid_580668
  var valid_580669 = query.getOrDefault("quotaUser")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "quotaUser", valid_580669
  var valid_580670 = query.getOrDefault("alt")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = newJString("json"))
  if valid_580670 != nil:
    section.add "alt", valid_580670
  var valid_580671 = query.getOrDefault("oauth_token")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "oauth_token", valid_580671
  var valid_580672 = query.getOrDefault("callback")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "callback", valid_580672
  var valid_580673 = query.getOrDefault("access_token")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = nil)
  if valid_580673 != nil:
    section.add "access_token", valid_580673
  var valid_580674 = query.getOrDefault("uploadType")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "uploadType", valid_580674
  var valid_580675 = query.getOrDefault("key")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "key", valid_580675
  var valid_580676 = query.getOrDefault("$.xgafv")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = newJString("1"))
  if valid_580676 != nil:
    section.add "$.xgafv", valid_580676
  var valid_580677 = query.getOrDefault("prettyPrint")
  valid_580677 = validateParameter(valid_580677, JBool, required = false,
                                 default = newJBool(true))
  if valid_580677 != nil:
    section.add "prettyPrint", valid_580677
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

proc call*(call_580679: Call_RunProjectsLocationsRoutesCreate_580663;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_580679.validator(path, query, header, formData, body)
  let scheme = call_580679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580679.url(scheme.get, call_580679.host, call_580679.base,
                         call_580679.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580679, url, valid)

proc call*(call_580680: Call_RunProjectsLocationsRoutesCreate_580663;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsRoutesCreate
  ## Create a route.
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
  ##         : The project ID or project number in which this route should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580681 = newJObject()
  var query_580682 = newJObject()
  var body_580683 = newJObject()
  add(query_580682, "upload_protocol", newJString(uploadProtocol))
  add(query_580682, "fields", newJString(fields))
  add(query_580682, "quotaUser", newJString(quotaUser))
  add(query_580682, "alt", newJString(alt))
  add(query_580682, "oauth_token", newJString(oauthToken))
  add(query_580682, "callback", newJString(callback))
  add(query_580682, "access_token", newJString(accessToken))
  add(query_580682, "uploadType", newJString(uploadType))
  add(path_580681, "parent", newJString(parent))
  add(query_580682, "key", newJString(key))
  add(query_580682, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580683 = body
  add(query_580682, "prettyPrint", newJBool(prettyPrint))
  result = call_580680.call(path_580681, query_580682, nil, nil, body_580683)

var runProjectsLocationsRoutesCreate* = Call_RunProjectsLocationsRoutesCreate_580663(
    name: "runProjectsLocationsRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesCreate_580664, base: "/",
    url: url_RunProjectsLocationsRoutesCreate_580665, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_580637 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsRoutesList_580639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRoutesList_580638(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the routes should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580640 = path.getOrDefault("parent")
  valid_580640 = validateParameter(valid_580640, JString, required = true,
                                 default = nil)
  if valid_580640 != nil:
    section.add "parent", valid_580640
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580641 = query.getOrDefault("upload_protocol")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "upload_protocol", valid_580641
  var valid_580642 = query.getOrDefault("fields")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "fields", valid_580642
  var valid_580643 = query.getOrDefault("quotaUser")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "quotaUser", valid_580643
  var valid_580644 = query.getOrDefault("includeUninitialized")
  valid_580644 = validateParameter(valid_580644, JBool, required = false, default = nil)
  if valid_580644 != nil:
    section.add "includeUninitialized", valid_580644
  var valid_580645 = query.getOrDefault("alt")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = newJString("json"))
  if valid_580645 != nil:
    section.add "alt", valid_580645
  var valid_580646 = query.getOrDefault("continue")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "continue", valid_580646
  var valid_580647 = query.getOrDefault("oauth_token")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "oauth_token", valid_580647
  var valid_580648 = query.getOrDefault("callback")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "callback", valid_580648
  var valid_580649 = query.getOrDefault("access_token")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "access_token", valid_580649
  var valid_580650 = query.getOrDefault("uploadType")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "uploadType", valid_580650
  var valid_580651 = query.getOrDefault("resourceVersion")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "resourceVersion", valid_580651
  var valid_580652 = query.getOrDefault("watch")
  valid_580652 = validateParameter(valid_580652, JBool, required = false, default = nil)
  if valid_580652 != nil:
    section.add "watch", valid_580652
  var valid_580653 = query.getOrDefault("key")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "key", valid_580653
  var valid_580654 = query.getOrDefault("$.xgafv")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = newJString("1"))
  if valid_580654 != nil:
    section.add "$.xgafv", valid_580654
  var valid_580655 = query.getOrDefault("labelSelector")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "labelSelector", valid_580655
  var valid_580656 = query.getOrDefault("prettyPrint")
  valid_580656 = validateParameter(valid_580656, JBool, required = false,
                                 default = newJBool(true))
  if valid_580656 != nil:
    section.add "prettyPrint", valid_580656
  var valid_580657 = query.getOrDefault("fieldSelector")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "fieldSelector", valid_580657
  var valid_580658 = query.getOrDefault("limit")
  valid_580658 = validateParameter(valid_580658, JInt, required = false, default = nil)
  if valid_580658 != nil:
    section.add "limit", valid_580658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580659: Call_RunProjectsLocationsRoutesList_580637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_580659.validator(path, query, header, formData, body)
  let scheme = call_580659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580659.url(scheme.get, call_580659.host, call_580659.base,
                         call_580659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580659, url, valid)

proc call*(call_580660: Call_RunProjectsLocationsRoutesList_580637; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsRoutesList
  ## List routes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the routes should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580661 = newJObject()
  var query_580662 = newJObject()
  add(query_580662, "upload_protocol", newJString(uploadProtocol))
  add(query_580662, "fields", newJString(fields))
  add(query_580662, "quotaUser", newJString(quotaUser))
  add(query_580662, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580662, "alt", newJString(alt))
  add(query_580662, "continue", newJString(`continue`))
  add(query_580662, "oauth_token", newJString(oauthToken))
  add(query_580662, "callback", newJString(callback))
  add(query_580662, "access_token", newJString(accessToken))
  add(query_580662, "uploadType", newJString(uploadType))
  add(path_580661, "parent", newJString(parent))
  add(query_580662, "resourceVersion", newJString(resourceVersion))
  add(query_580662, "watch", newJBool(watch))
  add(query_580662, "key", newJString(key))
  add(query_580662, "$.xgafv", newJString(Xgafv))
  add(query_580662, "labelSelector", newJString(labelSelector))
  add(query_580662, "prettyPrint", newJBool(prettyPrint))
  add(query_580662, "fieldSelector", newJString(fieldSelector))
  add(query_580662, "limit", newJInt(limit))
  result = call_580660.call(path_580661, query_580662, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_580637(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_580638, base: "/",
    url: url_RunProjectsLocationsRoutesList_580639, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_580710 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesCreate_580712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesCreate_580711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this service should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580713 = path.getOrDefault("parent")
  valid_580713 = validateParameter(valid_580713, JString, required = true,
                                 default = nil)
  if valid_580713 != nil:
    section.add "parent", valid_580713
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
  var valid_580714 = query.getOrDefault("upload_protocol")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "upload_protocol", valid_580714
  var valid_580715 = query.getOrDefault("fields")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "fields", valid_580715
  var valid_580716 = query.getOrDefault("quotaUser")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "quotaUser", valid_580716
  var valid_580717 = query.getOrDefault("alt")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = newJString("json"))
  if valid_580717 != nil:
    section.add "alt", valid_580717
  var valid_580718 = query.getOrDefault("oauth_token")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "oauth_token", valid_580718
  var valid_580719 = query.getOrDefault("callback")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "callback", valid_580719
  var valid_580720 = query.getOrDefault("access_token")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "access_token", valid_580720
  var valid_580721 = query.getOrDefault("uploadType")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "uploadType", valid_580721
  var valid_580722 = query.getOrDefault("key")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "key", valid_580722
  var valid_580723 = query.getOrDefault("$.xgafv")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = newJString("1"))
  if valid_580723 != nil:
    section.add "$.xgafv", valid_580723
  var valid_580724 = query.getOrDefault("prettyPrint")
  valid_580724 = validateParameter(valid_580724, JBool, required = false,
                                 default = newJBool(true))
  if valid_580724 != nil:
    section.add "prettyPrint", valid_580724
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

proc call*(call_580726: Call_RunProjectsLocationsServicesCreate_580710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_580726.validator(path, query, header, formData, body)
  let scheme = call_580726.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580726.url(scheme.get, call_580726.host, call_580726.base,
                         call_580726.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580726, url, valid)

proc call*(call_580727: Call_RunProjectsLocationsServicesCreate_580710;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesCreate
  ## Create a service.
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
  ##         : The project ID or project number in which this service should be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580728 = newJObject()
  var query_580729 = newJObject()
  var body_580730 = newJObject()
  add(query_580729, "upload_protocol", newJString(uploadProtocol))
  add(query_580729, "fields", newJString(fields))
  add(query_580729, "quotaUser", newJString(quotaUser))
  add(query_580729, "alt", newJString(alt))
  add(query_580729, "oauth_token", newJString(oauthToken))
  add(query_580729, "callback", newJString(callback))
  add(query_580729, "access_token", newJString(accessToken))
  add(query_580729, "uploadType", newJString(uploadType))
  add(path_580728, "parent", newJString(parent))
  add(query_580729, "key", newJString(key))
  add(query_580729, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580730 = body
  add(query_580729, "prettyPrint", newJBool(prettyPrint))
  result = call_580727.call(path_580728, query_580729, nil, nil, body_580730)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_580710(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_580711, base: "/",
    url: url_RunProjectsLocationsServicesCreate_580712, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_580684 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesList_580686(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesList_580685(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the services should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580687 = path.getOrDefault("parent")
  valid_580687 = validateParameter(valid_580687, JString, required = true,
                                 default = nil)
  if valid_580687 != nil:
    section.add "parent", valid_580687
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   alt: JString
  ##      : Data format for response.
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  section = newJObject()
  var valid_580688 = query.getOrDefault("upload_protocol")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "upload_protocol", valid_580688
  var valid_580689 = query.getOrDefault("fields")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "fields", valid_580689
  var valid_580690 = query.getOrDefault("quotaUser")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "quotaUser", valid_580690
  var valid_580691 = query.getOrDefault("includeUninitialized")
  valid_580691 = validateParameter(valid_580691, JBool, required = false, default = nil)
  if valid_580691 != nil:
    section.add "includeUninitialized", valid_580691
  var valid_580692 = query.getOrDefault("alt")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = newJString("json"))
  if valid_580692 != nil:
    section.add "alt", valid_580692
  var valid_580693 = query.getOrDefault("continue")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "continue", valid_580693
  var valid_580694 = query.getOrDefault("oauth_token")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "oauth_token", valid_580694
  var valid_580695 = query.getOrDefault("callback")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "callback", valid_580695
  var valid_580696 = query.getOrDefault("access_token")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "access_token", valid_580696
  var valid_580697 = query.getOrDefault("uploadType")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "uploadType", valid_580697
  var valid_580698 = query.getOrDefault("resourceVersion")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "resourceVersion", valid_580698
  var valid_580699 = query.getOrDefault("watch")
  valid_580699 = validateParameter(valid_580699, JBool, required = false, default = nil)
  if valid_580699 != nil:
    section.add "watch", valid_580699
  var valid_580700 = query.getOrDefault("key")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "key", valid_580700
  var valid_580701 = query.getOrDefault("$.xgafv")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = newJString("1"))
  if valid_580701 != nil:
    section.add "$.xgafv", valid_580701
  var valid_580702 = query.getOrDefault("labelSelector")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "labelSelector", valid_580702
  var valid_580703 = query.getOrDefault("prettyPrint")
  valid_580703 = validateParameter(valid_580703, JBool, required = false,
                                 default = newJBool(true))
  if valid_580703 != nil:
    section.add "prettyPrint", valid_580703
  var valid_580704 = query.getOrDefault("fieldSelector")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = nil)
  if valid_580704 != nil:
    section.add "fieldSelector", valid_580704
  var valid_580705 = query.getOrDefault("limit")
  valid_580705 = validateParameter(valid_580705, JInt, required = false, default = nil)
  if valid_580705 != nil:
    section.add "limit", valid_580705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580706: Call_RunProjectsLocationsServicesList_580684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_580706.validator(path, query, header, formData, body)
  let scheme = call_580706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580706.url(scheme.get, call_580706.host, call_580706.base,
                         call_580706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580706, url, valid)

proc call*(call_580707: Call_RunProjectsLocationsServicesList_580684;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsServicesList
  ## List services.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   alt: string
  ##      : Data format for response.
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The project ID or project number from which the services should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  var path_580708 = newJObject()
  var query_580709 = newJObject()
  add(query_580709, "upload_protocol", newJString(uploadProtocol))
  add(query_580709, "fields", newJString(fields))
  add(query_580709, "quotaUser", newJString(quotaUser))
  add(query_580709, "includeUninitialized", newJBool(includeUninitialized))
  add(query_580709, "alt", newJString(alt))
  add(query_580709, "continue", newJString(`continue`))
  add(query_580709, "oauth_token", newJString(oauthToken))
  add(query_580709, "callback", newJString(callback))
  add(query_580709, "access_token", newJString(accessToken))
  add(query_580709, "uploadType", newJString(uploadType))
  add(path_580708, "parent", newJString(parent))
  add(query_580709, "resourceVersion", newJString(resourceVersion))
  add(query_580709, "watch", newJBool(watch))
  add(query_580709, "key", newJString(key))
  add(query_580709, "$.xgafv", newJString(Xgafv))
  add(query_580709, "labelSelector", newJString(labelSelector))
  add(query_580709, "prettyPrint", newJBool(prettyPrint))
  add(query_580709, "fieldSelector", newJString(fieldSelector))
  add(query_580709, "limit", newJInt(limit))
  result = call_580707.call(path_580708, query_580709, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_580684(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_580685, base: "/",
    url: url_RunProjectsLocationsServicesList_580686, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_580731 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesGetIamPolicy_580733(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesGetIamPolicy_580732(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580734 = path.getOrDefault("resource")
  valid_580734 = validateParameter(valid_580734, JString, required = true,
                                 default = nil)
  if valid_580734 != nil:
    section.add "resource", valid_580734
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580735 = query.getOrDefault("upload_protocol")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "upload_protocol", valid_580735
  var valid_580736 = query.getOrDefault("fields")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "fields", valid_580736
  var valid_580737 = query.getOrDefault("quotaUser")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "quotaUser", valid_580737
  var valid_580738 = query.getOrDefault("alt")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = newJString("json"))
  if valid_580738 != nil:
    section.add "alt", valid_580738
  var valid_580739 = query.getOrDefault("oauth_token")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "oauth_token", valid_580739
  var valid_580740 = query.getOrDefault("callback")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "callback", valid_580740
  var valid_580741 = query.getOrDefault("access_token")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "access_token", valid_580741
  var valid_580742 = query.getOrDefault("uploadType")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "uploadType", valid_580742
  var valid_580743 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580743 = validateParameter(valid_580743, JInt, required = false, default = nil)
  if valid_580743 != nil:
    section.add "options.requestedPolicyVersion", valid_580743
  var valid_580744 = query.getOrDefault("key")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = nil)
  if valid_580744 != nil:
    section.add "key", valid_580744
  var valid_580745 = query.getOrDefault("$.xgafv")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = newJString("1"))
  if valid_580745 != nil:
    section.add "$.xgafv", valid_580745
  var valid_580746 = query.getOrDefault("prettyPrint")
  valid_580746 = validateParameter(valid_580746, JBool, required = false,
                                 default = newJBool(true))
  if valid_580746 != nil:
    section.add "prettyPrint", valid_580746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580747: Call_RunProjectsLocationsServicesGetIamPolicy_580731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_580747.validator(path, query, header, formData, body)
  let scheme = call_580747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580747.url(scheme.get, call_580747.host, call_580747.base,
                         call_580747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580747, url, valid)

proc call*(call_580748: Call_RunProjectsLocationsServicesGetIamPolicy_580731;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesGetIamPolicy
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580749 = newJObject()
  var query_580750 = newJObject()
  add(query_580750, "upload_protocol", newJString(uploadProtocol))
  add(query_580750, "fields", newJString(fields))
  add(query_580750, "quotaUser", newJString(quotaUser))
  add(query_580750, "alt", newJString(alt))
  add(query_580750, "oauth_token", newJString(oauthToken))
  add(query_580750, "callback", newJString(callback))
  add(query_580750, "access_token", newJString(accessToken))
  add(query_580750, "uploadType", newJString(uploadType))
  add(query_580750, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580750, "key", newJString(key))
  add(query_580750, "$.xgafv", newJString(Xgafv))
  add(path_580749, "resource", newJString(resource))
  add(query_580750, "prettyPrint", newJBool(prettyPrint))
  result = call_580748.call(path_580749, query_580750, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_580731(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_580732,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_580733,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_580751 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesSetIamPolicy_580753(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesSetIamPolicy_580752(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580754 = path.getOrDefault("resource")
  valid_580754 = validateParameter(valid_580754, JString, required = true,
                                 default = nil)
  if valid_580754 != nil:
    section.add "resource", valid_580754
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
  var valid_580755 = query.getOrDefault("upload_protocol")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "upload_protocol", valid_580755
  var valid_580756 = query.getOrDefault("fields")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "fields", valid_580756
  var valid_580757 = query.getOrDefault("quotaUser")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "quotaUser", valid_580757
  var valid_580758 = query.getOrDefault("alt")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = newJString("json"))
  if valid_580758 != nil:
    section.add "alt", valid_580758
  var valid_580759 = query.getOrDefault("oauth_token")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "oauth_token", valid_580759
  var valid_580760 = query.getOrDefault("callback")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "callback", valid_580760
  var valid_580761 = query.getOrDefault("access_token")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "access_token", valid_580761
  var valid_580762 = query.getOrDefault("uploadType")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "uploadType", valid_580762
  var valid_580763 = query.getOrDefault("key")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "key", valid_580763
  var valid_580764 = query.getOrDefault("$.xgafv")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = newJString("1"))
  if valid_580764 != nil:
    section.add "$.xgafv", valid_580764
  var valid_580765 = query.getOrDefault("prettyPrint")
  valid_580765 = validateParameter(valid_580765, JBool, required = false,
                                 default = newJBool(true))
  if valid_580765 != nil:
    section.add "prettyPrint", valid_580765
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

proc call*(call_580767: Call_RunProjectsLocationsServicesSetIamPolicy_580751;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_580767.validator(path, query, header, formData, body)
  let scheme = call_580767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580767.url(scheme.get, call_580767.host, call_580767.base,
                         call_580767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580767, url, valid)

proc call*(call_580768: Call_RunProjectsLocationsServicesSetIamPolicy_580751;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesSetIamPolicy
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
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
  var path_580769 = newJObject()
  var query_580770 = newJObject()
  var body_580771 = newJObject()
  add(query_580770, "upload_protocol", newJString(uploadProtocol))
  add(query_580770, "fields", newJString(fields))
  add(query_580770, "quotaUser", newJString(quotaUser))
  add(query_580770, "alt", newJString(alt))
  add(query_580770, "oauth_token", newJString(oauthToken))
  add(query_580770, "callback", newJString(callback))
  add(query_580770, "access_token", newJString(accessToken))
  add(query_580770, "uploadType", newJString(uploadType))
  add(query_580770, "key", newJString(key))
  add(query_580770, "$.xgafv", newJString(Xgafv))
  add(path_580769, "resource", newJString(resource))
  if body != nil:
    body_580771 = body
  add(query_580770, "prettyPrint", newJBool(prettyPrint))
  result = call_580768.call(path_580769, query_580770, nil, nil, body_580771)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_580751(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_580752,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_580753,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_580772 = ref object of OpenApiRestCall_579421
proc url_RunProjectsLocationsServicesTestIamPermissions_580774(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_RunProjectsLocationsServicesTestIamPermissions_580773(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580775 = path.getOrDefault("resource")
  valid_580775 = validateParameter(valid_580775, JString, required = true,
                                 default = nil)
  if valid_580775 != nil:
    section.add "resource", valid_580775
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
  var valid_580776 = query.getOrDefault("upload_protocol")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "upload_protocol", valid_580776
  var valid_580777 = query.getOrDefault("fields")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "fields", valid_580777
  var valid_580778 = query.getOrDefault("quotaUser")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "quotaUser", valid_580778
  var valid_580779 = query.getOrDefault("alt")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = newJString("json"))
  if valid_580779 != nil:
    section.add "alt", valid_580779
  var valid_580780 = query.getOrDefault("oauth_token")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "oauth_token", valid_580780
  var valid_580781 = query.getOrDefault("callback")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "callback", valid_580781
  var valid_580782 = query.getOrDefault("access_token")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "access_token", valid_580782
  var valid_580783 = query.getOrDefault("uploadType")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "uploadType", valid_580783
  var valid_580784 = query.getOrDefault("key")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "key", valid_580784
  var valid_580785 = query.getOrDefault("$.xgafv")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = newJString("1"))
  if valid_580785 != nil:
    section.add "$.xgafv", valid_580785
  var valid_580786 = query.getOrDefault("prettyPrint")
  valid_580786 = validateParameter(valid_580786, JBool, required = false,
                                 default = newJBool(true))
  if valid_580786 != nil:
    section.add "prettyPrint", valid_580786
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

proc call*(call_580788: Call_RunProjectsLocationsServicesTestIamPermissions_580772;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_580788.validator(path, query, header, formData, body)
  let scheme = call_580788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580788.url(scheme.get, call_580788.host, call_580788.base,
                         call_580788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580788, url, valid)

proc call*(call_580789: Call_RunProjectsLocationsServicesTestIamPermissions_580772;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesTestIamPermissions
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
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
  var path_580790 = newJObject()
  var query_580791 = newJObject()
  var body_580792 = newJObject()
  add(query_580791, "upload_protocol", newJString(uploadProtocol))
  add(query_580791, "fields", newJString(fields))
  add(query_580791, "quotaUser", newJString(quotaUser))
  add(query_580791, "alt", newJString(alt))
  add(query_580791, "oauth_token", newJString(oauthToken))
  add(query_580791, "callback", newJString(callback))
  add(query_580791, "access_token", newJString(accessToken))
  add(query_580791, "uploadType", newJString(uploadType))
  add(query_580791, "key", newJString(key))
  add(query_580791, "$.xgafv", newJString(Xgafv))
  add(path_580790, "resource", newJString(resource))
  if body != nil:
    body_580792 = body
  add(query_580791, "prettyPrint", newJBool(prettyPrint))
  result = call_580789.call(path_580790, query_580791, nil, nil, body_580792)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_580772(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_580773,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_580774,
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
