
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "run"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunNamespacesDomainmappingsReplaceDomainMapping_578907 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesDomainmappingsReplaceDomainMapping_578909(protocol: Scheme;
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

proc validate_RunNamespacesDomainmappingsReplaceDomainMapping_578908(
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
  var valid_578910 = path.getOrDefault("name")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "name", valid_578910
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
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("access_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "access_token", valid_578920
  var valid_578921 = query.getOrDefault("upload_protocol")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "upload_protocol", valid_578921
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

proc call*(call_578923: Call_RunNamespacesDomainmappingsReplaceDomainMapping_578907;
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
  let valid = call_578923.validator(path, query, header, formData, body)
  let scheme = call_578923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578923.url(scheme.get, call_578923.host, call_578923.base,
                         call_578923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578923, url, valid)

proc call*(call_578924: Call_RunNamespacesDomainmappingsReplaceDomainMapping_578907;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesDomainmappingsReplaceDomainMapping
  ## Replace a domain mapping.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
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
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578925 = newJObject()
  var query_578926 = newJObject()
  var body_578927 = newJObject()
  add(query_578926, "key", newJString(key))
  add(query_578926, "prettyPrint", newJBool(prettyPrint))
  add(query_578926, "oauth_token", newJString(oauthToken))
  add(query_578926, "$.xgafv", newJString(Xgafv))
  add(query_578926, "alt", newJString(alt))
  add(query_578926, "uploadType", newJString(uploadType))
  add(query_578926, "quotaUser", newJString(quotaUser))
  add(path_578925, "name", newJString(name))
  if body != nil:
    body_578927 = body
  add(query_578926, "callback", newJString(callback))
  add(query_578926, "fields", newJString(fields))
  add(query_578926, "access_token", newJString(accessToken))
  add(query_578926, "upload_protocol", newJString(uploadProtocol))
  result = call_578924.call(path_578925, query_578926, nil, nil, body_578927)

var runNamespacesDomainmappingsReplaceDomainMapping* = Call_RunNamespacesDomainmappingsReplaceDomainMapping_578907(
    name: "runNamespacesDomainmappingsReplaceDomainMapping",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsReplaceDomainMapping_578908,
    base: "/", url: url_RunNamespacesDomainmappingsReplaceDomainMapping_578909,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsGet_578619 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesDomainmappingsGet_578621(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsGet_578620(path: JsonNode;
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
  var valid_578747 = path.getOrDefault("name")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "name", valid_578747
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("$.xgafv")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("1"))
  if valid_578764 != nil:
    section.add "$.xgafv", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("uploadType")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "uploadType", valid_578766
  var valid_578767 = query.getOrDefault("quotaUser")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "quotaUser", valid_578767
  var valid_578768 = query.getOrDefault("callback")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "callback", valid_578768
  var valid_578769 = query.getOrDefault("fields")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "fields", valid_578769
  var valid_578770 = query.getOrDefault("access_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "access_token", valid_578770
  var valid_578771 = query.getOrDefault("upload_protocol")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "upload_protocol", valid_578771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578794: Call_RunNamespacesDomainmappingsGet_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a domain mapping.
  ## 
  let valid = call_578794.validator(path, query, header, formData, body)
  let scheme = call_578794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578794.url(scheme.get, call_578794.host, call_578794.base,
                         call_578794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578794, url, valid)

proc call*(call_578865: Call_RunNamespacesDomainmappingsGet_578619; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesDomainmappingsGet
  ## Get information about a domain mapping.
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
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578866 = newJObject()
  var query_578868 = newJObject()
  add(query_578868, "key", newJString(key))
  add(query_578868, "prettyPrint", newJBool(prettyPrint))
  add(query_578868, "oauth_token", newJString(oauthToken))
  add(query_578868, "$.xgafv", newJString(Xgafv))
  add(query_578868, "alt", newJString(alt))
  add(query_578868, "uploadType", newJString(uploadType))
  add(query_578868, "quotaUser", newJString(quotaUser))
  add(path_578866, "name", newJString(name))
  add(query_578868, "callback", newJString(callback))
  add(query_578868, "fields", newJString(fields))
  add(query_578868, "access_token", newJString(accessToken))
  add(query_578868, "upload_protocol", newJString(uploadProtocol))
  result = call_578865.call(path_578866, query_578868, nil, nil, nil)

var runNamespacesDomainmappingsGet* = Call_RunNamespacesDomainmappingsGet_578619(
    name: "runNamespacesDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsGet_578620, base: "/",
    url: url_RunNamespacesDomainmappingsGet_578621, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsDelete_578928 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesDomainmappingsDelete_578930(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsDelete_578929(path: JsonNode;
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
  var valid_578931 = path.getOrDefault("name")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "name", valid_578931
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
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: JString
  ##           : JSONP
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578932 = query.getOrDefault("key")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "key", valid_578932
  var valid_578933 = query.getOrDefault("prettyPrint")
  valid_578933 = validateParameter(valid_578933, JBool, required = false,
                                 default = newJBool(true))
  if valid_578933 != nil:
    section.add "prettyPrint", valid_578933
  var valid_578934 = query.getOrDefault("oauth_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "oauth_token", valid_578934
  var valid_578935 = query.getOrDefault("$.xgafv")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("1"))
  if valid_578935 != nil:
    section.add "$.xgafv", valid_578935
  var valid_578936 = query.getOrDefault("alt")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("json"))
  if valid_578936 != nil:
    section.add "alt", valid_578936
  var valid_578937 = query.getOrDefault("uploadType")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "uploadType", valid_578937
  var valid_578938 = query.getOrDefault("quotaUser")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "quotaUser", valid_578938
  var valid_578939 = query.getOrDefault("propagationPolicy")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "propagationPolicy", valid_578939
  var valid_578940 = query.getOrDefault("callback")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "callback", valid_578940
  var valid_578941 = query.getOrDefault("apiVersion")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "apiVersion", valid_578941
  var valid_578942 = query.getOrDefault("kind")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "kind", valid_578942
  var valid_578943 = query.getOrDefault("fields")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "fields", valid_578943
  var valid_578944 = query.getOrDefault("access_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "access_token", valid_578944
  var valid_578945 = query.getOrDefault("upload_protocol")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "upload_protocol", valid_578945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_RunNamespacesDomainmappingsDelete_578928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a domain mapping.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_RunNamespacesDomainmappingsDelete_578928;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; kind: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesDomainmappingsDelete
  ## Delete a domain mapping.
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
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: string
  ##           : JSONP
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578948 = newJObject()
  var query_578949 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(query_578949, "$.xgafv", newJString(Xgafv))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "uploadType", newJString(uploadType))
  add(query_578949, "quotaUser", newJString(quotaUser))
  add(path_578948, "name", newJString(name))
  add(query_578949, "propagationPolicy", newJString(propagationPolicy))
  add(query_578949, "callback", newJString(callback))
  add(query_578949, "apiVersion", newJString(apiVersion))
  add(query_578949, "kind", newJString(kind))
  add(query_578949, "fields", newJString(fields))
  add(query_578949, "access_token", newJString(accessToken))
  add(query_578949, "upload_protocol", newJString(uploadProtocol))
  result = call_578947.call(path_578948, query_578949, nil, nil, nil)

var runNamespacesDomainmappingsDelete* = Call_RunNamespacesDomainmappingsDelete_578928(
    name: "runNamespacesDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsDelete_578929, base: "/",
    url: url_RunNamespacesDomainmappingsDelete_578930, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_578950 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesAuthorizeddomainsList_578952(protocol: Scheme; host: string;
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

proc validate_RunNamespacesAuthorizeddomainsList_578951(path: JsonNode;
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
  var valid_578953 = path.getOrDefault("parent")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "parent", valid_578953
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
  ##           : Maximum results to return per page.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578954 = query.getOrDefault("key")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "key", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("$.xgafv")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("1"))
  if valid_578957 != nil:
    section.add "$.xgafv", valid_578957
  var valid_578958 = query.getOrDefault("pageSize")
  valid_578958 = validateParameter(valid_578958, JInt, required = false, default = nil)
  if valid_578958 != nil:
    section.add "pageSize", valid_578958
  var valid_578959 = query.getOrDefault("alt")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("json"))
  if valid_578959 != nil:
    section.add "alt", valid_578959
  var valid_578960 = query.getOrDefault("uploadType")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "uploadType", valid_578960
  var valid_578961 = query.getOrDefault("quotaUser")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "quotaUser", valid_578961
  var valid_578962 = query.getOrDefault("pageToken")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "pageToken", valid_578962
  var valid_578963 = query.getOrDefault("callback")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "callback", valid_578963
  var valid_578964 = query.getOrDefault("fields")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "fields", valid_578964
  var valid_578965 = query.getOrDefault("access_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "access_token", valid_578965
  var valid_578966 = query.getOrDefault("upload_protocol")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "upload_protocol", valid_578966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578967: Call_RunNamespacesAuthorizeddomainsList_578950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_578967.validator(path, query, header, formData, body)
  let scheme = call_578967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578967.url(scheme.get, call_578967.host, call_578967.base,
                         call_578967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578967, url, valid)

proc call*(call_578968: Call_RunNamespacesAuthorizeddomainsList_578950;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesAuthorizeddomainsList
  ## List authorized domains.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578969 = newJObject()
  var query_578970 = newJObject()
  add(query_578970, "key", newJString(key))
  add(query_578970, "prettyPrint", newJBool(prettyPrint))
  add(query_578970, "oauth_token", newJString(oauthToken))
  add(query_578970, "$.xgafv", newJString(Xgafv))
  add(query_578970, "pageSize", newJInt(pageSize))
  add(query_578970, "alt", newJString(alt))
  add(query_578970, "uploadType", newJString(uploadType))
  add(query_578970, "quotaUser", newJString(quotaUser))
  add(query_578970, "pageToken", newJString(pageToken))
  add(query_578970, "callback", newJString(callback))
  add(path_578969, "parent", newJString(parent))
  add(query_578970, "fields", newJString(fields))
  add(query_578970, "access_token", newJString(accessToken))
  add(query_578970, "upload_protocol", newJString(uploadProtocol))
  result = call_578968.call(path_578969, query_578970, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_578950(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_578951, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_578952, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsCreate_578997 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesAutodomainmappingsCreate_578999(protocol: Scheme;
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

proc validate_RunNamespacesAutodomainmappingsCreate_578998(path: JsonNode;
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
  var valid_579000 = path.getOrDefault("parent")
  valid_579000 = validateParameter(valid_579000, JString, required = true,
                                 default = nil)
  if valid_579000 != nil:
    section.add "parent", valid_579000
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
  var valid_579001 = query.getOrDefault("key")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "key", valid_579001
  var valid_579002 = query.getOrDefault("prettyPrint")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "prettyPrint", valid_579002
  var valid_579003 = query.getOrDefault("oauth_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "oauth_token", valid_579003
  var valid_579004 = query.getOrDefault("$.xgafv")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("1"))
  if valid_579004 != nil:
    section.add "$.xgafv", valid_579004
  var valid_579005 = query.getOrDefault("alt")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = newJString("json"))
  if valid_579005 != nil:
    section.add "alt", valid_579005
  var valid_579006 = query.getOrDefault("uploadType")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "uploadType", valid_579006
  var valid_579007 = query.getOrDefault("quotaUser")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "quotaUser", valid_579007
  var valid_579008 = query.getOrDefault("callback")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "callback", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  var valid_579010 = query.getOrDefault("access_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "access_token", valid_579010
  var valid_579011 = query.getOrDefault("upload_protocol")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "upload_protocol", valid_579011
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

proc call*(call_579013: Call_RunNamespacesAutodomainmappingsCreate_578997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_579013.validator(path, query, header, formData, body)
  let scheme = call_579013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579013.url(scheme.get, call_579013.host, call_579013.base,
                         call_579013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579013, url, valid)

proc call*(call_579014: Call_RunNamespacesAutodomainmappingsCreate_578997;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesAutodomainmappingsCreate
  ## Creates a new auto domain mapping.
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
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579015 = newJObject()
  var query_579016 = newJObject()
  var body_579017 = newJObject()
  add(query_579016, "key", newJString(key))
  add(query_579016, "prettyPrint", newJBool(prettyPrint))
  add(query_579016, "oauth_token", newJString(oauthToken))
  add(query_579016, "$.xgafv", newJString(Xgafv))
  add(query_579016, "alt", newJString(alt))
  add(query_579016, "uploadType", newJString(uploadType))
  add(query_579016, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579017 = body
  add(query_579016, "callback", newJString(callback))
  add(path_579015, "parent", newJString(parent))
  add(query_579016, "fields", newJString(fields))
  add(query_579016, "access_token", newJString(accessToken))
  add(query_579016, "upload_protocol", newJString(uploadProtocol))
  result = call_579014.call(path_579015, query_579016, nil, nil, body_579017)

var runNamespacesAutodomainmappingsCreate* = Call_RunNamespacesAutodomainmappingsCreate_578997(
    name: "runNamespacesAutodomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsCreate_578998, base: "/",
    url: url_RunNamespacesAutodomainmappingsCreate_578999, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsList_578971 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesAutodomainmappingsList_578973(protocol: Scheme; host: string;
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

proc validate_RunNamespacesAutodomainmappingsList_578972(path: JsonNode;
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
  var valid_578974 = path.getOrDefault("parent")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "parent", valid_578974
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_578975 = query.getOrDefault("key")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "key", valid_578975
  var valid_578976 = query.getOrDefault("includeUninitialized")
  valid_578976 = validateParameter(valid_578976, JBool, required = false, default = nil)
  if valid_578976 != nil:
    section.add "includeUninitialized", valid_578976
  var valid_578977 = query.getOrDefault("prettyPrint")
  valid_578977 = validateParameter(valid_578977, JBool, required = false,
                                 default = newJBool(true))
  if valid_578977 != nil:
    section.add "prettyPrint", valid_578977
  var valid_578978 = query.getOrDefault("oauth_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "oauth_token", valid_578978
  var valid_578979 = query.getOrDefault("fieldSelector")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "fieldSelector", valid_578979
  var valid_578980 = query.getOrDefault("labelSelector")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "labelSelector", valid_578980
  var valid_578981 = query.getOrDefault("$.xgafv")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("1"))
  if valid_578981 != nil:
    section.add "$.xgafv", valid_578981
  var valid_578982 = query.getOrDefault("limit")
  valid_578982 = validateParameter(valid_578982, JInt, required = false, default = nil)
  if valid_578982 != nil:
    section.add "limit", valid_578982
  var valid_578983 = query.getOrDefault("alt")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = newJString("json"))
  if valid_578983 != nil:
    section.add "alt", valid_578983
  var valid_578984 = query.getOrDefault("uploadType")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "uploadType", valid_578984
  var valid_578985 = query.getOrDefault("quotaUser")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "quotaUser", valid_578985
  var valid_578986 = query.getOrDefault("watch")
  valid_578986 = validateParameter(valid_578986, JBool, required = false, default = nil)
  if valid_578986 != nil:
    section.add "watch", valid_578986
  var valid_578987 = query.getOrDefault("callback")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "callback", valid_578987
  var valid_578988 = query.getOrDefault("resourceVersion")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "resourceVersion", valid_578988
  var valid_578989 = query.getOrDefault("fields")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "fields", valid_578989
  var valid_578990 = query.getOrDefault("access_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "access_token", valid_578990
  var valid_578991 = query.getOrDefault("upload_protocol")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "upload_protocol", valid_578991
  var valid_578992 = query.getOrDefault("continue")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "continue", valid_578992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578993: Call_RunNamespacesAutodomainmappingsList_578971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_578993.validator(path, query, header, formData, body)
  let scheme = call_578993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578993.url(scheme.get, call_578993.host, call_578993.base,
                         call_578993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578993, url, valid)

proc call*(call_578994: Call_RunNamespacesAutodomainmappingsList_578971;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesAutodomainmappingsList
  ## List auto domain mappings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_578995 = newJObject()
  var query_578996 = newJObject()
  add(query_578996, "key", newJString(key))
  add(query_578996, "includeUninitialized", newJBool(includeUninitialized))
  add(query_578996, "prettyPrint", newJBool(prettyPrint))
  add(query_578996, "oauth_token", newJString(oauthToken))
  add(query_578996, "fieldSelector", newJString(fieldSelector))
  add(query_578996, "labelSelector", newJString(labelSelector))
  add(query_578996, "$.xgafv", newJString(Xgafv))
  add(query_578996, "limit", newJInt(limit))
  add(query_578996, "alt", newJString(alt))
  add(query_578996, "uploadType", newJString(uploadType))
  add(query_578996, "quotaUser", newJString(quotaUser))
  add(query_578996, "watch", newJBool(watch))
  add(query_578996, "callback", newJString(callback))
  add(path_578995, "parent", newJString(parent))
  add(query_578996, "resourceVersion", newJString(resourceVersion))
  add(query_578996, "fields", newJString(fields))
  add(query_578996, "access_token", newJString(accessToken))
  add(query_578996, "upload_protocol", newJString(uploadProtocol))
  add(query_578996, "continue", newJString(`continue`))
  result = call_578994.call(path_578995, query_578996, nil, nil, nil)

var runNamespacesAutodomainmappingsList* = Call_RunNamespacesAutodomainmappingsList_578971(
    name: "runNamespacesAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsList_578972, base: "/",
    url: url_RunNamespacesAutodomainmappingsList_578973, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_579044 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesDomainmappingsCreate_579046(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsCreate_579045(path: JsonNode;
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
  var valid_579047 = path.getOrDefault("parent")
  valid_579047 = validateParameter(valid_579047, JString, required = true,
                                 default = nil)
  if valid_579047 != nil:
    section.add "parent", valid_579047
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
  var valid_579048 = query.getOrDefault("key")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "key", valid_579048
  var valid_579049 = query.getOrDefault("prettyPrint")
  valid_579049 = validateParameter(valid_579049, JBool, required = false,
                                 default = newJBool(true))
  if valid_579049 != nil:
    section.add "prettyPrint", valid_579049
  var valid_579050 = query.getOrDefault("oauth_token")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "oauth_token", valid_579050
  var valid_579051 = query.getOrDefault("$.xgafv")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("1"))
  if valid_579051 != nil:
    section.add "$.xgafv", valid_579051
  var valid_579052 = query.getOrDefault("alt")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = newJString("json"))
  if valid_579052 != nil:
    section.add "alt", valid_579052
  var valid_579053 = query.getOrDefault("uploadType")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "uploadType", valid_579053
  var valid_579054 = query.getOrDefault("quotaUser")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "quotaUser", valid_579054
  var valid_579055 = query.getOrDefault("callback")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "callback", valid_579055
  var valid_579056 = query.getOrDefault("fields")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "fields", valid_579056
  var valid_579057 = query.getOrDefault("access_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "access_token", valid_579057
  var valid_579058 = query.getOrDefault("upload_protocol")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "upload_protocol", valid_579058
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

proc call*(call_579060: Call_RunNamespacesDomainmappingsCreate_579044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_579060.validator(path, query, header, formData, body)
  let scheme = call_579060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579060.url(scheme.get, call_579060.host, call_579060.base,
                         call_579060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579060, url, valid)

proc call*(call_579061: Call_RunNamespacesDomainmappingsCreate_579044;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesDomainmappingsCreate
  ## Create a new domain mapping.
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
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579062 = newJObject()
  var query_579063 = newJObject()
  var body_579064 = newJObject()
  add(query_579063, "key", newJString(key))
  add(query_579063, "prettyPrint", newJBool(prettyPrint))
  add(query_579063, "oauth_token", newJString(oauthToken))
  add(query_579063, "$.xgafv", newJString(Xgafv))
  add(query_579063, "alt", newJString(alt))
  add(query_579063, "uploadType", newJString(uploadType))
  add(query_579063, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579064 = body
  add(query_579063, "callback", newJString(callback))
  add(path_579062, "parent", newJString(parent))
  add(query_579063, "fields", newJString(fields))
  add(query_579063, "access_token", newJString(accessToken))
  add(query_579063, "upload_protocol", newJString(uploadProtocol))
  result = call_579061.call(path_579062, query_579063, nil, nil, body_579064)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_579044(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_579045, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_579046, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_579018 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesDomainmappingsList_579020(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsList_579019(path: JsonNode;
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
  var valid_579021 = path.getOrDefault("parent")
  valid_579021 = validateParameter(valid_579021, JString, required = true,
                                 default = nil)
  if valid_579021 != nil:
    section.add "parent", valid_579021
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579022 = query.getOrDefault("key")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "key", valid_579022
  var valid_579023 = query.getOrDefault("includeUninitialized")
  valid_579023 = validateParameter(valid_579023, JBool, required = false, default = nil)
  if valid_579023 != nil:
    section.add "includeUninitialized", valid_579023
  var valid_579024 = query.getOrDefault("prettyPrint")
  valid_579024 = validateParameter(valid_579024, JBool, required = false,
                                 default = newJBool(true))
  if valid_579024 != nil:
    section.add "prettyPrint", valid_579024
  var valid_579025 = query.getOrDefault("oauth_token")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "oauth_token", valid_579025
  var valid_579026 = query.getOrDefault("fieldSelector")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "fieldSelector", valid_579026
  var valid_579027 = query.getOrDefault("labelSelector")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "labelSelector", valid_579027
  var valid_579028 = query.getOrDefault("$.xgafv")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = newJString("1"))
  if valid_579028 != nil:
    section.add "$.xgafv", valid_579028
  var valid_579029 = query.getOrDefault("limit")
  valid_579029 = validateParameter(valid_579029, JInt, required = false, default = nil)
  if valid_579029 != nil:
    section.add "limit", valid_579029
  var valid_579030 = query.getOrDefault("alt")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("json"))
  if valid_579030 != nil:
    section.add "alt", valid_579030
  var valid_579031 = query.getOrDefault("uploadType")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "uploadType", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("watch")
  valid_579033 = validateParameter(valid_579033, JBool, required = false, default = nil)
  if valid_579033 != nil:
    section.add "watch", valid_579033
  var valid_579034 = query.getOrDefault("callback")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "callback", valid_579034
  var valid_579035 = query.getOrDefault("resourceVersion")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "resourceVersion", valid_579035
  var valid_579036 = query.getOrDefault("fields")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "fields", valid_579036
  var valid_579037 = query.getOrDefault("access_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "access_token", valid_579037
  var valid_579038 = query.getOrDefault("upload_protocol")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "upload_protocol", valid_579038
  var valid_579039 = query.getOrDefault("continue")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "continue", valid_579039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579040: Call_RunNamespacesDomainmappingsList_579018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_579040.validator(path, query, header, formData, body)
  let scheme = call_579040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579040.url(scheme.get, call_579040.host, call_579040.base,
                         call_579040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579040, url, valid)

proc call*(call_579041: Call_RunNamespacesDomainmappingsList_579018;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesDomainmappingsList
  ## List domain mappings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579042 = newJObject()
  var query_579043 = newJObject()
  add(query_579043, "key", newJString(key))
  add(query_579043, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579043, "prettyPrint", newJBool(prettyPrint))
  add(query_579043, "oauth_token", newJString(oauthToken))
  add(query_579043, "fieldSelector", newJString(fieldSelector))
  add(query_579043, "labelSelector", newJString(labelSelector))
  add(query_579043, "$.xgafv", newJString(Xgafv))
  add(query_579043, "limit", newJInt(limit))
  add(query_579043, "alt", newJString(alt))
  add(query_579043, "uploadType", newJString(uploadType))
  add(query_579043, "quotaUser", newJString(quotaUser))
  add(query_579043, "watch", newJBool(watch))
  add(query_579043, "callback", newJString(callback))
  add(path_579042, "parent", newJString(parent))
  add(query_579043, "resourceVersion", newJString(resourceVersion))
  add(query_579043, "fields", newJString(fields))
  add(query_579043, "access_token", newJString(accessToken))
  add(query_579043, "upload_protocol", newJString(uploadProtocol))
  add(query_579043, "continue", newJString(`continue`))
  result = call_579041.call(path_579042, query_579043, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_579018(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_579019, base: "/",
    url: url_RunNamespacesDomainmappingsList_579020, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsReplaceConfiguration_579084 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesConfigurationsReplaceConfiguration_579086(protocol: Scheme;
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

proc validate_RunNamespacesConfigurationsReplaceConfiguration_579085(
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
  var valid_579087 = path.getOrDefault("name")
  valid_579087 = validateParameter(valid_579087, JString, required = true,
                                 default = nil)
  if valid_579087 != nil:
    section.add "name", valid_579087
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
  var valid_579088 = query.getOrDefault("key")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "key", valid_579088
  var valid_579089 = query.getOrDefault("prettyPrint")
  valid_579089 = validateParameter(valid_579089, JBool, required = false,
                                 default = newJBool(true))
  if valid_579089 != nil:
    section.add "prettyPrint", valid_579089
  var valid_579090 = query.getOrDefault("oauth_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "oauth_token", valid_579090
  var valid_579091 = query.getOrDefault("$.xgafv")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("1"))
  if valid_579091 != nil:
    section.add "$.xgafv", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("uploadType")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "uploadType", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("callback")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "callback", valid_579095
  var valid_579096 = query.getOrDefault("fields")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "fields", valid_579096
  var valid_579097 = query.getOrDefault("access_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "access_token", valid_579097
  var valid_579098 = query.getOrDefault("upload_protocol")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "upload_protocol", valid_579098
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

proc call*(call_579100: Call_RunNamespacesConfigurationsReplaceConfiguration_579084;
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
  let valid = call_579100.validator(path, query, header, formData, body)
  let scheme = call_579100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579100.url(scheme.get, call_579100.host, call_579100.base,
                         call_579100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579100, url, valid)

proc call*(call_579101: Call_RunNamespacesConfigurationsReplaceConfiguration_579084;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesConfigurationsReplaceConfiguration
  ## Replace a configuration.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
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
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579102 = newJObject()
  var query_579103 = newJObject()
  var body_579104 = newJObject()
  add(query_579103, "key", newJString(key))
  add(query_579103, "prettyPrint", newJBool(prettyPrint))
  add(query_579103, "oauth_token", newJString(oauthToken))
  add(query_579103, "$.xgafv", newJString(Xgafv))
  add(query_579103, "alt", newJString(alt))
  add(query_579103, "uploadType", newJString(uploadType))
  add(query_579103, "quotaUser", newJString(quotaUser))
  add(path_579102, "name", newJString(name))
  if body != nil:
    body_579104 = body
  add(query_579103, "callback", newJString(callback))
  add(query_579103, "fields", newJString(fields))
  add(query_579103, "access_token", newJString(accessToken))
  add(query_579103, "upload_protocol", newJString(uploadProtocol))
  result = call_579101.call(path_579102, query_579103, nil, nil, body_579104)

var runNamespacesConfigurationsReplaceConfiguration* = Call_RunNamespacesConfigurationsReplaceConfiguration_579084(
    name: "runNamespacesConfigurationsReplaceConfiguration",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsReplaceConfiguration_579085,
    base: "/", url: url_RunNamespacesConfigurationsReplaceConfiguration_579086,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsGet_579065 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesConfigurationsGet_579067(protocol: Scheme; host: string;
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

proc validate_RunNamespacesConfigurationsGet_579066(path: JsonNode;
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
  var valid_579068 = path.getOrDefault("name")
  valid_579068 = validateParameter(valid_579068, JString, required = true,
                                 default = nil)
  if valid_579068 != nil:
    section.add "name", valid_579068
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
  var valid_579069 = query.getOrDefault("key")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "key", valid_579069
  var valid_579070 = query.getOrDefault("prettyPrint")
  valid_579070 = validateParameter(valid_579070, JBool, required = false,
                                 default = newJBool(true))
  if valid_579070 != nil:
    section.add "prettyPrint", valid_579070
  var valid_579071 = query.getOrDefault("oauth_token")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "oauth_token", valid_579071
  var valid_579072 = query.getOrDefault("$.xgafv")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = newJString("1"))
  if valid_579072 != nil:
    section.add "$.xgafv", valid_579072
  var valid_579073 = query.getOrDefault("alt")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = newJString("json"))
  if valid_579073 != nil:
    section.add "alt", valid_579073
  var valid_579074 = query.getOrDefault("uploadType")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "uploadType", valid_579074
  var valid_579075 = query.getOrDefault("quotaUser")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "quotaUser", valid_579075
  var valid_579076 = query.getOrDefault("callback")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "callback", valid_579076
  var valid_579077 = query.getOrDefault("fields")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "fields", valid_579077
  var valid_579078 = query.getOrDefault("access_token")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "access_token", valid_579078
  var valid_579079 = query.getOrDefault("upload_protocol")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "upload_protocol", valid_579079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579080: Call_RunNamespacesConfigurationsGet_579065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a configuration.
  ## 
  let valid = call_579080.validator(path, query, header, formData, body)
  let scheme = call_579080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579080.url(scheme.get, call_579080.host, call_579080.base,
                         call_579080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579080, url, valid)

proc call*(call_579081: Call_RunNamespacesConfigurationsGet_579065; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesConfigurationsGet
  ## Get information about a configuration.
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
  ##       : The name of the configuration being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579082 = newJObject()
  var query_579083 = newJObject()
  add(query_579083, "key", newJString(key))
  add(query_579083, "prettyPrint", newJBool(prettyPrint))
  add(query_579083, "oauth_token", newJString(oauthToken))
  add(query_579083, "$.xgafv", newJString(Xgafv))
  add(query_579083, "alt", newJString(alt))
  add(query_579083, "uploadType", newJString(uploadType))
  add(query_579083, "quotaUser", newJString(quotaUser))
  add(path_579082, "name", newJString(name))
  add(query_579083, "callback", newJString(callback))
  add(query_579083, "fields", newJString(fields))
  add(query_579083, "access_token", newJString(accessToken))
  add(query_579083, "upload_protocol", newJString(uploadProtocol))
  result = call_579081.call(path_579082, query_579083, nil, nil, nil)

var runNamespacesConfigurationsGet* = Call_RunNamespacesConfigurationsGet_579065(
    name: "runNamespacesConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsGet_579066, base: "/",
    url: url_RunNamespacesConfigurationsGet_579067, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsDelete_579105 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesConfigurationsDelete_579107(protocol: Scheme; host: string;
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

proc validate_RunNamespacesConfigurationsDelete_579106(path: JsonNode;
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
  var valid_579108 = path.getOrDefault("name")
  valid_579108 = validateParameter(valid_579108, JString, required = true,
                                 default = nil)
  if valid_579108 != nil:
    section.add "name", valid_579108
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
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: JString
  ##           : JSONP
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579109 = query.getOrDefault("key")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "key", valid_579109
  var valid_579110 = query.getOrDefault("prettyPrint")
  valid_579110 = validateParameter(valid_579110, JBool, required = false,
                                 default = newJBool(true))
  if valid_579110 != nil:
    section.add "prettyPrint", valid_579110
  var valid_579111 = query.getOrDefault("oauth_token")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "oauth_token", valid_579111
  var valid_579112 = query.getOrDefault("$.xgafv")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = newJString("1"))
  if valid_579112 != nil:
    section.add "$.xgafv", valid_579112
  var valid_579113 = query.getOrDefault("alt")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = newJString("json"))
  if valid_579113 != nil:
    section.add "alt", valid_579113
  var valid_579114 = query.getOrDefault("uploadType")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "uploadType", valid_579114
  var valid_579115 = query.getOrDefault("quotaUser")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "quotaUser", valid_579115
  var valid_579116 = query.getOrDefault("propagationPolicy")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "propagationPolicy", valid_579116
  var valid_579117 = query.getOrDefault("callback")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "callback", valid_579117
  var valid_579118 = query.getOrDefault("apiVersion")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "apiVersion", valid_579118
  var valid_579119 = query.getOrDefault("kind")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "kind", valid_579119
  var valid_579120 = query.getOrDefault("fields")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "fields", valid_579120
  var valid_579121 = query.getOrDefault("access_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "access_token", valid_579121
  var valid_579122 = query.getOrDefault("upload_protocol")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "upload_protocol", valid_579122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579123: Call_RunNamespacesConfigurationsDelete_579105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ## 
  let valid = call_579123.validator(path, query, header, formData, body)
  let scheme = call_579123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579123.url(scheme.get, call_579123.host, call_579123.base,
                         call_579123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579123, url, valid)

proc call*(call_579124: Call_RunNamespacesConfigurationsDelete_579105;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; kind: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesConfigurationsDelete
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
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
  ##       : The name of the configuration being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: string
  ##           : JSONP
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579125 = newJObject()
  var query_579126 = newJObject()
  add(query_579126, "key", newJString(key))
  add(query_579126, "prettyPrint", newJBool(prettyPrint))
  add(query_579126, "oauth_token", newJString(oauthToken))
  add(query_579126, "$.xgafv", newJString(Xgafv))
  add(query_579126, "alt", newJString(alt))
  add(query_579126, "uploadType", newJString(uploadType))
  add(query_579126, "quotaUser", newJString(quotaUser))
  add(path_579125, "name", newJString(name))
  add(query_579126, "propagationPolicy", newJString(propagationPolicy))
  add(query_579126, "callback", newJString(callback))
  add(query_579126, "apiVersion", newJString(apiVersion))
  add(query_579126, "kind", newJString(kind))
  add(query_579126, "fields", newJString(fields))
  add(query_579126, "access_token", newJString(accessToken))
  add(query_579126, "upload_protocol", newJString(uploadProtocol))
  result = call_579124.call(path_579125, query_579126, nil, nil, nil)

var runNamespacesConfigurationsDelete* = Call_RunNamespacesConfigurationsDelete_579105(
    name: "runNamespacesConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsDelete_579106, base: "/",
    url: url_RunNamespacesConfigurationsDelete_579107, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsCreate_579153 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesConfigurationsCreate_579155(protocol: Scheme; host: string;
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

proc validate_RunNamespacesConfigurationsCreate_579154(path: JsonNode;
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
  var valid_579156 = path.getOrDefault("parent")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "parent", valid_579156
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
  var valid_579157 = query.getOrDefault("key")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "key", valid_579157
  var valid_579158 = query.getOrDefault("prettyPrint")
  valid_579158 = validateParameter(valid_579158, JBool, required = false,
                                 default = newJBool(true))
  if valid_579158 != nil:
    section.add "prettyPrint", valid_579158
  var valid_579159 = query.getOrDefault("oauth_token")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "oauth_token", valid_579159
  var valid_579160 = query.getOrDefault("$.xgafv")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = newJString("1"))
  if valid_579160 != nil:
    section.add "$.xgafv", valid_579160
  var valid_579161 = query.getOrDefault("alt")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("json"))
  if valid_579161 != nil:
    section.add "alt", valid_579161
  var valid_579162 = query.getOrDefault("uploadType")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "uploadType", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("callback")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "callback", valid_579164
  var valid_579165 = query.getOrDefault("fields")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "fields", valid_579165
  var valid_579166 = query.getOrDefault("access_token")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "access_token", valid_579166
  var valid_579167 = query.getOrDefault("upload_protocol")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "upload_protocol", valid_579167
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

proc call*(call_579169: Call_RunNamespacesConfigurationsCreate_579153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_579169.validator(path, query, header, formData, body)
  let scheme = call_579169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579169.url(scheme.get, call_579169.host, call_579169.base,
                         call_579169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579169, url, valid)

proc call*(call_579170: Call_RunNamespacesConfigurationsCreate_579153;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runNamespacesConfigurationsCreate
  ## Create a configuration.
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
  ##         : The project ID or project number in which this configuration should be
  ## created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579171 = newJObject()
  var query_579172 = newJObject()
  var body_579173 = newJObject()
  add(query_579172, "key", newJString(key))
  add(query_579172, "prettyPrint", newJBool(prettyPrint))
  add(query_579172, "oauth_token", newJString(oauthToken))
  add(query_579172, "$.xgafv", newJString(Xgafv))
  add(query_579172, "alt", newJString(alt))
  add(query_579172, "uploadType", newJString(uploadType))
  add(query_579172, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579173 = body
  add(query_579172, "callback", newJString(callback))
  add(path_579171, "parent", newJString(parent))
  add(query_579172, "fields", newJString(fields))
  add(query_579172, "access_token", newJString(accessToken))
  add(query_579172, "upload_protocol", newJString(uploadProtocol))
  result = call_579170.call(path_579171, query_579172, nil, nil, body_579173)

var runNamespacesConfigurationsCreate* = Call_RunNamespacesConfigurationsCreate_579153(
    name: "runNamespacesConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsCreate_579154, base: "/",
    url: url_RunNamespacesConfigurationsCreate_579155, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_579127 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesConfigurationsList_579129(protocol: Scheme; host: string;
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

proc validate_RunNamespacesConfigurationsList_579128(path: JsonNode;
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
  var valid_579130 = path.getOrDefault("parent")
  valid_579130 = validateParameter(valid_579130, JString, required = true,
                                 default = nil)
  if valid_579130 != nil:
    section.add "parent", valid_579130
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579131 = query.getOrDefault("key")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "key", valid_579131
  var valid_579132 = query.getOrDefault("includeUninitialized")
  valid_579132 = validateParameter(valid_579132, JBool, required = false, default = nil)
  if valid_579132 != nil:
    section.add "includeUninitialized", valid_579132
  var valid_579133 = query.getOrDefault("prettyPrint")
  valid_579133 = validateParameter(valid_579133, JBool, required = false,
                                 default = newJBool(true))
  if valid_579133 != nil:
    section.add "prettyPrint", valid_579133
  var valid_579134 = query.getOrDefault("oauth_token")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "oauth_token", valid_579134
  var valid_579135 = query.getOrDefault("fieldSelector")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "fieldSelector", valid_579135
  var valid_579136 = query.getOrDefault("labelSelector")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "labelSelector", valid_579136
  var valid_579137 = query.getOrDefault("$.xgafv")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = newJString("1"))
  if valid_579137 != nil:
    section.add "$.xgafv", valid_579137
  var valid_579138 = query.getOrDefault("limit")
  valid_579138 = validateParameter(valid_579138, JInt, required = false, default = nil)
  if valid_579138 != nil:
    section.add "limit", valid_579138
  var valid_579139 = query.getOrDefault("alt")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("json"))
  if valid_579139 != nil:
    section.add "alt", valid_579139
  var valid_579140 = query.getOrDefault("uploadType")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "uploadType", valid_579140
  var valid_579141 = query.getOrDefault("quotaUser")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "quotaUser", valid_579141
  var valid_579142 = query.getOrDefault("watch")
  valid_579142 = validateParameter(valid_579142, JBool, required = false, default = nil)
  if valid_579142 != nil:
    section.add "watch", valid_579142
  var valid_579143 = query.getOrDefault("callback")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "callback", valid_579143
  var valid_579144 = query.getOrDefault("resourceVersion")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "resourceVersion", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
  var valid_579146 = query.getOrDefault("access_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "access_token", valid_579146
  var valid_579147 = query.getOrDefault("upload_protocol")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "upload_protocol", valid_579147
  var valid_579148 = query.getOrDefault("continue")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "continue", valid_579148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579149: Call_RunNamespacesConfigurationsList_579127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_579149.validator(path, query, header, formData, body)
  let scheme = call_579149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579149.url(scheme.get, call_579149.host, call_579149.base,
                         call_579149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579149, url, valid)

proc call*(call_579150: Call_RunNamespacesConfigurationsList_579127;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesConfigurationsList
  ## List configurations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579151 = newJObject()
  var query_579152 = newJObject()
  add(query_579152, "key", newJString(key))
  add(query_579152, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579152, "prettyPrint", newJBool(prettyPrint))
  add(query_579152, "oauth_token", newJString(oauthToken))
  add(query_579152, "fieldSelector", newJString(fieldSelector))
  add(query_579152, "labelSelector", newJString(labelSelector))
  add(query_579152, "$.xgafv", newJString(Xgafv))
  add(query_579152, "limit", newJInt(limit))
  add(query_579152, "alt", newJString(alt))
  add(query_579152, "uploadType", newJString(uploadType))
  add(query_579152, "quotaUser", newJString(quotaUser))
  add(query_579152, "watch", newJBool(watch))
  add(query_579152, "callback", newJString(callback))
  add(path_579151, "parent", newJString(parent))
  add(query_579152, "resourceVersion", newJString(resourceVersion))
  add(query_579152, "fields", newJString(fields))
  add(query_579152, "access_token", newJString(accessToken))
  add(query_579152, "upload_protocol", newJString(uploadProtocol))
  add(query_579152, "continue", newJString(`continue`))
  result = call_579150.call(path_579151, query_579152, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_579127(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_579128, base: "/",
    url: url_RunNamespacesConfigurationsList_579129, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_579174 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesRevisionsList_579176(protocol: Scheme; host: string;
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

proc validate_RunNamespacesRevisionsList_579175(path: JsonNode; query: JsonNode;
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
  var valid_579177 = path.getOrDefault("parent")
  valid_579177 = validateParameter(valid_579177, JString, required = true,
                                 default = nil)
  if valid_579177 != nil:
    section.add "parent", valid_579177
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579178 = query.getOrDefault("key")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "key", valid_579178
  var valid_579179 = query.getOrDefault("includeUninitialized")
  valid_579179 = validateParameter(valid_579179, JBool, required = false, default = nil)
  if valid_579179 != nil:
    section.add "includeUninitialized", valid_579179
  var valid_579180 = query.getOrDefault("prettyPrint")
  valid_579180 = validateParameter(valid_579180, JBool, required = false,
                                 default = newJBool(true))
  if valid_579180 != nil:
    section.add "prettyPrint", valid_579180
  var valid_579181 = query.getOrDefault("oauth_token")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "oauth_token", valid_579181
  var valid_579182 = query.getOrDefault("fieldSelector")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "fieldSelector", valid_579182
  var valid_579183 = query.getOrDefault("labelSelector")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "labelSelector", valid_579183
  var valid_579184 = query.getOrDefault("$.xgafv")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = newJString("1"))
  if valid_579184 != nil:
    section.add "$.xgafv", valid_579184
  var valid_579185 = query.getOrDefault("limit")
  valid_579185 = validateParameter(valid_579185, JInt, required = false, default = nil)
  if valid_579185 != nil:
    section.add "limit", valid_579185
  var valid_579186 = query.getOrDefault("alt")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = newJString("json"))
  if valid_579186 != nil:
    section.add "alt", valid_579186
  var valid_579187 = query.getOrDefault("uploadType")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "uploadType", valid_579187
  var valid_579188 = query.getOrDefault("quotaUser")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "quotaUser", valid_579188
  var valid_579189 = query.getOrDefault("watch")
  valid_579189 = validateParameter(valid_579189, JBool, required = false, default = nil)
  if valid_579189 != nil:
    section.add "watch", valid_579189
  var valid_579190 = query.getOrDefault("callback")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "callback", valid_579190
  var valid_579191 = query.getOrDefault("resourceVersion")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "resourceVersion", valid_579191
  var valid_579192 = query.getOrDefault("fields")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "fields", valid_579192
  var valid_579193 = query.getOrDefault("access_token")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "access_token", valid_579193
  var valid_579194 = query.getOrDefault("upload_protocol")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "upload_protocol", valid_579194
  var valid_579195 = query.getOrDefault("continue")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "continue", valid_579195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579196: Call_RunNamespacesRevisionsList_579174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_579196.validator(path, query, header, formData, body)
  let scheme = call_579196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579196.url(scheme.get, call_579196.host, call_579196.base,
                         call_579196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579196, url, valid)

proc call*(call_579197: Call_RunNamespacesRevisionsList_579174; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesRevisionsList
  ## List revisions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the revisions should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579198 = newJObject()
  var query_579199 = newJObject()
  add(query_579199, "key", newJString(key))
  add(query_579199, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579199, "prettyPrint", newJBool(prettyPrint))
  add(query_579199, "oauth_token", newJString(oauthToken))
  add(query_579199, "fieldSelector", newJString(fieldSelector))
  add(query_579199, "labelSelector", newJString(labelSelector))
  add(query_579199, "$.xgafv", newJString(Xgafv))
  add(query_579199, "limit", newJInt(limit))
  add(query_579199, "alt", newJString(alt))
  add(query_579199, "uploadType", newJString(uploadType))
  add(query_579199, "quotaUser", newJString(quotaUser))
  add(query_579199, "watch", newJBool(watch))
  add(query_579199, "callback", newJString(callback))
  add(path_579198, "parent", newJString(parent))
  add(query_579199, "resourceVersion", newJString(resourceVersion))
  add(query_579199, "fields", newJString(fields))
  add(query_579199, "access_token", newJString(accessToken))
  add(query_579199, "upload_protocol", newJString(uploadProtocol))
  add(query_579199, "continue", newJString(`continue`))
  result = call_579197.call(path_579198, query_579199, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_579174(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_579175, base: "/",
    url: url_RunNamespacesRevisionsList_579176, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesCreate_579226 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesRoutesCreate_579228(protocol: Scheme; host: string;
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

proc validate_RunNamespacesRoutesCreate_579227(path: JsonNode; query: JsonNode;
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
  var valid_579229 = path.getOrDefault("parent")
  valid_579229 = validateParameter(valid_579229, JString, required = true,
                                 default = nil)
  if valid_579229 != nil:
    section.add "parent", valid_579229
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
  var valid_579230 = query.getOrDefault("key")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "key", valid_579230
  var valid_579231 = query.getOrDefault("prettyPrint")
  valid_579231 = validateParameter(valid_579231, JBool, required = false,
                                 default = newJBool(true))
  if valid_579231 != nil:
    section.add "prettyPrint", valid_579231
  var valid_579232 = query.getOrDefault("oauth_token")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "oauth_token", valid_579232
  var valid_579233 = query.getOrDefault("$.xgafv")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = newJString("1"))
  if valid_579233 != nil:
    section.add "$.xgafv", valid_579233
  var valid_579234 = query.getOrDefault("alt")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = newJString("json"))
  if valid_579234 != nil:
    section.add "alt", valid_579234
  var valid_579235 = query.getOrDefault("uploadType")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "uploadType", valid_579235
  var valid_579236 = query.getOrDefault("quotaUser")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "quotaUser", valid_579236
  var valid_579237 = query.getOrDefault("callback")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "callback", valid_579237
  var valid_579238 = query.getOrDefault("fields")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "fields", valid_579238
  var valid_579239 = query.getOrDefault("access_token")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "access_token", valid_579239
  var valid_579240 = query.getOrDefault("upload_protocol")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "upload_protocol", valid_579240
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

proc call*(call_579242: Call_RunNamespacesRoutesCreate_579226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_579242.validator(path, query, header, formData, body)
  let scheme = call_579242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579242.url(scheme.get, call_579242.host, call_579242.base,
                         call_579242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579242, url, valid)

proc call*(call_579243: Call_RunNamespacesRoutesCreate_579226; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesRoutesCreate
  ## Create a route.
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
  ##         : The project ID or project number in which this route should be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579244 = newJObject()
  var query_579245 = newJObject()
  var body_579246 = newJObject()
  add(query_579245, "key", newJString(key))
  add(query_579245, "prettyPrint", newJBool(prettyPrint))
  add(query_579245, "oauth_token", newJString(oauthToken))
  add(query_579245, "$.xgafv", newJString(Xgafv))
  add(query_579245, "alt", newJString(alt))
  add(query_579245, "uploadType", newJString(uploadType))
  add(query_579245, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579246 = body
  add(query_579245, "callback", newJString(callback))
  add(path_579244, "parent", newJString(parent))
  add(query_579245, "fields", newJString(fields))
  add(query_579245, "access_token", newJString(accessToken))
  add(query_579245, "upload_protocol", newJString(uploadProtocol))
  result = call_579243.call(path_579244, query_579245, nil, nil, body_579246)

var runNamespacesRoutesCreate* = Call_RunNamespacesRoutesCreate_579226(
    name: "runNamespacesRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesCreate_579227, base: "/",
    url: url_RunNamespacesRoutesCreate_579228, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_579200 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesRoutesList_579202(protocol: Scheme; host: string; base: string;
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

proc validate_RunNamespacesRoutesList_579201(path: JsonNode; query: JsonNode;
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
  var valid_579203 = path.getOrDefault("parent")
  valid_579203 = validateParameter(valid_579203, JString, required = true,
                                 default = nil)
  if valid_579203 != nil:
    section.add "parent", valid_579203
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579204 = query.getOrDefault("key")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "key", valid_579204
  var valid_579205 = query.getOrDefault("includeUninitialized")
  valid_579205 = validateParameter(valid_579205, JBool, required = false, default = nil)
  if valid_579205 != nil:
    section.add "includeUninitialized", valid_579205
  var valid_579206 = query.getOrDefault("prettyPrint")
  valid_579206 = validateParameter(valid_579206, JBool, required = false,
                                 default = newJBool(true))
  if valid_579206 != nil:
    section.add "prettyPrint", valid_579206
  var valid_579207 = query.getOrDefault("oauth_token")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "oauth_token", valid_579207
  var valid_579208 = query.getOrDefault("fieldSelector")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "fieldSelector", valid_579208
  var valid_579209 = query.getOrDefault("labelSelector")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "labelSelector", valid_579209
  var valid_579210 = query.getOrDefault("$.xgafv")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = newJString("1"))
  if valid_579210 != nil:
    section.add "$.xgafv", valid_579210
  var valid_579211 = query.getOrDefault("limit")
  valid_579211 = validateParameter(valid_579211, JInt, required = false, default = nil)
  if valid_579211 != nil:
    section.add "limit", valid_579211
  var valid_579212 = query.getOrDefault("alt")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = newJString("json"))
  if valid_579212 != nil:
    section.add "alt", valid_579212
  var valid_579213 = query.getOrDefault("uploadType")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "uploadType", valid_579213
  var valid_579214 = query.getOrDefault("quotaUser")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "quotaUser", valid_579214
  var valid_579215 = query.getOrDefault("watch")
  valid_579215 = validateParameter(valid_579215, JBool, required = false, default = nil)
  if valid_579215 != nil:
    section.add "watch", valid_579215
  var valid_579216 = query.getOrDefault("callback")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "callback", valid_579216
  var valid_579217 = query.getOrDefault("resourceVersion")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "resourceVersion", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  var valid_579219 = query.getOrDefault("access_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "access_token", valid_579219
  var valid_579220 = query.getOrDefault("upload_protocol")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "upload_protocol", valid_579220
  var valid_579221 = query.getOrDefault("continue")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "continue", valid_579221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579222: Call_RunNamespacesRoutesList_579200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_579222.validator(path, query, header, formData, body)
  let scheme = call_579222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579222.url(scheme.get, call_579222.host, call_579222.base,
                         call_579222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579222, url, valid)

proc call*(call_579223: Call_RunNamespacesRoutesList_579200; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesRoutesList
  ## List routes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the routes should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579224 = newJObject()
  var query_579225 = newJObject()
  add(query_579225, "key", newJString(key))
  add(query_579225, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579225, "prettyPrint", newJBool(prettyPrint))
  add(query_579225, "oauth_token", newJString(oauthToken))
  add(query_579225, "fieldSelector", newJString(fieldSelector))
  add(query_579225, "labelSelector", newJString(labelSelector))
  add(query_579225, "$.xgafv", newJString(Xgafv))
  add(query_579225, "limit", newJInt(limit))
  add(query_579225, "alt", newJString(alt))
  add(query_579225, "uploadType", newJString(uploadType))
  add(query_579225, "quotaUser", newJString(quotaUser))
  add(query_579225, "watch", newJBool(watch))
  add(query_579225, "callback", newJString(callback))
  add(path_579224, "parent", newJString(parent))
  add(query_579225, "resourceVersion", newJString(resourceVersion))
  add(query_579225, "fields", newJString(fields))
  add(query_579225, "access_token", newJString(accessToken))
  add(query_579225, "upload_protocol", newJString(uploadProtocol))
  add(query_579225, "continue", newJString(`continue`))
  result = call_579223.call(path_579224, query_579225, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_579200(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_579201, base: "/",
    url: url_RunNamespacesRoutesList_579202, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_579273 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesServicesCreate_579275(protocol: Scheme; host: string;
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

proc validate_RunNamespacesServicesCreate_579274(path: JsonNode; query: JsonNode;
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
  var valid_579276 = path.getOrDefault("parent")
  valid_579276 = validateParameter(valid_579276, JString, required = true,
                                 default = nil)
  if valid_579276 != nil:
    section.add "parent", valid_579276
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
  var valid_579277 = query.getOrDefault("key")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "key", valid_579277
  var valid_579278 = query.getOrDefault("prettyPrint")
  valid_579278 = validateParameter(valid_579278, JBool, required = false,
                                 default = newJBool(true))
  if valid_579278 != nil:
    section.add "prettyPrint", valid_579278
  var valid_579279 = query.getOrDefault("oauth_token")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "oauth_token", valid_579279
  var valid_579280 = query.getOrDefault("$.xgafv")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = newJString("1"))
  if valid_579280 != nil:
    section.add "$.xgafv", valid_579280
  var valid_579281 = query.getOrDefault("alt")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = newJString("json"))
  if valid_579281 != nil:
    section.add "alt", valid_579281
  var valid_579282 = query.getOrDefault("uploadType")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "uploadType", valid_579282
  var valid_579283 = query.getOrDefault("quotaUser")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "quotaUser", valid_579283
  var valid_579284 = query.getOrDefault("callback")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "callback", valid_579284
  var valid_579285 = query.getOrDefault("fields")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "fields", valid_579285
  var valid_579286 = query.getOrDefault("access_token")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "access_token", valid_579286
  var valid_579287 = query.getOrDefault("upload_protocol")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "upload_protocol", valid_579287
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

proc call*(call_579289: Call_RunNamespacesServicesCreate_579273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_579289.validator(path, query, header, formData, body)
  let scheme = call_579289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579289.url(scheme.get, call_579289.host, call_579289.base,
                         call_579289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579289, url, valid)

proc call*(call_579290: Call_RunNamespacesServicesCreate_579273; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesServicesCreate
  ## Create a service.
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
  ##         : The project ID or project number in which this service should be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579291 = newJObject()
  var query_579292 = newJObject()
  var body_579293 = newJObject()
  add(query_579292, "key", newJString(key))
  add(query_579292, "prettyPrint", newJBool(prettyPrint))
  add(query_579292, "oauth_token", newJString(oauthToken))
  add(query_579292, "$.xgafv", newJString(Xgafv))
  add(query_579292, "alt", newJString(alt))
  add(query_579292, "uploadType", newJString(uploadType))
  add(query_579292, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579293 = body
  add(query_579292, "callback", newJString(callback))
  add(path_579291, "parent", newJString(parent))
  add(query_579292, "fields", newJString(fields))
  add(query_579292, "access_token", newJString(accessToken))
  add(query_579292, "upload_protocol", newJString(uploadProtocol))
  result = call_579290.call(path_579291, query_579292, nil, nil, body_579293)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_579273(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_579274, base: "/",
    url: url_RunNamespacesServicesCreate_579275, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_579247 = ref object of OpenApiRestCall_578348
proc url_RunNamespacesServicesList_579249(protocol: Scheme; host: string;
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

proc validate_RunNamespacesServicesList_579248(path: JsonNode; query: JsonNode;
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
  var valid_579250 = path.getOrDefault("parent")
  valid_579250 = validateParameter(valid_579250, JString, required = true,
                                 default = nil)
  if valid_579250 != nil:
    section.add "parent", valid_579250
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579251 = query.getOrDefault("key")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "key", valid_579251
  var valid_579252 = query.getOrDefault("includeUninitialized")
  valid_579252 = validateParameter(valid_579252, JBool, required = false, default = nil)
  if valid_579252 != nil:
    section.add "includeUninitialized", valid_579252
  var valid_579253 = query.getOrDefault("prettyPrint")
  valid_579253 = validateParameter(valid_579253, JBool, required = false,
                                 default = newJBool(true))
  if valid_579253 != nil:
    section.add "prettyPrint", valid_579253
  var valid_579254 = query.getOrDefault("oauth_token")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "oauth_token", valid_579254
  var valid_579255 = query.getOrDefault("fieldSelector")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "fieldSelector", valid_579255
  var valid_579256 = query.getOrDefault("labelSelector")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "labelSelector", valid_579256
  var valid_579257 = query.getOrDefault("$.xgafv")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = newJString("1"))
  if valid_579257 != nil:
    section.add "$.xgafv", valid_579257
  var valid_579258 = query.getOrDefault("limit")
  valid_579258 = validateParameter(valid_579258, JInt, required = false, default = nil)
  if valid_579258 != nil:
    section.add "limit", valid_579258
  var valid_579259 = query.getOrDefault("alt")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = newJString("json"))
  if valid_579259 != nil:
    section.add "alt", valid_579259
  var valid_579260 = query.getOrDefault("uploadType")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "uploadType", valid_579260
  var valid_579261 = query.getOrDefault("quotaUser")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "quotaUser", valid_579261
  var valid_579262 = query.getOrDefault("watch")
  valid_579262 = validateParameter(valid_579262, JBool, required = false, default = nil)
  if valid_579262 != nil:
    section.add "watch", valid_579262
  var valid_579263 = query.getOrDefault("callback")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "callback", valid_579263
  var valid_579264 = query.getOrDefault("resourceVersion")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "resourceVersion", valid_579264
  var valid_579265 = query.getOrDefault("fields")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "fields", valid_579265
  var valid_579266 = query.getOrDefault("access_token")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "access_token", valid_579266
  var valid_579267 = query.getOrDefault("upload_protocol")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "upload_protocol", valid_579267
  var valid_579268 = query.getOrDefault("continue")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "continue", valid_579268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579269: Call_RunNamespacesServicesList_579247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_579269.validator(path, query, header, formData, body)
  let scheme = call_579269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579269.url(scheme.get, call_579269.host, call_579269.base,
                         call_579269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579269, url, valid)

proc call*(call_579270: Call_RunNamespacesServicesList_579247; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runNamespacesServicesList
  ## List services.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the services should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579271 = newJObject()
  var query_579272 = newJObject()
  add(query_579272, "key", newJString(key))
  add(query_579272, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579272, "prettyPrint", newJBool(prettyPrint))
  add(query_579272, "oauth_token", newJString(oauthToken))
  add(query_579272, "fieldSelector", newJString(fieldSelector))
  add(query_579272, "labelSelector", newJString(labelSelector))
  add(query_579272, "$.xgafv", newJString(Xgafv))
  add(query_579272, "limit", newJInt(limit))
  add(query_579272, "alt", newJString(alt))
  add(query_579272, "uploadType", newJString(uploadType))
  add(query_579272, "quotaUser", newJString(quotaUser))
  add(query_579272, "watch", newJBool(watch))
  add(query_579272, "callback", newJString(callback))
  add(path_579271, "parent", newJString(parent))
  add(query_579272, "resourceVersion", newJString(resourceVersion))
  add(query_579272, "fields", newJString(fields))
  add(query_579272, "access_token", newJString(accessToken))
  add(query_579272, "upload_protocol", newJString(uploadProtocol))
  add(query_579272, "continue", newJString(`continue`))
  result = call_579270.call(path_579271, query_579272, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_579247(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesList_579248, base: "/",
    url: url_RunNamespacesServicesList_579249, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesReplaceService_579313 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesReplaceService_579315(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesReplaceService_579314(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Replace a service.
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
  ##       : The name of the service being replaced. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579316 = path.getOrDefault("name")
  valid_579316 = validateParameter(valid_579316, JString, required = true,
                                 default = nil)
  if valid_579316 != nil:
    section.add "name", valid_579316
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
  var valid_579317 = query.getOrDefault("key")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "key", valid_579317
  var valid_579318 = query.getOrDefault("prettyPrint")
  valid_579318 = validateParameter(valid_579318, JBool, required = false,
                                 default = newJBool(true))
  if valid_579318 != nil:
    section.add "prettyPrint", valid_579318
  var valid_579319 = query.getOrDefault("oauth_token")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "oauth_token", valid_579319
  var valid_579320 = query.getOrDefault("$.xgafv")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("1"))
  if valid_579320 != nil:
    section.add "$.xgafv", valid_579320
  var valid_579321 = query.getOrDefault("alt")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = newJString("json"))
  if valid_579321 != nil:
    section.add "alt", valid_579321
  var valid_579322 = query.getOrDefault("uploadType")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "uploadType", valid_579322
  var valid_579323 = query.getOrDefault("quotaUser")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "quotaUser", valid_579323
  var valid_579324 = query.getOrDefault("callback")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "callback", valid_579324
  var valid_579325 = query.getOrDefault("fields")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "fields", valid_579325
  var valid_579326 = query.getOrDefault("access_token")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "access_token", valid_579326
  var valid_579327 = query.getOrDefault("upload_protocol")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "upload_protocol", valid_579327
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

proc call*(call_579329: Call_RunProjectsLocationsServicesReplaceService_579313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Replace a service.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_579329.validator(path, query, header, formData, body)
  let scheme = call_579329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579329.url(scheme.get, call_579329.host, call_579329.base,
                         call_579329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579329, url, valid)

proc call*(call_579330: Call_RunProjectsLocationsServicesReplaceService_579313;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesReplaceService
  ## Replace a service.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
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
  ##       : The name of the service being replaced. If needed, replace
  ## {namespace_id} with the project ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579331 = newJObject()
  var query_579332 = newJObject()
  var body_579333 = newJObject()
  add(query_579332, "key", newJString(key))
  add(query_579332, "prettyPrint", newJBool(prettyPrint))
  add(query_579332, "oauth_token", newJString(oauthToken))
  add(query_579332, "$.xgafv", newJString(Xgafv))
  add(query_579332, "alt", newJString(alt))
  add(query_579332, "uploadType", newJString(uploadType))
  add(query_579332, "quotaUser", newJString(quotaUser))
  add(path_579331, "name", newJString(name))
  if body != nil:
    body_579333 = body
  add(query_579332, "callback", newJString(callback))
  add(query_579332, "fields", newJString(fields))
  add(query_579332, "access_token", newJString(accessToken))
  add(query_579332, "upload_protocol", newJString(uploadProtocol))
  result = call_579330.call(path_579331, query_579332, nil, nil, body_579333)

var runProjectsLocationsServicesReplaceService* = Call_RunProjectsLocationsServicesReplaceService_579313(
    name: "runProjectsLocationsServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsServicesReplaceService_579314,
    base: "/", url: url_RunProjectsLocationsServicesReplaceService_579315,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGet_579294 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesGet_579296(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesGet_579295(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get information about a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the service being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579297 = path.getOrDefault("name")
  valid_579297 = validateParameter(valid_579297, JString, required = true,
                                 default = nil)
  if valid_579297 != nil:
    section.add "name", valid_579297
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
  var valid_579298 = query.getOrDefault("key")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "key", valid_579298
  var valid_579299 = query.getOrDefault("prettyPrint")
  valid_579299 = validateParameter(valid_579299, JBool, required = false,
                                 default = newJBool(true))
  if valid_579299 != nil:
    section.add "prettyPrint", valid_579299
  var valid_579300 = query.getOrDefault("oauth_token")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "oauth_token", valid_579300
  var valid_579301 = query.getOrDefault("$.xgafv")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = newJString("1"))
  if valid_579301 != nil:
    section.add "$.xgafv", valid_579301
  var valid_579302 = query.getOrDefault("alt")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = newJString("json"))
  if valid_579302 != nil:
    section.add "alt", valid_579302
  var valid_579303 = query.getOrDefault("uploadType")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "uploadType", valid_579303
  var valid_579304 = query.getOrDefault("quotaUser")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "quotaUser", valid_579304
  var valid_579305 = query.getOrDefault("callback")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "callback", valid_579305
  var valid_579306 = query.getOrDefault("fields")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "fields", valid_579306
  var valid_579307 = query.getOrDefault("access_token")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "access_token", valid_579307
  var valid_579308 = query.getOrDefault("upload_protocol")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "upload_protocol", valid_579308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579309: Call_RunProjectsLocationsServicesGet_579294;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a service.
  ## 
  let valid = call_579309.validator(path, query, header, formData, body)
  let scheme = call_579309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579309.url(scheme.get, call_579309.host, call_579309.base,
                         call_579309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579309, url, valid)

proc call*(call_579310: Call_RunProjectsLocationsServicesGet_579294; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesGet
  ## Get information about a service.
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
  ##       : The name of the service being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579311 = newJObject()
  var query_579312 = newJObject()
  add(query_579312, "key", newJString(key))
  add(query_579312, "prettyPrint", newJBool(prettyPrint))
  add(query_579312, "oauth_token", newJString(oauthToken))
  add(query_579312, "$.xgafv", newJString(Xgafv))
  add(query_579312, "alt", newJString(alt))
  add(query_579312, "uploadType", newJString(uploadType))
  add(query_579312, "quotaUser", newJString(quotaUser))
  add(path_579311, "name", newJString(name))
  add(query_579312, "callback", newJString(callback))
  add(query_579312, "fields", newJString(fields))
  add(query_579312, "access_token", newJString(accessToken))
  add(query_579312, "upload_protocol", newJString(uploadProtocol))
  result = call_579310.call(path_579311, query_579312, nil, nil, nil)

var runProjectsLocationsServicesGet* = Call_RunProjectsLocationsServicesGet_579294(
    name: "runProjectsLocationsServicesGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsServicesGet_579295, base: "/",
    url: url_RunProjectsLocationsServicesGet_579296, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesDelete_579334 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesDelete_579336(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesDelete_579335(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the service being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579337 = path.getOrDefault("name")
  valid_579337 = validateParameter(valid_579337, JString, required = true,
                                 default = nil)
  if valid_579337 != nil:
    section.add "name", valid_579337
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
  ##   propagationPolicy: JString
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: JString
  ##           : JSONP
  ##   apiVersion: JString
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: JString
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579338 = query.getOrDefault("key")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "key", valid_579338
  var valid_579339 = query.getOrDefault("prettyPrint")
  valid_579339 = validateParameter(valid_579339, JBool, required = false,
                                 default = newJBool(true))
  if valid_579339 != nil:
    section.add "prettyPrint", valid_579339
  var valid_579340 = query.getOrDefault("oauth_token")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "oauth_token", valid_579340
  var valid_579341 = query.getOrDefault("$.xgafv")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = newJString("1"))
  if valid_579341 != nil:
    section.add "$.xgafv", valid_579341
  var valid_579342 = query.getOrDefault("alt")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = newJString("json"))
  if valid_579342 != nil:
    section.add "alt", valid_579342
  var valid_579343 = query.getOrDefault("uploadType")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "uploadType", valid_579343
  var valid_579344 = query.getOrDefault("quotaUser")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "quotaUser", valid_579344
  var valid_579345 = query.getOrDefault("propagationPolicy")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "propagationPolicy", valid_579345
  var valid_579346 = query.getOrDefault("callback")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "callback", valid_579346
  var valid_579347 = query.getOrDefault("apiVersion")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "apiVersion", valid_579347
  var valid_579348 = query.getOrDefault("kind")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "kind", valid_579348
  var valid_579349 = query.getOrDefault("fields")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "fields", valid_579349
  var valid_579350 = query.getOrDefault("access_token")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "access_token", valid_579350
  var valid_579351 = query.getOrDefault("upload_protocol")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "upload_protocol", valid_579351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579352: Call_RunProjectsLocationsServicesDelete_579334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
  ## 
  let valid = call_579352.validator(path, query, header, formData, body)
  let scheme = call_579352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579352.url(scheme.get, call_579352.host, call_579352.base,
                         call_579352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579352, url, valid)

proc call*(call_579353: Call_RunProjectsLocationsServicesDelete_579334;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          propagationPolicy: string = ""; callback: string = "";
          apiVersion: string = ""; kind: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesDelete
  ## Delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
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
  ##       : The name of the service being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  ##   propagationPolicy: string
  ##                    : Specifies the propagation policy of delete. Cloud Run currently ignores
  ## this setting, and deletes in the background. Please see
  ## kubernetes.io/docs/concepts/workloads/controllers/garbage-collection/ for
  ## more information.
  ##   callback: string
  ##           : JSONP
  ##   apiVersion: string
  ##             : Cloud Run currently ignores this parameter.
  ##   kind: string
  ##       : Cloud Run currently ignores this parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579354 = newJObject()
  var query_579355 = newJObject()
  add(query_579355, "key", newJString(key))
  add(query_579355, "prettyPrint", newJBool(prettyPrint))
  add(query_579355, "oauth_token", newJString(oauthToken))
  add(query_579355, "$.xgafv", newJString(Xgafv))
  add(query_579355, "alt", newJString(alt))
  add(query_579355, "uploadType", newJString(uploadType))
  add(query_579355, "quotaUser", newJString(quotaUser))
  add(path_579354, "name", newJString(name))
  add(query_579355, "propagationPolicy", newJString(propagationPolicy))
  add(query_579355, "callback", newJString(callback))
  add(query_579355, "apiVersion", newJString(apiVersion))
  add(query_579355, "kind", newJString(kind))
  add(query_579355, "fields", newJString(fields))
  add(query_579355, "access_token", newJString(accessToken))
  add(query_579355, "upload_protocol", newJString(uploadProtocol))
  result = call_579353.call(path_579354, query_579355, nil, nil, nil)

var runProjectsLocationsServicesDelete* = Call_RunProjectsLocationsServicesDelete_579334(
    name: "runProjectsLocationsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsServicesDelete_579335, base: "/",
    url: url_RunProjectsLocationsServicesDelete_579336, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_579356 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsList_579358(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsList_579357(path: JsonNode; query: JsonNode;
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
  var valid_579359 = path.getOrDefault("name")
  valid_579359 = validateParameter(valid_579359, JString, required = true,
                                 default = nil)
  if valid_579359 != nil:
    section.add "name", valid_579359
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579360 = query.getOrDefault("key")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "key", valid_579360
  var valid_579361 = query.getOrDefault("prettyPrint")
  valid_579361 = validateParameter(valid_579361, JBool, required = false,
                                 default = newJBool(true))
  if valid_579361 != nil:
    section.add "prettyPrint", valid_579361
  var valid_579362 = query.getOrDefault("oauth_token")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "oauth_token", valid_579362
  var valid_579363 = query.getOrDefault("$.xgafv")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = newJString("1"))
  if valid_579363 != nil:
    section.add "$.xgafv", valid_579363
  var valid_579364 = query.getOrDefault("pageSize")
  valid_579364 = validateParameter(valid_579364, JInt, required = false, default = nil)
  if valid_579364 != nil:
    section.add "pageSize", valid_579364
  var valid_579365 = query.getOrDefault("alt")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = newJString("json"))
  if valid_579365 != nil:
    section.add "alt", valid_579365
  var valid_579366 = query.getOrDefault("uploadType")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "uploadType", valid_579366
  var valid_579367 = query.getOrDefault("quotaUser")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "quotaUser", valid_579367
  var valid_579368 = query.getOrDefault("filter")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "filter", valid_579368
  var valid_579369 = query.getOrDefault("pageToken")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "pageToken", valid_579369
  var valid_579370 = query.getOrDefault("callback")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = nil)
  if valid_579370 != nil:
    section.add "callback", valid_579370
  var valid_579371 = query.getOrDefault("fields")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "fields", valid_579371
  var valid_579372 = query.getOrDefault("access_token")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "access_token", valid_579372
  var valid_579373 = query.getOrDefault("upload_protocol")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "upload_protocol", valid_579373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579374: Call_RunProjectsLocationsList_579356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_579374.validator(path, query, header, formData, body)
  let scheme = call_579374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579374.url(scheme.get, call_579374.host, call_579374.base,
                         call_579374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579374, url, valid)

proc call*(call_579375: Call_RunProjectsLocationsList_579356; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579376 = newJObject()
  var query_579377 = newJObject()
  add(query_579377, "key", newJString(key))
  add(query_579377, "prettyPrint", newJBool(prettyPrint))
  add(query_579377, "oauth_token", newJString(oauthToken))
  add(query_579377, "$.xgafv", newJString(Xgafv))
  add(query_579377, "pageSize", newJInt(pageSize))
  add(query_579377, "alt", newJString(alt))
  add(query_579377, "uploadType", newJString(uploadType))
  add(query_579377, "quotaUser", newJString(quotaUser))
  add(path_579376, "name", newJString(name))
  add(query_579377, "filter", newJString(filter))
  add(query_579377, "pageToken", newJString(pageToken))
  add(query_579377, "callback", newJString(callback))
  add(query_579377, "fields", newJString(fields))
  add(query_579377, "access_token", newJString(accessToken))
  add(query_579377, "upload_protocol", newJString(uploadProtocol))
  result = call_579375.call(path_579376, query_579377, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_579356(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_RunProjectsLocationsList_579357, base: "/",
    url: url_RunProjectsLocationsList_579358, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_579378 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsAuthorizeddomainsList_579380(protocol: Scheme;
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

proc validate_RunProjectsLocationsAuthorizeddomainsList_579379(path: JsonNode;
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
  var valid_579381 = path.getOrDefault("parent")
  valid_579381 = validateParameter(valid_579381, JString, required = true,
                                 default = nil)
  if valid_579381 != nil:
    section.add "parent", valid_579381
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
  ##           : Maximum results to return per page.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token for fetching the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579382 = query.getOrDefault("key")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "key", valid_579382
  var valid_579383 = query.getOrDefault("prettyPrint")
  valid_579383 = validateParameter(valid_579383, JBool, required = false,
                                 default = newJBool(true))
  if valid_579383 != nil:
    section.add "prettyPrint", valid_579383
  var valid_579384 = query.getOrDefault("oauth_token")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "oauth_token", valid_579384
  var valid_579385 = query.getOrDefault("$.xgafv")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = newJString("1"))
  if valid_579385 != nil:
    section.add "$.xgafv", valid_579385
  var valid_579386 = query.getOrDefault("pageSize")
  valid_579386 = validateParameter(valid_579386, JInt, required = false, default = nil)
  if valid_579386 != nil:
    section.add "pageSize", valid_579386
  var valid_579387 = query.getOrDefault("alt")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = newJString("json"))
  if valid_579387 != nil:
    section.add "alt", valid_579387
  var valid_579388 = query.getOrDefault("uploadType")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "uploadType", valid_579388
  var valid_579389 = query.getOrDefault("quotaUser")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "quotaUser", valid_579389
  var valid_579390 = query.getOrDefault("pageToken")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "pageToken", valid_579390
  var valid_579391 = query.getOrDefault("callback")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = nil)
  if valid_579391 != nil:
    section.add "callback", valid_579391
  var valid_579392 = query.getOrDefault("fields")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "fields", valid_579392
  var valid_579393 = query.getOrDefault("access_token")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "access_token", valid_579393
  var valid_579394 = query.getOrDefault("upload_protocol")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "upload_protocol", valid_579394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579395: Call_RunProjectsLocationsAuthorizeddomainsList_579378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_579395.validator(path, query, header, formData, body)
  let scheme = call_579395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579395.url(scheme.get, call_579395.host, call_579395.base,
                         call_579395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579395, url, valid)

proc call*(call_579396: Call_RunProjectsLocationsAuthorizeddomainsList_579378;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsAuthorizeddomainsList
  ## List authorized domains.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum results to return per page.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token for fetching the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579397 = newJObject()
  var query_579398 = newJObject()
  add(query_579398, "key", newJString(key))
  add(query_579398, "prettyPrint", newJBool(prettyPrint))
  add(query_579398, "oauth_token", newJString(oauthToken))
  add(query_579398, "$.xgafv", newJString(Xgafv))
  add(query_579398, "pageSize", newJInt(pageSize))
  add(query_579398, "alt", newJString(alt))
  add(query_579398, "uploadType", newJString(uploadType))
  add(query_579398, "quotaUser", newJString(quotaUser))
  add(query_579398, "pageToken", newJString(pageToken))
  add(query_579398, "callback", newJString(callback))
  add(path_579397, "parent", newJString(parent))
  add(query_579398, "fields", newJString(fields))
  add(query_579398, "access_token", newJString(accessToken))
  add(query_579398, "upload_protocol", newJString(uploadProtocol))
  result = call_579396.call(path_579397, query_579398, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_579378(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_579379,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_579380,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsCreate_579425 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsAutodomainmappingsCreate_579427(protocol: Scheme;
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

proc validate_RunProjectsLocationsAutodomainmappingsCreate_579426(path: JsonNode;
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
  var valid_579428 = path.getOrDefault("parent")
  valid_579428 = validateParameter(valid_579428, JString, required = true,
                                 default = nil)
  if valid_579428 != nil:
    section.add "parent", valid_579428
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
  var valid_579429 = query.getOrDefault("key")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "key", valid_579429
  var valid_579430 = query.getOrDefault("prettyPrint")
  valid_579430 = validateParameter(valid_579430, JBool, required = false,
                                 default = newJBool(true))
  if valid_579430 != nil:
    section.add "prettyPrint", valid_579430
  var valid_579431 = query.getOrDefault("oauth_token")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "oauth_token", valid_579431
  var valid_579432 = query.getOrDefault("$.xgafv")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = newJString("1"))
  if valid_579432 != nil:
    section.add "$.xgafv", valid_579432
  var valid_579433 = query.getOrDefault("alt")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = newJString("json"))
  if valid_579433 != nil:
    section.add "alt", valid_579433
  var valid_579434 = query.getOrDefault("uploadType")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "uploadType", valid_579434
  var valid_579435 = query.getOrDefault("quotaUser")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "quotaUser", valid_579435
  var valid_579436 = query.getOrDefault("callback")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "callback", valid_579436
  var valid_579437 = query.getOrDefault("fields")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "fields", valid_579437
  var valid_579438 = query.getOrDefault("access_token")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "access_token", valid_579438
  var valid_579439 = query.getOrDefault("upload_protocol")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "upload_protocol", valid_579439
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

proc call*(call_579441: Call_RunProjectsLocationsAutodomainmappingsCreate_579425;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_579441.validator(path, query, header, formData, body)
  let scheme = call_579441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579441.url(scheme.get, call_579441.host, call_579441.base,
                         call_579441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579441, url, valid)

proc call*(call_579442: Call_RunProjectsLocationsAutodomainmappingsCreate_579425;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsAutodomainmappingsCreate
  ## Creates a new auto domain mapping.
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
  ##         : The project ID or project number in which this auto domain mapping should
  ## be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579443 = newJObject()
  var query_579444 = newJObject()
  var body_579445 = newJObject()
  add(query_579444, "key", newJString(key))
  add(query_579444, "prettyPrint", newJBool(prettyPrint))
  add(query_579444, "oauth_token", newJString(oauthToken))
  add(query_579444, "$.xgafv", newJString(Xgafv))
  add(query_579444, "alt", newJString(alt))
  add(query_579444, "uploadType", newJString(uploadType))
  add(query_579444, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579445 = body
  add(query_579444, "callback", newJString(callback))
  add(path_579443, "parent", newJString(parent))
  add(query_579444, "fields", newJString(fields))
  add(query_579444, "access_token", newJString(accessToken))
  add(query_579444, "upload_protocol", newJString(uploadProtocol))
  result = call_579442.call(path_579443, query_579444, nil, nil, body_579445)

var runProjectsLocationsAutodomainmappingsCreate* = Call_RunProjectsLocationsAutodomainmappingsCreate_579425(
    name: "runProjectsLocationsAutodomainmappingsCreate",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsCreate_579426,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsCreate_579427,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsList_579399 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsAutodomainmappingsList_579401(protocol: Scheme;
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

proc validate_RunProjectsLocationsAutodomainmappingsList_579400(path: JsonNode;
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
  var valid_579402 = path.getOrDefault("parent")
  valid_579402 = validateParameter(valid_579402, JString, required = true,
                                 default = nil)
  if valid_579402 != nil:
    section.add "parent", valid_579402
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579403 = query.getOrDefault("key")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "key", valid_579403
  var valid_579404 = query.getOrDefault("includeUninitialized")
  valid_579404 = validateParameter(valid_579404, JBool, required = false, default = nil)
  if valid_579404 != nil:
    section.add "includeUninitialized", valid_579404
  var valid_579405 = query.getOrDefault("prettyPrint")
  valid_579405 = validateParameter(valid_579405, JBool, required = false,
                                 default = newJBool(true))
  if valid_579405 != nil:
    section.add "prettyPrint", valid_579405
  var valid_579406 = query.getOrDefault("oauth_token")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "oauth_token", valid_579406
  var valid_579407 = query.getOrDefault("fieldSelector")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "fieldSelector", valid_579407
  var valid_579408 = query.getOrDefault("labelSelector")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "labelSelector", valid_579408
  var valid_579409 = query.getOrDefault("$.xgafv")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = newJString("1"))
  if valid_579409 != nil:
    section.add "$.xgafv", valid_579409
  var valid_579410 = query.getOrDefault("limit")
  valid_579410 = validateParameter(valid_579410, JInt, required = false, default = nil)
  if valid_579410 != nil:
    section.add "limit", valid_579410
  var valid_579411 = query.getOrDefault("alt")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = newJString("json"))
  if valid_579411 != nil:
    section.add "alt", valid_579411
  var valid_579412 = query.getOrDefault("uploadType")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = nil)
  if valid_579412 != nil:
    section.add "uploadType", valid_579412
  var valid_579413 = query.getOrDefault("quotaUser")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = nil)
  if valid_579413 != nil:
    section.add "quotaUser", valid_579413
  var valid_579414 = query.getOrDefault("watch")
  valid_579414 = validateParameter(valid_579414, JBool, required = false, default = nil)
  if valid_579414 != nil:
    section.add "watch", valid_579414
  var valid_579415 = query.getOrDefault("callback")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "callback", valid_579415
  var valid_579416 = query.getOrDefault("resourceVersion")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "resourceVersion", valid_579416
  var valid_579417 = query.getOrDefault("fields")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "fields", valid_579417
  var valid_579418 = query.getOrDefault("access_token")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "access_token", valid_579418
  var valid_579419 = query.getOrDefault("upload_protocol")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "upload_protocol", valid_579419
  var valid_579420 = query.getOrDefault("continue")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "continue", valid_579420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579421: Call_RunProjectsLocationsAutodomainmappingsList_579399;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_579421.validator(path, query, header, formData, body)
  let scheme = call_579421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579421.url(scheme.get, call_579421.host, call_579421.base,
                         call_579421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579421, url, valid)

proc call*(call_579422: Call_RunProjectsLocationsAutodomainmappingsList_579399;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsAutodomainmappingsList
  ## List auto domain mappings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the auto domain mappings should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579423 = newJObject()
  var query_579424 = newJObject()
  add(query_579424, "key", newJString(key))
  add(query_579424, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579424, "prettyPrint", newJBool(prettyPrint))
  add(query_579424, "oauth_token", newJString(oauthToken))
  add(query_579424, "fieldSelector", newJString(fieldSelector))
  add(query_579424, "labelSelector", newJString(labelSelector))
  add(query_579424, "$.xgafv", newJString(Xgafv))
  add(query_579424, "limit", newJInt(limit))
  add(query_579424, "alt", newJString(alt))
  add(query_579424, "uploadType", newJString(uploadType))
  add(query_579424, "quotaUser", newJString(quotaUser))
  add(query_579424, "watch", newJBool(watch))
  add(query_579424, "callback", newJString(callback))
  add(path_579423, "parent", newJString(parent))
  add(query_579424, "resourceVersion", newJString(resourceVersion))
  add(query_579424, "fields", newJString(fields))
  add(query_579424, "access_token", newJString(accessToken))
  add(query_579424, "upload_protocol", newJString(uploadProtocol))
  add(query_579424, "continue", newJString(`continue`))
  result = call_579422.call(path_579423, query_579424, nil, nil, nil)

var runProjectsLocationsAutodomainmappingsList* = Call_RunProjectsLocationsAutodomainmappingsList_579399(
    name: "runProjectsLocationsAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsList_579400,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsList_579401,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsCreate_579472 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsConfigurationsCreate_579474(protocol: Scheme;
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

proc validate_RunProjectsLocationsConfigurationsCreate_579473(path: JsonNode;
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
  var valid_579475 = path.getOrDefault("parent")
  valid_579475 = validateParameter(valid_579475, JString, required = true,
                                 default = nil)
  if valid_579475 != nil:
    section.add "parent", valid_579475
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
  var valid_579476 = query.getOrDefault("key")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "key", valid_579476
  var valid_579477 = query.getOrDefault("prettyPrint")
  valid_579477 = validateParameter(valid_579477, JBool, required = false,
                                 default = newJBool(true))
  if valid_579477 != nil:
    section.add "prettyPrint", valid_579477
  var valid_579478 = query.getOrDefault("oauth_token")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "oauth_token", valid_579478
  var valid_579479 = query.getOrDefault("$.xgafv")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = newJString("1"))
  if valid_579479 != nil:
    section.add "$.xgafv", valid_579479
  var valid_579480 = query.getOrDefault("alt")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = newJString("json"))
  if valid_579480 != nil:
    section.add "alt", valid_579480
  var valid_579481 = query.getOrDefault("uploadType")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "uploadType", valid_579481
  var valid_579482 = query.getOrDefault("quotaUser")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "quotaUser", valid_579482
  var valid_579483 = query.getOrDefault("callback")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "callback", valid_579483
  var valid_579484 = query.getOrDefault("fields")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "fields", valid_579484
  var valid_579485 = query.getOrDefault("access_token")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "access_token", valid_579485
  var valid_579486 = query.getOrDefault("upload_protocol")
  valid_579486 = validateParameter(valid_579486, JString, required = false,
                                 default = nil)
  if valid_579486 != nil:
    section.add "upload_protocol", valid_579486
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

proc call*(call_579488: Call_RunProjectsLocationsConfigurationsCreate_579472;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_579488.validator(path, query, header, formData, body)
  let scheme = call_579488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579488.url(scheme.get, call_579488.host, call_579488.base,
                         call_579488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579488, url, valid)

proc call*(call_579489: Call_RunProjectsLocationsConfigurationsCreate_579472;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsConfigurationsCreate
  ## Create a configuration.
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
  ##         : The project ID or project number in which this configuration should be
  ## created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579490 = newJObject()
  var query_579491 = newJObject()
  var body_579492 = newJObject()
  add(query_579491, "key", newJString(key))
  add(query_579491, "prettyPrint", newJBool(prettyPrint))
  add(query_579491, "oauth_token", newJString(oauthToken))
  add(query_579491, "$.xgafv", newJString(Xgafv))
  add(query_579491, "alt", newJString(alt))
  add(query_579491, "uploadType", newJString(uploadType))
  add(query_579491, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579492 = body
  add(query_579491, "callback", newJString(callback))
  add(path_579490, "parent", newJString(parent))
  add(query_579491, "fields", newJString(fields))
  add(query_579491, "access_token", newJString(accessToken))
  add(query_579491, "upload_protocol", newJString(uploadProtocol))
  result = call_579489.call(path_579490, query_579491, nil, nil, body_579492)

var runProjectsLocationsConfigurationsCreate* = Call_RunProjectsLocationsConfigurationsCreate_579472(
    name: "runProjectsLocationsConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsCreate_579473,
    base: "/", url: url_RunProjectsLocationsConfigurationsCreate_579474,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_579446 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsConfigurationsList_579448(protocol: Scheme;
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

proc validate_RunProjectsLocationsConfigurationsList_579447(path: JsonNode;
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
  var valid_579449 = path.getOrDefault("parent")
  valid_579449 = validateParameter(valid_579449, JString, required = true,
                                 default = nil)
  if valid_579449 != nil:
    section.add "parent", valid_579449
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579450 = query.getOrDefault("key")
  valid_579450 = validateParameter(valid_579450, JString, required = false,
                                 default = nil)
  if valid_579450 != nil:
    section.add "key", valid_579450
  var valid_579451 = query.getOrDefault("includeUninitialized")
  valid_579451 = validateParameter(valid_579451, JBool, required = false, default = nil)
  if valid_579451 != nil:
    section.add "includeUninitialized", valid_579451
  var valid_579452 = query.getOrDefault("prettyPrint")
  valid_579452 = validateParameter(valid_579452, JBool, required = false,
                                 default = newJBool(true))
  if valid_579452 != nil:
    section.add "prettyPrint", valid_579452
  var valid_579453 = query.getOrDefault("oauth_token")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "oauth_token", valid_579453
  var valid_579454 = query.getOrDefault("fieldSelector")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "fieldSelector", valid_579454
  var valid_579455 = query.getOrDefault("labelSelector")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = nil)
  if valid_579455 != nil:
    section.add "labelSelector", valid_579455
  var valid_579456 = query.getOrDefault("$.xgafv")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = newJString("1"))
  if valid_579456 != nil:
    section.add "$.xgafv", valid_579456
  var valid_579457 = query.getOrDefault("limit")
  valid_579457 = validateParameter(valid_579457, JInt, required = false, default = nil)
  if valid_579457 != nil:
    section.add "limit", valid_579457
  var valid_579458 = query.getOrDefault("alt")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = newJString("json"))
  if valid_579458 != nil:
    section.add "alt", valid_579458
  var valid_579459 = query.getOrDefault("uploadType")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "uploadType", valid_579459
  var valid_579460 = query.getOrDefault("quotaUser")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "quotaUser", valid_579460
  var valid_579461 = query.getOrDefault("watch")
  valid_579461 = validateParameter(valid_579461, JBool, required = false, default = nil)
  if valid_579461 != nil:
    section.add "watch", valid_579461
  var valid_579462 = query.getOrDefault("callback")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "callback", valid_579462
  var valid_579463 = query.getOrDefault("resourceVersion")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "resourceVersion", valid_579463
  var valid_579464 = query.getOrDefault("fields")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "fields", valid_579464
  var valid_579465 = query.getOrDefault("access_token")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "access_token", valid_579465
  var valid_579466 = query.getOrDefault("upload_protocol")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "upload_protocol", valid_579466
  var valid_579467 = query.getOrDefault("continue")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "continue", valid_579467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579468: Call_RunProjectsLocationsConfigurationsList_579446;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_579468.validator(path, query, header, formData, body)
  let scheme = call_579468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579468.url(scheme.get, call_579468.host, call_579468.base,
                         call_579468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579468, url, valid)

proc call*(call_579469: Call_RunProjectsLocationsConfigurationsList_579446;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsConfigurationsList
  ## List configurations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579470 = newJObject()
  var query_579471 = newJObject()
  add(query_579471, "key", newJString(key))
  add(query_579471, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579471, "prettyPrint", newJBool(prettyPrint))
  add(query_579471, "oauth_token", newJString(oauthToken))
  add(query_579471, "fieldSelector", newJString(fieldSelector))
  add(query_579471, "labelSelector", newJString(labelSelector))
  add(query_579471, "$.xgafv", newJString(Xgafv))
  add(query_579471, "limit", newJInt(limit))
  add(query_579471, "alt", newJString(alt))
  add(query_579471, "uploadType", newJString(uploadType))
  add(query_579471, "quotaUser", newJString(quotaUser))
  add(query_579471, "watch", newJBool(watch))
  add(query_579471, "callback", newJString(callback))
  add(path_579470, "parent", newJString(parent))
  add(query_579471, "resourceVersion", newJString(resourceVersion))
  add(query_579471, "fields", newJString(fields))
  add(query_579471, "access_token", newJString(accessToken))
  add(query_579471, "upload_protocol", newJString(uploadProtocol))
  add(query_579471, "continue", newJString(`continue`))
  result = call_579469.call(path_579470, query_579471, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_579446(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_579447, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_579448,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_579519 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsDomainmappingsCreate_579521(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsCreate_579520(path: JsonNode;
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
  var valid_579522 = path.getOrDefault("parent")
  valid_579522 = validateParameter(valid_579522, JString, required = true,
                                 default = nil)
  if valid_579522 != nil:
    section.add "parent", valid_579522
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
  var valid_579523 = query.getOrDefault("key")
  valid_579523 = validateParameter(valid_579523, JString, required = false,
                                 default = nil)
  if valid_579523 != nil:
    section.add "key", valid_579523
  var valid_579524 = query.getOrDefault("prettyPrint")
  valid_579524 = validateParameter(valid_579524, JBool, required = false,
                                 default = newJBool(true))
  if valid_579524 != nil:
    section.add "prettyPrint", valid_579524
  var valid_579525 = query.getOrDefault("oauth_token")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "oauth_token", valid_579525
  var valid_579526 = query.getOrDefault("$.xgafv")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = newJString("1"))
  if valid_579526 != nil:
    section.add "$.xgafv", valid_579526
  var valid_579527 = query.getOrDefault("alt")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = newJString("json"))
  if valid_579527 != nil:
    section.add "alt", valid_579527
  var valid_579528 = query.getOrDefault("uploadType")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "uploadType", valid_579528
  var valid_579529 = query.getOrDefault("quotaUser")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "quotaUser", valid_579529
  var valid_579530 = query.getOrDefault("callback")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "callback", valid_579530
  var valid_579531 = query.getOrDefault("fields")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "fields", valid_579531
  var valid_579532 = query.getOrDefault("access_token")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "access_token", valid_579532
  var valid_579533 = query.getOrDefault("upload_protocol")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "upload_protocol", valid_579533
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

proc call*(call_579535: Call_RunProjectsLocationsDomainmappingsCreate_579519;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_579535.validator(path, query, header, formData, body)
  let scheme = call_579535.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579535.url(scheme.get, call_579535.host, call_579535.base,
                         call_579535.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579535, url, valid)

proc call*(call_579536: Call_RunProjectsLocationsDomainmappingsCreate_579519;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsCreate
  ## Create a new domain mapping.
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
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579537 = newJObject()
  var query_579538 = newJObject()
  var body_579539 = newJObject()
  add(query_579538, "key", newJString(key))
  add(query_579538, "prettyPrint", newJBool(prettyPrint))
  add(query_579538, "oauth_token", newJString(oauthToken))
  add(query_579538, "$.xgafv", newJString(Xgafv))
  add(query_579538, "alt", newJString(alt))
  add(query_579538, "uploadType", newJString(uploadType))
  add(query_579538, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579539 = body
  add(query_579538, "callback", newJString(callback))
  add(path_579537, "parent", newJString(parent))
  add(query_579538, "fields", newJString(fields))
  add(query_579538, "access_token", newJString(accessToken))
  add(query_579538, "upload_protocol", newJString(uploadProtocol))
  result = call_579536.call(path_579537, query_579538, nil, nil, body_579539)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_579519(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_579520,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_579521,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_579493 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsDomainmappingsList_579495(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsList_579494(path: JsonNode;
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
  var valid_579496 = path.getOrDefault("parent")
  valid_579496 = validateParameter(valid_579496, JString, required = true,
                                 default = nil)
  if valid_579496 != nil:
    section.add "parent", valid_579496
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579497 = query.getOrDefault("key")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "key", valid_579497
  var valid_579498 = query.getOrDefault("includeUninitialized")
  valid_579498 = validateParameter(valid_579498, JBool, required = false, default = nil)
  if valid_579498 != nil:
    section.add "includeUninitialized", valid_579498
  var valid_579499 = query.getOrDefault("prettyPrint")
  valid_579499 = validateParameter(valid_579499, JBool, required = false,
                                 default = newJBool(true))
  if valid_579499 != nil:
    section.add "prettyPrint", valid_579499
  var valid_579500 = query.getOrDefault("oauth_token")
  valid_579500 = validateParameter(valid_579500, JString, required = false,
                                 default = nil)
  if valid_579500 != nil:
    section.add "oauth_token", valid_579500
  var valid_579501 = query.getOrDefault("fieldSelector")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "fieldSelector", valid_579501
  var valid_579502 = query.getOrDefault("labelSelector")
  valid_579502 = validateParameter(valid_579502, JString, required = false,
                                 default = nil)
  if valid_579502 != nil:
    section.add "labelSelector", valid_579502
  var valid_579503 = query.getOrDefault("$.xgafv")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = newJString("1"))
  if valid_579503 != nil:
    section.add "$.xgafv", valid_579503
  var valid_579504 = query.getOrDefault("limit")
  valid_579504 = validateParameter(valid_579504, JInt, required = false, default = nil)
  if valid_579504 != nil:
    section.add "limit", valid_579504
  var valid_579505 = query.getOrDefault("alt")
  valid_579505 = validateParameter(valid_579505, JString, required = false,
                                 default = newJString("json"))
  if valid_579505 != nil:
    section.add "alt", valid_579505
  var valid_579506 = query.getOrDefault("uploadType")
  valid_579506 = validateParameter(valid_579506, JString, required = false,
                                 default = nil)
  if valid_579506 != nil:
    section.add "uploadType", valid_579506
  var valid_579507 = query.getOrDefault("quotaUser")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = nil)
  if valid_579507 != nil:
    section.add "quotaUser", valid_579507
  var valid_579508 = query.getOrDefault("watch")
  valid_579508 = validateParameter(valid_579508, JBool, required = false, default = nil)
  if valid_579508 != nil:
    section.add "watch", valid_579508
  var valid_579509 = query.getOrDefault("callback")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "callback", valid_579509
  var valid_579510 = query.getOrDefault("resourceVersion")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "resourceVersion", valid_579510
  var valid_579511 = query.getOrDefault("fields")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = nil)
  if valid_579511 != nil:
    section.add "fields", valid_579511
  var valid_579512 = query.getOrDefault("access_token")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "access_token", valid_579512
  var valid_579513 = query.getOrDefault("upload_protocol")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "upload_protocol", valid_579513
  var valid_579514 = query.getOrDefault("continue")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "continue", valid_579514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579515: Call_RunProjectsLocationsDomainmappingsList_579493;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_579515.validator(path, query, header, formData, body)
  let scheme = call_579515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579515.url(scheme.get, call_579515.host, call_579515.base,
                         call_579515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579515, url, valid)

proc call*(call_579516: Call_RunProjectsLocationsDomainmappingsList_579493;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsList
  ## List domain mappings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579517 = newJObject()
  var query_579518 = newJObject()
  add(query_579518, "key", newJString(key))
  add(query_579518, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579518, "prettyPrint", newJBool(prettyPrint))
  add(query_579518, "oauth_token", newJString(oauthToken))
  add(query_579518, "fieldSelector", newJString(fieldSelector))
  add(query_579518, "labelSelector", newJString(labelSelector))
  add(query_579518, "$.xgafv", newJString(Xgafv))
  add(query_579518, "limit", newJInt(limit))
  add(query_579518, "alt", newJString(alt))
  add(query_579518, "uploadType", newJString(uploadType))
  add(query_579518, "quotaUser", newJString(quotaUser))
  add(query_579518, "watch", newJBool(watch))
  add(query_579518, "callback", newJString(callback))
  add(path_579517, "parent", newJString(parent))
  add(query_579518, "resourceVersion", newJString(resourceVersion))
  add(query_579518, "fields", newJString(fields))
  add(query_579518, "access_token", newJString(accessToken))
  add(query_579518, "upload_protocol", newJString(uploadProtocol))
  add(query_579518, "continue", newJString(`continue`))
  result = call_579516.call(path_579517, query_579518, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_579493(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_579494, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_579495,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_579540 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsRevisionsList_579542(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsRevisionsList_579541(path: JsonNode;
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
  var valid_579543 = path.getOrDefault("parent")
  valid_579543 = validateParameter(valid_579543, JString, required = true,
                                 default = nil)
  if valid_579543 != nil:
    section.add "parent", valid_579543
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579544 = query.getOrDefault("key")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "key", valid_579544
  var valid_579545 = query.getOrDefault("includeUninitialized")
  valid_579545 = validateParameter(valid_579545, JBool, required = false, default = nil)
  if valid_579545 != nil:
    section.add "includeUninitialized", valid_579545
  var valid_579546 = query.getOrDefault("prettyPrint")
  valid_579546 = validateParameter(valid_579546, JBool, required = false,
                                 default = newJBool(true))
  if valid_579546 != nil:
    section.add "prettyPrint", valid_579546
  var valid_579547 = query.getOrDefault("oauth_token")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "oauth_token", valid_579547
  var valid_579548 = query.getOrDefault("fieldSelector")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = nil)
  if valid_579548 != nil:
    section.add "fieldSelector", valid_579548
  var valid_579549 = query.getOrDefault("labelSelector")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "labelSelector", valid_579549
  var valid_579550 = query.getOrDefault("$.xgafv")
  valid_579550 = validateParameter(valid_579550, JString, required = false,
                                 default = newJString("1"))
  if valid_579550 != nil:
    section.add "$.xgafv", valid_579550
  var valid_579551 = query.getOrDefault("limit")
  valid_579551 = validateParameter(valid_579551, JInt, required = false, default = nil)
  if valid_579551 != nil:
    section.add "limit", valid_579551
  var valid_579552 = query.getOrDefault("alt")
  valid_579552 = validateParameter(valid_579552, JString, required = false,
                                 default = newJString("json"))
  if valid_579552 != nil:
    section.add "alt", valid_579552
  var valid_579553 = query.getOrDefault("uploadType")
  valid_579553 = validateParameter(valid_579553, JString, required = false,
                                 default = nil)
  if valid_579553 != nil:
    section.add "uploadType", valid_579553
  var valid_579554 = query.getOrDefault("quotaUser")
  valid_579554 = validateParameter(valid_579554, JString, required = false,
                                 default = nil)
  if valid_579554 != nil:
    section.add "quotaUser", valid_579554
  var valid_579555 = query.getOrDefault("watch")
  valid_579555 = validateParameter(valid_579555, JBool, required = false, default = nil)
  if valid_579555 != nil:
    section.add "watch", valid_579555
  var valid_579556 = query.getOrDefault("callback")
  valid_579556 = validateParameter(valid_579556, JString, required = false,
                                 default = nil)
  if valid_579556 != nil:
    section.add "callback", valid_579556
  var valid_579557 = query.getOrDefault("resourceVersion")
  valid_579557 = validateParameter(valid_579557, JString, required = false,
                                 default = nil)
  if valid_579557 != nil:
    section.add "resourceVersion", valid_579557
  var valid_579558 = query.getOrDefault("fields")
  valid_579558 = validateParameter(valid_579558, JString, required = false,
                                 default = nil)
  if valid_579558 != nil:
    section.add "fields", valid_579558
  var valid_579559 = query.getOrDefault("access_token")
  valid_579559 = validateParameter(valid_579559, JString, required = false,
                                 default = nil)
  if valid_579559 != nil:
    section.add "access_token", valid_579559
  var valid_579560 = query.getOrDefault("upload_protocol")
  valid_579560 = validateParameter(valid_579560, JString, required = false,
                                 default = nil)
  if valid_579560 != nil:
    section.add "upload_protocol", valid_579560
  var valid_579561 = query.getOrDefault("continue")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "continue", valid_579561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579562: Call_RunProjectsLocationsRevisionsList_579540;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_579562.validator(path, query, header, formData, body)
  let scheme = call_579562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579562.url(scheme.get, call_579562.host, call_579562.base,
                         call_579562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579562, url, valid)

proc call*(call_579563: Call_RunProjectsLocationsRevisionsList_579540;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsRevisionsList
  ## List revisions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the revisions should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579564 = newJObject()
  var query_579565 = newJObject()
  add(query_579565, "key", newJString(key))
  add(query_579565, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579565, "prettyPrint", newJBool(prettyPrint))
  add(query_579565, "oauth_token", newJString(oauthToken))
  add(query_579565, "fieldSelector", newJString(fieldSelector))
  add(query_579565, "labelSelector", newJString(labelSelector))
  add(query_579565, "$.xgafv", newJString(Xgafv))
  add(query_579565, "limit", newJInt(limit))
  add(query_579565, "alt", newJString(alt))
  add(query_579565, "uploadType", newJString(uploadType))
  add(query_579565, "quotaUser", newJString(quotaUser))
  add(query_579565, "watch", newJBool(watch))
  add(query_579565, "callback", newJString(callback))
  add(path_579564, "parent", newJString(parent))
  add(query_579565, "resourceVersion", newJString(resourceVersion))
  add(query_579565, "fields", newJString(fields))
  add(query_579565, "access_token", newJString(accessToken))
  add(query_579565, "upload_protocol", newJString(uploadProtocol))
  add(query_579565, "continue", newJString(`continue`))
  result = call_579563.call(path_579564, query_579565, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_579540(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_579541, base: "/",
    url: url_RunProjectsLocationsRevisionsList_579542, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesCreate_579592 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsRoutesCreate_579594(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsRoutesCreate_579593(path: JsonNode;
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
  var valid_579595 = path.getOrDefault("parent")
  valid_579595 = validateParameter(valid_579595, JString, required = true,
                                 default = nil)
  if valid_579595 != nil:
    section.add "parent", valid_579595
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
  var valid_579596 = query.getOrDefault("key")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = nil)
  if valid_579596 != nil:
    section.add "key", valid_579596
  var valid_579597 = query.getOrDefault("prettyPrint")
  valid_579597 = validateParameter(valid_579597, JBool, required = false,
                                 default = newJBool(true))
  if valid_579597 != nil:
    section.add "prettyPrint", valid_579597
  var valid_579598 = query.getOrDefault("oauth_token")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = nil)
  if valid_579598 != nil:
    section.add "oauth_token", valid_579598
  var valid_579599 = query.getOrDefault("$.xgafv")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = newJString("1"))
  if valid_579599 != nil:
    section.add "$.xgafv", valid_579599
  var valid_579600 = query.getOrDefault("alt")
  valid_579600 = validateParameter(valid_579600, JString, required = false,
                                 default = newJString("json"))
  if valid_579600 != nil:
    section.add "alt", valid_579600
  var valid_579601 = query.getOrDefault("uploadType")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "uploadType", valid_579601
  var valid_579602 = query.getOrDefault("quotaUser")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = nil)
  if valid_579602 != nil:
    section.add "quotaUser", valid_579602
  var valid_579603 = query.getOrDefault("callback")
  valid_579603 = validateParameter(valid_579603, JString, required = false,
                                 default = nil)
  if valid_579603 != nil:
    section.add "callback", valid_579603
  var valid_579604 = query.getOrDefault("fields")
  valid_579604 = validateParameter(valid_579604, JString, required = false,
                                 default = nil)
  if valid_579604 != nil:
    section.add "fields", valid_579604
  var valid_579605 = query.getOrDefault("access_token")
  valid_579605 = validateParameter(valid_579605, JString, required = false,
                                 default = nil)
  if valid_579605 != nil:
    section.add "access_token", valid_579605
  var valid_579606 = query.getOrDefault("upload_protocol")
  valid_579606 = validateParameter(valid_579606, JString, required = false,
                                 default = nil)
  if valid_579606 != nil:
    section.add "upload_protocol", valid_579606
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

proc call*(call_579608: Call_RunProjectsLocationsRoutesCreate_579592;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_579608.validator(path, query, header, formData, body)
  let scheme = call_579608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579608.url(scheme.get, call_579608.host, call_579608.base,
                         call_579608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579608, url, valid)

proc call*(call_579609: Call_RunProjectsLocationsRoutesCreate_579592;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsRoutesCreate
  ## Create a route.
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
  ##         : The project ID or project number in which this route should be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579610 = newJObject()
  var query_579611 = newJObject()
  var body_579612 = newJObject()
  add(query_579611, "key", newJString(key))
  add(query_579611, "prettyPrint", newJBool(prettyPrint))
  add(query_579611, "oauth_token", newJString(oauthToken))
  add(query_579611, "$.xgafv", newJString(Xgafv))
  add(query_579611, "alt", newJString(alt))
  add(query_579611, "uploadType", newJString(uploadType))
  add(query_579611, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579612 = body
  add(query_579611, "callback", newJString(callback))
  add(path_579610, "parent", newJString(parent))
  add(query_579611, "fields", newJString(fields))
  add(query_579611, "access_token", newJString(accessToken))
  add(query_579611, "upload_protocol", newJString(uploadProtocol))
  result = call_579609.call(path_579610, query_579611, nil, nil, body_579612)

var runProjectsLocationsRoutesCreate* = Call_RunProjectsLocationsRoutesCreate_579592(
    name: "runProjectsLocationsRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesCreate_579593, base: "/",
    url: url_RunProjectsLocationsRoutesCreate_579594, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_579566 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsRoutesList_579568(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsRoutesList_579567(path: JsonNode;
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
  var valid_579569 = path.getOrDefault("parent")
  valid_579569 = validateParameter(valid_579569, JString, required = true,
                                 default = nil)
  if valid_579569 != nil:
    section.add "parent", valid_579569
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579570 = query.getOrDefault("key")
  valid_579570 = validateParameter(valid_579570, JString, required = false,
                                 default = nil)
  if valid_579570 != nil:
    section.add "key", valid_579570
  var valid_579571 = query.getOrDefault("includeUninitialized")
  valid_579571 = validateParameter(valid_579571, JBool, required = false, default = nil)
  if valid_579571 != nil:
    section.add "includeUninitialized", valid_579571
  var valid_579572 = query.getOrDefault("prettyPrint")
  valid_579572 = validateParameter(valid_579572, JBool, required = false,
                                 default = newJBool(true))
  if valid_579572 != nil:
    section.add "prettyPrint", valid_579572
  var valid_579573 = query.getOrDefault("oauth_token")
  valid_579573 = validateParameter(valid_579573, JString, required = false,
                                 default = nil)
  if valid_579573 != nil:
    section.add "oauth_token", valid_579573
  var valid_579574 = query.getOrDefault("fieldSelector")
  valid_579574 = validateParameter(valid_579574, JString, required = false,
                                 default = nil)
  if valid_579574 != nil:
    section.add "fieldSelector", valid_579574
  var valid_579575 = query.getOrDefault("labelSelector")
  valid_579575 = validateParameter(valid_579575, JString, required = false,
                                 default = nil)
  if valid_579575 != nil:
    section.add "labelSelector", valid_579575
  var valid_579576 = query.getOrDefault("$.xgafv")
  valid_579576 = validateParameter(valid_579576, JString, required = false,
                                 default = newJString("1"))
  if valid_579576 != nil:
    section.add "$.xgafv", valid_579576
  var valid_579577 = query.getOrDefault("limit")
  valid_579577 = validateParameter(valid_579577, JInt, required = false, default = nil)
  if valid_579577 != nil:
    section.add "limit", valid_579577
  var valid_579578 = query.getOrDefault("alt")
  valid_579578 = validateParameter(valid_579578, JString, required = false,
                                 default = newJString("json"))
  if valid_579578 != nil:
    section.add "alt", valid_579578
  var valid_579579 = query.getOrDefault("uploadType")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = nil)
  if valid_579579 != nil:
    section.add "uploadType", valid_579579
  var valid_579580 = query.getOrDefault("quotaUser")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = nil)
  if valid_579580 != nil:
    section.add "quotaUser", valid_579580
  var valid_579581 = query.getOrDefault("watch")
  valid_579581 = validateParameter(valid_579581, JBool, required = false, default = nil)
  if valid_579581 != nil:
    section.add "watch", valid_579581
  var valid_579582 = query.getOrDefault("callback")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "callback", valid_579582
  var valid_579583 = query.getOrDefault("resourceVersion")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = nil)
  if valid_579583 != nil:
    section.add "resourceVersion", valid_579583
  var valid_579584 = query.getOrDefault("fields")
  valid_579584 = validateParameter(valid_579584, JString, required = false,
                                 default = nil)
  if valid_579584 != nil:
    section.add "fields", valid_579584
  var valid_579585 = query.getOrDefault("access_token")
  valid_579585 = validateParameter(valid_579585, JString, required = false,
                                 default = nil)
  if valid_579585 != nil:
    section.add "access_token", valid_579585
  var valid_579586 = query.getOrDefault("upload_protocol")
  valid_579586 = validateParameter(valid_579586, JString, required = false,
                                 default = nil)
  if valid_579586 != nil:
    section.add "upload_protocol", valid_579586
  var valid_579587 = query.getOrDefault("continue")
  valid_579587 = validateParameter(valid_579587, JString, required = false,
                                 default = nil)
  if valid_579587 != nil:
    section.add "continue", valid_579587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579588: Call_RunProjectsLocationsRoutesList_579566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_579588.validator(path, query, header, formData, body)
  let scheme = call_579588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579588.url(scheme.get, call_579588.host, call_579588.base,
                         call_579588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579588, url, valid)

proc call*(call_579589: Call_RunProjectsLocationsRoutesList_579566; parent: string;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsRoutesList
  ## List routes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the routes should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579590 = newJObject()
  var query_579591 = newJObject()
  add(query_579591, "key", newJString(key))
  add(query_579591, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579591, "prettyPrint", newJBool(prettyPrint))
  add(query_579591, "oauth_token", newJString(oauthToken))
  add(query_579591, "fieldSelector", newJString(fieldSelector))
  add(query_579591, "labelSelector", newJString(labelSelector))
  add(query_579591, "$.xgafv", newJString(Xgafv))
  add(query_579591, "limit", newJInt(limit))
  add(query_579591, "alt", newJString(alt))
  add(query_579591, "uploadType", newJString(uploadType))
  add(query_579591, "quotaUser", newJString(quotaUser))
  add(query_579591, "watch", newJBool(watch))
  add(query_579591, "callback", newJString(callback))
  add(path_579590, "parent", newJString(parent))
  add(query_579591, "resourceVersion", newJString(resourceVersion))
  add(query_579591, "fields", newJString(fields))
  add(query_579591, "access_token", newJString(accessToken))
  add(query_579591, "upload_protocol", newJString(uploadProtocol))
  add(query_579591, "continue", newJString(`continue`))
  result = call_579589.call(path_579590, query_579591, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_579566(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_579567, base: "/",
    url: url_RunProjectsLocationsRoutesList_579568, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_579639 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesCreate_579641(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesCreate_579640(path: JsonNode;
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
  var valid_579642 = path.getOrDefault("parent")
  valid_579642 = validateParameter(valid_579642, JString, required = true,
                                 default = nil)
  if valid_579642 != nil:
    section.add "parent", valid_579642
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
  var valid_579643 = query.getOrDefault("key")
  valid_579643 = validateParameter(valid_579643, JString, required = false,
                                 default = nil)
  if valid_579643 != nil:
    section.add "key", valid_579643
  var valid_579644 = query.getOrDefault("prettyPrint")
  valid_579644 = validateParameter(valid_579644, JBool, required = false,
                                 default = newJBool(true))
  if valid_579644 != nil:
    section.add "prettyPrint", valid_579644
  var valid_579645 = query.getOrDefault("oauth_token")
  valid_579645 = validateParameter(valid_579645, JString, required = false,
                                 default = nil)
  if valid_579645 != nil:
    section.add "oauth_token", valid_579645
  var valid_579646 = query.getOrDefault("$.xgafv")
  valid_579646 = validateParameter(valid_579646, JString, required = false,
                                 default = newJString("1"))
  if valid_579646 != nil:
    section.add "$.xgafv", valid_579646
  var valid_579647 = query.getOrDefault("alt")
  valid_579647 = validateParameter(valid_579647, JString, required = false,
                                 default = newJString("json"))
  if valid_579647 != nil:
    section.add "alt", valid_579647
  var valid_579648 = query.getOrDefault("uploadType")
  valid_579648 = validateParameter(valid_579648, JString, required = false,
                                 default = nil)
  if valid_579648 != nil:
    section.add "uploadType", valid_579648
  var valid_579649 = query.getOrDefault("quotaUser")
  valid_579649 = validateParameter(valid_579649, JString, required = false,
                                 default = nil)
  if valid_579649 != nil:
    section.add "quotaUser", valid_579649
  var valid_579650 = query.getOrDefault("callback")
  valid_579650 = validateParameter(valid_579650, JString, required = false,
                                 default = nil)
  if valid_579650 != nil:
    section.add "callback", valid_579650
  var valid_579651 = query.getOrDefault("fields")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "fields", valid_579651
  var valid_579652 = query.getOrDefault("access_token")
  valid_579652 = validateParameter(valid_579652, JString, required = false,
                                 default = nil)
  if valid_579652 != nil:
    section.add "access_token", valid_579652
  var valid_579653 = query.getOrDefault("upload_protocol")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "upload_protocol", valid_579653
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

proc call*(call_579655: Call_RunProjectsLocationsServicesCreate_579639;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_579655.validator(path, query, header, formData, body)
  let scheme = call_579655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579655.url(scheme.get, call_579655.host, call_579655.base,
                         call_579655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579655, url, valid)

proc call*(call_579656: Call_RunProjectsLocationsServicesCreate_579639;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesCreate
  ## Create a service.
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
  ##         : The project ID or project number in which this service should be created.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579657 = newJObject()
  var query_579658 = newJObject()
  var body_579659 = newJObject()
  add(query_579658, "key", newJString(key))
  add(query_579658, "prettyPrint", newJBool(prettyPrint))
  add(query_579658, "oauth_token", newJString(oauthToken))
  add(query_579658, "$.xgafv", newJString(Xgafv))
  add(query_579658, "alt", newJString(alt))
  add(query_579658, "uploadType", newJString(uploadType))
  add(query_579658, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579659 = body
  add(query_579658, "callback", newJString(callback))
  add(path_579657, "parent", newJString(parent))
  add(query_579658, "fields", newJString(fields))
  add(query_579658, "access_token", newJString(accessToken))
  add(query_579658, "upload_protocol", newJString(uploadProtocol))
  result = call_579656.call(path_579657, query_579658, nil, nil, body_579659)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_579639(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_579640, base: "/",
    url: url_RunProjectsLocationsServicesCreate_579641, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_579613 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesList_579615(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesList_579614(path: JsonNode;
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
  var valid_579616 = path.getOrDefault("parent")
  valid_579616 = validateParameter(valid_579616, JString, required = true,
                                 default = nil)
  if valid_579616 != nil:
    section.add "parent", valid_579616
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##        : The maximum number of records that should be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579617 = query.getOrDefault("key")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "key", valid_579617
  var valid_579618 = query.getOrDefault("includeUninitialized")
  valid_579618 = validateParameter(valid_579618, JBool, required = false, default = nil)
  if valid_579618 != nil:
    section.add "includeUninitialized", valid_579618
  var valid_579619 = query.getOrDefault("prettyPrint")
  valid_579619 = validateParameter(valid_579619, JBool, required = false,
                                 default = newJBool(true))
  if valid_579619 != nil:
    section.add "prettyPrint", valid_579619
  var valid_579620 = query.getOrDefault("oauth_token")
  valid_579620 = validateParameter(valid_579620, JString, required = false,
                                 default = nil)
  if valid_579620 != nil:
    section.add "oauth_token", valid_579620
  var valid_579621 = query.getOrDefault("fieldSelector")
  valid_579621 = validateParameter(valid_579621, JString, required = false,
                                 default = nil)
  if valid_579621 != nil:
    section.add "fieldSelector", valid_579621
  var valid_579622 = query.getOrDefault("labelSelector")
  valid_579622 = validateParameter(valid_579622, JString, required = false,
                                 default = nil)
  if valid_579622 != nil:
    section.add "labelSelector", valid_579622
  var valid_579623 = query.getOrDefault("$.xgafv")
  valid_579623 = validateParameter(valid_579623, JString, required = false,
                                 default = newJString("1"))
  if valid_579623 != nil:
    section.add "$.xgafv", valid_579623
  var valid_579624 = query.getOrDefault("limit")
  valid_579624 = validateParameter(valid_579624, JInt, required = false, default = nil)
  if valid_579624 != nil:
    section.add "limit", valid_579624
  var valid_579625 = query.getOrDefault("alt")
  valid_579625 = validateParameter(valid_579625, JString, required = false,
                                 default = newJString("json"))
  if valid_579625 != nil:
    section.add "alt", valid_579625
  var valid_579626 = query.getOrDefault("uploadType")
  valid_579626 = validateParameter(valid_579626, JString, required = false,
                                 default = nil)
  if valid_579626 != nil:
    section.add "uploadType", valid_579626
  var valid_579627 = query.getOrDefault("quotaUser")
  valid_579627 = validateParameter(valid_579627, JString, required = false,
                                 default = nil)
  if valid_579627 != nil:
    section.add "quotaUser", valid_579627
  var valid_579628 = query.getOrDefault("watch")
  valid_579628 = validateParameter(valid_579628, JBool, required = false, default = nil)
  if valid_579628 != nil:
    section.add "watch", valid_579628
  var valid_579629 = query.getOrDefault("callback")
  valid_579629 = validateParameter(valid_579629, JString, required = false,
                                 default = nil)
  if valid_579629 != nil:
    section.add "callback", valid_579629
  var valid_579630 = query.getOrDefault("resourceVersion")
  valid_579630 = validateParameter(valid_579630, JString, required = false,
                                 default = nil)
  if valid_579630 != nil:
    section.add "resourceVersion", valid_579630
  var valid_579631 = query.getOrDefault("fields")
  valid_579631 = validateParameter(valid_579631, JString, required = false,
                                 default = nil)
  if valid_579631 != nil:
    section.add "fields", valid_579631
  var valid_579632 = query.getOrDefault("access_token")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "access_token", valid_579632
  var valid_579633 = query.getOrDefault("upload_protocol")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = nil)
  if valid_579633 != nil:
    section.add "upload_protocol", valid_579633
  var valid_579634 = query.getOrDefault("continue")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = nil)
  if valid_579634 != nil:
    section.add "continue", valid_579634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579635: Call_RunProjectsLocationsServicesList_579613;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_579635.validator(path, query, header, formData, body)
  let scheme = call_579635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579635.url(scheme.get, call_579635.host, call_579635.base,
                         call_579635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579635, url, valid)

proc call*(call_579636: Call_RunProjectsLocationsServicesList_579613;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsServicesList
  ## List services.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##        : The maximum number of records that should be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the services should be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579637 = newJObject()
  var query_579638 = newJObject()
  add(query_579638, "key", newJString(key))
  add(query_579638, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579638, "prettyPrint", newJBool(prettyPrint))
  add(query_579638, "oauth_token", newJString(oauthToken))
  add(query_579638, "fieldSelector", newJString(fieldSelector))
  add(query_579638, "labelSelector", newJString(labelSelector))
  add(query_579638, "$.xgafv", newJString(Xgafv))
  add(query_579638, "limit", newJInt(limit))
  add(query_579638, "alt", newJString(alt))
  add(query_579638, "uploadType", newJString(uploadType))
  add(query_579638, "quotaUser", newJString(quotaUser))
  add(query_579638, "watch", newJBool(watch))
  add(query_579638, "callback", newJString(callback))
  add(path_579637, "parent", newJString(parent))
  add(query_579638, "resourceVersion", newJString(resourceVersion))
  add(query_579638, "fields", newJString(fields))
  add(query_579638, "access_token", newJString(accessToken))
  add(query_579638, "upload_protocol", newJString(uploadProtocol))
  add(query_579638, "continue", newJString(`continue`))
  result = call_579636.call(path_579637, query_579638, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_579613(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_579614, base: "/",
    url: url_RunProjectsLocationsServicesList_579615, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_579660 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesGetIamPolicy_579662(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesGetIamPolicy_579661(path: JsonNode;
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
  var valid_579663 = path.getOrDefault("resource")
  valid_579663 = validateParameter(valid_579663, JString, required = true,
                                 default = nil)
  if valid_579663 != nil:
    section.add "resource", valid_579663
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
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
  var valid_579664 = query.getOrDefault("key")
  valid_579664 = validateParameter(valid_579664, JString, required = false,
                                 default = nil)
  if valid_579664 != nil:
    section.add "key", valid_579664
  var valid_579665 = query.getOrDefault("prettyPrint")
  valid_579665 = validateParameter(valid_579665, JBool, required = false,
                                 default = newJBool(true))
  if valid_579665 != nil:
    section.add "prettyPrint", valid_579665
  var valid_579666 = query.getOrDefault("oauth_token")
  valid_579666 = validateParameter(valid_579666, JString, required = false,
                                 default = nil)
  if valid_579666 != nil:
    section.add "oauth_token", valid_579666
  var valid_579667 = query.getOrDefault("$.xgafv")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = newJString("1"))
  if valid_579667 != nil:
    section.add "$.xgafv", valid_579667
  var valid_579668 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579668 = validateParameter(valid_579668, JInt, required = false, default = nil)
  if valid_579668 != nil:
    section.add "options.requestedPolicyVersion", valid_579668
  var valid_579669 = query.getOrDefault("alt")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = newJString("json"))
  if valid_579669 != nil:
    section.add "alt", valid_579669
  var valid_579670 = query.getOrDefault("uploadType")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = nil)
  if valid_579670 != nil:
    section.add "uploadType", valid_579670
  var valid_579671 = query.getOrDefault("quotaUser")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "quotaUser", valid_579671
  var valid_579672 = query.getOrDefault("callback")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "callback", valid_579672
  var valid_579673 = query.getOrDefault("fields")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "fields", valid_579673
  var valid_579674 = query.getOrDefault("access_token")
  valid_579674 = validateParameter(valid_579674, JString, required = false,
                                 default = nil)
  if valid_579674 != nil:
    section.add "access_token", valid_579674
  var valid_579675 = query.getOrDefault("upload_protocol")
  valid_579675 = validateParameter(valid_579675, JString, required = false,
                                 default = nil)
  if valid_579675 != nil:
    section.add "upload_protocol", valid_579675
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579676: Call_RunProjectsLocationsServicesGetIamPolicy_579660;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_579676.validator(path, query, header, formData, body)
  let scheme = call_579676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579676.url(scheme.get, call_579676.host, call_579676.base,
                         call_579676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579676, url, valid)

proc call*(call_579677: Call_RunProjectsLocationsServicesGetIamPolicy_579660;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesGetIamPolicy
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579678 = newJObject()
  var query_579679 = newJObject()
  add(query_579679, "key", newJString(key))
  add(query_579679, "prettyPrint", newJBool(prettyPrint))
  add(query_579679, "oauth_token", newJString(oauthToken))
  add(query_579679, "$.xgafv", newJString(Xgafv))
  add(query_579679, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579679, "alt", newJString(alt))
  add(query_579679, "uploadType", newJString(uploadType))
  add(query_579679, "quotaUser", newJString(quotaUser))
  add(path_579678, "resource", newJString(resource))
  add(query_579679, "callback", newJString(callback))
  add(query_579679, "fields", newJString(fields))
  add(query_579679, "access_token", newJString(accessToken))
  add(query_579679, "upload_protocol", newJString(uploadProtocol))
  result = call_579677.call(path_579678, query_579679, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_579660(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_579661,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_579662,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_579680 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesSetIamPolicy_579682(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesSetIamPolicy_579681(path: JsonNode;
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
  var valid_579683 = path.getOrDefault("resource")
  valid_579683 = validateParameter(valid_579683, JString, required = true,
                                 default = nil)
  if valid_579683 != nil:
    section.add "resource", valid_579683
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
  var valid_579684 = query.getOrDefault("key")
  valid_579684 = validateParameter(valid_579684, JString, required = false,
                                 default = nil)
  if valid_579684 != nil:
    section.add "key", valid_579684
  var valid_579685 = query.getOrDefault("prettyPrint")
  valid_579685 = validateParameter(valid_579685, JBool, required = false,
                                 default = newJBool(true))
  if valid_579685 != nil:
    section.add "prettyPrint", valid_579685
  var valid_579686 = query.getOrDefault("oauth_token")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = nil)
  if valid_579686 != nil:
    section.add "oauth_token", valid_579686
  var valid_579687 = query.getOrDefault("$.xgafv")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = newJString("1"))
  if valid_579687 != nil:
    section.add "$.xgafv", valid_579687
  var valid_579688 = query.getOrDefault("alt")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = newJString("json"))
  if valid_579688 != nil:
    section.add "alt", valid_579688
  var valid_579689 = query.getOrDefault("uploadType")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = nil)
  if valid_579689 != nil:
    section.add "uploadType", valid_579689
  var valid_579690 = query.getOrDefault("quotaUser")
  valid_579690 = validateParameter(valid_579690, JString, required = false,
                                 default = nil)
  if valid_579690 != nil:
    section.add "quotaUser", valid_579690
  var valid_579691 = query.getOrDefault("callback")
  valid_579691 = validateParameter(valid_579691, JString, required = false,
                                 default = nil)
  if valid_579691 != nil:
    section.add "callback", valid_579691
  var valid_579692 = query.getOrDefault("fields")
  valid_579692 = validateParameter(valid_579692, JString, required = false,
                                 default = nil)
  if valid_579692 != nil:
    section.add "fields", valid_579692
  var valid_579693 = query.getOrDefault("access_token")
  valid_579693 = validateParameter(valid_579693, JString, required = false,
                                 default = nil)
  if valid_579693 != nil:
    section.add "access_token", valid_579693
  var valid_579694 = query.getOrDefault("upload_protocol")
  valid_579694 = validateParameter(valid_579694, JString, required = false,
                                 default = nil)
  if valid_579694 != nil:
    section.add "upload_protocol", valid_579694
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

proc call*(call_579696: Call_RunProjectsLocationsServicesSetIamPolicy_579680;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_579696.validator(path, query, header, formData, body)
  let scheme = call_579696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579696.url(scheme.get, call_579696.host, call_579696.base,
                         call_579696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579696, url, valid)

proc call*(call_579697: Call_RunProjectsLocationsServicesSetIamPolicy_579680;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesSetIamPolicy
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
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
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579698 = newJObject()
  var query_579699 = newJObject()
  var body_579700 = newJObject()
  add(query_579699, "key", newJString(key))
  add(query_579699, "prettyPrint", newJBool(prettyPrint))
  add(query_579699, "oauth_token", newJString(oauthToken))
  add(query_579699, "$.xgafv", newJString(Xgafv))
  add(query_579699, "alt", newJString(alt))
  add(query_579699, "uploadType", newJString(uploadType))
  add(query_579699, "quotaUser", newJString(quotaUser))
  add(path_579698, "resource", newJString(resource))
  if body != nil:
    body_579700 = body
  add(query_579699, "callback", newJString(callback))
  add(query_579699, "fields", newJString(fields))
  add(query_579699, "access_token", newJString(accessToken))
  add(query_579699, "upload_protocol", newJString(uploadProtocol))
  result = call_579697.call(path_579698, query_579699, nil, nil, body_579700)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_579680(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_579681,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_579682,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_579701 = ref object of OpenApiRestCall_578348
proc url_RunProjectsLocationsServicesTestIamPermissions_579703(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesTestIamPermissions_579702(
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
  var valid_579704 = path.getOrDefault("resource")
  valid_579704 = validateParameter(valid_579704, JString, required = true,
                                 default = nil)
  if valid_579704 != nil:
    section.add "resource", valid_579704
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
  var valid_579705 = query.getOrDefault("key")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "key", valid_579705
  var valid_579706 = query.getOrDefault("prettyPrint")
  valid_579706 = validateParameter(valid_579706, JBool, required = false,
                                 default = newJBool(true))
  if valid_579706 != nil:
    section.add "prettyPrint", valid_579706
  var valid_579707 = query.getOrDefault("oauth_token")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = nil)
  if valid_579707 != nil:
    section.add "oauth_token", valid_579707
  var valid_579708 = query.getOrDefault("$.xgafv")
  valid_579708 = validateParameter(valid_579708, JString, required = false,
                                 default = newJString("1"))
  if valid_579708 != nil:
    section.add "$.xgafv", valid_579708
  var valid_579709 = query.getOrDefault("alt")
  valid_579709 = validateParameter(valid_579709, JString, required = false,
                                 default = newJString("json"))
  if valid_579709 != nil:
    section.add "alt", valid_579709
  var valid_579710 = query.getOrDefault("uploadType")
  valid_579710 = validateParameter(valid_579710, JString, required = false,
                                 default = nil)
  if valid_579710 != nil:
    section.add "uploadType", valid_579710
  var valid_579711 = query.getOrDefault("quotaUser")
  valid_579711 = validateParameter(valid_579711, JString, required = false,
                                 default = nil)
  if valid_579711 != nil:
    section.add "quotaUser", valid_579711
  var valid_579712 = query.getOrDefault("callback")
  valid_579712 = validateParameter(valid_579712, JString, required = false,
                                 default = nil)
  if valid_579712 != nil:
    section.add "callback", valid_579712
  var valid_579713 = query.getOrDefault("fields")
  valid_579713 = validateParameter(valid_579713, JString, required = false,
                                 default = nil)
  if valid_579713 != nil:
    section.add "fields", valid_579713
  var valid_579714 = query.getOrDefault("access_token")
  valid_579714 = validateParameter(valid_579714, JString, required = false,
                                 default = nil)
  if valid_579714 != nil:
    section.add "access_token", valid_579714
  var valid_579715 = query.getOrDefault("upload_protocol")
  valid_579715 = validateParameter(valid_579715, JString, required = false,
                                 default = nil)
  if valid_579715 != nil:
    section.add "upload_protocol", valid_579715
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

proc call*(call_579717: Call_RunProjectsLocationsServicesTestIamPermissions_579701;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_579717.validator(path, query, header, formData, body)
  let scheme = call_579717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579717.url(scheme.get, call_579717.host, call_579717.base,
                         call_579717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579717, url, valid)

proc call*(call_579718: Call_RunProjectsLocationsServicesTestIamPermissions_579701;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsServicesTestIamPermissions
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
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
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579719 = newJObject()
  var query_579720 = newJObject()
  var body_579721 = newJObject()
  add(query_579720, "key", newJString(key))
  add(query_579720, "prettyPrint", newJBool(prettyPrint))
  add(query_579720, "oauth_token", newJString(oauthToken))
  add(query_579720, "$.xgafv", newJString(Xgafv))
  add(query_579720, "alt", newJString(alt))
  add(query_579720, "uploadType", newJString(uploadType))
  add(query_579720, "quotaUser", newJString(quotaUser))
  add(path_579719, "resource", newJString(resource))
  if body != nil:
    body_579721 = body
  add(query_579720, "callback", newJString(callback))
  add(query_579720, "fields", newJString(fields))
  add(query_579720, "access_token", newJString(accessToken))
  add(query_579720, "upload_protocol", newJString(uploadProtocol))
  result = call_579718.call(path_579719, query_579720, nil, nil, body_579721)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_579701(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_579702,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_579703,
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
