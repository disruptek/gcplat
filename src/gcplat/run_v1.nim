
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
  gcpServiceName = "run"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunNamespacesDomainmappingsReplaceDomainMapping_589007 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesDomainmappingsReplaceDomainMapping_589009(protocol: Scheme;
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

proc validate_RunNamespacesDomainmappingsReplaceDomainMapping_589008(
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
  var valid_589010 = path.getOrDefault("name")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "name", valid_589010
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589023: Call_RunNamespacesDomainmappingsReplaceDomainMapping_589007;
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
  let valid = call_589023.validator(path, query, header, formData, body)
  let scheme = call_589023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589023.url(scheme.get, call_589023.host, call_589023.base,
                         call_589023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589023, url, valid)

proc call*(call_589024: Call_RunNamespacesDomainmappingsReplaceDomainMapping_589007;
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
  var path_589025 = newJObject()
  var query_589026 = newJObject()
  var body_589027 = newJObject()
  add(query_589026, "upload_protocol", newJString(uploadProtocol))
  add(query_589026, "fields", newJString(fields))
  add(query_589026, "quotaUser", newJString(quotaUser))
  add(path_589025, "name", newJString(name))
  add(query_589026, "alt", newJString(alt))
  add(query_589026, "oauth_token", newJString(oauthToken))
  add(query_589026, "callback", newJString(callback))
  add(query_589026, "access_token", newJString(accessToken))
  add(query_589026, "uploadType", newJString(uploadType))
  add(query_589026, "key", newJString(key))
  add(query_589026, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589027 = body
  add(query_589026, "prettyPrint", newJBool(prettyPrint))
  result = call_589024.call(path_589025, query_589026, nil, nil, body_589027)

var runNamespacesDomainmappingsReplaceDomainMapping* = Call_RunNamespacesDomainmappingsReplaceDomainMapping_589007(
    name: "runNamespacesDomainmappingsReplaceDomainMapping",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsReplaceDomainMapping_589008,
    base: "/", url: url_RunNamespacesDomainmappingsReplaceDomainMapping_589009,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsGet_588719 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesDomainmappingsGet_588721(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsGet_588720(path: JsonNode;
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
  var valid_588847 = path.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
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

proc call*(call_588894: Call_RunNamespacesDomainmappingsGet_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a domain mapping.
  ## 
  let valid = call_588894.validator(path, query, header, formData, body)
  let scheme = call_588894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588894.url(scheme.get, call_588894.host, call_588894.base,
                         call_588894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588894, url, valid)

proc call*(call_588965: Call_RunNamespacesDomainmappingsGet_588719; name: string;
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
  var path_588966 = newJObject()
  var query_588968 = newJObject()
  add(query_588968, "upload_protocol", newJString(uploadProtocol))
  add(query_588968, "fields", newJString(fields))
  add(query_588968, "quotaUser", newJString(quotaUser))
  add(path_588966, "name", newJString(name))
  add(query_588968, "alt", newJString(alt))
  add(query_588968, "oauth_token", newJString(oauthToken))
  add(query_588968, "callback", newJString(callback))
  add(query_588968, "access_token", newJString(accessToken))
  add(query_588968, "uploadType", newJString(uploadType))
  add(query_588968, "key", newJString(key))
  add(query_588968, "$.xgafv", newJString(Xgafv))
  add(query_588968, "prettyPrint", newJBool(prettyPrint))
  result = call_588965.call(path_588966, query_588968, nil, nil, nil)

var runNamespacesDomainmappingsGet* = Call_RunNamespacesDomainmappingsGet_588719(
    name: "runNamespacesDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsGet_588720, base: "/",
    url: url_RunNamespacesDomainmappingsGet_588721, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsDelete_589028 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesDomainmappingsDelete_589030(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsDelete_589029(path: JsonNode;
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
  var valid_589031 = path.getOrDefault("name")
  valid_589031 = validateParameter(valid_589031, JString, required = true,
                                 default = nil)
  if valid_589031 != nil:
    section.add "name", valid_589031
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
  var valid_589032 = query.getOrDefault("upload_protocol")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "upload_protocol", valid_589032
  var valid_589033 = query.getOrDefault("fields")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "fields", valid_589033
  var valid_589034 = query.getOrDefault("quotaUser")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "quotaUser", valid_589034
  var valid_589035 = query.getOrDefault("alt")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = newJString("json"))
  if valid_589035 != nil:
    section.add "alt", valid_589035
  var valid_589036 = query.getOrDefault("oauth_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "oauth_token", valid_589036
  var valid_589037 = query.getOrDefault("callback")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "callback", valid_589037
  var valid_589038 = query.getOrDefault("access_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "access_token", valid_589038
  var valid_589039 = query.getOrDefault("uploadType")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "uploadType", valid_589039
  var valid_589040 = query.getOrDefault("kind")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "kind", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("$.xgafv")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("1"))
  if valid_589042 != nil:
    section.add "$.xgafv", valid_589042
  var valid_589043 = query.getOrDefault("prettyPrint")
  valid_589043 = validateParameter(valid_589043, JBool, required = false,
                                 default = newJBool(true))
  if valid_589043 != nil:
    section.add "prettyPrint", valid_589043
  var valid_589044 = query.getOrDefault("propagationPolicy")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "propagationPolicy", valid_589044
  var valid_589045 = query.getOrDefault("apiVersion")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "apiVersion", valid_589045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589046: Call_RunNamespacesDomainmappingsDelete_589028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a domain mapping.
  ## 
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_RunNamespacesDomainmappingsDelete_589028;
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
  var path_589048 = newJObject()
  var query_589049 = newJObject()
  add(query_589049, "upload_protocol", newJString(uploadProtocol))
  add(query_589049, "fields", newJString(fields))
  add(query_589049, "quotaUser", newJString(quotaUser))
  add(path_589048, "name", newJString(name))
  add(query_589049, "alt", newJString(alt))
  add(query_589049, "oauth_token", newJString(oauthToken))
  add(query_589049, "callback", newJString(callback))
  add(query_589049, "access_token", newJString(accessToken))
  add(query_589049, "uploadType", newJString(uploadType))
  add(query_589049, "kind", newJString(kind))
  add(query_589049, "key", newJString(key))
  add(query_589049, "$.xgafv", newJString(Xgafv))
  add(query_589049, "prettyPrint", newJBool(prettyPrint))
  add(query_589049, "propagationPolicy", newJString(propagationPolicy))
  add(query_589049, "apiVersion", newJString(apiVersion))
  result = call_589047.call(path_589048, query_589049, nil, nil, nil)

var runNamespacesDomainmappingsDelete* = Call_RunNamespacesDomainmappingsDelete_589028(
    name: "runNamespacesDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/domains.cloudrun.com/v1/{name}",
    validator: validate_RunNamespacesDomainmappingsDelete_589029, base: "/",
    url: url_RunNamespacesDomainmappingsDelete_589030, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_589050 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesAuthorizeddomainsList_589052(protocol: Scheme; host: string;
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

proc validate_RunNamespacesAuthorizeddomainsList_589051(path: JsonNode;
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
  var valid_589053 = path.getOrDefault("parent")
  valid_589053 = validateParameter(valid_589053, JString, required = true,
                                 default = nil)
  if valid_589053 != nil:
    section.add "parent", valid_589053
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
  var valid_589054 = query.getOrDefault("upload_protocol")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "upload_protocol", valid_589054
  var valid_589055 = query.getOrDefault("fields")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "fields", valid_589055
  var valid_589056 = query.getOrDefault("pageToken")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "pageToken", valid_589056
  var valid_589057 = query.getOrDefault("quotaUser")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "quotaUser", valid_589057
  var valid_589058 = query.getOrDefault("alt")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("json"))
  if valid_589058 != nil:
    section.add "alt", valid_589058
  var valid_589059 = query.getOrDefault("oauth_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "oauth_token", valid_589059
  var valid_589060 = query.getOrDefault("callback")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "callback", valid_589060
  var valid_589061 = query.getOrDefault("access_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "access_token", valid_589061
  var valid_589062 = query.getOrDefault("uploadType")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "uploadType", valid_589062
  var valid_589063 = query.getOrDefault("key")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "key", valid_589063
  var valid_589064 = query.getOrDefault("$.xgafv")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = newJString("1"))
  if valid_589064 != nil:
    section.add "$.xgafv", valid_589064
  var valid_589065 = query.getOrDefault("pageSize")
  valid_589065 = validateParameter(valid_589065, JInt, required = false, default = nil)
  if valid_589065 != nil:
    section.add "pageSize", valid_589065
  var valid_589066 = query.getOrDefault("prettyPrint")
  valid_589066 = validateParameter(valid_589066, JBool, required = false,
                                 default = newJBool(true))
  if valid_589066 != nil:
    section.add "prettyPrint", valid_589066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589067: Call_RunNamespacesAuthorizeddomainsList_589050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_589067.validator(path, query, header, formData, body)
  let scheme = call_589067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589067.url(scheme.get, call_589067.host, call_589067.base,
                         call_589067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589067, url, valid)

proc call*(call_589068: Call_RunNamespacesAuthorizeddomainsList_589050;
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
  var path_589069 = newJObject()
  var query_589070 = newJObject()
  add(query_589070, "upload_protocol", newJString(uploadProtocol))
  add(query_589070, "fields", newJString(fields))
  add(query_589070, "pageToken", newJString(pageToken))
  add(query_589070, "quotaUser", newJString(quotaUser))
  add(query_589070, "alt", newJString(alt))
  add(query_589070, "oauth_token", newJString(oauthToken))
  add(query_589070, "callback", newJString(callback))
  add(query_589070, "access_token", newJString(accessToken))
  add(query_589070, "uploadType", newJString(uploadType))
  add(path_589069, "parent", newJString(parent))
  add(query_589070, "key", newJString(key))
  add(query_589070, "$.xgafv", newJString(Xgafv))
  add(query_589070, "pageSize", newJInt(pageSize))
  add(query_589070, "prettyPrint", newJBool(prettyPrint))
  result = call_589068.call(path_589069, query_589070, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_589050(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_589051, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_589052, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsCreate_589097 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesAutodomainmappingsCreate_589099(protocol: Scheme;
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

proc validate_RunNamespacesAutodomainmappingsCreate_589098(path: JsonNode;
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
  var valid_589100 = path.getOrDefault("parent")
  valid_589100 = validateParameter(valid_589100, JString, required = true,
                                 default = nil)
  if valid_589100 != nil:
    section.add "parent", valid_589100
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
  var valid_589101 = query.getOrDefault("upload_protocol")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "upload_protocol", valid_589101
  var valid_589102 = query.getOrDefault("fields")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "fields", valid_589102
  var valid_589103 = query.getOrDefault("quotaUser")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "quotaUser", valid_589103
  var valid_589104 = query.getOrDefault("alt")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = newJString("json"))
  if valid_589104 != nil:
    section.add "alt", valid_589104
  var valid_589105 = query.getOrDefault("oauth_token")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "oauth_token", valid_589105
  var valid_589106 = query.getOrDefault("callback")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "callback", valid_589106
  var valid_589107 = query.getOrDefault("access_token")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "access_token", valid_589107
  var valid_589108 = query.getOrDefault("uploadType")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "uploadType", valid_589108
  var valid_589109 = query.getOrDefault("key")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "key", valid_589109
  var valid_589110 = query.getOrDefault("$.xgafv")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = newJString("1"))
  if valid_589110 != nil:
    section.add "$.xgafv", valid_589110
  var valid_589111 = query.getOrDefault("prettyPrint")
  valid_589111 = validateParameter(valid_589111, JBool, required = false,
                                 default = newJBool(true))
  if valid_589111 != nil:
    section.add "prettyPrint", valid_589111
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

proc call*(call_589113: Call_RunNamespacesAutodomainmappingsCreate_589097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_589113.validator(path, query, header, formData, body)
  let scheme = call_589113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589113.url(scheme.get, call_589113.host, call_589113.base,
                         call_589113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589113, url, valid)

proc call*(call_589114: Call_RunNamespacesAutodomainmappingsCreate_589097;
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
  var path_589115 = newJObject()
  var query_589116 = newJObject()
  var body_589117 = newJObject()
  add(query_589116, "upload_protocol", newJString(uploadProtocol))
  add(query_589116, "fields", newJString(fields))
  add(query_589116, "quotaUser", newJString(quotaUser))
  add(query_589116, "alt", newJString(alt))
  add(query_589116, "oauth_token", newJString(oauthToken))
  add(query_589116, "callback", newJString(callback))
  add(query_589116, "access_token", newJString(accessToken))
  add(query_589116, "uploadType", newJString(uploadType))
  add(path_589115, "parent", newJString(parent))
  add(query_589116, "key", newJString(key))
  add(query_589116, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589117 = body
  add(query_589116, "prettyPrint", newJBool(prettyPrint))
  result = call_589114.call(path_589115, query_589116, nil, nil, body_589117)

var runNamespacesAutodomainmappingsCreate* = Call_RunNamespacesAutodomainmappingsCreate_589097(
    name: "runNamespacesAutodomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsCreate_589098, base: "/",
    url: url_RunNamespacesAutodomainmappingsCreate_589099, schemes: {Scheme.Https})
type
  Call_RunNamespacesAutodomainmappingsList_589071 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesAutodomainmappingsList_589073(protocol: Scheme; host: string;
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

proc validate_RunNamespacesAutodomainmappingsList_589072(path: JsonNode;
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
  var valid_589074 = path.getOrDefault("parent")
  valid_589074 = validateParameter(valid_589074, JString, required = true,
                                 default = nil)
  if valid_589074 != nil:
    section.add "parent", valid_589074
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
  var valid_589075 = query.getOrDefault("upload_protocol")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "upload_protocol", valid_589075
  var valid_589076 = query.getOrDefault("fields")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "fields", valid_589076
  var valid_589077 = query.getOrDefault("quotaUser")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "quotaUser", valid_589077
  var valid_589078 = query.getOrDefault("includeUninitialized")
  valid_589078 = validateParameter(valid_589078, JBool, required = false, default = nil)
  if valid_589078 != nil:
    section.add "includeUninitialized", valid_589078
  var valid_589079 = query.getOrDefault("alt")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = newJString("json"))
  if valid_589079 != nil:
    section.add "alt", valid_589079
  var valid_589080 = query.getOrDefault("continue")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "continue", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("callback")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "callback", valid_589082
  var valid_589083 = query.getOrDefault("access_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "access_token", valid_589083
  var valid_589084 = query.getOrDefault("uploadType")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "uploadType", valid_589084
  var valid_589085 = query.getOrDefault("resourceVersion")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "resourceVersion", valid_589085
  var valid_589086 = query.getOrDefault("watch")
  valid_589086 = validateParameter(valid_589086, JBool, required = false, default = nil)
  if valid_589086 != nil:
    section.add "watch", valid_589086
  var valid_589087 = query.getOrDefault("key")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "key", valid_589087
  var valid_589088 = query.getOrDefault("$.xgafv")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = newJString("1"))
  if valid_589088 != nil:
    section.add "$.xgafv", valid_589088
  var valid_589089 = query.getOrDefault("labelSelector")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "labelSelector", valid_589089
  var valid_589090 = query.getOrDefault("prettyPrint")
  valid_589090 = validateParameter(valid_589090, JBool, required = false,
                                 default = newJBool(true))
  if valid_589090 != nil:
    section.add "prettyPrint", valid_589090
  var valid_589091 = query.getOrDefault("fieldSelector")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "fieldSelector", valid_589091
  var valid_589092 = query.getOrDefault("limit")
  valid_589092 = validateParameter(valid_589092, JInt, required = false, default = nil)
  if valid_589092 != nil:
    section.add "limit", valid_589092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589093: Call_RunNamespacesAutodomainmappingsList_589071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_589093.validator(path, query, header, formData, body)
  let scheme = call_589093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589093.url(scheme.get, call_589093.host, call_589093.base,
                         call_589093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589093, url, valid)

proc call*(call_589094: Call_RunNamespacesAutodomainmappingsList_589071;
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
  var path_589095 = newJObject()
  var query_589096 = newJObject()
  add(query_589096, "upload_protocol", newJString(uploadProtocol))
  add(query_589096, "fields", newJString(fields))
  add(query_589096, "quotaUser", newJString(quotaUser))
  add(query_589096, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589096, "alt", newJString(alt))
  add(query_589096, "continue", newJString(`continue`))
  add(query_589096, "oauth_token", newJString(oauthToken))
  add(query_589096, "callback", newJString(callback))
  add(query_589096, "access_token", newJString(accessToken))
  add(query_589096, "uploadType", newJString(uploadType))
  add(path_589095, "parent", newJString(parent))
  add(query_589096, "resourceVersion", newJString(resourceVersion))
  add(query_589096, "watch", newJBool(watch))
  add(query_589096, "key", newJString(key))
  add(query_589096, "$.xgafv", newJString(Xgafv))
  add(query_589096, "labelSelector", newJString(labelSelector))
  add(query_589096, "prettyPrint", newJBool(prettyPrint))
  add(query_589096, "fieldSelector", newJString(fieldSelector))
  add(query_589096, "limit", newJInt(limit))
  result = call_589094.call(path_589095, query_589096, nil, nil, nil)

var runNamespacesAutodomainmappingsList* = Call_RunNamespacesAutodomainmappingsList_589071(
    name: "runNamespacesAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/autodomainmappings",
    validator: validate_RunNamespacesAutodomainmappingsList_589072, base: "/",
    url: url_RunNamespacesAutodomainmappingsList_589073, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_589144 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesDomainmappingsCreate_589146(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsCreate_589145(path: JsonNode;
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
  var valid_589147 = path.getOrDefault("parent")
  valid_589147 = validateParameter(valid_589147, JString, required = true,
                                 default = nil)
  if valid_589147 != nil:
    section.add "parent", valid_589147
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
  var valid_589148 = query.getOrDefault("upload_protocol")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "upload_protocol", valid_589148
  var valid_589149 = query.getOrDefault("fields")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "fields", valid_589149
  var valid_589150 = query.getOrDefault("quotaUser")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "quotaUser", valid_589150
  var valid_589151 = query.getOrDefault("alt")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = newJString("json"))
  if valid_589151 != nil:
    section.add "alt", valid_589151
  var valid_589152 = query.getOrDefault("oauth_token")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "oauth_token", valid_589152
  var valid_589153 = query.getOrDefault("callback")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "callback", valid_589153
  var valid_589154 = query.getOrDefault("access_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "access_token", valid_589154
  var valid_589155 = query.getOrDefault("uploadType")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "uploadType", valid_589155
  var valid_589156 = query.getOrDefault("key")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "key", valid_589156
  var valid_589157 = query.getOrDefault("$.xgafv")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = newJString("1"))
  if valid_589157 != nil:
    section.add "$.xgafv", valid_589157
  var valid_589158 = query.getOrDefault("prettyPrint")
  valid_589158 = validateParameter(valid_589158, JBool, required = false,
                                 default = newJBool(true))
  if valid_589158 != nil:
    section.add "prettyPrint", valid_589158
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

proc call*(call_589160: Call_RunNamespacesDomainmappingsCreate_589144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_589160.validator(path, query, header, formData, body)
  let scheme = call_589160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589160.url(scheme.get, call_589160.host, call_589160.base,
                         call_589160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589160, url, valid)

proc call*(call_589161: Call_RunNamespacesDomainmappingsCreate_589144;
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
  var path_589162 = newJObject()
  var query_589163 = newJObject()
  var body_589164 = newJObject()
  add(query_589163, "upload_protocol", newJString(uploadProtocol))
  add(query_589163, "fields", newJString(fields))
  add(query_589163, "quotaUser", newJString(quotaUser))
  add(query_589163, "alt", newJString(alt))
  add(query_589163, "oauth_token", newJString(oauthToken))
  add(query_589163, "callback", newJString(callback))
  add(query_589163, "access_token", newJString(accessToken))
  add(query_589163, "uploadType", newJString(uploadType))
  add(path_589162, "parent", newJString(parent))
  add(query_589163, "key", newJString(key))
  add(query_589163, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589164 = body
  add(query_589163, "prettyPrint", newJBool(prettyPrint))
  result = call_589161.call(path_589162, query_589163, nil, nil, body_589164)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_589144(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_589145, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_589146, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_589118 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesDomainmappingsList_589120(protocol: Scheme; host: string;
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

proc validate_RunNamespacesDomainmappingsList_589119(path: JsonNode;
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
  var valid_589121 = path.getOrDefault("parent")
  valid_589121 = validateParameter(valid_589121, JString, required = true,
                                 default = nil)
  if valid_589121 != nil:
    section.add "parent", valid_589121
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
  var valid_589122 = query.getOrDefault("upload_protocol")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "upload_protocol", valid_589122
  var valid_589123 = query.getOrDefault("fields")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "fields", valid_589123
  var valid_589124 = query.getOrDefault("quotaUser")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "quotaUser", valid_589124
  var valid_589125 = query.getOrDefault("includeUninitialized")
  valid_589125 = validateParameter(valid_589125, JBool, required = false, default = nil)
  if valid_589125 != nil:
    section.add "includeUninitialized", valid_589125
  var valid_589126 = query.getOrDefault("alt")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = newJString("json"))
  if valid_589126 != nil:
    section.add "alt", valid_589126
  var valid_589127 = query.getOrDefault("continue")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "continue", valid_589127
  var valid_589128 = query.getOrDefault("oauth_token")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "oauth_token", valid_589128
  var valid_589129 = query.getOrDefault("callback")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "callback", valid_589129
  var valid_589130 = query.getOrDefault("access_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "access_token", valid_589130
  var valid_589131 = query.getOrDefault("uploadType")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "uploadType", valid_589131
  var valid_589132 = query.getOrDefault("resourceVersion")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "resourceVersion", valid_589132
  var valid_589133 = query.getOrDefault("watch")
  valid_589133 = validateParameter(valid_589133, JBool, required = false, default = nil)
  if valid_589133 != nil:
    section.add "watch", valid_589133
  var valid_589134 = query.getOrDefault("key")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "key", valid_589134
  var valid_589135 = query.getOrDefault("$.xgafv")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = newJString("1"))
  if valid_589135 != nil:
    section.add "$.xgafv", valid_589135
  var valid_589136 = query.getOrDefault("labelSelector")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "labelSelector", valid_589136
  var valid_589137 = query.getOrDefault("prettyPrint")
  valid_589137 = validateParameter(valid_589137, JBool, required = false,
                                 default = newJBool(true))
  if valid_589137 != nil:
    section.add "prettyPrint", valid_589137
  var valid_589138 = query.getOrDefault("fieldSelector")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "fieldSelector", valid_589138
  var valid_589139 = query.getOrDefault("limit")
  valid_589139 = validateParameter(valid_589139, JInt, required = false, default = nil)
  if valid_589139 != nil:
    section.add "limit", valid_589139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589140: Call_RunNamespacesDomainmappingsList_589118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_589140.validator(path, query, header, formData, body)
  let scheme = call_589140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589140.url(scheme.get, call_589140.host, call_589140.base,
                         call_589140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589140, url, valid)

proc call*(call_589141: Call_RunNamespacesDomainmappingsList_589118;
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
  var path_589142 = newJObject()
  var query_589143 = newJObject()
  add(query_589143, "upload_protocol", newJString(uploadProtocol))
  add(query_589143, "fields", newJString(fields))
  add(query_589143, "quotaUser", newJString(quotaUser))
  add(query_589143, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589143, "alt", newJString(alt))
  add(query_589143, "continue", newJString(`continue`))
  add(query_589143, "oauth_token", newJString(oauthToken))
  add(query_589143, "callback", newJString(callback))
  add(query_589143, "access_token", newJString(accessToken))
  add(query_589143, "uploadType", newJString(uploadType))
  add(path_589142, "parent", newJString(parent))
  add(query_589143, "resourceVersion", newJString(resourceVersion))
  add(query_589143, "watch", newJBool(watch))
  add(query_589143, "key", newJString(key))
  add(query_589143, "$.xgafv", newJString(Xgafv))
  add(query_589143, "labelSelector", newJString(labelSelector))
  add(query_589143, "prettyPrint", newJBool(prettyPrint))
  add(query_589143, "fieldSelector", newJString(fieldSelector))
  add(query_589143, "limit", newJInt(limit))
  result = call_589141.call(path_589142, query_589143, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_589118(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_589119, base: "/",
    url: url_RunNamespacesDomainmappingsList_589120, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsReplaceConfiguration_589184 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesConfigurationsReplaceConfiguration_589186(protocol: Scheme;
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

proc validate_RunNamespacesConfigurationsReplaceConfiguration_589185(
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
  var valid_589187 = path.getOrDefault("name")
  valid_589187 = validateParameter(valid_589187, JString, required = true,
                                 default = nil)
  if valid_589187 != nil:
    section.add "name", valid_589187
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
  var valid_589188 = query.getOrDefault("upload_protocol")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "upload_protocol", valid_589188
  var valid_589189 = query.getOrDefault("fields")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "fields", valid_589189
  var valid_589190 = query.getOrDefault("quotaUser")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "quotaUser", valid_589190
  var valid_589191 = query.getOrDefault("alt")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = newJString("json"))
  if valid_589191 != nil:
    section.add "alt", valid_589191
  var valid_589192 = query.getOrDefault("oauth_token")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "oauth_token", valid_589192
  var valid_589193 = query.getOrDefault("callback")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "callback", valid_589193
  var valid_589194 = query.getOrDefault("access_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "access_token", valid_589194
  var valid_589195 = query.getOrDefault("uploadType")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "uploadType", valid_589195
  var valid_589196 = query.getOrDefault("key")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "key", valid_589196
  var valid_589197 = query.getOrDefault("$.xgafv")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = newJString("1"))
  if valid_589197 != nil:
    section.add "$.xgafv", valid_589197
  var valid_589198 = query.getOrDefault("prettyPrint")
  valid_589198 = validateParameter(valid_589198, JBool, required = false,
                                 default = newJBool(true))
  if valid_589198 != nil:
    section.add "prettyPrint", valid_589198
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

proc call*(call_589200: Call_RunNamespacesConfigurationsReplaceConfiguration_589184;
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
  let valid = call_589200.validator(path, query, header, formData, body)
  let scheme = call_589200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589200.url(scheme.get, call_589200.host, call_589200.base,
                         call_589200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589200, url, valid)

proc call*(call_589201: Call_RunNamespacesConfigurationsReplaceConfiguration_589184;
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
  var path_589202 = newJObject()
  var query_589203 = newJObject()
  var body_589204 = newJObject()
  add(query_589203, "upload_protocol", newJString(uploadProtocol))
  add(query_589203, "fields", newJString(fields))
  add(query_589203, "quotaUser", newJString(quotaUser))
  add(path_589202, "name", newJString(name))
  add(query_589203, "alt", newJString(alt))
  add(query_589203, "oauth_token", newJString(oauthToken))
  add(query_589203, "callback", newJString(callback))
  add(query_589203, "access_token", newJString(accessToken))
  add(query_589203, "uploadType", newJString(uploadType))
  add(query_589203, "key", newJString(key))
  add(query_589203, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589204 = body
  add(query_589203, "prettyPrint", newJBool(prettyPrint))
  result = call_589201.call(path_589202, query_589203, nil, nil, body_589204)

var runNamespacesConfigurationsReplaceConfiguration* = Call_RunNamespacesConfigurationsReplaceConfiguration_589184(
    name: "runNamespacesConfigurationsReplaceConfiguration",
    meth: HttpMethod.HttpPut, host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsReplaceConfiguration_589185,
    base: "/", url: url_RunNamespacesConfigurationsReplaceConfiguration_589186,
    schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsGet_589165 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesConfigurationsGet_589167(protocol: Scheme; host: string;
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

proc validate_RunNamespacesConfigurationsGet_589166(path: JsonNode;
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
  var valid_589168 = path.getOrDefault("name")
  valid_589168 = validateParameter(valid_589168, JString, required = true,
                                 default = nil)
  if valid_589168 != nil:
    section.add "name", valid_589168
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
  var valid_589169 = query.getOrDefault("upload_protocol")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "upload_protocol", valid_589169
  var valid_589170 = query.getOrDefault("fields")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "fields", valid_589170
  var valid_589171 = query.getOrDefault("quotaUser")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "quotaUser", valid_589171
  var valid_589172 = query.getOrDefault("alt")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = newJString("json"))
  if valid_589172 != nil:
    section.add "alt", valid_589172
  var valid_589173 = query.getOrDefault("oauth_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "oauth_token", valid_589173
  var valid_589174 = query.getOrDefault("callback")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "callback", valid_589174
  var valid_589175 = query.getOrDefault("access_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "access_token", valid_589175
  var valid_589176 = query.getOrDefault("uploadType")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "uploadType", valid_589176
  var valid_589177 = query.getOrDefault("key")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "key", valid_589177
  var valid_589178 = query.getOrDefault("$.xgafv")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = newJString("1"))
  if valid_589178 != nil:
    section.add "$.xgafv", valid_589178
  var valid_589179 = query.getOrDefault("prettyPrint")
  valid_589179 = validateParameter(valid_589179, JBool, required = false,
                                 default = newJBool(true))
  if valid_589179 != nil:
    section.add "prettyPrint", valid_589179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589180: Call_RunNamespacesConfigurationsGet_589165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about a configuration.
  ## 
  let valid = call_589180.validator(path, query, header, formData, body)
  let scheme = call_589180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589180.url(scheme.get, call_589180.host, call_589180.base,
                         call_589180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589180, url, valid)

proc call*(call_589181: Call_RunNamespacesConfigurationsGet_589165; name: string;
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
  var path_589182 = newJObject()
  var query_589183 = newJObject()
  add(query_589183, "upload_protocol", newJString(uploadProtocol))
  add(query_589183, "fields", newJString(fields))
  add(query_589183, "quotaUser", newJString(quotaUser))
  add(path_589182, "name", newJString(name))
  add(query_589183, "alt", newJString(alt))
  add(query_589183, "oauth_token", newJString(oauthToken))
  add(query_589183, "callback", newJString(callback))
  add(query_589183, "access_token", newJString(accessToken))
  add(query_589183, "uploadType", newJString(uploadType))
  add(query_589183, "key", newJString(key))
  add(query_589183, "$.xgafv", newJString(Xgafv))
  add(query_589183, "prettyPrint", newJBool(prettyPrint))
  result = call_589181.call(path_589182, query_589183, nil, nil, nil)

var runNamespacesConfigurationsGet* = Call_RunNamespacesConfigurationsGet_589165(
    name: "runNamespacesConfigurationsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsGet_589166, base: "/",
    url: url_RunNamespacesConfigurationsGet_589167, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsDelete_589205 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesConfigurationsDelete_589207(protocol: Scheme; host: string;
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

proc validate_RunNamespacesConfigurationsDelete_589206(path: JsonNode;
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
  var valid_589208 = path.getOrDefault("name")
  valid_589208 = validateParameter(valid_589208, JString, required = true,
                                 default = nil)
  if valid_589208 != nil:
    section.add "name", valid_589208
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
  var valid_589209 = query.getOrDefault("upload_protocol")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "upload_protocol", valid_589209
  var valid_589210 = query.getOrDefault("fields")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "fields", valid_589210
  var valid_589211 = query.getOrDefault("quotaUser")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "quotaUser", valid_589211
  var valid_589212 = query.getOrDefault("alt")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("json"))
  if valid_589212 != nil:
    section.add "alt", valid_589212
  var valid_589213 = query.getOrDefault("oauth_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "oauth_token", valid_589213
  var valid_589214 = query.getOrDefault("callback")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "callback", valid_589214
  var valid_589215 = query.getOrDefault("access_token")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "access_token", valid_589215
  var valid_589216 = query.getOrDefault("uploadType")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "uploadType", valid_589216
  var valid_589217 = query.getOrDefault("kind")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "kind", valid_589217
  var valid_589218 = query.getOrDefault("key")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "key", valid_589218
  var valid_589219 = query.getOrDefault("$.xgafv")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = newJString("1"))
  if valid_589219 != nil:
    section.add "$.xgafv", valid_589219
  var valid_589220 = query.getOrDefault("prettyPrint")
  valid_589220 = validateParameter(valid_589220, JBool, required = false,
                                 default = newJBool(true))
  if valid_589220 != nil:
    section.add "prettyPrint", valid_589220
  var valid_589221 = query.getOrDefault("propagationPolicy")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "propagationPolicy", valid_589221
  var valid_589222 = query.getOrDefault("apiVersion")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "apiVersion", valid_589222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589223: Call_RunNamespacesConfigurationsDelete_589205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## delete a configuration.
  ## This will cause the configuration to delete all child revisions. Prior to
  ## calling this, any route referencing the configuration (or revision
  ## from the configuration) must be deleted.
  ## 
  let valid = call_589223.validator(path, query, header, formData, body)
  let scheme = call_589223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589223.url(scheme.get, call_589223.host, call_589223.base,
                         call_589223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589223, url, valid)

proc call*(call_589224: Call_RunNamespacesConfigurationsDelete_589205;
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
  var path_589225 = newJObject()
  var query_589226 = newJObject()
  add(query_589226, "upload_protocol", newJString(uploadProtocol))
  add(query_589226, "fields", newJString(fields))
  add(query_589226, "quotaUser", newJString(quotaUser))
  add(path_589225, "name", newJString(name))
  add(query_589226, "alt", newJString(alt))
  add(query_589226, "oauth_token", newJString(oauthToken))
  add(query_589226, "callback", newJString(callback))
  add(query_589226, "access_token", newJString(accessToken))
  add(query_589226, "uploadType", newJString(uploadType))
  add(query_589226, "kind", newJString(kind))
  add(query_589226, "key", newJString(key))
  add(query_589226, "$.xgafv", newJString(Xgafv))
  add(query_589226, "prettyPrint", newJBool(prettyPrint))
  add(query_589226, "propagationPolicy", newJString(propagationPolicy))
  add(query_589226, "apiVersion", newJString(apiVersion))
  result = call_589224.call(path_589225, query_589226, nil, nil, nil)

var runNamespacesConfigurationsDelete* = Call_RunNamespacesConfigurationsDelete_589205(
    name: "runNamespacesConfigurationsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/apis/serving.knative.dev/v1/{name}",
    validator: validate_RunNamespacesConfigurationsDelete_589206, base: "/",
    url: url_RunNamespacesConfigurationsDelete_589207, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsCreate_589253 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesConfigurationsCreate_589255(protocol: Scheme; host: string;
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

proc validate_RunNamespacesConfigurationsCreate_589254(path: JsonNode;
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
  var valid_589256 = path.getOrDefault("parent")
  valid_589256 = validateParameter(valid_589256, JString, required = true,
                                 default = nil)
  if valid_589256 != nil:
    section.add "parent", valid_589256
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
  var valid_589257 = query.getOrDefault("upload_protocol")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "upload_protocol", valid_589257
  var valid_589258 = query.getOrDefault("fields")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "fields", valid_589258
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
  var valid_589267 = query.getOrDefault("prettyPrint")
  valid_589267 = validateParameter(valid_589267, JBool, required = false,
                                 default = newJBool(true))
  if valid_589267 != nil:
    section.add "prettyPrint", valid_589267
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

proc call*(call_589269: Call_RunNamespacesConfigurationsCreate_589253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_589269.validator(path, query, header, formData, body)
  let scheme = call_589269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589269.url(scheme.get, call_589269.host, call_589269.base,
                         call_589269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589269, url, valid)

proc call*(call_589270: Call_RunNamespacesConfigurationsCreate_589253;
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
  var path_589271 = newJObject()
  var query_589272 = newJObject()
  var body_589273 = newJObject()
  add(query_589272, "upload_protocol", newJString(uploadProtocol))
  add(query_589272, "fields", newJString(fields))
  add(query_589272, "quotaUser", newJString(quotaUser))
  add(query_589272, "alt", newJString(alt))
  add(query_589272, "oauth_token", newJString(oauthToken))
  add(query_589272, "callback", newJString(callback))
  add(query_589272, "access_token", newJString(accessToken))
  add(query_589272, "uploadType", newJString(uploadType))
  add(path_589271, "parent", newJString(parent))
  add(query_589272, "key", newJString(key))
  add(query_589272, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589273 = body
  add(query_589272, "prettyPrint", newJBool(prettyPrint))
  result = call_589270.call(path_589271, query_589272, nil, nil, body_589273)

var runNamespacesConfigurationsCreate* = Call_RunNamespacesConfigurationsCreate_589253(
    name: "runNamespacesConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsCreate_589254, base: "/",
    url: url_RunNamespacesConfigurationsCreate_589255, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_589227 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesConfigurationsList_589229(protocol: Scheme; host: string;
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

proc validate_RunNamespacesConfigurationsList_589228(path: JsonNode;
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
  var valid_589230 = path.getOrDefault("parent")
  valid_589230 = validateParameter(valid_589230, JString, required = true,
                                 default = nil)
  if valid_589230 != nil:
    section.add "parent", valid_589230
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
  var valid_589231 = query.getOrDefault("upload_protocol")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "upload_protocol", valid_589231
  var valid_589232 = query.getOrDefault("fields")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "fields", valid_589232
  var valid_589233 = query.getOrDefault("quotaUser")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "quotaUser", valid_589233
  var valid_589234 = query.getOrDefault("includeUninitialized")
  valid_589234 = validateParameter(valid_589234, JBool, required = false, default = nil)
  if valid_589234 != nil:
    section.add "includeUninitialized", valid_589234
  var valid_589235 = query.getOrDefault("alt")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("json"))
  if valid_589235 != nil:
    section.add "alt", valid_589235
  var valid_589236 = query.getOrDefault("continue")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "continue", valid_589236
  var valid_589237 = query.getOrDefault("oauth_token")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "oauth_token", valid_589237
  var valid_589238 = query.getOrDefault("callback")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "callback", valid_589238
  var valid_589239 = query.getOrDefault("access_token")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "access_token", valid_589239
  var valid_589240 = query.getOrDefault("uploadType")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "uploadType", valid_589240
  var valid_589241 = query.getOrDefault("resourceVersion")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "resourceVersion", valid_589241
  var valid_589242 = query.getOrDefault("watch")
  valid_589242 = validateParameter(valid_589242, JBool, required = false, default = nil)
  if valid_589242 != nil:
    section.add "watch", valid_589242
  var valid_589243 = query.getOrDefault("key")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "key", valid_589243
  var valid_589244 = query.getOrDefault("$.xgafv")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("1"))
  if valid_589244 != nil:
    section.add "$.xgafv", valid_589244
  var valid_589245 = query.getOrDefault("labelSelector")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "labelSelector", valid_589245
  var valid_589246 = query.getOrDefault("prettyPrint")
  valid_589246 = validateParameter(valid_589246, JBool, required = false,
                                 default = newJBool(true))
  if valid_589246 != nil:
    section.add "prettyPrint", valid_589246
  var valid_589247 = query.getOrDefault("fieldSelector")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "fieldSelector", valid_589247
  var valid_589248 = query.getOrDefault("limit")
  valid_589248 = validateParameter(valid_589248, JInt, required = false, default = nil)
  if valid_589248 != nil:
    section.add "limit", valid_589248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589249: Call_RunNamespacesConfigurationsList_589227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_589249.validator(path, query, header, formData, body)
  let scheme = call_589249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589249.url(scheme.get, call_589249.host, call_589249.base,
                         call_589249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589249, url, valid)

proc call*(call_589250: Call_RunNamespacesConfigurationsList_589227;
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
  var path_589251 = newJObject()
  var query_589252 = newJObject()
  add(query_589252, "upload_protocol", newJString(uploadProtocol))
  add(query_589252, "fields", newJString(fields))
  add(query_589252, "quotaUser", newJString(quotaUser))
  add(query_589252, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589252, "alt", newJString(alt))
  add(query_589252, "continue", newJString(`continue`))
  add(query_589252, "oauth_token", newJString(oauthToken))
  add(query_589252, "callback", newJString(callback))
  add(query_589252, "access_token", newJString(accessToken))
  add(query_589252, "uploadType", newJString(uploadType))
  add(path_589251, "parent", newJString(parent))
  add(query_589252, "resourceVersion", newJString(resourceVersion))
  add(query_589252, "watch", newJBool(watch))
  add(query_589252, "key", newJString(key))
  add(query_589252, "$.xgafv", newJString(Xgafv))
  add(query_589252, "labelSelector", newJString(labelSelector))
  add(query_589252, "prettyPrint", newJBool(prettyPrint))
  add(query_589252, "fieldSelector", newJString(fieldSelector))
  add(query_589252, "limit", newJInt(limit))
  result = call_589250.call(path_589251, query_589252, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_589227(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_589228, base: "/",
    url: url_RunNamespacesConfigurationsList_589229, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_589274 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesRevisionsList_589276(protocol: Scheme; host: string;
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

proc validate_RunNamespacesRevisionsList_589275(path: JsonNode; query: JsonNode;
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
  var valid_589281 = query.getOrDefault("includeUninitialized")
  valid_589281 = validateParameter(valid_589281, JBool, required = false, default = nil)
  if valid_589281 != nil:
    section.add "includeUninitialized", valid_589281
  var valid_589282 = query.getOrDefault("alt")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = newJString("json"))
  if valid_589282 != nil:
    section.add "alt", valid_589282
  var valid_589283 = query.getOrDefault("continue")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "continue", valid_589283
  var valid_589284 = query.getOrDefault("oauth_token")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "oauth_token", valid_589284
  var valid_589285 = query.getOrDefault("callback")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "callback", valid_589285
  var valid_589286 = query.getOrDefault("access_token")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "access_token", valid_589286
  var valid_589287 = query.getOrDefault("uploadType")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "uploadType", valid_589287
  var valid_589288 = query.getOrDefault("resourceVersion")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "resourceVersion", valid_589288
  var valid_589289 = query.getOrDefault("watch")
  valid_589289 = validateParameter(valid_589289, JBool, required = false, default = nil)
  if valid_589289 != nil:
    section.add "watch", valid_589289
  var valid_589290 = query.getOrDefault("key")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "key", valid_589290
  var valid_589291 = query.getOrDefault("$.xgafv")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = newJString("1"))
  if valid_589291 != nil:
    section.add "$.xgafv", valid_589291
  var valid_589292 = query.getOrDefault("labelSelector")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "labelSelector", valid_589292
  var valid_589293 = query.getOrDefault("prettyPrint")
  valid_589293 = validateParameter(valid_589293, JBool, required = false,
                                 default = newJBool(true))
  if valid_589293 != nil:
    section.add "prettyPrint", valid_589293
  var valid_589294 = query.getOrDefault("fieldSelector")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "fieldSelector", valid_589294
  var valid_589295 = query.getOrDefault("limit")
  valid_589295 = validateParameter(valid_589295, JInt, required = false, default = nil)
  if valid_589295 != nil:
    section.add "limit", valid_589295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589296: Call_RunNamespacesRevisionsList_589274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_589296.validator(path, query, header, formData, body)
  let scheme = call_589296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589296.url(scheme.get, call_589296.host, call_589296.base,
                         call_589296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589296, url, valid)

proc call*(call_589297: Call_RunNamespacesRevisionsList_589274; parent: string;
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
  var path_589298 = newJObject()
  var query_589299 = newJObject()
  add(query_589299, "upload_protocol", newJString(uploadProtocol))
  add(query_589299, "fields", newJString(fields))
  add(query_589299, "quotaUser", newJString(quotaUser))
  add(query_589299, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589299, "alt", newJString(alt))
  add(query_589299, "continue", newJString(`continue`))
  add(query_589299, "oauth_token", newJString(oauthToken))
  add(query_589299, "callback", newJString(callback))
  add(query_589299, "access_token", newJString(accessToken))
  add(query_589299, "uploadType", newJString(uploadType))
  add(path_589298, "parent", newJString(parent))
  add(query_589299, "resourceVersion", newJString(resourceVersion))
  add(query_589299, "watch", newJBool(watch))
  add(query_589299, "key", newJString(key))
  add(query_589299, "$.xgafv", newJString(Xgafv))
  add(query_589299, "labelSelector", newJString(labelSelector))
  add(query_589299, "prettyPrint", newJBool(prettyPrint))
  add(query_589299, "fieldSelector", newJString(fieldSelector))
  add(query_589299, "limit", newJInt(limit))
  result = call_589297.call(path_589298, query_589299, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_589274(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_589275, base: "/",
    url: url_RunNamespacesRevisionsList_589276, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesCreate_589326 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesRoutesCreate_589328(protocol: Scheme; host: string;
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

proc validate_RunNamespacesRoutesCreate_589327(path: JsonNode; query: JsonNode;
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
  var valid_589329 = path.getOrDefault("parent")
  valid_589329 = validateParameter(valid_589329, JString, required = true,
                                 default = nil)
  if valid_589329 != nil:
    section.add "parent", valid_589329
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
  var valid_589330 = query.getOrDefault("upload_protocol")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "upload_protocol", valid_589330
  var valid_589331 = query.getOrDefault("fields")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "fields", valid_589331
  var valid_589332 = query.getOrDefault("quotaUser")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "quotaUser", valid_589332
  var valid_589333 = query.getOrDefault("alt")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = newJString("json"))
  if valid_589333 != nil:
    section.add "alt", valid_589333
  var valid_589334 = query.getOrDefault("oauth_token")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "oauth_token", valid_589334
  var valid_589335 = query.getOrDefault("callback")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "callback", valid_589335
  var valid_589336 = query.getOrDefault("access_token")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "access_token", valid_589336
  var valid_589337 = query.getOrDefault("uploadType")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "uploadType", valid_589337
  var valid_589338 = query.getOrDefault("key")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "key", valid_589338
  var valid_589339 = query.getOrDefault("$.xgafv")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = newJString("1"))
  if valid_589339 != nil:
    section.add "$.xgafv", valid_589339
  var valid_589340 = query.getOrDefault("prettyPrint")
  valid_589340 = validateParameter(valid_589340, JBool, required = false,
                                 default = newJBool(true))
  if valid_589340 != nil:
    section.add "prettyPrint", valid_589340
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

proc call*(call_589342: Call_RunNamespacesRoutesCreate_589326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_589342.validator(path, query, header, formData, body)
  let scheme = call_589342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589342.url(scheme.get, call_589342.host, call_589342.base,
                         call_589342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589342, url, valid)

proc call*(call_589343: Call_RunNamespacesRoutesCreate_589326; parent: string;
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
  var path_589344 = newJObject()
  var query_589345 = newJObject()
  var body_589346 = newJObject()
  add(query_589345, "upload_protocol", newJString(uploadProtocol))
  add(query_589345, "fields", newJString(fields))
  add(query_589345, "quotaUser", newJString(quotaUser))
  add(query_589345, "alt", newJString(alt))
  add(query_589345, "oauth_token", newJString(oauthToken))
  add(query_589345, "callback", newJString(callback))
  add(query_589345, "access_token", newJString(accessToken))
  add(query_589345, "uploadType", newJString(uploadType))
  add(path_589344, "parent", newJString(parent))
  add(query_589345, "key", newJString(key))
  add(query_589345, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589346 = body
  add(query_589345, "prettyPrint", newJBool(prettyPrint))
  result = call_589343.call(path_589344, query_589345, nil, nil, body_589346)

var runNamespacesRoutesCreate* = Call_RunNamespacesRoutesCreate_589326(
    name: "runNamespacesRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesCreate_589327, base: "/",
    url: url_RunNamespacesRoutesCreate_589328, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_589300 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesRoutesList_589302(protocol: Scheme; host: string; base: string;
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

proc validate_RunNamespacesRoutesList_589301(path: JsonNode; query: JsonNode;
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
  var valid_589303 = path.getOrDefault("parent")
  valid_589303 = validateParameter(valid_589303, JString, required = true,
                                 default = nil)
  if valid_589303 != nil:
    section.add "parent", valid_589303
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
  var valid_589304 = query.getOrDefault("upload_protocol")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "upload_protocol", valid_589304
  var valid_589305 = query.getOrDefault("fields")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "fields", valid_589305
  var valid_589306 = query.getOrDefault("quotaUser")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "quotaUser", valid_589306
  var valid_589307 = query.getOrDefault("includeUninitialized")
  valid_589307 = validateParameter(valid_589307, JBool, required = false, default = nil)
  if valid_589307 != nil:
    section.add "includeUninitialized", valid_589307
  var valid_589308 = query.getOrDefault("alt")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = newJString("json"))
  if valid_589308 != nil:
    section.add "alt", valid_589308
  var valid_589309 = query.getOrDefault("continue")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "continue", valid_589309
  var valid_589310 = query.getOrDefault("oauth_token")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "oauth_token", valid_589310
  var valid_589311 = query.getOrDefault("callback")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "callback", valid_589311
  var valid_589312 = query.getOrDefault("access_token")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "access_token", valid_589312
  var valid_589313 = query.getOrDefault("uploadType")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "uploadType", valid_589313
  var valid_589314 = query.getOrDefault("resourceVersion")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "resourceVersion", valid_589314
  var valid_589315 = query.getOrDefault("watch")
  valid_589315 = validateParameter(valid_589315, JBool, required = false, default = nil)
  if valid_589315 != nil:
    section.add "watch", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("$.xgafv")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = newJString("1"))
  if valid_589317 != nil:
    section.add "$.xgafv", valid_589317
  var valid_589318 = query.getOrDefault("labelSelector")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "labelSelector", valid_589318
  var valid_589319 = query.getOrDefault("prettyPrint")
  valid_589319 = validateParameter(valid_589319, JBool, required = false,
                                 default = newJBool(true))
  if valid_589319 != nil:
    section.add "prettyPrint", valid_589319
  var valid_589320 = query.getOrDefault("fieldSelector")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "fieldSelector", valid_589320
  var valid_589321 = query.getOrDefault("limit")
  valid_589321 = validateParameter(valid_589321, JInt, required = false, default = nil)
  if valid_589321 != nil:
    section.add "limit", valid_589321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589322: Call_RunNamespacesRoutesList_589300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_RunNamespacesRoutesList_589300; parent: string;
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
  var path_589324 = newJObject()
  var query_589325 = newJObject()
  add(query_589325, "upload_protocol", newJString(uploadProtocol))
  add(query_589325, "fields", newJString(fields))
  add(query_589325, "quotaUser", newJString(quotaUser))
  add(query_589325, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589325, "alt", newJString(alt))
  add(query_589325, "continue", newJString(`continue`))
  add(query_589325, "oauth_token", newJString(oauthToken))
  add(query_589325, "callback", newJString(callback))
  add(query_589325, "access_token", newJString(accessToken))
  add(query_589325, "uploadType", newJString(uploadType))
  add(path_589324, "parent", newJString(parent))
  add(query_589325, "resourceVersion", newJString(resourceVersion))
  add(query_589325, "watch", newJBool(watch))
  add(query_589325, "key", newJString(key))
  add(query_589325, "$.xgafv", newJString(Xgafv))
  add(query_589325, "labelSelector", newJString(labelSelector))
  add(query_589325, "prettyPrint", newJBool(prettyPrint))
  add(query_589325, "fieldSelector", newJString(fieldSelector))
  add(query_589325, "limit", newJInt(limit))
  result = call_589323.call(path_589324, query_589325, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_589300(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_589301, base: "/",
    url: url_RunNamespacesRoutesList_589302, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_589373 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesServicesCreate_589375(protocol: Scheme; host: string;
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

proc validate_RunNamespacesServicesCreate_589374(path: JsonNode; query: JsonNode;
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
  var valid_589376 = path.getOrDefault("parent")
  valid_589376 = validateParameter(valid_589376, JString, required = true,
                                 default = nil)
  if valid_589376 != nil:
    section.add "parent", valid_589376
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
  var valid_589377 = query.getOrDefault("upload_protocol")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "upload_protocol", valid_589377
  var valid_589378 = query.getOrDefault("fields")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "fields", valid_589378
  var valid_589379 = query.getOrDefault("quotaUser")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "quotaUser", valid_589379
  var valid_589380 = query.getOrDefault("alt")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = newJString("json"))
  if valid_589380 != nil:
    section.add "alt", valid_589380
  var valid_589381 = query.getOrDefault("oauth_token")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "oauth_token", valid_589381
  var valid_589382 = query.getOrDefault("callback")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "callback", valid_589382
  var valid_589383 = query.getOrDefault("access_token")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "access_token", valid_589383
  var valid_589384 = query.getOrDefault("uploadType")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "uploadType", valid_589384
  var valid_589385 = query.getOrDefault("key")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "key", valid_589385
  var valid_589386 = query.getOrDefault("$.xgafv")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = newJString("1"))
  if valid_589386 != nil:
    section.add "$.xgafv", valid_589386
  var valid_589387 = query.getOrDefault("prettyPrint")
  valid_589387 = validateParameter(valid_589387, JBool, required = false,
                                 default = newJBool(true))
  if valid_589387 != nil:
    section.add "prettyPrint", valid_589387
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

proc call*(call_589389: Call_RunNamespacesServicesCreate_589373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_589389.validator(path, query, header, formData, body)
  let scheme = call_589389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589389.url(scheme.get, call_589389.host, call_589389.base,
                         call_589389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589389, url, valid)

proc call*(call_589390: Call_RunNamespacesServicesCreate_589373; parent: string;
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
  var path_589391 = newJObject()
  var query_589392 = newJObject()
  var body_589393 = newJObject()
  add(query_589392, "upload_protocol", newJString(uploadProtocol))
  add(query_589392, "fields", newJString(fields))
  add(query_589392, "quotaUser", newJString(quotaUser))
  add(query_589392, "alt", newJString(alt))
  add(query_589392, "oauth_token", newJString(oauthToken))
  add(query_589392, "callback", newJString(callback))
  add(query_589392, "access_token", newJString(accessToken))
  add(query_589392, "uploadType", newJString(uploadType))
  add(path_589391, "parent", newJString(parent))
  add(query_589392, "key", newJString(key))
  add(query_589392, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589393 = body
  add(query_589392, "prettyPrint", newJBool(prettyPrint))
  result = call_589390.call(path_589391, query_589392, nil, nil, body_589393)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_589373(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_589374, base: "/",
    url: url_RunNamespacesServicesCreate_589375, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_589347 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesServicesList_589349(protocol: Scheme; host: string;
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

proc validate_RunNamespacesServicesList_589348(path: JsonNode; query: JsonNode;
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
  var valid_589350 = path.getOrDefault("parent")
  valid_589350 = validateParameter(valid_589350, JString, required = true,
                                 default = nil)
  if valid_589350 != nil:
    section.add "parent", valid_589350
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
  var valid_589351 = query.getOrDefault("upload_protocol")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "upload_protocol", valid_589351
  var valid_589352 = query.getOrDefault("fields")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "fields", valid_589352
  var valid_589353 = query.getOrDefault("quotaUser")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "quotaUser", valid_589353
  var valid_589354 = query.getOrDefault("includeUninitialized")
  valid_589354 = validateParameter(valid_589354, JBool, required = false, default = nil)
  if valid_589354 != nil:
    section.add "includeUninitialized", valid_589354
  var valid_589355 = query.getOrDefault("alt")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = newJString("json"))
  if valid_589355 != nil:
    section.add "alt", valid_589355
  var valid_589356 = query.getOrDefault("continue")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "continue", valid_589356
  var valid_589357 = query.getOrDefault("oauth_token")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "oauth_token", valid_589357
  var valid_589358 = query.getOrDefault("callback")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "callback", valid_589358
  var valid_589359 = query.getOrDefault("access_token")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "access_token", valid_589359
  var valid_589360 = query.getOrDefault("uploadType")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "uploadType", valid_589360
  var valid_589361 = query.getOrDefault("resourceVersion")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "resourceVersion", valid_589361
  var valid_589362 = query.getOrDefault("watch")
  valid_589362 = validateParameter(valid_589362, JBool, required = false, default = nil)
  if valid_589362 != nil:
    section.add "watch", valid_589362
  var valid_589363 = query.getOrDefault("key")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "key", valid_589363
  var valid_589364 = query.getOrDefault("$.xgafv")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = newJString("1"))
  if valid_589364 != nil:
    section.add "$.xgafv", valid_589364
  var valid_589365 = query.getOrDefault("labelSelector")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "labelSelector", valid_589365
  var valid_589366 = query.getOrDefault("prettyPrint")
  valid_589366 = validateParameter(valid_589366, JBool, required = false,
                                 default = newJBool(true))
  if valid_589366 != nil:
    section.add "prettyPrint", valid_589366
  var valid_589367 = query.getOrDefault("fieldSelector")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "fieldSelector", valid_589367
  var valid_589368 = query.getOrDefault("limit")
  valid_589368 = validateParameter(valid_589368, JInt, required = false, default = nil)
  if valid_589368 != nil:
    section.add "limit", valid_589368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589369: Call_RunNamespacesServicesList_589347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_589369.validator(path, query, header, formData, body)
  let scheme = call_589369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589369.url(scheme.get, call_589369.host, call_589369.base,
                         call_589369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589369, url, valid)

proc call*(call_589370: Call_RunNamespacesServicesList_589347; parent: string;
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
  var path_589371 = newJObject()
  var query_589372 = newJObject()
  add(query_589372, "upload_protocol", newJString(uploadProtocol))
  add(query_589372, "fields", newJString(fields))
  add(query_589372, "quotaUser", newJString(quotaUser))
  add(query_589372, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589372, "alt", newJString(alt))
  add(query_589372, "continue", newJString(`continue`))
  add(query_589372, "oauth_token", newJString(oauthToken))
  add(query_589372, "callback", newJString(callback))
  add(query_589372, "access_token", newJString(accessToken))
  add(query_589372, "uploadType", newJString(uploadType))
  add(path_589371, "parent", newJString(parent))
  add(query_589372, "resourceVersion", newJString(resourceVersion))
  add(query_589372, "watch", newJBool(watch))
  add(query_589372, "key", newJString(key))
  add(query_589372, "$.xgafv", newJString(Xgafv))
  add(query_589372, "labelSelector", newJString(labelSelector))
  add(query_589372, "prettyPrint", newJBool(prettyPrint))
  add(query_589372, "fieldSelector", newJString(fieldSelector))
  add(query_589372, "limit", newJInt(limit))
  result = call_589370.call(path_589371, query_589372, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_589347(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1/{parent}/services",
    validator: validate_RunNamespacesServicesList_589348, base: "/",
    url: url_RunNamespacesServicesList_589349, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesReplaceService_589413 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesReplaceService_589415(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesReplaceService_589414(path: JsonNode;
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
  var valid_589416 = path.getOrDefault("name")
  valid_589416 = validateParameter(valid_589416, JString, required = true,
                                 default = nil)
  if valid_589416 != nil:
    section.add "name", valid_589416
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
  var valid_589417 = query.getOrDefault("upload_protocol")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "upload_protocol", valid_589417
  var valid_589418 = query.getOrDefault("fields")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "fields", valid_589418
  var valid_589419 = query.getOrDefault("quotaUser")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "quotaUser", valid_589419
  var valid_589420 = query.getOrDefault("alt")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = newJString("json"))
  if valid_589420 != nil:
    section.add "alt", valid_589420
  var valid_589421 = query.getOrDefault("oauth_token")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "oauth_token", valid_589421
  var valid_589422 = query.getOrDefault("callback")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "callback", valid_589422
  var valid_589423 = query.getOrDefault("access_token")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "access_token", valid_589423
  var valid_589424 = query.getOrDefault("uploadType")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "uploadType", valid_589424
  var valid_589425 = query.getOrDefault("key")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "key", valid_589425
  var valid_589426 = query.getOrDefault("$.xgafv")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = newJString("1"))
  if valid_589426 != nil:
    section.add "$.xgafv", valid_589426
  var valid_589427 = query.getOrDefault("prettyPrint")
  valid_589427 = validateParameter(valid_589427, JBool, required = false,
                                 default = newJBool(true))
  if valid_589427 != nil:
    section.add "prettyPrint", valid_589427
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

proc call*(call_589429: Call_RunProjectsLocationsServicesReplaceService_589413;
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
  let valid = call_589429.validator(path, query, header, formData, body)
  let scheme = call_589429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589429.url(scheme.get, call_589429.host, call_589429.base,
                         call_589429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589429, url, valid)

proc call*(call_589430: Call_RunProjectsLocationsServicesReplaceService_589413;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesReplaceService
  ## Replace a service.
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
  ##       : The name of the service being replaced. If needed, replace
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
  var path_589431 = newJObject()
  var query_589432 = newJObject()
  var body_589433 = newJObject()
  add(query_589432, "upload_protocol", newJString(uploadProtocol))
  add(query_589432, "fields", newJString(fields))
  add(query_589432, "quotaUser", newJString(quotaUser))
  add(path_589431, "name", newJString(name))
  add(query_589432, "alt", newJString(alt))
  add(query_589432, "oauth_token", newJString(oauthToken))
  add(query_589432, "callback", newJString(callback))
  add(query_589432, "access_token", newJString(accessToken))
  add(query_589432, "uploadType", newJString(uploadType))
  add(query_589432, "key", newJString(key))
  add(query_589432, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589433 = body
  add(query_589432, "prettyPrint", newJBool(prettyPrint))
  result = call_589430.call(path_589431, query_589432, nil, nil, body_589433)

var runProjectsLocationsServicesReplaceService* = Call_RunProjectsLocationsServicesReplaceService_589413(
    name: "runProjectsLocationsServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsServicesReplaceService_589414,
    base: "/", url: url_RunProjectsLocationsServicesReplaceService_589415,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGet_589394 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesGet_589396(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesGet_589395(path: JsonNode;
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
  var valid_589397 = path.getOrDefault("name")
  valid_589397 = validateParameter(valid_589397, JString, required = true,
                                 default = nil)
  if valid_589397 != nil:
    section.add "name", valid_589397
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
  var valid_589398 = query.getOrDefault("upload_protocol")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "upload_protocol", valid_589398
  var valid_589399 = query.getOrDefault("fields")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "fields", valid_589399
  var valid_589400 = query.getOrDefault("quotaUser")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "quotaUser", valid_589400
  var valid_589401 = query.getOrDefault("alt")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = newJString("json"))
  if valid_589401 != nil:
    section.add "alt", valid_589401
  var valid_589402 = query.getOrDefault("oauth_token")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "oauth_token", valid_589402
  var valid_589403 = query.getOrDefault("callback")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "callback", valid_589403
  var valid_589404 = query.getOrDefault("access_token")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "access_token", valid_589404
  var valid_589405 = query.getOrDefault("uploadType")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "uploadType", valid_589405
  var valid_589406 = query.getOrDefault("key")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "key", valid_589406
  var valid_589407 = query.getOrDefault("$.xgafv")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = newJString("1"))
  if valid_589407 != nil:
    section.add "$.xgafv", valid_589407
  var valid_589408 = query.getOrDefault("prettyPrint")
  valid_589408 = validateParameter(valid_589408, JBool, required = false,
                                 default = newJBool(true))
  if valid_589408 != nil:
    section.add "prettyPrint", valid_589408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589409: Call_RunProjectsLocationsServicesGet_589394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get information about a service.
  ## 
  let valid = call_589409.validator(path, query, header, formData, body)
  let scheme = call_589409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589409.url(scheme.get, call_589409.host, call_589409.base,
                         call_589409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589409, url, valid)

proc call*(call_589410: Call_RunProjectsLocationsServicesGet_589394; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesGet
  ## Get information about a service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the service being retrieved. If needed, replace
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
  var path_589411 = newJObject()
  var query_589412 = newJObject()
  add(query_589412, "upload_protocol", newJString(uploadProtocol))
  add(query_589412, "fields", newJString(fields))
  add(query_589412, "quotaUser", newJString(quotaUser))
  add(path_589411, "name", newJString(name))
  add(query_589412, "alt", newJString(alt))
  add(query_589412, "oauth_token", newJString(oauthToken))
  add(query_589412, "callback", newJString(callback))
  add(query_589412, "access_token", newJString(accessToken))
  add(query_589412, "uploadType", newJString(uploadType))
  add(query_589412, "key", newJString(key))
  add(query_589412, "$.xgafv", newJString(Xgafv))
  add(query_589412, "prettyPrint", newJBool(prettyPrint))
  result = call_589410.call(path_589411, query_589412, nil, nil, nil)

var runProjectsLocationsServicesGet* = Call_RunProjectsLocationsServicesGet_589394(
    name: "runProjectsLocationsServicesGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsServicesGet_589395, base: "/",
    url: url_RunProjectsLocationsServicesGet_589396, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesDelete_589434 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesDelete_589436(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesDelete_589435(path: JsonNode;
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
  var valid_589437 = path.getOrDefault("name")
  valid_589437 = validateParameter(valid_589437, JString, required = true,
                                 default = nil)
  if valid_589437 != nil:
    section.add "name", valid_589437
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
  var valid_589438 = query.getOrDefault("upload_protocol")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "upload_protocol", valid_589438
  var valid_589439 = query.getOrDefault("fields")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "fields", valid_589439
  var valid_589440 = query.getOrDefault("quotaUser")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "quotaUser", valid_589440
  var valid_589441 = query.getOrDefault("alt")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = newJString("json"))
  if valid_589441 != nil:
    section.add "alt", valid_589441
  var valid_589442 = query.getOrDefault("oauth_token")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "oauth_token", valid_589442
  var valid_589443 = query.getOrDefault("callback")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "callback", valid_589443
  var valid_589444 = query.getOrDefault("access_token")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "access_token", valid_589444
  var valid_589445 = query.getOrDefault("uploadType")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "uploadType", valid_589445
  var valid_589446 = query.getOrDefault("kind")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "kind", valid_589446
  var valid_589447 = query.getOrDefault("key")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "key", valid_589447
  var valid_589448 = query.getOrDefault("$.xgafv")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = newJString("1"))
  if valid_589448 != nil:
    section.add "$.xgafv", valid_589448
  var valid_589449 = query.getOrDefault("prettyPrint")
  valid_589449 = validateParameter(valid_589449, JBool, required = false,
                                 default = newJBool(true))
  if valid_589449 != nil:
    section.add "prettyPrint", valid_589449
  var valid_589450 = query.getOrDefault("propagationPolicy")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "propagationPolicy", valid_589450
  var valid_589451 = query.getOrDefault("apiVersion")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "apiVersion", valid_589451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589452: Call_RunProjectsLocationsServicesDelete_589434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
  ## 
  let valid = call_589452.validator(path, query, header, formData, body)
  let scheme = call_589452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589452.url(scheme.get, call_589452.host, call_589452.base,
                         call_589452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589452, url, valid)

proc call*(call_589453: Call_RunProjectsLocationsServicesDelete_589434;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runProjectsLocationsServicesDelete
  ## Delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the service being deleted. If needed, replace
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
  var path_589454 = newJObject()
  var query_589455 = newJObject()
  add(query_589455, "upload_protocol", newJString(uploadProtocol))
  add(query_589455, "fields", newJString(fields))
  add(query_589455, "quotaUser", newJString(quotaUser))
  add(path_589454, "name", newJString(name))
  add(query_589455, "alt", newJString(alt))
  add(query_589455, "oauth_token", newJString(oauthToken))
  add(query_589455, "callback", newJString(callback))
  add(query_589455, "access_token", newJString(accessToken))
  add(query_589455, "uploadType", newJString(uploadType))
  add(query_589455, "kind", newJString(kind))
  add(query_589455, "key", newJString(key))
  add(query_589455, "$.xgafv", newJString(Xgafv))
  add(query_589455, "prettyPrint", newJBool(prettyPrint))
  add(query_589455, "propagationPolicy", newJString(propagationPolicy))
  add(query_589455, "apiVersion", newJString(apiVersion))
  result = call_589453.call(path_589454, query_589455, nil, nil, nil)

var runProjectsLocationsServicesDelete* = Call_RunProjectsLocationsServicesDelete_589434(
    name: "runProjectsLocationsServicesDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1/{name}",
    validator: validate_RunProjectsLocationsServicesDelete_589435, base: "/",
    url: url_RunProjectsLocationsServicesDelete_589436, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_589456 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsList_589458(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsList_589457(path: JsonNode; query: JsonNode;
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
  var valid_589459 = path.getOrDefault("name")
  valid_589459 = validateParameter(valid_589459, JString, required = true,
                                 default = nil)
  if valid_589459 != nil:
    section.add "name", valid_589459
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
  var valid_589460 = query.getOrDefault("upload_protocol")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "upload_protocol", valid_589460
  var valid_589461 = query.getOrDefault("fields")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "fields", valid_589461
  var valid_589462 = query.getOrDefault("pageToken")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "pageToken", valid_589462
  var valid_589463 = query.getOrDefault("quotaUser")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "quotaUser", valid_589463
  var valid_589464 = query.getOrDefault("alt")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = newJString("json"))
  if valid_589464 != nil:
    section.add "alt", valid_589464
  var valid_589465 = query.getOrDefault("oauth_token")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "oauth_token", valid_589465
  var valid_589466 = query.getOrDefault("callback")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "callback", valid_589466
  var valid_589467 = query.getOrDefault("access_token")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "access_token", valid_589467
  var valid_589468 = query.getOrDefault("uploadType")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "uploadType", valid_589468
  var valid_589469 = query.getOrDefault("key")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "key", valid_589469
  var valid_589470 = query.getOrDefault("$.xgafv")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = newJString("1"))
  if valid_589470 != nil:
    section.add "$.xgafv", valid_589470
  var valid_589471 = query.getOrDefault("pageSize")
  valid_589471 = validateParameter(valid_589471, JInt, required = false, default = nil)
  if valid_589471 != nil:
    section.add "pageSize", valid_589471
  var valid_589472 = query.getOrDefault("prettyPrint")
  valid_589472 = validateParameter(valid_589472, JBool, required = false,
                                 default = newJBool(true))
  if valid_589472 != nil:
    section.add "prettyPrint", valid_589472
  var valid_589473 = query.getOrDefault("filter")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "filter", valid_589473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589474: Call_RunProjectsLocationsList_589456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589474.validator(path, query, header, formData, body)
  let scheme = call_589474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589474.url(scheme.get, call_589474.host, call_589474.base,
                         call_589474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589474, url, valid)

proc call*(call_589475: Call_RunProjectsLocationsList_589456; name: string;
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
  var path_589476 = newJObject()
  var query_589477 = newJObject()
  add(query_589477, "upload_protocol", newJString(uploadProtocol))
  add(query_589477, "fields", newJString(fields))
  add(query_589477, "pageToken", newJString(pageToken))
  add(query_589477, "quotaUser", newJString(quotaUser))
  add(path_589476, "name", newJString(name))
  add(query_589477, "alt", newJString(alt))
  add(query_589477, "oauth_token", newJString(oauthToken))
  add(query_589477, "callback", newJString(callback))
  add(query_589477, "access_token", newJString(accessToken))
  add(query_589477, "uploadType", newJString(uploadType))
  add(query_589477, "key", newJString(key))
  add(query_589477, "$.xgafv", newJString(Xgafv))
  add(query_589477, "pageSize", newJInt(pageSize))
  add(query_589477, "prettyPrint", newJBool(prettyPrint))
  add(query_589477, "filter", newJString(filter))
  result = call_589475.call(path_589476, query_589477, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_589456(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_RunProjectsLocationsList_589457, base: "/",
    url: url_RunProjectsLocationsList_589458, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_589478 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsAuthorizeddomainsList_589480(protocol: Scheme;
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

proc validate_RunProjectsLocationsAuthorizeddomainsList_589479(path: JsonNode;
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
  var valid_589481 = path.getOrDefault("parent")
  valid_589481 = validateParameter(valid_589481, JString, required = true,
                                 default = nil)
  if valid_589481 != nil:
    section.add "parent", valid_589481
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
  var valid_589482 = query.getOrDefault("upload_protocol")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "upload_protocol", valid_589482
  var valid_589483 = query.getOrDefault("fields")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "fields", valid_589483
  var valid_589484 = query.getOrDefault("pageToken")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "pageToken", valid_589484
  var valid_589485 = query.getOrDefault("quotaUser")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "quotaUser", valid_589485
  var valid_589486 = query.getOrDefault("alt")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = newJString("json"))
  if valid_589486 != nil:
    section.add "alt", valid_589486
  var valid_589487 = query.getOrDefault("oauth_token")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "oauth_token", valid_589487
  var valid_589488 = query.getOrDefault("callback")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = nil)
  if valid_589488 != nil:
    section.add "callback", valid_589488
  var valid_589489 = query.getOrDefault("access_token")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "access_token", valid_589489
  var valid_589490 = query.getOrDefault("uploadType")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "uploadType", valid_589490
  var valid_589491 = query.getOrDefault("key")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "key", valid_589491
  var valid_589492 = query.getOrDefault("$.xgafv")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = newJString("1"))
  if valid_589492 != nil:
    section.add "$.xgafv", valid_589492
  var valid_589493 = query.getOrDefault("pageSize")
  valid_589493 = validateParameter(valid_589493, JInt, required = false, default = nil)
  if valid_589493 != nil:
    section.add "pageSize", valid_589493
  var valid_589494 = query.getOrDefault("prettyPrint")
  valid_589494 = validateParameter(valid_589494, JBool, required = false,
                                 default = newJBool(true))
  if valid_589494 != nil:
    section.add "prettyPrint", valid_589494
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589495: Call_RunProjectsLocationsAuthorizeddomainsList_589478;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List authorized domains.
  ## 
  let valid = call_589495.validator(path, query, header, formData, body)
  let scheme = call_589495.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589495.url(scheme.get, call_589495.host, call_589495.base,
                         call_589495.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589495, url, valid)

proc call*(call_589496: Call_RunProjectsLocationsAuthorizeddomainsList_589478;
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
  var path_589497 = newJObject()
  var query_589498 = newJObject()
  add(query_589498, "upload_protocol", newJString(uploadProtocol))
  add(query_589498, "fields", newJString(fields))
  add(query_589498, "pageToken", newJString(pageToken))
  add(query_589498, "quotaUser", newJString(quotaUser))
  add(query_589498, "alt", newJString(alt))
  add(query_589498, "oauth_token", newJString(oauthToken))
  add(query_589498, "callback", newJString(callback))
  add(query_589498, "access_token", newJString(accessToken))
  add(query_589498, "uploadType", newJString(uploadType))
  add(path_589497, "parent", newJString(parent))
  add(query_589498, "key", newJString(key))
  add(query_589498, "$.xgafv", newJString(Xgafv))
  add(query_589498, "pageSize", newJInt(pageSize))
  add(query_589498, "prettyPrint", newJBool(prettyPrint))
  result = call_589496.call(path_589497, query_589498, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_589478(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_589479,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_589480,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsCreate_589525 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsAutodomainmappingsCreate_589527(protocol: Scheme;
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

proc validate_RunProjectsLocationsAutodomainmappingsCreate_589526(path: JsonNode;
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
  var valid_589528 = path.getOrDefault("parent")
  valid_589528 = validateParameter(valid_589528, JString, required = true,
                                 default = nil)
  if valid_589528 != nil:
    section.add "parent", valid_589528
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
  var valid_589529 = query.getOrDefault("upload_protocol")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "upload_protocol", valid_589529
  var valid_589530 = query.getOrDefault("fields")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = nil)
  if valid_589530 != nil:
    section.add "fields", valid_589530
  var valid_589531 = query.getOrDefault("quotaUser")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "quotaUser", valid_589531
  var valid_589532 = query.getOrDefault("alt")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = newJString("json"))
  if valid_589532 != nil:
    section.add "alt", valid_589532
  var valid_589533 = query.getOrDefault("oauth_token")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "oauth_token", valid_589533
  var valid_589534 = query.getOrDefault("callback")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "callback", valid_589534
  var valid_589535 = query.getOrDefault("access_token")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = nil)
  if valid_589535 != nil:
    section.add "access_token", valid_589535
  var valid_589536 = query.getOrDefault("uploadType")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "uploadType", valid_589536
  var valid_589537 = query.getOrDefault("key")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "key", valid_589537
  var valid_589538 = query.getOrDefault("$.xgafv")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = newJString("1"))
  if valid_589538 != nil:
    section.add "$.xgafv", valid_589538
  var valid_589539 = query.getOrDefault("prettyPrint")
  valid_589539 = validateParameter(valid_589539, JBool, required = false,
                                 default = newJBool(true))
  if valid_589539 != nil:
    section.add "prettyPrint", valid_589539
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

proc call*(call_589541: Call_RunProjectsLocationsAutodomainmappingsCreate_589525;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new auto domain mapping.
  ## 
  let valid = call_589541.validator(path, query, header, formData, body)
  let scheme = call_589541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589541.url(scheme.get, call_589541.host, call_589541.base,
                         call_589541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589541, url, valid)

proc call*(call_589542: Call_RunProjectsLocationsAutodomainmappingsCreate_589525;
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
  var path_589543 = newJObject()
  var query_589544 = newJObject()
  var body_589545 = newJObject()
  add(query_589544, "upload_protocol", newJString(uploadProtocol))
  add(query_589544, "fields", newJString(fields))
  add(query_589544, "quotaUser", newJString(quotaUser))
  add(query_589544, "alt", newJString(alt))
  add(query_589544, "oauth_token", newJString(oauthToken))
  add(query_589544, "callback", newJString(callback))
  add(query_589544, "access_token", newJString(accessToken))
  add(query_589544, "uploadType", newJString(uploadType))
  add(path_589543, "parent", newJString(parent))
  add(query_589544, "key", newJString(key))
  add(query_589544, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589545 = body
  add(query_589544, "prettyPrint", newJBool(prettyPrint))
  result = call_589542.call(path_589543, query_589544, nil, nil, body_589545)

var runProjectsLocationsAutodomainmappingsCreate* = Call_RunProjectsLocationsAutodomainmappingsCreate_589525(
    name: "runProjectsLocationsAutodomainmappingsCreate",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsCreate_589526,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsCreate_589527,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAutodomainmappingsList_589499 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsAutodomainmappingsList_589501(protocol: Scheme;
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

proc validate_RunProjectsLocationsAutodomainmappingsList_589500(path: JsonNode;
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
  var valid_589502 = path.getOrDefault("parent")
  valid_589502 = validateParameter(valid_589502, JString, required = true,
                                 default = nil)
  if valid_589502 != nil:
    section.add "parent", valid_589502
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
  var valid_589503 = query.getOrDefault("upload_protocol")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "upload_protocol", valid_589503
  var valid_589504 = query.getOrDefault("fields")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "fields", valid_589504
  var valid_589505 = query.getOrDefault("quotaUser")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "quotaUser", valid_589505
  var valid_589506 = query.getOrDefault("includeUninitialized")
  valid_589506 = validateParameter(valid_589506, JBool, required = false, default = nil)
  if valid_589506 != nil:
    section.add "includeUninitialized", valid_589506
  var valid_589507 = query.getOrDefault("alt")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = newJString("json"))
  if valid_589507 != nil:
    section.add "alt", valid_589507
  var valid_589508 = query.getOrDefault("continue")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "continue", valid_589508
  var valid_589509 = query.getOrDefault("oauth_token")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "oauth_token", valid_589509
  var valid_589510 = query.getOrDefault("callback")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "callback", valid_589510
  var valid_589511 = query.getOrDefault("access_token")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "access_token", valid_589511
  var valid_589512 = query.getOrDefault("uploadType")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "uploadType", valid_589512
  var valid_589513 = query.getOrDefault("resourceVersion")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "resourceVersion", valid_589513
  var valid_589514 = query.getOrDefault("watch")
  valid_589514 = validateParameter(valid_589514, JBool, required = false, default = nil)
  if valid_589514 != nil:
    section.add "watch", valid_589514
  var valid_589515 = query.getOrDefault("key")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "key", valid_589515
  var valid_589516 = query.getOrDefault("$.xgafv")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = newJString("1"))
  if valid_589516 != nil:
    section.add "$.xgafv", valid_589516
  var valid_589517 = query.getOrDefault("labelSelector")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "labelSelector", valid_589517
  var valid_589518 = query.getOrDefault("prettyPrint")
  valid_589518 = validateParameter(valid_589518, JBool, required = false,
                                 default = newJBool(true))
  if valid_589518 != nil:
    section.add "prettyPrint", valid_589518
  var valid_589519 = query.getOrDefault("fieldSelector")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "fieldSelector", valid_589519
  var valid_589520 = query.getOrDefault("limit")
  valid_589520 = validateParameter(valid_589520, JInt, required = false, default = nil)
  if valid_589520 != nil:
    section.add "limit", valid_589520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589521: Call_RunProjectsLocationsAutodomainmappingsList_589499;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List auto domain mappings.
  ## 
  let valid = call_589521.validator(path, query, header, formData, body)
  let scheme = call_589521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589521.url(scheme.get, call_589521.host, call_589521.base,
                         call_589521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589521, url, valid)

proc call*(call_589522: Call_RunProjectsLocationsAutodomainmappingsList_589499;
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
  var path_589523 = newJObject()
  var query_589524 = newJObject()
  add(query_589524, "upload_protocol", newJString(uploadProtocol))
  add(query_589524, "fields", newJString(fields))
  add(query_589524, "quotaUser", newJString(quotaUser))
  add(query_589524, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589524, "alt", newJString(alt))
  add(query_589524, "continue", newJString(`continue`))
  add(query_589524, "oauth_token", newJString(oauthToken))
  add(query_589524, "callback", newJString(callback))
  add(query_589524, "access_token", newJString(accessToken))
  add(query_589524, "uploadType", newJString(uploadType))
  add(path_589523, "parent", newJString(parent))
  add(query_589524, "resourceVersion", newJString(resourceVersion))
  add(query_589524, "watch", newJBool(watch))
  add(query_589524, "key", newJString(key))
  add(query_589524, "$.xgafv", newJString(Xgafv))
  add(query_589524, "labelSelector", newJString(labelSelector))
  add(query_589524, "prettyPrint", newJBool(prettyPrint))
  add(query_589524, "fieldSelector", newJString(fieldSelector))
  add(query_589524, "limit", newJInt(limit))
  result = call_589522.call(path_589523, query_589524, nil, nil, nil)

var runProjectsLocationsAutodomainmappingsList* = Call_RunProjectsLocationsAutodomainmappingsList_589499(
    name: "runProjectsLocationsAutodomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/autodomainmappings",
    validator: validate_RunProjectsLocationsAutodomainmappingsList_589500,
    base: "/", url: url_RunProjectsLocationsAutodomainmappingsList_589501,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsCreate_589572 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsConfigurationsCreate_589574(protocol: Scheme;
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

proc validate_RunProjectsLocationsConfigurationsCreate_589573(path: JsonNode;
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
  var valid_589575 = path.getOrDefault("parent")
  valid_589575 = validateParameter(valid_589575, JString, required = true,
                                 default = nil)
  if valid_589575 != nil:
    section.add "parent", valid_589575
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
  var valid_589576 = query.getOrDefault("upload_protocol")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = nil)
  if valid_589576 != nil:
    section.add "upload_protocol", valid_589576
  var valid_589577 = query.getOrDefault("fields")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "fields", valid_589577
  var valid_589578 = query.getOrDefault("quotaUser")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "quotaUser", valid_589578
  var valid_589579 = query.getOrDefault("alt")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = newJString("json"))
  if valid_589579 != nil:
    section.add "alt", valid_589579
  var valid_589580 = query.getOrDefault("oauth_token")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "oauth_token", valid_589580
  var valid_589581 = query.getOrDefault("callback")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = nil)
  if valid_589581 != nil:
    section.add "callback", valid_589581
  var valid_589582 = query.getOrDefault("access_token")
  valid_589582 = validateParameter(valid_589582, JString, required = false,
                                 default = nil)
  if valid_589582 != nil:
    section.add "access_token", valid_589582
  var valid_589583 = query.getOrDefault("uploadType")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "uploadType", valid_589583
  var valid_589584 = query.getOrDefault("key")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "key", valid_589584
  var valid_589585 = query.getOrDefault("$.xgafv")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = newJString("1"))
  if valid_589585 != nil:
    section.add "$.xgafv", valid_589585
  var valid_589586 = query.getOrDefault("prettyPrint")
  valid_589586 = validateParameter(valid_589586, JBool, required = false,
                                 default = newJBool(true))
  if valid_589586 != nil:
    section.add "prettyPrint", valid_589586
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

proc call*(call_589588: Call_RunProjectsLocationsConfigurationsCreate_589572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a configuration.
  ## 
  let valid = call_589588.validator(path, query, header, formData, body)
  let scheme = call_589588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589588.url(scheme.get, call_589588.host, call_589588.base,
                         call_589588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589588, url, valid)

proc call*(call_589589: Call_RunProjectsLocationsConfigurationsCreate_589572;
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
  var path_589590 = newJObject()
  var query_589591 = newJObject()
  var body_589592 = newJObject()
  add(query_589591, "upload_protocol", newJString(uploadProtocol))
  add(query_589591, "fields", newJString(fields))
  add(query_589591, "quotaUser", newJString(quotaUser))
  add(query_589591, "alt", newJString(alt))
  add(query_589591, "oauth_token", newJString(oauthToken))
  add(query_589591, "callback", newJString(callback))
  add(query_589591, "access_token", newJString(accessToken))
  add(query_589591, "uploadType", newJString(uploadType))
  add(path_589590, "parent", newJString(parent))
  add(query_589591, "key", newJString(key))
  add(query_589591, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589592 = body
  add(query_589591, "prettyPrint", newJBool(prettyPrint))
  result = call_589589.call(path_589590, query_589591, nil, nil, body_589592)

var runProjectsLocationsConfigurationsCreate* = Call_RunProjectsLocationsConfigurationsCreate_589572(
    name: "runProjectsLocationsConfigurationsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsCreate_589573,
    base: "/", url: url_RunProjectsLocationsConfigurationsCreate_589574,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_589546 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsConfigurationsList_589548(protocol: Scheme;
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

proc validate_RunProjectsLocationsConfigurationsList_589547(path: JsonNode;
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
  var valid_589549 = path.getOrDefault("parent")
  valid_589549 = validateParameter(valid_589549, JString, required = true,
                                 default = nil)
  if valid_589549 != nil:
    section.add "parent", valid_589549
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
  var valid_589550 = query.getOrDefault("upload_protocol")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = nil)
  if valid_589550 != nil:
    section.add "upload_protocol", valid_589550
  var valid_589551 = query.getOrDefault("fields")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "fields", valid_589551
  var valid_589552 = query.getOrDefault("quotaUser")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "quotaUser", valid_589552
  var valid_589553 = query.getOrDefault("includeUninitialized")
  valid_589553 = validateParameter(valid_589553, JBool, required = false, default = nil)
  if valid_589553 != nil:
    section.add "includeUninitialized", valid_589553
  var valid_589554 = query.getOrDefault("alt")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = newJString("json"))
  if valid_589554 != nil:
    section.add "alt", valid_589554
  var valid_589555 = query.getOrDefault("continue")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = nil)
  if valid_589555 != nil:
    section.add "continue", valid_589555
  var valid_589556 = query.getOrDefault("oauth_token")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "oauth_token", valid_589556
  var valid_589557 = query.getOrDefault("callback")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "callback", valid_589557
  var valid_589558 = query.getOrDefault("access_token")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "access_token", valid_589558
  var valid_589559 = query.getOrDefault("uploadType")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "uploadType", valid_589559
  var valid_589560 = query.getOrDefault("resourceVersion")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "resourceVersion", valid_589560
  var valid_589561 = query.getOrDefault("watch")
  valid_589561 = validateParameter(valid_589561, JBool, required = false, default = nil)
  if valid_589561 != nil:
    section.add "watch", valid_589561
  var valid_589562 = query.getOrDefault("key")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "key", valid_589562
  var valid_589563 = query.getOrDefault("$.xgafv")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = newJString("1"))
  if valid_589563 != nil:
    section.add "$.xgafv", valid_589563
  var valid_589564 = query.getOrDefault("labelSelector")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "labelSelector", valid_589564
  var valid_589565 = query.getOrDefault("prettyPrint")
  valid_589565 = validateParameter(valid_589565, JBool, required = false,
                                 default = newJBool(true))
  if valid_589565 != nil:
    section.add "prettyPrint", valid_589565
  var valid_589566 = query.getOrDefault("fieldSelector")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "fieldSelector", valid_589566
  var valid_589567 = query.getOrDefault("limit")
  valid_589567 = validateParameter(valid_589567, JInt, required = false, default = nil)
  if valid_589567 != nil:
    section.add "limit", valid_589567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589568: Call_RunProjectsLocationsConfigurationsList_589546;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List configurations.
  ## 
  let valid = call_589568.validator(path, query, header, formData, body)
  let scheme = call_589568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589568.url(scheme.get, call_589568.host, call_589568.base,
                         call_589568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589568, url, valid)

proc call*(call_589569: Call_RunProjectsLocationsConfigurationsList_589546;
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
  var path_589570 = newJObject()
  var query_589571 = newJObject()
  add(query_589571, "upload_protocol", newJString(uploadProtocol))
  add(query_589571, "fields", newJString(fields))
  add(query_589571, "quotaUser", newJString(quotaUser))
  add(query_589571, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589571, "alt", newJString(alt))
  add(query_589571, "continue", newJString(`continue`))
  add(query_589571, "oauth_token", newJString(oauthToken))
  add(query_589571, "callback", newJString(callback))
  add(query_589571, "access_token", newJString(accessToken))
  add(query_589571, "uploadType", newJString(uploadType))
  add(path_589570, "parent", newJString(parent))
  add(query_589571, "resourceVersion", newJString(resourceVersion))
  add(query_589571, "watch", newJBool(watch))
  add(query_589571, "key", newJString(key))
  add(query_589571, "$.xgafv", newJString(Xgafv))
  add(query_589571, "labelSelector", newJString(labelSelector))
  add(query_589571, "prettyPrint", newJBool(prettyPrint))
  add(query_589571, "fieldSelector", newJString(fieldSelector))
  add(query_589571, "limit", newJInt(limit))
  result = call_589569.call(path_589570, query_589571, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_589546(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_589547, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_589548,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_589619 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsDomainmappingsCreate_589621(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsCreate_589620(path: JsonNode;
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
  var valid_589622 = path.getOrDefault("parent")
  valid_589622 = validateParameter(valid_589622, JString, required = true,
                                 default = nil)
  if valid_589622 != nil:
    section.add "parent", valid_589622
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
  var valid_589623 = query.getOrDefault("upload_protocol")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "upload_protocol", valid_589623
  var valid_589624 = query.getOrDefault("fields")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = nil)
  if valid_589624 != nil:
    section.add "fields", valid_589624
  var valid_589625 = query.getOrDefault("quotaUser")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "quotaUser", valid_589625
  var valid_589626 = query.getOrDefault("alt")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = newJString("json"))
  if valid_589626 != nil:
    section.add "alt", valid_589626
  var valid_589627 = query.getOrDefault("oauth_token")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "oauth_token", valid_589627
  var valid_589628 = query.getOrDefault("callback")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "callback", valid_589628
  var valid_589629 = query.getOrDefault("access_token")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "access_token", valid_589629
  var valid_589630 = query.getOrDefault("uploadType")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "uploadType", valid_589630
  var valid_589631 = query.getOrDefault("key")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = nil)
  if valid_589631 != nil:
    section.add "key", valid_589631
  var valid_589632 = query.getOrDefault("$.xgafv")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = newJString("1"))
  if valid_589632 != nil:
    section.add "$.xgafv", valid_589632
  var valid_589633 = query.getOrDefault("prettyPrint")
  valid_589633 = validateParameter(valid_589633, JBool, required = false,
                                 default = newJBool(true))
  if valid_589633 != nil:
    section.add "prettyPrint", valid_589633
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

proc call*(call_589635: Call_RunProjectsLocationsDomainmappingsCreate_589619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new domain mapping.
  ## 
  let valid = call_589635.validator(path, query, header, formData, body)
  let scheme = call_589635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589635.url(scheme.get, call_589635.host, call_589635.base,
                         call_589635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589635, url, valid)

proc call*(call_589636: Call_RunProjectsLocationsDomainmappingsCreate_589619;
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
  var path_589637 = newJObject()
  var query_589638 = newJObject()
  var body_589639 = newJObject()
  add(query_589638, "upload_protocol", newJString(uploadProtocol))
  add(query_589638, "fields", newJString(fields))
  add(query_589638, "quotaUser", newJString(quotaUser))
  add(query_589638, "alt", newJString(alt))
  add(query_589638, "oauth_token", newJString(oauthToken))
  add(query_589638, "callback", newJString(callback))
  add(query_589638, "access_token", newJString(accessToken))
  add(query_589638, "uploadType", newJString(uploadType))
  add(path_589637, "parent", newJString(parent))
  add(query_589638, "key", newJString(key))
  add(query_589638, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589639 = body
  add(query_589638, "prettyPrint", newJBool(prettyPrint))
  result = call_589636.call(path_589637, query_589638, nil, nil, body_589639)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_589619(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_589620,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_589621,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_589593 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsDomainmappingsList_589595(protocol: Scheme;
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

proc validate_RunProjectsLocationsDomainmappingsList_589594(path: JsonNode;
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
  var valid_589596 = path.getOrDefault("parent")
  valid_589596 = validateParameter(valid_589596, JString, required = true,
                                 default = nil)
  if valid_589596 != nil:
    section.add "parent", valid_589596
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
  var valid_589597 = query.getOrDefault("upload_protocol")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "upload_protocol", valid_589597
  var valid_589598 = query.getOrDefault("fields")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = nil)
  if valid_589598 != nil:
    section.add "fields", valid_589598
  var valid_589599 = query.getOrDefault("quotaUser")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "quotaUser", valid_589599
  var valid_589600 = query.getOrDefault("includeUninitialized")
  valid_589600 = validateParameter(valid_589600, JBool, required = false, default = nil)
  if valid_589600 != nil:
    section.add "includeUninitialized", valid_589600
  var valid_589601 = query.getOrDefault("alt")
  valid_589601 = validateParameter(valid_589601, JString, required = false,
                                 default = newJString("json"))
  if valid_589601 != nil:
    section.add "alt", valid_589601
  var valid_589602 = query.getOrDefault("continue")
  valid_589602 = validateParameter(valid_589602, JString, required = false,
                                 default = nil)
  if valid_589602 != nil:
    section.add "continue", valid_589602
  var valid_589603 = query.getOrDefault("oauth_token")
  valid_589603 = validateParameter(valid_589603, JString, required = false,
                                 default = nil)
  if valid_589603 != nil:
    section.add "oauth_token", valid_589603
  var valid_589604 = query.getOrDefault("callback")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = nil)
  if valid_589604 != nil:
    section.add "callback", valid_589604
  var valid_589605 = query.getOrDefault("access_token")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = nil)
  if valid_589605 != nil:
    section.add "access_token", valid_589605
  var valid_589606 = query.getOrDefault("uploadType")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "uploadType", valid_589606
  var valid_589607 = query.getOrDefault("resourceVersion")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "resourceVersion", valid_589607
  var valid_589608 = query.getOrDefault("watch")
  valid_589608 = validateParameter(valid_589608, JBool, required = false, default = nil)
  if valid_589608 != nil:
    section.add "watch", valid_589608
  var valid_589609 = query.getOrDefault("key")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "key", valid_589609
  var valid_589610 = query.getOrDefault("$.xgafv")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = newJString("1"))
  if valid_589610 != nil:
    section.add "$.xgafv", valid_589610
  var valid_589611 = query.getOrDefault("labelSelector")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "labelSelector", valid_589611
  var valid_589612 = query.getOrDefault("prettyPrint")
  valid_589612 = validateParameter(valid_589612, JBool, required = false,
                                 default = newJBool(true))
  if valid_589612 != nil:
    section.add "prettyPrint", valid_589612
  var valid_589613 = query.getOrDefault("fieldSelector")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "fieldSelector", valid_589613
  var valid_589614 = query.getOrDefault("limit")
  valid_589614 = validateParameter(valid_589614, JInt, required = false, default = nil)
  if valid_589614 != nil:
    section.add "limit", valid_589614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589615: Call_RunProjectsLocationsDomainmappingsList_589593;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List domain mappings.
  ## 
  let valid = call_589615.validator(path, query, header, formData, body)
  let scheme = call_589615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589615.url(scheme.get, call_589615.host, call_589615.base,
                         call_589615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589615, url, valid)

proc call*(call_589616: Call_RunProjectsLocationsDomainmappingsList_589593;
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
  var path_589617 = newJObject()
  var query_589618 = newJObject()
  add(query_589618, "upload_protocol", newJString(uploadProtocol))
  add(query_589618, "fields", newJString(fields))
  add(query_589618, "quotaUser", newJString(quotaUser))
  add(query_589618, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589618, "alt", newJString(alt))
  add(query_589618, "continue", newJString(`continue`))
  add(query_589618, "oauth_token", newJString(oauthToken))
  add(query_589618, "callback", newJString(callback))
  add(query_589618, "access_token", newJString(accessToken))
  add(query_589618, "uploadType", newJString(uploadType))
  add(path_589617, "parent", newJString(parent))
  add(query_589618, "resourceVersion", newJString(resourceVersion))
  add(query_589618, "watch", newJBool(watch))
  add(query_589618, "key", newJString(key))
  add(query_589618, "$.xgafv", newJString(Xgafv))
  add(query_589618, "labelSelector", newJString(labelSelector))
  add(query_589618, "prettyPrint", newJBool(prettyPrint))
  add(query_589618, "fieldSelector", newJString(fieldSelector))
  add(query_589618, "limit", newJInt(limit))
  result = call_589616.call(path_589617, query_589618, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_589593(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_589594, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_589595,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_589640 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsRevisionsList_589642(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsRevisionsList_589641(path: JsonNode;
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
  var valid_589643 = path.getOrDefault("parent")
  valid_589643 = validateParameter(valid_589643, JString, required = true,
                                 default = nil)
  if valid_589643 != nil:
    section.add "parent", valid_589643
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
  var valid_589644 = query.getOrDefault("upload_protocol")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "upload_protocol", valid_589644
  var valid_589645 = query.getOrDefault("fields")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = nil)
  if valid_589645 != nil:
    section.add "fields", valid_589645
  var valid_589646 = query.getOrDefault("quotaUser")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "quotaUser", valid_589646
  var valid_589647 = query.getOrDefault("includeUninitialized")
  valid_589647 = validateParameter(valid_589647, JBool, required = false, default = nil)
  if valid_589647 != nil:
    section.add "includeUninitialized", valid_589647
  var valid_589648 = query.getOrDefault("alt")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = newJString("json"))
  if valid_589648 != nil:
    section.add "alt", valid_589648
  var valid_589649 = query.getOrDefault("continue")
  valid_589649 = validateParameter(valid_589649, JString, required = false,
                                 default = nil)
  if valid_589649 != nil:
    section.add "continue", valid_589649
  var valid_589650 = query.getOrDefault("oauth_token")
  valid_589650 = validateParameter(valid_589650, JString, required = false,
                                 default = nil)
  if valid_589650 != nil:
    section.add "oauth_token", valid_589650
  var valid_589651 = query.getOrDefault("callback")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = nil)
  if valid_589651 != nil:
    section.add "callback", valid_589651
  var valid_589652 = query.getOrDefault("access_token")
  valid_589652 = validateParameter(valid_589652, JString, required = false,
                                 default = nil)
  if valid_589652 != nil:
    section.add "access_token", valid_589652
  var valid_589653 = query.getOrDefault("uploadType")
  valid_589653 = validateParameter(valid_589653, JString, required = false,
                                 default = nil)
  if valid_589653 != nil:
    section.add "uploadType", valid_589653
  var valid_589654 = query.getOrDefault("resourceVersion")
  valid_589654 = validateParameter(valid_589654, JString, required = false,
                                 default = nil)
  if valid_589654 != nil:
    section.add "resourceVersion", valid_589654
  var valid_589655 = query.getOrDefault("watch")
  valid_589655 = validateParameter(valid_589655, JBool, required = false, default = nil)
  if valid_589655 != nil:
    section.add "watch", valid_589655
  var valid_589656 = query.getOrDefault("key")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "key", valid_589656
  var valid_589657 = query.getOrDefault("$.xgafv")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = newJString("1"))
  if valid_589657 != nil:
    section.add "$.xgafv", valid_589657
  var valid_589658 = query.getOrDefault("labelSelector")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = nil)
  if valid_589658 != nil:
    section.add "labelSelector", valid_589658
  var valid_589659 = query.getOrDefault("prettyPrint")
  valid_589659 = validateParameter(valid_589659, JBool, required = false,
                                 default = newJBool(true))
  if valid_589659 != nil:
    section.add "prettyPrint", valid_589659
  var valid_589660 = query.getOrDefault("fieldSelector")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "fieldSelector", valid_589660
  var valid_589661 = query.getOrDefault("limit")
  valid_589661 = validateParameter(valid_589661, JInt, required = false, default = nil)
  if valid_589661 != nil:
    section.add "limit", valid_589661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589662: Call_RunProjectsLocationsRevisionsList_589640;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List revisions.
  ## 
  let valid = call_589662.validator(path, query, header, formData, body)
  let scheme = call_589662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589662.url(scheme.get, call_589662.host, call_589662.base,
                         call_589662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589662, url, valid)

proc call*(call_589663: Call_RunProjectsLocationsRevisionsList_589640;
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
  var path_589664 = newJObject()
  var query_589665 = newJObject()
  add(query_589665, "upload_protocol", newJString(uploadProtocol))
  add(query_589665, "fields", newJString(fields))
  add(query_589665, "quotaUser", newJString(quotaUser))
  add(query_589665, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589665, "alt", newJString(alt))
  add(query_589665, "continue", newJString(`continue`))
  add(query_589665, "oauth_token", newJString(oauthToken))
  add(query_589665, "callback", newJString(callback))
  add(query_589665, "access_token", newJString(accessToken))
  add(query_589665, "uploadType", newJString(uploadType))
  add(path_589664, "parent", newJString(parent))
  add(query_589665, "resourceVersion", newJString(resourceVersion))
  add(query_589665, "watch", newJBool(watch))
  add(query_589665, "key", newJString(key))
  add(query_589665, "$.xgafv", newJString(Xgafv))
  add(query_589665, "labelSelector", newJString(labelSelector))
  add(query_589665, "prettyPrint", newJBool(prettyPrint))
  add(query_589665, "fieldSelector", newJString(fieldSelector))
  add(query_589665, "limit", newJInt(limit))
  result = call_589663.call(path_589664, query_589665, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_589640(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_589641, base: "/",
    url: url_RunProjectsLocationsRevisionsList_589642, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesCreate_589692 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsRoutesCreate_589694(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsRoutesCreate_589693(path: JsonNode;
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
  var valid_589695 = path.getOrDefault("parent")
  valid_589695 = validateParameter(valid_589695, JString, required = true,
                                 default = nil)
  if valid_589695 != nil:
    section.add "parent", valid_589695
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
  var valid_589696 = query.getOrDefault("upload_protocol")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "upload_protocol", valid_589696
  var valid_589697 = query.getOrDefault("fields")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = nil)
  if valid_589697 != nil:
    section.add "fields", valid_589697
  var valid_589698 = query.getOrDefault("quotaUser")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "quotaUser", valid_589698
  var valid_589699 = query.getOrDefault("alt")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = newJString("json"))
  if valid_589699 != nil:
    section.add "alt", valid_589699
  var valid_589700 = query.getOrDefault("oauth_token")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = nil)
  if valid_589700 != nil:
    section.add "oauth_token", valid_589700
  var valid_589701 = query.getOrDefault("callback")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = nil)
  if valid_589701 != nil:
    section.add "callback", valid_589701
  var valid_589702 = query.getOrDefault("access_token")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "access_token", valid_589702
  var valid_589703 = query.getOrDefault("uploadType")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "uploadType", valid_589703
  var valid_589704 = query.getOrDefault("key")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = nil)
  if valid_589704 != nil:
    section.add "key", valid_589704
  var valid_589705 = query.getOrDefault("$.xgafv")
  valid_589705 = validateParameter(valid_589705, JString, required = false,
                                 default = newJString("1"))
  if valid_589705 != nil:
    section.add "$.xgafv", valid_589705
  var valid_589706 = query.getOrDefault("prettyPrint")
  valid_589706 = validateParameter(valid_589706, JBool, required = false,
                                 default = newJBool(true))
  if valid_589706 != nil:
    section.add "prettyPrint", valid_589706
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

proc call*(call_589708: Call_RunProjectsLocationsRoutesCreate_589692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a route.
  ## 
  let valid = call_589708.validator(path, query, header, formData, body)
  let scheme = call_589708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589708.url(scheme.get, call_589708.host, call_589708.base,
                         call_589708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589708, url, valid)

proc call*(call_589709: Call_RunProjectsLocationsRoutesCreate_589692;
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
  var path_589710 = newJObject()
  var query_589711 = newJObject()
  var body_589712 = newJObject()
  add(query_589711, "upload_protocol", newJString(uploadProtocol))
  add(query_589711, "fields", newJString(fields))
  add(query_589711, "quotaUser", newJString(quotaUser))
  add(query_589711, "alt", newJString(alt))
  add(query_589711, "oauth_token", newJString(oauthToken))
  add(query_589711, "callback", newJString(callback))
  add(query_589711, "access_token", newJString(accessToken))
  add(query_589711, "uploadType", newJString(uploadType))
  add(path_589710, "parent", newJString(parent))
  add(query_589711, "key", newJString(key))
  add(query_589711, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589712 = body
  add(query_589711, "prettyPrint", newJBool(prettyPrint))
  result = call_589709.call(path_589710, query_589711, nil, nil, body_589712)

var runProjectsLocationsRoutesCreate* = Call_RunProjectsLocationsRoutesCreate_589692(
    name: "runProjectsLocationsRoutesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesCreate_589693, base: "/",
    url: url_RunProjectsLocationsRoutesCreate_589694, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_589666 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsRoutesList_589668(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsRoutesList_589667(path: JsonNode;
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
  var valid_589669 = path.getOrDefault("parent")
  valid_589669 = validateParameter(valid_589669, JString, required = true,
                                 default = nil)
  if valid_589669 != nil:
    section.add "parent", valid_589669
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
  var valid_589670 = query.getOrDefault("upload_protocol")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = nil)
  if valid_589670 != nil:
    section.add "upload_protocol", valid_589670
  var valid_589671 = query.getOrDefault("fields")
  valid_589671 = validateParameter(valid_589671, JString, required = false,
                                 default = nil)
  if valid_589671 != nil:
    section.add "fields", valid_589671
  var valid_589672 = query.getOrDefault("quotaUser")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "quotaUser", valid_589672
  var valid_589673 = query.getOrDefault("includeUninitialized")
  valid_589673 = validateParameter(valid_589673, JBool, required = false, default = nil)
  if valid_589673 != nil:
    section.add "includeUninitialized", valid_589673
  var valid_589674 = query.getOrDefault("alt")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = newJString("json"))
  if valid_589674 != nil:
    section.add "alt", valid_589674
  var valid_589675 = query.getOrDefault("continue")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = nil)
  if valid_589675 != nil:
    section.add "continue", valid_589675
  var valid_589676 = query.getOrDefault("oauth_token")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = nil)
  if valid_589676 != nil:
    section.add "oauth_token", valid_589676
  var valid_589677 = query.getOrDefault("callback")
  valid_589677 = validateParameter(valid_589677, JString, required = false,
                                 default = nil)
  if valid_589677 != nil:
    section.add "callback", valid_589677
  var valid_589678 = query.getOrDefault("access_token")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "access_token", valid_589678
  var valid_589679 = query.getOrDefault("uploadType")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = nil)
  if valid_589679 != nil:
    section.add "uploadType", valid_589679
  var valid_589680 = query.getOrDefault("resourceVersion")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "resourceVersion", valid_589680
  var valid_589681 = query.getOrDefault("watch")
  valid_589681 = validateParameter(valid_589681, JBool, required = false, default = nil)
  if valid_589681 != nil:
    section.add "watch", valid_589681
  var valid_589682 = query.getOrDefault("key")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "key", valid_589682
  var valid_589683 = query.getOrDefault("$.xgafv")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = newJString("1"))
  if valid_589683 != nil:
    section.add "$.xgafv", valid_589683
  var valid_589684 = query.getOrDefault("labelSelector")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "labelSelector", valid_589684
  var valid_589685 = query.getOrDefault("prettyPrint")
  valid_589685 = validateParameter(valid_589685, JBool, required = false,
                                 default = newJBool(true))
  if valid_589685 != nil:
    section.add "prettyPrint", valid_589685
  var valid_589686 = query.getOrDefault("fieldSelector")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = nil)
  if valid_589686 != nil:
    section.add "fieldSelector", valid_589686
  var valid_589687 = query.getOrDefault("limit")
  valid_589687 = validateParameter(valid_589687, JInt, required = false, default = nil)
  if valid_589687 != nil:
    section.add "limit", valid_589687
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589688: Call_RunProjectsLocationsRoutesList_589666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List routes.
  ## 
  let valid = call_589688.validator(path, query, header, formData, body)
  let scheme = call_589688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589688.url(scheme.get, call_589688.host, call_589688.base,
                         call_589688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589688, url, valid)

proc call*(call_589689: Call_RunProjectsLocationsRoutesList_589666; parent: string;
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
  var path_589690 = newJObject()
  var query_589691 = newJObject()
  add(query_589691, "upload_protocol", newJString(uploadProtocol))
  add(query_589691, "fields", newJString(fields))
  add(query_589691, "quotaUser", newJString(quotaUser))
  add(query_589691, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589691, "alt", newJString(alt))
  add(query_589691, "continue", newJString(`continue`))
  add(query_589691, "oauth_token", newJString(oauthToken))
  add(query_589691, "callback", newJString(callback))
  add(query_589691, "access_token", newJString(accessToken))
  add(query_589691, "uploadType", newJString(uploadType))
  add(path_589690, "parent", newJString(parent))
  add(query_589691, "resourceVersion", newJString(resourceVersion))
  add(query_589691, "watch", newJBool(watch))
  add(query_589691, "key", newJString(key))
  add(query_589691, "$.xgafv", newJString(Xgafv))
  add(query_589691, "labelSelector", newJString(labelSelector))
  add(query_589691, "prettyPrint", newJBool(prettyPrint))
  add(query_589691, "fieldSelector", newJString(fieldSelector))
  add(query_589691, "limit", newJInt(limit))
  result = call_589689.call(path_589690, query_589691, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_589666(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_589667, base: "/",
    url: url_RunProjectsLocationsRoutesList_589668, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_589739 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesCreate_589741(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesCreate_589740(path: JsonNode;
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
  var valid_589742 = path.getOrDefault("parent")
  valid_589742 = validateParameter(valid_589742, JString, required = true,
                                 default = nil)
  if valid_589742 != nil:
    section.add "parent", valid_589742
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
  var valid_589743 = query.getOrDefault("upload_protocol")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "upload_protocol", valid_589743
  var valid_589744 = query.getOrDefault("fields")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = nil)
  if valid_589744 != nil:
    section.add "fields", valid_589744
  var valid_589745 = query.getOrDefault("quotaUser")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = nil)
  if valid_589745 != nil:
    section.add "quotaUser", valid_589745
  var valid_589746 = query.getOrDefault("alt")
  valid_589746 = validateParameter(valid_589746, JString, required = false,
                                 default = newJString("json"))
  if valid_589746 != nil:
    section.add "alt", valid_589746
  var valid_589747 = query.getOrDefault("oauth_token")
  valid_589747 = validateParameter(valid_589747, JString, required = false,
                                 default = nil)
  if valid_589747 != nil:
    section.add "oauth_token", valid_589747
  var valid_589748 = query.getOrDefault("callback")
  valid_589748 = validateParameter(valid_589748, JString, required = false,
                                 default = nil)
  if valid_589748 != nil:
    section.add "callback", valid_589748
  var valid_589749 = query.getOrDefault("access_token")
  valid_589749 = validateParameter(valid_589749, JString, required = false,
                                 default = nil)
  if valid_589749 != nil:
    section.add "access_token", valid_589749
  var valid_589750 = query.getOrDefault("uploadType")
  valid_589750 = validateParameter(valid_589750, JString, required = false,
                                 default = nil)
  if valid_589750 != nil:
    section.add "uploadType", valid_589750
  var valid_589751 = query.getOrDefault("key")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = nil)
  if valid_589751 != nil:
    section.add "key", valid_589751
  var valid_589752 = query.getOrDefault("$.xgafv")
  valid_589752 = validateParameter(valid_589752, JString, required = false,
                                 default = newJString("1"))
  if valid_589752 != nil:
    section.add "$.xgafv", valid_589752
  var valid_589753 = query.getOrDefault("prettyPrint")
  valid_589753 = validateParameter(valid_589753, JBool, required = false,
                                 default = newJBool(true))
  if valid_589753 != nil:
    section.add "prettyPrint", valid_589753
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

proc call*(call_589755: Call_RunProjectsLocationsServicesCreate_589739;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a service.
  ## 
  let valid = call_589755.validator(path, query, header, formData, body)
  let scheme = call_589755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589755.url(scheme.get, call_589755.host, call_589755.base,
                         call_589755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589755, url, valid)

proc call*(call_589756: Call_RunProjectsLocationsServicesCreate_589739;
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
  var path_589757 = newJObject()
  var query_589758 = newJObject()
  var body_589759 = newJObject()
  add(query_589758, "upload_protocol", newJString(uploadProtocol))
  add(query_589758, "fields", newJString(fields))
  add(query_589758, "quotaUser", newJString(quotaUser))
  add(query_589758, "alt", newJString(alt))
  add(query_589758, "oauth_token", newJString(oauthToken))
  add(query_589758, "callback", newJString(callback))
  add(query_589758, "access_token", newJString(accessToken))
  add(query_589758, "uploadType", newJString(uploadType))
  add(path_589757, "parent", newJString(parent))
  add(query_589758, "key", newJString(key))
  add(query_589758, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589759 = body
  add(query_589758, "prettyPrint", newJBool(prettyPrint))
  result = call_589756.call(path_589757, query_589758, nil, nil, body_589759)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_589739(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_589740, base: "/",
    url: url_RunProjectsLocationsServicesCreate_589741, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_589713 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesList_589715(protocol: Scheme; host: string;
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

proc validate_RunProjectsLocationsServicesList_589714(path: JsonNode;
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
  var valid_589716 = path.getOrDefault("parent")
  valid_589716 = validateParameter(valid_589716, JString, required = true,
                                 default = nil)
  if valid_589716 != nil:
    section.add "parent", valid_589716
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
  var valid_589717 = query.getOrDefault("upload_protocol")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = nil)
  if valid_589717 != nil:
    section.add "upload_protocol", valid_589717
  var valid_589718 = query.getOrDefault("fields")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "fields", valid_589718
  var valid_589719 = query.getOrDefault("quotaUser")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = nil)
  if valid_589719 != nil:
    section.add "quotaUser", valid_589719
  var valid_589720 = query.getOrDefault("includeUninitialized")
  valid_589720 = validateParameter(valid_589720, JBool, required = false, default = nil)
  if valid_589720 != nil:
    section.add "includeUninitialized", valid_589720
  var valid_589721 = query.getOrDefault("alt")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = newJString("json"))
  if valid_589721 != nil:
    section.add "alt", valid_589721
  var valid_589722 = query.getOrDefault("continue")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "continue", valid_589722
  var valid_589723 = query.getOrDefault("oauth_token")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = nil)
  if valid_589723 != nil:
    section.add "oauth_token", valid_589723
  var valid_589724 = query.getOrDefault("callback")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "callback", valid_589724
  var valid_589725 = query.getOrDefault("access_token")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "access_token", valid_589725
  var valid_589726 = query.getOrDefault("uploadType")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = nil)
  if valid_589726 != nil:
    section.add "uploadType", valid_589726
  var valid_589727 = query.getOrDefault("resourceVersion")
  valid_589727 = validateParameter(valid_589727, JString, required = false,
                                 default = nil)
  if valid_589727 != nil:
    section.add "resourceVersion", valid_589727
  var valid_589728 = query.getOrDefault("watch")
  valid_589728 = validateParameter(valid_589728, JBool, required = false, default = nil)
  if valid_589728 != nil:
    section.add "watch", valid_589728
  var valid_589729 = query.getOrDefault("key")
  valid_589729 = validateParameter(valid_589729, JString, required = false,
                                 default = nil)
  if valid_589729 != nil:
    section.add "key", valid_589729
  var valid_589730 = query.getOrDefault("$.xgafv")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = newJString("1"))
  if valid_589730 != nil:
    section.add "$.xgafv", valid_589730
  var valid_589731 = query.getOrDefault("labelSelector")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = nil)
  if valid_589731 != nil:
    section.add "labelSelector", valid_589731
  var valid_589732 = query.getOrDefault("prettyPrint")
  valid_589732 = validateParameter(valid_589732, JBool, required = false,
                                 default = newJBool(true))
  if valid_589732 != nil:
    section.add "prettyPrint", valid_589732
  var valid_589733 = query.getOrDefault("fieldSelector")
  valid_589733 = validateParameter(valid_589733, JString, required = false,
                                 default = nil)
  if valid_589733 != nil:
    section.add "fieldSelector", valid_589733
  var valid_589734 = query.getOrDefault("limit")
  valid_589734 = validateParameter(valid_589734, JInt, required = false, default = nil)
  if valid_589734 != nil:
    section.add "limit", valid_589734
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589735: Call_RunProjectsLocationsServicesList_589713;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List services.
  ## 
  let valid = call_589735.validator(path, query, header, formData, body)
  let scheme = call_589735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589735.url(scheme.get, call_589735.host, call_589735.base,
                         call_589735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589735, url, valid)

proc call*(call_589736: Call_RunProjectsLocationsServicesList_589713;
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
  var path_589737 = newJObject()
  var query_589738 = newJObject()
  add(query_589738, "upload_protocol", newJString(uploadProtocol))
  add(query_589738, "fields", newJString(fields))
  add(query_589738, "quotaUser", newJString(quotaUser))
  add(query_589738, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589738, "alt", newJString(alt))
  add(query_589738, "continue", newJString(`continue`))
  add(query_589738, "oauth_token", newJString(oauthToken))
  add(query_589738, "callback", newJString(callback))
  add(query_589738, "access_token", newJString(accessToken))
  add(query_589738, "uploadType", newJString(uploadType))
  add(path_589737, "parent", newJString(parent))
  add(query_589738, "resourceVersion", newJString(resourceVersion))
  add(query_589738, "watch", newJBool(watch))
  add(query_589738, "key", newJString(key))
  add(query_589738, "$.xgafv", newJString(Xgafv))
  add(query_589738, "labelSelector", newJString(labelSelector))
  add(query_589738, "prettyPrint", newJBool(prettyPrint))
  add(query_589738, "fieldSelector", newJString(fieldSelector))
  add(query_589738, "limit", newJInt(limit))
  result = call_589736.call(path_589737, query_589738, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_589713(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_589714, base: "/",
    url: url_RunProjectsLocationsServicesList_589715, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_589760 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesGetIamPolicy_589762(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesGetIamPolicy_589761(path: JsonNode;
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
  var valid_589763 = path.getOrDefault("resource")
  valid_589763 = validateParameter(valid_589763, JString, required = true,
                                 default = nil)
  if valid_589763 != nil:
    section.add "resource", valid_589763
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
  var valid_589764 = query.getOrDefault("upload_protocol")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = nil)
  if valid_589764 != nil:
    section.add "upload_protocol", valid_589764
  var valid_589765 = query.getOrDefault("fields")
  valid_589765 = validateParameter(valid_589765, JString, required = false,
                                 default = nil)
  if valid_589765 != nil:
    section.add "fields", valid_589765
  var valid_589766 = query.getOrDefault("quotaUser")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = nil)
  if valid_589766 != nil:
    section.add "quotaUser", valid_589766
  var valid_589767 = query.getOrDefault("alt")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = newJString("json"))
  if valid_589767 != nil:
    section.add "alt", valid_589767
  var valid_589768 = query.getOrDefault("oauth_token")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "oauth_token", valid_589768
  var valid_589769 = query.getOrDefault("callback")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = nil)
  if valid_589769 != nil:
    section.add "callback", valid_589769
  var valid_589770 = query.getOrDefault("access_token")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "access_token", valid_589770
  var valid_589771 = query.getOrDefault("uploadType")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "uploadType", valid_589771
  var valid_589772 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589772 = validateParameter(valid_589772, JInt, required = false, default = nil)
  if valid_589772 != nil:
    section.add "options.requestedPolicyVersion", valid_589772
  var valid_589773 = query.getOrDefault("key")
  valid_589773 = validateParameter(valid_589773, JString, required = false,
                                 default = nil)
  if valid_589773 != nil:
    section.add "key", valid_589773
  var valid_589774 = query.getOrDefault("$.xgafv")
  valid_589774 = validateParameter(valid_589774, JString, required = false,
                                 default = newJString("1"))
  if valid_589774 != nil:
    section.add "$.xgafv", valid_589774
  var valid_589775 = query.getOrDefault("prettyPrint")
  valid_589775 = validateParameter(valid_589775, JBool, required = false,
                                 default = newJBool(true))
  if valid_589775 != nil:
    section.add "prettyPrint", valid_589775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589776: Call_RunProjectsLocationsServicesGetIamPolicy_589760;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_589776.validator(path, query, header, formData, body)
  let scheme = call_589776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589776.url(scheme.get, call_589776.host, call_589776.base,
                         call_589776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589776, url, valid)

proc call*(call_589777: Call_RunProjectsLocationsServicesGetIamPolicy_589760;
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
  var path_589778 = newJObject()
  var query_589779 = newJObject()
  add(query_589779, "upload_protocol", newJString(uploadProtocol))
  add(query_589779, "fields", newJString(fields))
  add(query_589779, "quotaUser", newJString(quotaUser))
  add(query_589779, "alt", newJString(alt))
  add(query_589779, "oauth_token", newJString(oauthToken))
  add(query_589779, "callback", newJString(callback))
  add(query_589779, "access_token", newJString(accessToken))
  add(query_589779, "uploadType", newJString(uploadType))
  add(query_589779, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589779, "key", newJString(key))
  add(query_589779, "$.xgafv", newJString(Xgafv))
  add(path_589778, "resource", newJString(resource))
  add(query_589779, "prettyPrint", newJBool(prettyPrint))
  result = call_589777.call(path_589778, query_589779, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_589760(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_589761,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_589762,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_589780 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesSetIamPolicy_589782(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesSetIamPolicy_589781(path: JsonNode;
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
  var valid_589783 = path.getOrDefault("resource")
  valid_589783 = validateParameter(valid_589783, JString, required = true,
                                 default = nil)
  if valid_589783 != nil:
    section.add "resource", valid_589783
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
  var valid_589784 = query.getOrDefault("upload_protocol")
  valid_589784 = validateParameter(valid_589784, JString, required = false,
                                 default = nil)
  if valid_589784 != nil:
    section.add "upload_protocol", valid_589784
  var valid_589785 = query.getOrDefault("fields")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "fields", valid_589785
  var valid_589786 = query.getOrDefault("quotaUser")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = nil)
  if valid_589786 != nil:
    section.add "quotaUser", valid_589786
  var valid_589787 = query.getOrDefault("alt")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = newJString("json"))
  if valid_589787 != nil:
    section.add "alt", valid_589787
  var valid_589788 = query.getOrDefault("oauth_token")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = nil)
  if valid_589788 != nil:
    section.add "oauth_token", valid_589788
  var valid_589789 = query.getOrDefault("callback")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "callback", valid_589789
  var valid_589790 = query.getOrDefault("access_token")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "access_token", valid_589790
  var valid_589791 = query.getOrDefault("uploadType")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = nil)
  if valid_589791 != nil:
    section.add "uploadType", valid_589791
  var valid_589792 = query.getOrDefault("key")
  valid_589792 = validateParameter(valid_589792, JString, required = false,
                                 default = nil)
  if valid_589792 != nil:
    section.add "key", valid_589792
  var valid_589793 = query.getOrDefault("$.xgafv")
  valid_589793 = validateParameter(valid_589793, JString, required = false,
                                 default = newJString("1"))
  if valid_589793 != nil:
    section.add "$.xgafv", valid_589793
  var valid_589794 = query.getOrDefault("prettyPrint")
  valid_589794 = validateParameter(valid_589794, JBool, required = false,
                                 default = newJBool(true))
  if valid_589794 != nil:
    section.add "prettyPrint", valid_589794
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

proc call*(call_589796: Call_RunProjectsLocationsServicesSetIamPolicy_589780;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_589796.validator(path, query, header, formData, body)
  let scheme = call_589796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589796.url(scheme.get, call_589796.host, call_589796.base,
                         call_589796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589796, url, valid)

proc call*(call_589797: Call_RunProjectsLocationsServicesSetIamPolicy_589780;
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
  var path_589798 = newJObject()
  var query_589799 = newJObject()
  var body_589800 = newJObject()
  add(query_589799, "upload_protocol", newJString(uploadProtocol))
  add(query_589799, "fields", newJString(fields))
  add(query_589799, "quotaUser", newJString(quotaUser))
  add(query_589799, "alt", newJString(alt))
  add(query_589799, "oauth_token", newJString(oauthToken))
  add(query_589799, "callback", newJString(callback))
  add(query_589799, "access_token", newJString(accessToken))
  add(query_589799, "uploadType", newJString(uploadType))
  add(query_589799, "key", newJString(key))
  add(query_589799, "$.xgafv", newJString(Xgafv))
  add(path_589798, "resource", newJString(resource))
  if body != nil:
    body_589800 = body
  add(query_589799, "prettyPrint", newJBool(prettyPrint))
  result = call_589797.call(path_589798, query_589799, nil, nil, body_589800)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_589780(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_589781,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_589782,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_589801 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesTestIamPermissions_589803(protocol: Scheme;
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

proc validate_RunProjectsLocationsServicesTestIamPermissions_589802(
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
  var valid_589804 = path.getOrDefault("resource")
  valid_589804 = validateParameter(valid_589804, JString, required = true,
                                 default = nil)
  if valid_589804 != nil:
    section.add "resource", valid_589804
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
  var valid_589805 = query.getOrDefault("upload_protocol")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = nil)
  if valid_589805 != nil:
    section.add "upload_protocol", valid_589805
  var valid_589806 = query.getOrDefault("fields")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "fields", valid_589806
  var valid_589807 = query.getOrDefault("quotaUser")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "quotaUser", valid_589807
  var valid_589808 = query.getOrDefault("alt")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = newJString("json"))
  if valid_589808 != nil:
    section.add "alt", valid_589808
  var valid_589809 = query.getOrDefault("oauth_token")
  valid_589809 = validateParameter(valid_589809, JString, required = false,
                                 default = nil)
  if valid_589809 != nil:
    section.add "oauth_token", valid_589809
  var valid_589810 = query.getOrDefault("callback")
  valid_589810 = validateParameter(valid_589810, JString, required = false,
                                 default = nil)
  if valid_589810 != nil:
    section.add "callback", valid_589810
  var valid_589811 = query.getOrDefault("access_token")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "access_token", valid_589811
  var valid_589812 = query.getOrDefault("uploadType")
  valid_589812 = validateParameter(valid_589812, JString, required = false,
                                 default = nil)
  if valid_589812 != nil:
    section.add "uploadType", valid_589812
  var valid_589813 = query.getOrDefault("key")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = nil)
  if valid_589813 != nil:
    section.add "key", valid_589813
  var valid_589814 = query.getOrDefault("$.xgafv")
  valid_589814 = validateParameter(valid_589814, JString, required = false,
                                 default = newJString("1"))
  if valid_589814 != nil:
    section.add "$.xgafv", valid_589814
  var valid_589815 = query.getOrDefault("prettyPrint")
  valid_589815 = validateParameter(valid_589815, JBool, required = false,
                                 default = newJBool(true))
  if valid_589815 != nil:
    section.add "prettyPrint", valid_589815
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

proc call*(call_589817: Call_RunProjectsLocationsServicesTestIamPermissions_589801;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_589817.validator(path, query, header, formData, body)
  let scheme = call_589817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589817.url(scheme.get, call_589817.host, call_589817.base,
                         call_589817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589817, url, valid)

proc call*(call_589818: Call_RunProjectsLocationsServicesTestIamPermissions_589801;
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
  var path_589819 = newJObject()
  var query_589820 = newJObject()
  var body_589821 = newJObject()
  add(query_589820, "upload_protocol", newJString(uploadProtocol))
  add(query_589820, "fields", newJString(fields))
  add(query_589820, "quotaUser", newJString(quotaUser))
  add(query_589820, "alt", newJString(alt))
  add(query_589820, "oauth_token", newJString(oauthToken))
  add(query_589820, "callback", newJString(callback))
  add(query_589820, "access_token", newJString(accessToken))
  add(query_589820, "uploadType", newJString(uploadType))
  add(query_589820, "key", newJString(key))
  add(query_589820, "$.xgafv", newJString(Xgafv))
  add(path_589819, "resource", newJString(resource))
  if body != nil:
    body_589821 = body
  add(query_589820, "prettyPrint", newJBool(prettyPrint))
  result = call_589818.call(path_589819, query_589820, nil, nil, body_589821)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_589801(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_589802,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_589803,
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
