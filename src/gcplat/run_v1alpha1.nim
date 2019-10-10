
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Run
## version: v1alpha1
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
  Call_RunNamespacesDomainmappingsGet_588719 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesDomainmappingsGet_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsGet_588720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a domain mapping.
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
  ## Rpc to get information about a domain mapping.
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
  ## Rpc to get information about a domain mapping.
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
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsGet_588720, base: "/",
    url: url_RunNamespacesDomainmappingsGet_588721, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsDelete_589007 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesDomainmappingsDelete_589009(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsDelete_589008(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
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
  ##   orphanDependents: JBool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
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
  var valid_589013 = query.getOrDefault("orphanDependents")
  valid_589013 = validateParameter(valid_589013, JBool, required = false, default = nil)
  if valid_589013 != nil:
    section.add "orphanDependents", valid_589013
  var valid_589014 = query.getOrDefault("quotaUser")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "quotaUser", valid_589014
  var valid_589015 = query.getOrDefault("alt")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("json"))
  if valid_589015 != nil:
    section.add "alt", valid_589015
  var valid_589016 = query.getOrDefault("oauth_token")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "oauth_token", valid_589016
  var valid_589017 = query.getOrDefault("callback")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "callback", valid_589017
  var valid_589018 = query.getOrDefault("access_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "access_token", valid_589018
  var valid_589019 = query.getOrDefault("uploadType")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "uploadType", valid_589019
  var valid_589020 = query.getOrDefault("kind")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "kind", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("$.xgafv")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("1"))
  if valid_589022 != nil:
    section.add "$.xgafv", valid_589022
  var valid_589023 = query.getOrDefault("prettyPrint")
  valid_589023 = validateParameter(valid_589023, JBool, required = false,
                                 default = newJBool(true))
  if valid_589023 != nil:
    section.add "prettyPrint", valid_589023
  var valid_589024 = query.getOrDefault("propagationPolicy")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "propagationPolicy", valid_589024
  var valid_589025 = query.getOrDefault("apiVersion")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "apiVersion", valid_589025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589026: Call_RunNamespacesDomainmappingsDelete_589007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_RunNamespacesDomainmappingsDelete_589007;
          name: string; uploadProtocol: string = ""; fields: string = "";
          orphanDependents: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runNamespacesDomainmappingsDelete
  ## Rpc to delete a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: bool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
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
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  add(query_589029, "upload_protocol", newJString(uploadProtocol))
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "orphanDependents", newJBool(orphanDependents))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(path_589028, "name", newJString(name))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "callback", newJString(callback))
  add(query_589029, "access_token", newJString(accessToken))
  add(query_589029, "uploadType", newJString(uploadType))
  add(query_589029, "kind", newJString(kind))
  add(query_589029, "key", newJString(key))
  add(query_589029, "$.xgafv", newJString(Xgafv))
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  add(query_589029, "propagationPolicy", newJString(propagationPolicy))
  add(query_589029, "apiVersion", newJString(apiVersion))
  result = call_589027.call(path_589028, query_589029, nil, nil, nil)

var runNamespacesDomainmappingsDelete* = Call_RunNamespacesDomainmappingsDelete_589007(
    name: "runNamespacesDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{name}",
    validator: validate_RunNamespacesDomainmappingsDelete_589008, base: "/",
    url: url_RunNamespacesDomainmappingsDelete_589009, schemes: {Scheme.Https})
type
  Call_RunNamespacesAuthorizeddomainsList_589030 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesAuthorizeddomainsList_589032(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/authorizeddomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesAuthorizeddomainsList_589031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## RPC to list authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589033 = path.getOrDefault("parent")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "parent", valid_589033
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
  var valid_589034 = query.getOrDefault("upload_protocol")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "upload_protocol", valid_589034
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("pageToken")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "pageToken", valid_589036
  var valid_589037 = query.getOrDefault("quotaUser")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "quotaUser", valid_589037
  var valid_589038 = query.getOrDefault("alt")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("json"))
  if valid_589038 != nil:
    section.add "alt", valid_589038
  var valid_589039 = query.getOrDefault("oauth_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "oauth_token", valid_589039
  var valid_589040 = query.getOrDefault("callback")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "callback", valid_589040
  var valid_589041 = query.getOrDefault("access_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "access_token", valid_589041
  var valid_589042 = query.getOrDefault("uploadType")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "uploadType", valid_589042
  var valid_589043 = query.getOrDefault("key")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "key", valid_589043
  var valid_589044 = query.getOrDefault("$.xgafv")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("1"))
  if valid_589044 != nil:
    section.add "$.xgafv", valid_589044
  var valid_589045 = query.getOrDefault("pageSize")
  valid_589045 = validateParameter(valid_589045, JInt, required = false, default = nil)
  if valid_589045 != nil:
    section.add "pageSize", valid_589045
  var valid_589046 = query.getOrDefault("prettyPrint")
  valid_589046 = validateParameter(valid_589046, JBool, required = false,
                                 default = newJBool(true))
  if valid_589046 != nil:
    section.add "prettyPrint", valid_589046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589047: Call_RunNamespacesAuthorizeddomainsList_589030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_589047.validator(path, query, header, formData, body)
  let scheme = call_589047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589047.url(scheme.get, call_589047.host, call_589047.base,
                         call_589047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589047, url, valid)

proc call*(call_589048: Call_RunNamespacesAuthorizeddomainsList_589030;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesAuthorizeddomainsList
  ## RPC to list authorized domains.
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
  var path_589049 = newJObject()
  var query_589050 = newJObject()
  add(query_589050, "upload_protocol", newJString(uploadProtocol))
  add(query_589050, "fields", newJString(fields))
  add(query_589050, "pageToken", newJString(pageToken))
  add(query_589050, "quotaUser", newJString(quotaUser))
  add(query_589050, "alt", newJString(alt))
  add(query_589050, "oauth_token", newJString(oauthToken))
  add(query_589050, "callback", newJString(callback))
  add(query_589050, "access_token", newJString(accessToken))
  add(query_589050, "uploadType", newJString(uploadType))
  add(path_589049, "parent", newJString(parent))
  add(query_589050, "key", newJString(key))
  add(query_589050, "$.xgafv", newJString(Xgafv))
  add(query_589050, "pageSize", newJInt(pageSize))
  add(query_589050, "prettyPrint", newJBool(prettyPrint))
  result = call_589048.call(path_589049, query_589050, nil, nil, nil)

var runNamespacesAuthorizeddomainsList* = Call_RunNamespacesAuthorizeddomainsList_589030(
    name: "runNamespacesAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunNamespacesAuthorizeddomainsList_589031, base: "/",
    url: url_RunNamespacesAuthorizeddomainsList_589032, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsCreate_589077 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesDomainmappingsCreate_589079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsCreate_589078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589080 = path.getOrDefault("parent")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "parent", valid_589080
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
  var valid_589081 = query.getOrDefault("upload_protocol")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "upload_protocol", valid_589081
  var valid_589082 = query.getOrDefault("fields")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "fields", valid_589082
  var valid_589083 = query.getOrDefault("quotaUser")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "quotaUser", valid_589083
  var valid_589084 = query.getOrDefault("alt")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("json"))
  if valid_589084 != nil:
    section.add "alt", valid_589084
  var valid_589085 = query.getOrDefault("oauth_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "oauth_token", valid_589085
  var valid_589086 = query.getOrDefault("callback")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "callback", valid_589086
  var valid_589087 = query.getOrDefault("access_token")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "access_token", valid_589087
  var valid_589088 = query.getOrDefault("uploadType")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "uploadType", valid_589088
  var valid_589089 = query.getOrDefault("key")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "key", valid_589089
  var valid_589090 = query.getOrDefault("$.xgafv")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("1"))
  if valid_589090 != nil:
    section.add "$.xgafv", valid_589090
  var valid_589091 = query.getOrDefault("prettyPrint")
  valid_589091 = validateParameter(valid_589091, JBool, required = false,
                                 default = newJBool(true))
  if valid_589091 != nil:
    section.add "prettyPrint", valid_589091
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

proc call*(call_589093: Call_RunNamespacesDomainmappingsCreate_589077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_589093.validator(path, query, header, formData, body)
  let scheme = call_589093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589093.url(scheme.get, call_589093.host, call_589093.base,
                         call_589093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589093, url, valid)

proc call*(call_589094: Call_RunNamespacesDomainmappingsCreate_589077;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesDomainmappingsCreate
  ## Creates a new domain mapping.
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
  var path_589095 = newJObject()
  var query_589096 = newJObject()
  var body_589097 = newJObject()
  add(query_589096, "upload_protocol", newJString(uploadProtocol))
  add(query_589096, "fields", newJString(fields))
  add(query_589096, "quotaUser", newJString(quotaUser))
  add(query_589096, "alt", newJString(alt))
  add(query_589096, "oauth_token", newJString(oauthToken))
  add(query_589096, "callback", newJString(callback))
  add(query_589096, "access_token", newJString(accessToken))
  add(query_589096, "uploadType", newJString(uploadType))
  add(path_589095, "parent", newJString(parent))
  add(query_589096, "key", newJString(key))
  add(query_589096, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589097 = body
  add(query_589096, "prettyPrint", newJBool(prettyPrint))
  result = call_589094.call(path_589095, query_589096, nil, nil, body_589097)

var runNamespacesDomainmappingsCreate* = Call_RunNamespacesDomainmappingsCreate_589077(
    name: "runNamespacesDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsCreate_589078, base: "/",
    url: url_RunNamespacesDomainmappingsCreate_589079, schemes: {Scheme.Https})
type
  Call_RunNamespacesDomainmappingsList_589051 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesDomainmappingsList_589053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/domains.cloudrun.com/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesDomainmappingsList_589052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589054 = path.getOrDefault("parent")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "parent", valid_589054
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
  var valid_589055 = query.getOrDefault("upload_protocol")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "upload_protocol", valid_589055
  var valid_589056 = query.getOrDefault("fields")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "fields", valid_589056
  var valid_589057 = query.getOrDefault("quotaUser")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "quotaUser", valid_589057
  var valid_589058 = query.getOrDefault("includeUninitialized")
  valid_589058 = validateParameter(valid_589058, JBool, required = false, default = nil)
  if valid_589058 != nil:
    section.add "includeUninitialized", valid_589058
  var valid_589059 = query.getOrDefault("alt")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = newJString("json"))
  if valid_589059 != nil:
    section.add "alt", valid_589059
  var valid_589060 = query.getOrDefault("continue")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "continue", valid_589060
  var valid_589061 = query.getOrDefault("oauth_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "oauth_token", valid_589061
  var valid_589062 = query.getOrDefault("callback")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "callback", valid_589062
  var valid_589063 = query.getOrDefault("access_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "access_token", valid_589063
  var valid_589064 = query.getOrDefault("uploadType")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "uploadType", valid_589064
  var valid_589065 = query.getOrDefault("resourceVersion")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "resourceVersion", valid_589065
  var valid_589066 = query.getOrDefault("watch")
  valid_589066 = validateParameter(valid_589066, JBool, required = false, default = nil)
  if valid_589066 != nil:
    section.add "watch", valid_589066
  var valid_589067 = query.getOrDefault("key")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "key", valid_589067
  var valid_589068 = query.getOrDefault("$.xgafv")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("1"))
  if valid_589068 != nil:
    section.add "$.xgafv", valid_589068
  var valid_589069 = query.getOrDefault("labelSelector")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "labelSelector", valid_589069
  var valid_589070 = query.getOrDefault("prettyPrint")
  valid_589070 = validateParameter(valid_589070, JBool, required = false,
                                 default = newJBool(true))
  if valid_589070 != nil:
    section.add "prettyPrint", valid_589070
  var valid_589071 = query.getOrDefault("fieldSelector")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "fieldSelector", valid_589071
  var valid_589072 = query.getOrDefault("limit")
  valid_589072 = validateParameter(valid_589072, JInt, required = false, default = nil)
  if valid_589072 != nil:
    section.add "limit", valid_589072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589073: Call_RunNamespacesDomainmappingsList_589051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_589073.validator(path, query, header, formData, body)
  let scheme = call_589073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589073.url(scheme.get, call_589073.host, call_589073.base,
                         call_589073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589073, url, valid)

proc call*(call_589074: Call_RunNamespacesDomainmappingsList_589051;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesDomainmappingsList
  ## Rpc to list domain mappings.
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
  var path_589075 = newJObject()
  var query_589076 = newJObject()
  add(query_589076, "upload_protocol", newJString(uploadProtocol))
  add(query_589076, "fields", newJString(fields))
  add(query_589076, "quotaUser", newJString(quotaUser))
  add(query_589076, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589076, "alt", newJString(alt))
  add(query_589076, "continue", newJString(`continue`))
  add(query_589076, "oauth_token", newJString(oauthToken))
  add(query_589076, "callback", newJString(callback))
  add(query_589076, "access_token", newJString(accessToken))
  add(query_589076, "uploadType", newJString(uploadType))
  add(path_589075, "parent", newJString(parent))
  add(query_589076, "resourceVersion", newJString(resourceVersion))
  add(query_589076, "watch", newJBool(watch))
  add(query_589076, "key", newJString(key))
  add(query_589076, "$.xgafv", newJString(Xgafv))
  add(query_589076, "labelSelector", newJString(labelSelector))
  add(query_589076, "prettyPrint", newJBool(prettyPrint))
  add(query_589076, "fieldSelector", newJString(fieldSelector))
  add(query_589076, "limit", newJInt(limit))
  result = call_589074.call(path_589075, query_589076, nil, nil, nil)

var runNamespacesDomainmappingsList* = Call_RunNamespacesDomainmappingsList_589051(
    name: "runNamespacesDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/domains.cloudrun.com/v1alpha1/{parent}/domainmappings",
    validator: validate_RunNamespacesDomainmappingsList_589052, base: "/",
    url: url_RunNamespacesDomainmappingsList_589053, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersReplaceTrigger_589117 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesTriggersReplaceTrigger_589119(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersReplaceTrigger_589118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to replace a trigger.
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
  ##       : The name of the trigger being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589120 = path.getOrDefault("name")
  valid_589120 = validateParameter(valid_589120, JString, required = true,
                                 default = nil)
  if valid_589120 != nil:
    section.add "name", valid_589120
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
  var valid_589121 = query.getOrDefault("upload_protocol")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "upload_protocol", valid_589121
  var valid_589122 = query.getOrDefault("fields")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "fields", valid_589122
  var valid_589123 = query.getOrDefault("quotaUser")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "quotaUser", valid_589123
  var valid_589124 = query.getOrDefault("alt")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = newJString("json"))
  if valid_589124 != nil:
    section.add "alt", valid_589124
  var valid_589125 = query.getOrDefault("oauth_token")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "oauth_token", valid_589125
  var valid_589126 = query.getOrDefault("callback")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "callback", valid_589126
  var valid_589127 = query.getOrDefault("access_token")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "access_token", valid_589127
  var valid_589128 = query.getOrDefault("uploadType")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "uploadType", valid_589128
  var valid_589129 = query.getOrDefault("key")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "key", valid_589129
  var valid_589130 = query.getOrDefault("$.xgafv")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = newJString("1"))
  if valid_589130 != nil:
    section.add "$.xgafv", valid_589130
  var valid_589131 = query.getOrDefault("prettyPrint")
  valid_589131 = validateParameter(valid_589131, JBool, required = false,
                                 default = newJBool(true))
  if valid_589131 != nil:
    section.add "prettyPrint", valid_589131
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

proc call*(call_589133: Call_RunNamespacesTriggersReplaceTrigger_589117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to replace a trigger.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_589133.validator(path, query, header, formData, body)
  let scheme = call_589133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589133.url(scheme.get, call_589133.host, call_589133.base,
                         call_589133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589133, url, valid)

proc call*(call_589134: Call_RunNamespacesTriggersReplaceTrigger_589117;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesTriggersReplaceTrigger
  ## Rpc to replace a trigger.
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
  ##       : The name of the trigger being retrieved. If needed, replace
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
  var path_589135 = newJObject()
  var query_589136 = newJObject()
  var body_589137 = newJObject()
  add(query_589136, "upload_protocol", newJString(uploadProtocol))
  add(query_589136, "fields", newJString(fields))
  add(query_589136, "quotaUser", newJString(quotaUser))
  add(path_589135, "name", newJString(name))
  add(query_589136, "alt", newJString(alt))
  add(query_589136, "oauth_token", newJString(oauthToken))
  add(query_589136, "callback", newJString(callback))
  add(query_589136, "access_token", newJString(accessToken))
  add(query_589136, "uploadType", newJString(uploadType))
  add(query_589136, "key", newJString(key))
  add(query_589136, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589137 = body
  add(query_589136, "prettyPrint", newJBool(prettyPrint))
  result = call_589134.call(path_589135, query_589136, nil, nil, body_589137)

var runNamespacesTriggersReplaceTrigger* = Call_RunNamespacesTriggersReplaceTrigger_589117(
    name: "runNamespacesTriggersReplaceTrigger", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersReplaceTrigger_589118, base: "/",
    url: url_RunNamespacesTriggersReplaceTrigger_589119, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersGet_589098 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesTriggersGet_589100(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersGet_589099(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the trigger being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589101 = path.getOrDefault("name")
  valid_589101 = validateParameter(valid_589101, JString, required = true,
                                 default = nil)
  if valid_589101 != nil:
    section.add "name", valid_589101
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
  var valid_589102 = query.getOrDefault("upload_protocol")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "upload_protocol", valid_589102
  var valid_589103 = query.getOrDefault("fields")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "fields", valid_589103
  var valid_589104 = query.getOrDefault("quotaUser")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "quotaUser", valid_589104
  var valid_589105 = query.getOrDefault("alt")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("json"))
  if valid_589105 != nil:
    section.add "alt", valid_589105
  var valid_589106 = query.getOrDefault("oauth_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "oauth_token", valid_589106
  var valid_589107 = query.getOrDefault("callback")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "callback", valid_589107
  var valid_589108 = query.getOrDefault("access_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "access_token", valid_589108
  var valid_589109 = query.getOrDefault("uploadType")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "uploadType", valid_589109
  var valid_589110 = query.getOrDefault("key")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "key", valid_589110
  var valid_589111 = query.getOrDefault("$.xgafv")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("1"))
  if valid_589111 != nil:
    section.add "$.xgafv", valid_589111
  var valid_589112 = query.getOrDefault("prettyPrint")
  valid_589112 = validateParameter(valid_589112, JBool, required = false,
                                 default = newJBool(true))
  if valid_589112 != nil:
    section.add "prettyPrint", valid_589112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589113: Call_RunNamespacesTriggersGet_589098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a trigger.
  ## 
  let valid = call_589113.validator(path, query, header, formData, body)
  let scheme = call_589113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589113.url(scheme.get, call_589113.host, call_589113.base,
                         call_589113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589113, url, valid)

proc call*(call_589114: Call_RunNamespacesTriggersGet_589098; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runNamespacesTriggersGet
  ## Rpc to get information about a trigger.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the trigger being retrieved. If needed, replace
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
  var path_589115 = newJObject()
  var query_589116 = newJObject()
  add(query_589116, "upload_protocol", newJString(uploadProtocol))
  add(query_589116, "fields", newJString(fields))
  add(query_589116, "quotaUser", newJString(quotaUser))
  add(path_589115, "name", newJString(name))
  add(query_589116, "alt", newJString(alt))
  add(query_589116, "oauth_token", newJString(oauthToken))
  add(query_589116, "callback", newJString(callback))
  add(query_589116, "access_token", newJString(accessToken))
  add(query_589116, "uploadType", newJString(uploadType))
  add(query_589116, "key", newJString(key))
  add(query_589116, "$.xgafv", newJString(Xgafv))
  add(query_589116, "prettyPrint", newJBool(prettyPrint))
  result = call_589114.call(path_589115, query_589116, nil, nil, nil)

var runNamespacesTriggersGet* = Call_RunNamespacesTriggersGet_589098(
    name: "runNamespacesTriggersGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersGet_589099, base: "/",
    url: url_RunNamespacesTriggersGet_589100, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersDelete_589138 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesTriggersDelete_589140(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersDelete_589139(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the trigger being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589141 = path.getOrDefault("name")
  valid_589141 = validateParameter(valid_589141, JString, required = true,
                                 default = nil)
  if valid_589141 != nil:
    section.add "name", valid_589141
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
  var valid_589142 = query.getOrDefault("upload_protocol")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "upload_protocol", valid_589142
  var valid_589143 = query.getOrDefault("fields")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "fields", valid_589143
  var valid_589144 = query.getOrDefault("quotaUser")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "quotaUser", valid_589144
  var valid_589145 = query.getOrDefault("alt")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("json"))
  if valid_589145 != nil:
    section.add "alt", valid_589145
  var valid_589146 = query.getOrDefault("oauth_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "oauth_token", valid_589146
  var valid_589147 = query.getOrDefault("callback")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "callback", valid_589147
  var valid_589148 = query.getOrDefault("access_token")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "access_token", valid_589148
  var valid_589149 = query.getOrDefault("uploadType")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "uploadType", valid_589149
  var valid_589150 = query.getOrDefault("kind")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "kind", valid_589150
  var valid_589151 = query.getOrDefault("key")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "key", valid_589151
  var valid_589152 = query.getOrDefault("$.xgafv")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = newJString("1"))
  if valid_589152 != nil:
    section.add "$.xgafv", valid_589152
  var valid_589153 = query.getOrDefault("prettyPrint")
  valid_589153 = validateParameter(valid_589153, JBool, required = false,
                                 default = newJBool(true))
  if valid_589153 != nil:
    section.add "prettyPrint", valid_589153
  var valid_589154 = query.getOrDefault("propagationPolicy")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "propagationPolicy", valid_589154
  var valid_589155 = query.getOrDefault("apiVersion")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "apiVersion", valid_589155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589156: Call_RunNamespacesTriggersDelete_589138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a trigger.
  ## 
  let valid = call_589156.validator(path, query, header, formData, body)
  let scheme = call_589156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589156.url(scheme.get, call_589156.host, call_589156.base,
                         call_589156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589156, url, valid)

proc call*(call_589157: Call_RunNamespacesTriggersDelete_589138; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; kind: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          propagationPolicy: string = ""; apiVersion: string = ""): Recallable =
  ## runNamespacesTriggersDelete
  ## Rpc to delete a trigger.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the trigger being deleted. If needed, replace
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
  var path_589158 = newJObject()
  var query_589159 = newJObject()
  add(query_589159, "upload_protocol", newJString(uploadProtocol))
  add(query_589159, "fields", newJString(fields))
  add(query_589159, "quotaUser", newJString(quotaUser))
  add(path_589158, "name", newJString(name))
  add(query_589159, "alt", newJString(alt))
  add(query_589159, "oauth_token", newJString(oauthToken))
  add(query_589159, "callback", newJString(callback))
  add(query_589159, "access_token", newJString(accessToken))
  add(query_589159, "uploadType", newJString(uploadType))
  add(query_589159, "kind", newJString(kind))
  add(query_589159, "key", newJString(key))
  add(query_589159, "$.xgafv", newJString(Xgafv))
  add(query_589159, "prettyPrint", newJBool(prettyPrint))
  add(query_589159, "propagationPolicy", newJString(propagationPolicy))
  add(query_589159, "apiVersion", newJString(apiVersion))
  result = call_589157.call(path_589158, query_589159, nil, nil, nil)

var runNamespacesTriggersDelete* = Call_RunNamespacesTriggersDelete_589138(
    name: "runNamespacesTriggersDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesTriggersDelete_589139, base: "/",
    url: url_RunNamespacesTriggersDelete_589140, schemes: {Scheme.Https})
type
  Call_RunNamespacesEventtypesList_589160 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesEventtypesList_589162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/eventtypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesEventtypesList_589161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list EventTypes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the EventTypes should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589163 = path.getOrDefault("parent")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "parent", valid_589163
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
  var valid_589164 = query.getOrDefault("upload_protocol")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "upload_protocol", valid_589164
  var valid_589165 = query.getOrDefault("fields")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "fields", valid_589165
  var valid_589166 = query.getOrDefault("quotaUser")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "quotaUser", valid_589166
  var valid_589167 = query.getOrDefault("includeUninitialized")
  valid_589167 = validateParameter(valid_589167, JBool, required = false, default = nil)
  if valid_589167 != nil:
    section.add "includeUninitialized", valid_589167
  var valid_589168 = query.getOrDefault("alt")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = newJString("json"))
  if valid_589168 != nil:
    section.add "alt", valid_589168
  var valid_589169 = query.getOrDefault("continue")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "continue", valid_589169
  var valid_589170 = query.getOrDefault("oauth_token")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "oauth_token", valid_589170
  var valid_589171 = query.getOrDefault("callback")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "callback", valid_589171
  var valid_589172 = query.getOrDefault("access_token")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "access_token", valid_589172
  var valid_589173 = query.getOrDefault("uploadType")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "uploadType", valid_589173
  var valid_589174 = query.getOrDefault("resourceVersion")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "resourceVersion", valid_589174
  var valid_589175 = query.getOrDefault("watch")
  valid_589175 = validateParameter(valid_589175, JBool, required = false, default = nil)
  if valid_589175 != nil:
    section.add "watch", valid_589175
  var valid_589176 = query.getOrDefault("key")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "key", valid_589176
  var valid_589177 = query.getOrDefault("$.xgafv")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("1"))
  if valid_589177 != nil:
    section.add "$.xgafv", valid_589177
  var valid_589178 = query.getOrDefault("labelSelector")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "labelSelector", valid_589178
  var valid_589179 = query.getOrDefault("prettyPrint")
  valid_589179 = validateParameter(valid_589179, JBool, required = false,
                                 default = newJBool(true))
  if valid_589179 != nil:
    section.add "prettyPrint", valid_589179
  var valid_589180 = query.getOrDefault("fieldSelector")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "fieldSelector", valid_589180
  var valid_589181 = query.getOrDefault("limit")
  valid_589181 = validateParameter(valid_589181, JInt, required = false, default = nil)
  if valid_589181 != nil:
    section.add "limit", valid_589181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589182: Call_RunNamespacesEventtypesList_589160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_RunNamespacesEventtypesList_589160; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesEventtypesList
  ## Rpc to list EventTypes.
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
  ##         : The project ID or project number from which the EventTypes should be
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
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  add(query_589185, "upload_protocol", newJString(uploadProtocol))
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "continue", newJString(`continue`))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "callback", newJString(callback))
  add(query_589185, "access_token", newJString(accessToken))
  add(query_589185, "uploadType", newJString(uploadType))
  add(path_589184, "parent", newJString(parent))
  add(query_589185, "resourceVersion", newJString(resourceVersion))
  add(query_589185, "watch", newJBool(watch))
  add(query_589185, "key", newJString(key))
  add(query_589185, "$.xgafv", newJString(Xgafv))
  add(query_589185, "labelSelector", newJString(labelSelector))
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  add(query_589185, "fieldSelector", newJString(fieldSelector))
  add(query_589185, "limit", newJInt(limit))
  result = call_589183.call(path_589184, query_589185, nil, nil, nil)

var runNamespacesEventtypesList* = Call_RunNamespacesEventtypesList_589160(
    name: "runNamespacesEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/eventtypes",
    validator: validate_RunNamespacesEventtypesList_589161, base: "/",
    url: url_RunNamespacesEventtypesList_589162, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersCreate_589212 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesTriggersCreate_589214(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersCreate_589213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this trigger should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589215 = path.getOrDefault("parent")
  valid_589215 = validateParameter(valid_589215, JString, required = true,
                                 default = nil)
  if valid_589215 != nil:
    section.add "parent", valid_589215
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
  var valid_589216 = query.getOrDefault("upload_protocol")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "upload_protocol", valid_589216
  var valid_589217 = query.getOrDefault("fields")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "fields", valid_589217
  var valid_589218 = query.getOrDefault("quotaUser")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "quotaUser", valid_589218
  var valid_589219 = query.getOrDefault("alt")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = newJString("json"))
  if valid_589219 != nil:
    section.add "alt", valid_589219
  var valid_589220 = query.getOrDefault("oauth_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "oauth_token", valid_589220
  var valid_589221 = query.getOrDefault("callback")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "callback", valid_589221
  var valid_589222 = query.getOrDefault("access_token")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "access_token", valid_589222
  var valid_589223 = query.getOrDefault("uploadType")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "uploadType", valid_589223
  var valid_589224 = query.getOrDefault("key")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "key", valid_589224
  var valid_589225 = query.getOrDefault("$.xgafv")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = newJString("1"))
  if valid_589225 != nil:
    section.add "$.xgafv", valid_589225
  var valid_589226 = query.getOrDefault("prettyPrint")
  valid_589226 = validateParameter(valid_589226, JBool, required = false,
                                 default = newJBool(true))
  if valid_589226 != nil:
    section.add "prettyPrint", valid_589226
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

proc call*(call_589228: Call_RunNamespacesTriggersCreate_589212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_589228.validator(path, query, header, formData, body)
  let scheme = call_589228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589228.url(scheme.get, call_589228.host, call_589228.base,
                         call_589228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589228, url, valid)

proc call*(call_589229: Call_RunNamespacesTriggersCreate_589212; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runNamespacesTriggersCreate
  ## Creates a new trigger.
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
  ##         : The project ID or project number in which this trigger should
  ## be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589230 = newJObject()
  var query_589231 = newJObject()
  var body_589232 = newJObject()
  add(query_589231, "upload_protocol", newJString(uploadProtocol))
  add(query_589231, "fields", newJString(fields))
  add(query_589231, "quotaUser", newJString(quotaUser))
  add(query_589231, "alt", newJString(alt))
  add(query_589231, "oauth_token", newJString(oauthToken))
  add(query_589231, "callback", newJString(callback))
  add(query_589231, "access_token", newJString(accessToken))
  add(query_589231, "uploadType", newJString(uploadType))
  add(path_589230, "parent", newJString(parent))
  add(query_589231, "key", newJString(key))
  add(query_589231, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589232 = body
  add(query_589231, "prettyPrint", newJBool(prettyPrint))
  result = call_589229.call(path_589230, query_589231, nil, nil, body_589232)

var runNamespacesTriggersCreate* = Call_RunNamespacesTriggersCreate_589212(
    name: "runNamespacesTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersCreate_589213, base: "/",
    url: url_RunNamespacesTriggersCreate_589214, schemes: {Scheme.Https})
type
  Call_RunNamespacesTriggersList_589186 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesTriggersList_589188(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/eventing.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesTriggersList_589187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the triggers should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589189 = path.getOrDefault("parent")
  valid_589189 = validateParameter(valid_589189, JString, required = true,
                                 default = nil)
  if valid_589189 != nil:
    section.add "parent", valid_589189
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
  var valid_589190 = query.getOrDefault("upload_protocol")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "upload_protocol", valid_589190
  var valid_589191 = query.getOrDefault("fields")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "fields", valid_589191
  var valid_589192 = query.getOrDefault("quotaUser")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "quotaUser", valid_589192
  var valid_589193 = query.getOrDefault("includeUninitialized")
  valid_589193 = validateParameter(valid_589193, JBool, required = false, default = nil)
  if valid_589193 != nil:
    section.add "includeUninitialized", valid_589193
  var valid_589194 = query.getOrDefault("alt")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = newJString("json"))
  if valid_589194 != nil:
    section.add "alt", valid_589194
  var valid_589195 = query.getOrDefault("continue")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "continue", valid_589195
  var valid_589196 = query.getOrDefault("oauth_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "oauth_token", valid_589196
  var valid_589197 = query.getOrDefault("callback")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "callback", valid_589197
  var valid_589198 = query.getOrDefault("access_token")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "access_token", valid_589198
  var valid_589199 = query.getOrDefault("uploadType")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "uploadType", valid_589199
  var valid_589200 = query.getOrDefault("resourceVersion")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "resourceVersion", valid_589200
  var valid_589201 = query.getOrDefault("watch")
  valid_589201 = validateParameter(valid_589201, JBool, required = false, default = nil)
  if valid_589201 != nil:
    section.add "watch", valid_589201
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
  var valid_589204 = query.getOrDefault("labelSelector")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "labelSelector", valid_589204
  var valid_589205 = query.getOrDefault("prettyPrint")
  valid_589205 = validateParameter(valid_589205, JBool, required = false,
                                 default = newJBool(true))
  if valid_589205 != nil:
    section.add "prettyPrint", valid_589205
  var valid_589206 = query.getOrDefault("fieldSelector")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "fieldSelector", valid_589206
  var valid_589207 = query.getOrDefault("limit")
  valid_589207 = validateParameter(valid_589207, JInt, required = false, default = nil)
  if valid_589207 != nil:
    section.add "limit", valid_589207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589208: Call_RunNamespacesTriggersList_589186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_589208.validator(path, query, header, formData, body)
  let scheme = call_589208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589208.url(scheme.get, call_589208.host, call_589208.base,
                         call_589208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589208, url, valid)

proc call*(call_589209: Call_RunNamespacesTriggersList_589186; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesTriggersList
  ## Rpc to list triggers.
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
  ##         : The project ID or project number from which the triggers should
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
  var path_589210 = newJObject()
  var query_589211 = newJObject()
  add(query_589211, "upload_protocol", newJString(uploadProtocol))
  add(query_589211, "fields", newJString(fields))
  add(query_589211, "quotaUser", newJString(quotaUser))
  add(query_589211, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589211, "alt", newJString(alt))
  add(query_589211, "continue", newJString(`continue`))
  add(query_589211, "oauth_token", newJString(oauthToken))
  add(query_589211, "callback", newJString(callback))
  add(query_589211, "access_token", newJString(accessToken))
  add(query_589211, "uploadType", newJString(uploadType))
  add(path_589210, "parent", newJString(parent))
  add(query_589211, "resourceVersion", newJString(resourceVersion))
  add(query_589211, "watch", newJBool(watch))
  add(query_589211, "key", newJString(key))
  add(query_589211, "$.xgafv", newJString(Xgafv))
  add(query_589211, "labelSelector", newJString(labelSelector))
  add(query_589211, "prettyPrint", newJBool(prettyPrint))
  add(query_589211, "fieldSelector", newJString(fieldSelector))
  add(query_589211, "limit", newJInt(limit))
  result = call_589209.call(path_589210, query_589211, nil, nil, nil)

var runNamespacesTriggersList* = Call_RunNamespacesTriggersList_589186(
    name: "runNamespacesTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/eventing.knative.dev/v1alpha1/{parent}/triggers",
    validator: validate_RunNamespacesTriggersList_589187, base: "/",
    url: url_RunNamespacesTriggersList_589188, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesReplaceService_589252 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesServicesReplaceService_589254(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesReplaceService_589253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to replace a service.
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
  var valid_589255 = path.getOrDefault("name")
  valid_589255 = validateParameter(valid_589255, JString, required = true,
                                 default = nil)
  if valid_589255 != nil:
    section.add "name", valid_589255
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
  var valid_589258 = query.getOrDefault("quotaUser")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "quotaUser", valid_589258
  var valid_589259 = query.getOrDefault("alt")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = newJString("json"))
  if valid_589259 != nil:
    section.add "alt", valid_589259
  var valid_589260 = query.getOrDefault("oauth_token")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "oauth_token", valid_589260
  var valid_589261 = query.getOrDefault("callback")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "callback", valid_589261
  var valid_589262 = query.getOrDefault("access_token")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "access_token", valid_589262
  var valid_589263 = query.getOrDefault("uploadType")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "uploadType", valid_589263
  var valid_589264 = query.getOrDefault("key")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "key", valid_589264
  var valid_589265 = query.getOrDefault("$.xgafv")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = newJString("1"))
  if valid_589265 != nil:
    section.add "$.xgafv", valid_589265
  var valid_589266 = query.getOrDefault("prettyPrint")
  valid_589266 = validateParameter(valid_589266, JBool, required = false,
                                 default = newJBool(true))
  if valid_589266 != nil:
    section.add "prettyPrint", valid_589266
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

proc call*(call_589268: Call_RunNamespacesServicesReplaceService_589252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to replace a service.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_589268.validator(path, query, header, formData, body)
  let scheme = call_589268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589268.url(scheme.get, call_589268.host, call_589268.base,
                         call_589268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589268, url, valid)

proc call*(call_589269: Call_RunNamespacesServicesReplaceService_589252;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runNamespacesServicesReplaceService
  ## Rpc to replace a service.
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
  var path_589270 = newJObject()
  var query_589271 = newJObject()
  var body_589272 = newJObject()
  add(query_589271, "upload_protocol", newJString(uploadProtocol))
  add(query_589271, "fields", newJString(fields))
  add(query_589271, "quotaUser", newJString(quotaUser))
  add(path_589270, "name", newJString(name))
  add(query_589271, "alt", newJString(alt))
  add(query_589271, "oauth_token", newJString(oauthToken))
  add(query_589271, "callback", newJString(callback))
  add(query_589271, "access_token", newJString(accessToken))
  add(query_589271, "uploadType", newJString(uploadType))
  add(query_589271, "key", newJString(key))
  add(query_589271, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589272 = body
  add(query_589271, "prettyPrint", newJBool(prettyPrint))
  result = call_589269.call(path_589270, query_589271, nil, nil, body_589272)

var runNamespacesServicesReplaceService* = Call_RunNamespacesServicesReplaceService_589252(
    name: "runNamespacesServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesServicesReplaceService_589253, base: "/",
    url: url_RunNamespacesServicesReplaceService_589254, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesGet_589233 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesServicesGet_589235(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesGet_589234(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the service being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589236 = path.getOrDefault("name")
  valid_589236 = validateParameter(valid_589236, JString, required = true,
                                 default = nil)
  if valid_589236 != nil:
    section.add "name", valid_589236
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
  var valid_589237 = query.getOrDefault("upload_protocol")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "upload_protocol", valid_589237
  var valid_589238 = query.getOrDefault("fields")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "fields", valid_589238
  var valid_589239 = query.getOrDefault("quotaUser")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "quotaUser", valid_589239
  var valid_589240 = query.getOrDefault("alt")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = newJString("json"))
  if valid_589240 != nil:
    section.add "alt", valid_589240
  var valid_589241 = query.getOrDefault("oauth_token")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "oauth_token", valid_589241
  var valid_589242 = query.getOrDefault("callback")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "callback", valid_589242
  var valid_589243 = query.getOrDefault("access_token")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "access_token", valid_589243
  var valid_589244 = query.getOrDefault("uploadType")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "uploadType", valid_589244
  var valid_589245 = query.getOrDefault("key")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "key", valid_589245
  var valid_589246 = query.getOrDefault("$.xgafv")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = newJString("1"))
  if valid_589246 != nil:
    section.add "$.xgafv", valid_589246
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

proc call*(call_589248: Call_RunNamespacesServicesGet_589233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to get information about a service.
  ## 
  let valid = call_589248.validator(path, query, header, formData, body)
  let scheme = call_589248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589248.url(scheme.get, call_589248.host, call_589248.base,
                         call_589248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589248, url, valid)

proc call*(call_589249: Call_RunNamespacesServicesGet_589233; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runNamespacesServicesGet
  ## Rpc to get information about a service.
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
  var path_589250 = newJObject()
  var query_589251 = newJObject()
  add(query_589251, "upload_protocol", newJString(uploadProtocol))
  add(query_589251, "fields", newJString(fields))
  add(query_589251, "quotaUser", newJString(quotaUser))
  add(path_589250, "name", newJString(name))
  add(query_589251, "alt", newJString(alt))
  add(query_589251, "oauth_token", newJString(oauthToken))
  add(query_589251, "callback", newJString(callback))
  add(query_589251, "access_token", newJString(accessToken))
  add(query_589251, "uploadType", newJString(uploadType))
  add(query_589251, "key", newJString(key))
  add(query_589251, "$.xgafv", newJString(Xgafv))
  add(query_589251, "prettyPrint", newJBool(prettyPrint))
  result = call_589249.call(path_589250, query_589251, nil, nil, nil)

var runNamespacesServicesGet* = Call_RunNamespacesServicesGet_589233(
    name: "runNamespacesServicesGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesServicesGet_589234, base: "/",
    url: url_RunNamespacesServicesGet_589235, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesDelete_589273 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesServicesDelete_589275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesDelete_589274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a service.
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
  var valid_589276 = path.getOrDefault("name")
  valid_589276 = validateParameter(valid_589276, JString, required = true,
                                 default = nil)
  if valid_589276 != nil:
    section.add "name", valid_589276
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: JBool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
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
  var valid_589277 = query.getOrDefault("upload_protocol")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "upload_protocol", valid_589277
  var valid_589278 = query.getOrDefault("fields")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "fields", valid_589278
  var valid_589279 = query.getOrDefault("orphanDependents")
  valid_589279 = validateParameter(valid_589279, JBool, required = false, default = nil)
  if valid_589279 != nil:
    section.add "orphanDependents", valid_589279
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
  var valid_589286 = query.getOrDefault("kind")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "kind", valid_589286
  var valid_589287 = query.getOrDefault("key")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "key", valid_589287
  var valid_589288 = query.getOrDefault("$.xgafv")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = newJString("1"))
  if valid_589288 != nil:
    section.add "$.xgafv", valid_589288
  var valid_589289 = query.getOrDefault("prettyPrint")
  valid_589289 = validateParameter(valid_589289, JBool, required = false,
                                 default = newJBool(true))
  if valid_589289 != nil:
    section.add "prettyPrint", valid_589289
  var valid_589290 = query.getOrDefault("propagationPolicy")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "propagationPolicy", valid_589290
  var valid_589291 = query.getOrDefault("apiVersion")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "apiVersion", valid_589291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589292: Call_RunNamespacesServicesDelete_589273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
  ## 
  let valid = call_589292.validator(path, query, header, formData, body)
  let scheme = call_589292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589292.url(scheme.get, call_589292.host, call_589292.base,
                         call_589292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589292, url, valid)

proc call*(call_589293: Call_RunNamespacesServicesDelete_589273; name: string;
          uploadProtocol: string = ""; fields: string = "";
          orphanDependents: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runNamespacesServicesDelete
  ## Rpc to delete a service.
  ## This will cause the Service to stop serving traffic and will delete the
  ## child entities like Routes, Configurations and Revisions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: bool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
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
  var path_589294 = newJObject()
  var query_589295 = newJObject()
  add(query_589295, "upload_protocol", newJString(uploadProtocol))
  add(query_589295, "fields", newJString(fields))
  add(query_589295, "orphanDependents", newJBool(orphanDependents))
  add(query_589295, "quotaUser", newJString(quotaUser))
  add(path_589294, "name", newJString(name))
  add(query_589295, "alt", newJString(alt))
  add(query_589295, "oauth_token", newJString(oauthToken))
  add(query_589295, "callback", newJString(callback))
  add(query_589295, "access_token", newJString(accessToken))
  add(query_589295, "uploadType", newJString(uploadType))
  add(query_589295, "kind", newJString(kind))
  add(query_589295, "key", newJString(key))
  add(query_589295, "$.xgafv", newJString(Xgafv))
  add(query_589295, "prettyPrint", newJBool(prettyPrint))
  add(query_589295, "propagationPolicy", newJString(propagationPolicy))
  add(query_589295, "apiVersion", newJString(apiVersion))
  result = call_589293.call(path_589294, query_589295, nil, nil, nil)

var runNamespacesServicesDelete* = Call_RunNamespacesServicesDelete_589273(
    name: "runNamespacesServicesDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{name}",
    validator: validate_RunNamespacesServicesDelete_589274, base: "/",
    url: url_RunNamespacesServicesDelete_589275, schemes: {Scheme.Https})
type
  Call_RunNamespacesConfigurationsList_589296 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesConfigurationsList_589298(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesConfigurationsList_589297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589299 = path.getOrDefault("parent")
  valid_589299 = validateParameter(valid_589299, JString, required = true,
                                 default = nil)
  if valid_589299 != nil:
    section.add "parent", valid_589299
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
  var valid_589300 = query.getOrDefault("upload_protocol")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "upload_protocol", valid_589300
  var valid_589301 = query.getOrDefault("fields")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "fields", valid_589301
  var valid_589302 = query.getOrDefault("quotaUser")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "quotaUser", valid_589302
  var valid_589303 = query.getOrDefault("includeUninitialized")
  valid_589303 = validateParameter(valid_589303, JBool, required = false, default = nil)
  if valid_589303 != nil:
    section.add "includeUninitialized", valid_589303
  var valid_589304 = query.getOrDefault("alt")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("json"))
  if valid_589304 != nil:
    section.add "alt", valid_589304
  var valid_589305 = query.getOrDefault("continue")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "continue", valid_589305
  var valid_589306 = query.getOrDefault("oauth_token")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "oauth_token", valid_589306
  var valid_589307 = query.getOrDefault("callback")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "callback", valid_589307
  var valid_589308 = query.getOrDefault("access_token")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "access_token", valid_589308
  var valid_589309 = query.getOrDefault("uploadType")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "uploadType", valid_589309
  var valid_589310 = query.getOrDefault("resourceVersion")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "resourceVersion", valid_589310
  var valid_589311 = query.getOrDefault("watch")
  valid_589311 = validateParameter(valid_589311, JBool, required = false, default = nil)
  if valid_589311 != nil:
    section.add "watch", valid_589311
  var valid_589312 = query.getOrDefault("key")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "key", valid_589312
  var valid_589313 = query.getOrDefault("$.xgafv")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("1"))
  if valid_589313 != nil:
    section.add "$.xgafv", valid_589313
  var valid_589314 = query.getOrDefault("labelSelector")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "labelSelector", valid_589314
  var valid_589315 = query.getOrDefault("prettyPrint")
  valid_589315 = validateParameter(valid_589315, JBool, required = false,
                                 default = newJBool(true))
  if valid_589315 != nil:
    section.add "prettyPrint", valid_589315
  var valid_589316 = query.getOrDefault("fieldSelector")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "fieldSelector", valid_589316
  var valid_589317 = query.getOrDefault("limit")
  valid_589317 = validateParameter(valid_589317, JInt, required = false, default = nil)
  if valid_589317 != nil:
    section.add "limit", valid_589317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589318: Call_RunNamespacesConfigurationsList_589296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_589318.validator(path, query, header, formData, body)
  let scheme = call_589318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589318.url(scheme.get, call_589318.host, call_589318.base,
                         call_589318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589318, url, valid)

proc call*(call_589319: Call_RunNamespacesConfigurationsList_589296;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesConfigurationsList
  ## Rpc to list configurations.
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
  var path_589320 = newJObject()
  var query_589321 = newJObject()
  add(query_589321, "upload_protocol", newJString(uploadProtocol))
  add(query_589321, "fields", newJString(fields))
  add(query_589321, "quotaUser", newJString(quotaUser))
  add(query_589321, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589321, "alt", newJString(alt))
  add(query_589321, "continue", newJString(`continue`))
  add(query_589321, "oauth_token", newJString(oauthToken))
  add(query_589321, "callback", newJString(callback))
  add(query_589321, "access_token", newJString(accessToken))
  add(query_589321, "uploadType", newJString(uploadType))
  add(path_589320, "parent", newJString(parent))
  add(query_589321, "resourceVersion", newJString(resourceVersion))
  add(query_589321, "watch", newJBool(watch))
  add(query_589321, "key", newJString(key))
  add(query_589321, "$.xgafv", newJString(Xgafv))
  add(query_589321, "labelSelector", newJString(labelSelector))
  add(query_589321, "prettyPrint", newJBool(prettyPrint))
  add(query_589321, "fieldSelector", newJString(fieldSelector))
  add(query_589321, "limit", newJInt(limit))
  result = call_589319.call(path_589320, query_589321, nil, nil, nil)

var runNamespacesConfigurationsList* = Call_RunNamespacesConfigurationsList_589296(
    name: "runNamespacesConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/configurations",
    validator: validate_RunNamespacesConfigurationsList_589297, base: "/",
    url: url_RunNamespacesConfigurationsList_589298, schemes: {Scheme.Https})
type
  Call_RunNamespacesRevisionsList_589322 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesRevisionsList_589324(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesRevisionsList_589323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the revisions should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589325 = path.getOrDefault("parent")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "parent", valid_589325
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
  var valid_589326 = query.getOrDefault("upload_protocol")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "upload_protocol", valid_589326
  var valid_589327 = query.getOrDefault("fields")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "fields", valid_589327
  var valid_589328 = query.getOrDefault("quotaUser")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "quotaUser", valid_589328
  var valid_589329 = query.getOrDefault("includeUninitialized")
  valid_589329 = validateParameter(valid_589329, JBool, required = false, default = nil)
  if valid_589329 != nil:
    section.add "includeUninitialized", valid_589329
  var valid_589330 = query.getOrDefault("alt")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = newJString("json"))
  if valid_589330 != nil:
    section.add "alt", valid_589330
  var valid_589331 = query.getOrDefault("continue")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "continue", valid_589331
  var valid_589332 = query.getOrDefault("oauth_token")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "oauth_token", valid_589332
  var valid_589333 = query.getOrDefault("callback")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "callback", valid_589333
  var valid_589334 = query.getOrDefault("access_token")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "access_token", valid_589334
  var valid_589335 = query.getOrDefault("uploadType")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "uploadType", valid_589335
  var valid_589336 = query.getOrDefault("resourceVersion")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "resourceVersion", valid_589336
  var valid_589337 = query.getOrDefault("watch")
  valid_589337 = validateParameter(valid_589337, JBool, required = false, default = nil)
  if valid_589337 != nil:
    section.add "watch", valid_589337
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
  var valid_589340 = query.getOrDefault("labelSelector")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "labelSelector", valid_589340
  var valid_589341 = query.getOrDefault("prettyPrint")
  valid_589341 = validateParameter(valid_589341, JBool, required = false,
                                 default = newJBool(true))
  if valid_589341 != nil:
    section.add "prettyPrint", valid_589341
  var valid_589342 = query.getOrDefault("fieldSelector")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "fieldSelector", valid_589342
  var valid_589343 = query.getOrDefault("limit")
  valid_589343 = validateParameter(valid_589343, JInt, required = false, default = nil)
  if valid_589343 != nil:
    section.add "limit", valid_589343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589344: Call_RunNamespacesRevisionsList_589322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_589344.validator(path, query, header, formData, body)
  let scheme = call_589344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589344.url(scheme.get, call_589344.host, call_589344.base,
                         call_589344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589344, url, valid)

proc call*(call_589345: Call_RunNamespacesRevisionsList_589322; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesRevisionsList
  ## Rpc to list revisions.
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
  var path_589346 = newJObject()
  var query_589347 = newJObject()
  add(query_589347, "upload_protocol", newJString(uploadProtocol))
  add(query_589347, "fields", newJString(fields))
  add(query_589347, "quotaUser", newJString(quotaUser))
  add(query_589347, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589347, "alt", newJString(alt))
  add(query_589347, "continue", newJString(`continue`))
  add(query_589347, "oauth_token", newJString(oauthToken))
  add(query_589347, "callback", newJString(callback))
  add(query_589347, "access_token", newJString(accessToken))
  add(query_589347, "uploadType", newJString(uploadType))
  add(path_589346, "parent", newJString(parent))
  add(query_589347, "resourceVersion", newJString(resourceVersion))
  add(query_589347, "watch", newJBool(watch))
  add(query_589347, "key", newJString(key))
  add(query_589347, "$.xgafv", newJString(Xgafv))
  add(query_589347, "labelSelector", newJString(labelSelector))
  add(query_589347, "prettyPrint", newJBool(prettyPrint))
  add(query_589347, "fieldSelector", newJString(fieldSelector))
  add(query_589347, "limit", newJInt(limit))
  result = call_589345.call(path_589346, query_589347, nil, nil, nil)

var runNamespacesRevisionsList* = Call_RunNamespacesRevisionsList_589322(
    name: "runNamespacesRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/revisions",
    validator: validate_RunNamespacesRevisionsList_589323, base: "/",
    url: url_RunNamespacesRevisionsList_589324, schemes: {Scheme.Https})
type
  Call_RunNamespacesRoutesList_589348 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesRoutesList_589350(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesRoutesList_589349(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the routes should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589351 = path.getOrDefault("parent")
  valid_589351 = validateParameter(valid_589351, JString, required = true,
                                 default = nil)
  if valid_589351 != nil:
    section.add "parent", valid_589351
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
  var valid_589352 = query.getOrDefault("upload_protocol")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "upload_protocol", valid_589352
  var valid_589353 = query.getOrDefault("fields")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "fields", valid_589353
  var valid_589354 = query.getOrDefault("quotaUser")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "quotaUser", valid_589354
  var valid_589355 = query.getOrDefault("includeUninitialized")
  valid_589355 = validateParameter(valid_589355, JBool, required = false, default = nil)
  if valid_589355 != nil:
    section.add "includeUninitialized", valid_589355
  var valid_589356 = query.getOrDefault("alt")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = newJString("json"))
  if valid_589356 != nil:
    section.add "alt", valid_589356
  var valid_589357 = query.getOrDefault("continue")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "continue", valid_589357
  var valid_589358 = query.getOrDefault("oauth_token")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "oauth_token", valid_589358
  var valid_589359 = query.getOrDefault("callback")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "callback", valid_589359
  var valid_589360 = query.getOrDefault("access_token")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "access_token", valid_589360
  var valid_589361 = query.getOrDefault("uploadType")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "uploadType", valid_589361
  var valid_589362 = query.getOrDefault("resourceVersion")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "resourceVersion", valid_589362
  var valid_589363 = query.getOrDefault("watch")
  valid_589363 = validateParameter(valid_589363, JBool, required = false, default = nil)
  if valid_589363 != nil:
    section.add "watch", valid_589363
  var valid_589364 = query.getOrDefault("key")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "key", valid_589364
  var valid_589365 = query.getOrDefault("$.xgafv")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = newJString("1"))
  if valid_589365 != nil:
    section.add "$.xgafv", valid_589365
  var valid_589366 = query.getOrDefault("labelSelector")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "labelSelector", valid_589366
  var valid_589367 = query.getOrDefault("prettyPrint")
  valid_589367 = validateParameter(valid_589367, JBool, required = false,
                                 default = newJBool(true))
  if valid_589367 != nil:
    section.add "prettyPrint", valid_589367
  var valid_589368 = query.getOrDefault("fieldSelector")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "fieldSelector", valid_589368
  var valid_589369 = query.getOrDefault("limit")
  valid_589369 = validateParameter(valid_589369, JInt, required = false, default = nil)
  if valid_589369 != nil:
    section.add "limit", valid_589369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589370: Call_RunNamespacesRoutesList_589348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_589370.validator(path, query, header, formData, body)
  let scheme = call_589370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589370.url(scheme.get, call_589370.host, call_589370.base,
                         call_589370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589370, url, valid)

proc call*(call_589371: Call_RunNamespacesRoutesList_589348; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesRoutesList
  ## Rpc to list routes.
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
  var path_589372 = newJObject()
  var query_589373 = newJObject()
  add(query_589373, "upload_protocol", newJString(uploadProtocol))
  add(query_589373, "fields", newJString(fields))
  add(query_589373, "quotaUser", newJString(quotaUser))
  add(query_589373, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589373, "alt", newJString(alt))
  add(query_589373, "continue", newJString(`continue`))
  add(query_589373, "oauth_token", newJString(oauthToken))
  add(query_589373, "callback", newJString(callback))
  add(query_589373, "access_token", newJString(accessToken))
  add(query_589373, "uploadType", newJString(uploadType))
  add(path_589372, "parent", newJString(parent))
  add(query_589373, "resourceVersion", newJString(resourceVersion))
  add(query_589373, "watch", newJBool(watch))
  add(query_589373, "key", newJString(key))
  add(query_589373, "$.xgafv", newJString(Xgafv))
  add(query_589373, "labelSelector", newJString(labelSelector))
  add(query_589373, "prettyPrint", newJBool(prettyPrint))
  add(query_589373, "fieldSelector", newJString(fieldSelector))
  add(query_589373, "limit", newJInt(limit))
  result = call_589371.call(path_589372, query_589373, nil, nil, nil)

var runNamespacesRoutesList* = Call_RunNamespacesRoutesList_589348(
    name: "runNamespacesRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/routes",
    validator: validate_RunNamespacesRoutesList_589349, base: "/",
    url: url_RunNamespacesRoutesList_589350, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesCreate_589400 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesServicesCreate_589402(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesCreate_589401(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this service should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589403 = path.getOrDefault("parent")
  valid_589403 = validateParameter(valid_589403, JString, required = true,
                                 default = nil)
  if valid_589403 != nil:
    section.add "parent", valid_589403
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

proc call*(call_589416: Call_RunNamespacesServicesCreate_589400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_589416.validator(path, query, header, formData, body)
  let scheme = call_589416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589416.url(scheme.get, call_589416.host, call_589416.base,
                         call_589416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589416, url, valid)

proc call*(call_589417: Call_RunNamespacesServicesCreate_589400; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## runNamespacesServicesCreate
  ## Rpc to create a service.
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
  var path_589418 = newJObject()
  var query_589419 = newJObject()
  var body_589420 = newJObject()
  add(query_589419, "upload_protocol", newJString(uploadProtocol))
  add(query_589419, "fields", newJString(fields))
  add(query_589419, "quotaUser", newJString(quotaUser))
  add(query_589419, "alt", newJString(alt))
  add(query_589419, "oauth_token", newJString(oauthToken))
  add(query_589419, "callback", newJString(callback))
  add(query_589419, "access_token", newJString(accessToken))
  add(query_589419, "uploadType", newJString(uploadType))
  add(path_589418, "parent", newJString(parent))
  add(query_589419, "key", newJString(key))
  add(query_589419, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589420 = body
  add(query_589419, "prettyPrint", newJBool(prettyPrint))
  result = call_589417.call(path_589418, query_589419, nil, nil, body_589420)

var runNamespacesServicesCreate* = Call_RunNamespacesServicesCreate_589400(
    name: "runNamespacesServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesCreate_589401, base: "/",
    url: url_RunNamespacesServicesCreate_589402, schemes: {Scheme.Https})
type
  Call_RunNamespacesServicesList_589374 = ref object of OpenApiRestCall_588450
proc url_RunNamespacesServicesList_589376(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/serving.knative.dev/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunNamespacesServicesList_589375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the services should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589377 = path.getOrDefault("parent")
  valid_589377 = validateParameter(valid_589377, JString, required = true,
                                 default = nil)
  if valid_589377 != nil:
    section.add "parent", valid_589377
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
  var valid_589378 = query.getOrDefault("upload_protocol")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "upload_protocol", valid_589378
  var valid_589379 = query.getOrDefault("fields")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "fields", valid_589379
  var valid_589380 = query.getOrDefault("quotaUser")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "quotaUser", valid_589380
  var valid_589381 = query.getOrDefault("includeUninitialized")
  valid_589381 = validateParameter(valid_589381, JBool, required = false, default = nil)
  if valid_589381 != nil:
    section.add "includeUninitialized", valid_589381
  var valid_589382 = query.getOrDefault("alt")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = newJString("json"))
  if valid_589382 != nil:
    section.add "alt", valid_589382
  var valid_589383 = query.getOrDefault("continue")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "continue", valid_589383
  var valid_589384 = query.getOrDefault("oauth_token")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "oauth_token", valid_589384
  var valid_589385 = query.getOrDefault("callback")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "callback", valid_589385
  var valid_589386 = query.getOrDefault("access_token")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "access_token", valid_589386
  var valid_589387 = query.getOrDefault("uploadType")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "uploadType", valid_589387
  var valid_589388 = query.getOrDefault("resourceVersion")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "resourceVersion", valid_589388
  var valid_589389 = query.getOrDefault("watch")
  valid_589389 = validateParameter(valid_589389, JBool, required = false, default = nil)
  if valid_589389 != nil:
    section.add "watch", valid_589389
  var valid_589390 = query.getOrDefault("key")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "key", valid_589390
  var valid_589391 = query.getOrDefault("$.xgafv")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = newJString("1"))
  if valid_589391 != nil:
    section.add "$.xgafv", valid_589391
  var valid_589392 = query.getOrDefault("labelSelector")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "labelSelector", valid_589392
  var valid_589393 = query.getOrDefault("prettyPrint")
  valid_589393 = validateParameter(valid_589393, JBool, required = false,
                                 default = newJBool(true))
  if valid_589393 != nil:
    section.add "prettyPrint", valid_589393
  var valid_589394 = query.getOrDefault("fieldSelector")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "fieldSelector", valid_589394
  var valid_589395 = query.getOrDefault("limit")
  valid_589395 = validateParameter(valid_589395, JInt, required = false, default = nil)
  if valid_589395 != nil:
    section.add "limit", valid_589395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589396: Call_RunNamespacesServicesList_589374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_589396.validator(path, query, header, formData, body)
  let scheme = call_589396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589396.url(scheme.get, call_589396.host, call_589396.base,
                         call_589396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589396, url, valid)

proc call*(call_589397: Call_RunNamespacesServicesList_589374; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runNamespacesServicesList
  ## Rpc to list services.
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
  var path_589398 = newJObject()
  var query_589399 = newJObject()
  add(query_589399, "upload_protocol", newJString(uploadProtocol))
  add(query_589399, "fields", newJString(fields))
  add(query_589399, "quotaUser", newJString(quotaUser))
  add(query_589399, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589399, "alt", newJString(alt))
  add(query_589399, "continue", newJString(`continue`))
  add(query_589399, "oauth_token", newJString(oauthToken))
  add(query_589399, "callback", newJString(callback))
  add(query_589399, "access_token", newJString(accessToken))
  add(query_589399, "uploadType", newJString(uploadType))
  add(path_589398, "parent", newJString(parent))
  add(query_589399, "resourceVersion", newJString(resourceVersion))
  add(query_589399, "watch", newJBool(watch))
  add(query_589399, "key", newJString(key))
  add(query_589399, "$.xgafv", newJString(Xgafv))
  add(query_589399, "labelSelector", newJString(labelSelector))
  add(query_589399, "prettyPrint", newJBool(prettyPrint))
  add(query_589399, "fieldSelector", newJString(fieldSelector))
  add(query_589399, "limit", newJInt(limit))
  result = call_589397.call(path_589398, query_589399, nil, nil, nil)

var runNamespacesServicesList* = Call_RunNamespacesServicesList_589374(
    name: "runNamespacesServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/serving.knative.dev/v1alpha1/{parent}/services",
    validator: validate_RunNamespacesServicesList_589375, base: "/",
    url: url_RunNamespacesServicesList_589376, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesReplaceService_589440 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesReplaceService_589442(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesReplaceService_589441(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to replace a service.
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
  var valid_589443 = path.getOrDefault("name")
  valid_589443 = validateParameter(valid_589443, JString, required = true,
                                 default = nil)
  if valid_589443 != nil:
    section.add "name", valid_589443
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
  var valid_589444 = query.getOrDefault("upload_protocol")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "upload_protocol", valid_589444
  var valid_589445 = query.getOrDefault("fields")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "fields", valid_589445
  var valid_589446 = query.getOrDefault("quotaUser")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "quotaUser", valid_589446
  var valid_589447 = query.getOrDefault("alt")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = newJString("json"))
  if valid_589447 != nil:
    section.add "alt", valid_589447
  var valid_589448 = query.getOrDefault("oauth_token")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = nil)
  if valid_589448 != nil:
    section.add "oauth_token", valid_589448
  var valid_589449 = query.getOrDefault("callback")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "callback", valid_589449
  var valid_589450 = query.getOrDefault("access_token")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "access_token", valid_589450
  var valid_589451 = query.getOrDefault("uploadType")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "uploadType", valid_589451
  var valid_589452 = query.getOrDefault("key")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "key", valid_589452
  var valid_589453 = query.getOrDefault("$.xgafv")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = newJString("1"))
  if valid_589453 != nil:
    section.add "$.xgafv", valid_589453
  var valid_589454 = query.getOrDefault("prettyPrint")
  valid_589454 = validateParameter(valid_589454, JBool, required = false,
                                 default = newJBool(true))
  if valid_589454 != nil:
    section.add "prettyPrint", valid_589454
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

proc call*(call_589456: Call_RunProjectsLocationsServicesReplaceService_589440;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to replace a service.
  ## 
  ## Only the spec and metadata labels and annotations are modifiable. After
  ## the Update request, Cloud Run will work to make the 'status'
  ## match the requested 'spec'.
  ## 
  ## May provide metadata.resourceVersion to enforce update from last read for
  ## optimistic concurrency control.
  ## 
  let valid = call_589456.validator(path, query, header, formData, body)
  let scheme = call_589456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589456.url(scheme.get, call_589456.host, call_589456.base,
                         call_589456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589456, url, valid)

proc call*(call_589457: Call_RunProjectsLocationsServicesReplaceService_589440;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesReplaceService
  ## Rpc to replace a service.
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
  var path_589458 = newJObject()
  var query_589459 = newJObject()
  var body_589460 = newJObject()
  add(query_589459, "upload_protocol", newJString(uploadProtocol))
  add(query_589459, "fields", newJString(fields))
  add(query_589459, "quotaUser", newJString(quotaUser))
  add(path_589458, "name", newJString(name))
  add(query_589459, "alt", newJString(alt))
  add(query_589459, "oauth_token", newJString(oauthToken))
  add(query_589459, "callback", newJString(callback))
  add(query_589459, "access_token", newJString(accessToken))
  add(query_589459, "uploadType", newJString(uploadType))
  add(query_589459, "key", newJString(key))
  add(query_589459, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589460 = body
  add(query_589459, "prettyPrint", newJBool(prettyPrint))
  result = call_589457.call(path_589458, query_589459, nil, nil, body_589460)

var runProjectsLocationsServicesReplaceService* = Call_RunProjectsLocationsServicesReplaceService_589440(
    name: "runProjectsLocationsServicesReplaceService", meth: HttpMethod.HttpPut,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsServicesReplaceService_589441,
    base: "/", url: url_RunProjectsLocationsServicesReplaceService_589442,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsGet_589421 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsDomainmappingsGet_589423(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsGet_589422(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being retrieved. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589424 = path.getOrDefault("name")
  valid_589424 = validateParameter(valid_589424, JString, required = true,
                                 default = nil)
  if valid_589424 != nil:
    section.add "name", valid_589424
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
  if body != nil:
    result.add "body", body

proc call*(call_589436: Call_RunProjectsLocationsDomainmappingsGet_589421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to get information about a domain mapping.
  ## 
  let valid = call_589436.validator(path, query, header, formData, body)
  let scheme = call_589436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589436.url(scheme.get, call_589436.host, call_589436.base,
                         call_589436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589436, url, valid)

proc call*(call_589437: Call_RunProjectsLocationsDomainmappingsGet_589421;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsGet
  ## Rpc to get information about a domain mapping.
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
  var path_589438 = newJObject()
  var query_589439 = newJObject()
  add(query_589439, "upload_protocol", newJString(uploadProtocol))
  add(query_589439, "fields", newJString(fields))
  add(query_589439, "quotaUser", newJString(quotaUser))
  add(path_589438, "name", newJString(name))
  add(query_589439, "alt", newJString(alt))
  add(query_589439, "oauth_token", newJString(oauthToken))
  add(query_589439, "callback", newJString(callback))
  add(query_589439, "access_token", newJString(accessToken))
  add(query_589439, "uploadType", newJString(uploadType))
  add(query_589439, "key", newJString(key))
  add(query_589439, "$.xgafv", newJString(Xgafv))
  add(query_589439, "prettyPrint", newJBool(prettyPrint))
  result = call_589437.call(path_589438, query_589439, nil, nil, nil)

var runProjectsLocationsDomainmappingsGet* = Call_RunProjectsLocationsDomainmappingsGet_589421(
    name: "runProjectsLocationsDomainmappingsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsGet_589422, base: "/",
    url: url_RunProjectsLocationsDomainmappingsGet_589423, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsDelete_589461 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsDomainmappingsDelete_589463(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsDelete_589462(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to delete a domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the domain mapping being deleted. If needed, replace
  ## {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589464 = path.getOrDefault("name")
  valid_589464 = validateParameter(valid_589464, JString, required = true,
                                 default = nil)
  if valid_589464 != nil:
    section.add "name", valid_589464
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: JBool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
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
  var valid_589465 = query.getOrDefault("upload_protocol")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "upload_protocol", valid_589465
  var valid_589466 = query.getOrDefault("fields")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "fields", valid_589466
  var valid_589467 = query.getOrDefault("orphanDependents")
  valid_589467 = validateParameter(valid_589467, JBool, required = false, default = nil)
  if valid_589467 != nil:
    section.add "orphanDependents", valid_589467
  var valid_589468 = query.getOrDefault("quotaUser")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "quotaUser", valid_589468
  var valid_589469 = query.getOrDefault("alt")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = newJString("json"))
  if valid_589469 != nil:
    section.add "alt", valid_589469
  var valid_589470 = query.getOrDefault("oauth_token")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "oauth_token", valid_589470
  var valid_589471 = query.getOrDefault("callback")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "callback", valid_589471
  var valid_589472 = query.getOrDefault("access_token")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "access_token", valid_589472
  var valid_589473 = query.getOrDefault("uploadType")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "uploadType", valid_589473
  var valid_589474 = query.getOrDefault("kind")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "kind", valid_589474
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
  var valid_589478 = query.getOrDefault("propagationPolicy")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "propagationPolicy", valid_589478
  var valid_589479 = query.getOrDefault("apiVersion")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "apiVersion", valid_589479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589480: Call_RunProjectsLocationsDomainmappingsDelete_589461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to delete a domain mapping.
  ## 
  let valid = call_589480.validator(path, query, header, formData, body)
  let scheme = call_589480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589480.url(scheme.get, call_589480.host, call_589480.base,
                         call_589480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589480, url, valid)

proc call*(call_589481: Call_RunProjectsLocationsDomainmappingsDelete_589461;
          name: string; uploadProtocol: string = ""; fields: string = "";
          orphanDependents: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; kind: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; propagationPolicy: string = "";
          apiVersion: string = ""): Recallable =
  ## runProjectsLocationsDomainmappingsDelete
  ## Rpc to delete a domain mapping.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   orphanDependents: bool
  ##                   : Deprecated.
  ## Specifies the cascade behavior on delete.
  ## Cloud Run only supports cascading behavior, so this must be false.
  ## This attribute is deprecated, and is now replaced with PropagationPolicy
  ## See https://github.com/kubernetes/kubernetes/issues/46659 for more info.
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
  var path_589482 = newJObject()
  var query_589483 = newJObject()
  add(query_589483, "upload_protocol", newJString(uploadProtocol))
  add(query_589483, "fields", newJString(fields))
  add(query_589483, "orphanDependents", newJBool(orphanDependents))
  add(query_589483, "quotaUser", newJString(quotaUser))
  add(path_589482, "name", newJString(name))
  add(query_589483, "alt", newJString(alt))
  add(query_589483, "oauth_token", newJString(oauthToken))
  add(query_589483, "callback", newJString(callback))
  add(query_589483, "access_token", newJString(accessToken))
  add(query_589483, "uploadType", newJString(uploadType))
  add(query_589483, "kind", newJString(kind))
  add(query_589483, "key", newJString(key))
  add(query_589483, "$.xgafv", newJString(Xgafv))
  add(query_589483, "prettyPrint", newJBool(prettyPrint))
  add(query_589483, "propagationPolicy", newJString(propagationPolicy))
  add(query_589483, "apiVersion", newJString(apiVersion))
  result = call_589481.call(path_589482, query_589483, nil, nil, nil)

var runProjectsLocationsDomainmappingsDelete* = Call_RunProjectsLocationsDomainmappingsDelete_589461(
    name: "runProjectsLocationsDomainmappingsDelete", meth: HttpMethod.HttpDelete,
    host: "run.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_RunProjectsLocationsDomainmappingsDelete_589462,
    base: "/", url: url_RunProjectsLocationsDomainmappingsDelete_589463,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsList_589484 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsList_589486(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsList_589485(path: JsonNode; query: JsonNode;
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
  var valid_589487 = path.getOrDefault("name")
  valid_589487 = validateParameter(valid_589487, JString, required = true,
                                 default = nil)
  if valid_589487 != nil:
    section.add "name", valid_589487
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
  var valid_589490 = query.getOrDefault("pageToken")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "pageToken", valid_589490
  var valid_589491 = query.getOrDefault("quotaUser")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "quotaUser", valid_589491
  var valid_589492 = query.getOrDefault("alt")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = newJString("json"))
  if valid_589492 != nil:
    section.add "alt", valid_589492
  var valid_589493 = query.getOrDefault("oauth_token")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "oauth_token", valid_589493
  var valid_589494 = query.getOrDefault("callback")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "callback", valid_589494
  var valid_589495 = query.getOrDefault("access_token")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "access_token", valid_589495
  var valid_589496 = query.getOrDefault("uploadType")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "uploadType", valid_589496
  var valid_589497 = query.getOrDefault("key")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "key", valid_589497
  var valid_589498 = query.getOrDefault("$.xgafv")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = newJString("1"))
  if valid_589498 != nil:
    section.add "$.xgafv", valid_589498
  var valid_589499 = query.getOrDefault("pageSize")
  valid_589499 = validateParameter(valid_589499, JInt, required = false, default = nil)
  if valid_589499 != nil:
    section.add "pageSize", valid_589499
  var valid_589500 = query.getOrDefault("prettyPrint")
  valid_589500 = validateParameter(valid_589500, JBool, required = false,
                                 default = newJBool(true))
  if valid_589500 != nil:
    section.add "prettyPrint", valid_589500
  var valid_589501 = query.getOrDefault("filter")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "filter", valid_589501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589502: Call_RunProjectsLocationsList_589484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589502.validator(path, query, header, formData, body)
  let scheme = call_589502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589502.url(scheme.get, call_589502.host, call_589502.base,
                         call_589502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589502, url, valid)

proc call*(call_589503: Call_RunProjectsLocationsList_589484; name: string;
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
  var path_589504 = newJObject()
  var query_589505 = newJObject()
  add(query_589505, "upload_protocol", newJString(uploadProtocol))
  add(query_589505, "fields", newJString(fields))
  add(query_589505, "pageToken", newJString(pageToken))
  add(query_589505, "quotaUser", newJString(quotaUser))
  add(path_589504, "name", newJString(name))
  add(query_589505, "alt", newJString(alt))
  add(query_589505, "oauth_token", newJString(oauthToken))
  add(query_589505, "callback", newJString(callback))
  add(query_589505, "access_token", newJString(accessToken))
  add(query_589505, "uploadType", newJString(uploadType))
  add(query_589505, "key", newJString(key))
  add(query_589505, "$.xgafv", newJString(Xgafv))
  add(query_589505, "pageSize", newJInt(pageSize))
  add(query_589505, "prettyPrint", newJBool(prettyPrint))
  add(query_589505, "filter", newJString(filter))
  result = call_589503.call(path_589504, query_589505, nil, nil, nil)

var runProjectsLocationsList* = Call_RunProjectsLocationsList_589484(
    name: "runProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{name}/locations",
    validator: validate_RunProjectsLocationsList_589485, base: "/",
    url: url_RunProjectsLocationsList_589486, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsAuthorizeddomainsList_589506 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsAuthorizeddomainsList_589508(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/authorizeddomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsAuthorizeddomainsList_589507(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## RPC to list authorized domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the parent Application resource. Example: `apps/myapp`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589509 = path.getOrDefault("parent")
  valid_589509 = validateParameter(valid_589509, JString, required = true,
                                 default = nil)
  if valid_589509 != nil:
    section.add "parent", valid_589509
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
  var valid_589510 = query.getOrDefault("upload_protocol")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "upload_protocol", valid_589510
  var valid_589511 = query.getOrDefault("fields")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "fields", valid_589511
  var valid_589512 = query.getOrDefault("pageToken")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "pageToken", valid_589512
  var valid_589513 = query.getOrDefault("quotaUser")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "quotaUser", valid_589513
  var valid_589514 = query.getOrDefault("alt")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = newJString("json"))
  if valid_589514 != nil:
    section.add "alt", valid_589514
  var valid_589515 = query.getOrDefault("oauth_token")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "oauth_token", valid_589515
  var valid_589516 = query.getOrDefault("callback")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "callback", valid_589516
  var valid_589517 = query.getOrDefault("access_token")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "access_token", valid_589517
  var valid_589518 = query.getOrDefault("uploadType")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "uploadType", valid_589518
  var valid_589519 = query.getOrDefault("key")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "key", valid_589519
  var valid_589520 = query.getOrDefault("$.xgafv")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = newJString("1"))
  if valid_589520 != nil:
    section.add "$.xgafv", valid_589520
  var valid_589521 = query.getOrDefault("pageSize")
  valid_589521 = validateParameter(valid_589521, JInt, required = false, default = nil)
  if valid_589521 != nil:
    section.add "pageSize", valid_589521
  var valid_589522 = query.getOrDefault("prettyPrint")
  valid_589522 = validateParameter(valid_589522, JBool, required = false,
                                 default = newJBool(true))
  if valid_589522 != nil:
    section.add "prettyPrint", valid_589522
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589523: Call_RunProjectsLocationsAuthorizeddomainsList_589506;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## RPC to list authorized domains.
  ## 
  let valid = call_589523.validator(path, query, header, formData, body)
  let scheme = call_589523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589523.url(scheme.get, call_589523.host, call_589523.base,
                         call_589523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589523, url, valid)

proc call*(call_589524: Call_RunProjectsLocationsAuthorizeddomainsList_589506;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsAuthorizeddomainsList
  ## RPC to list authorized domains.
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
  var path_589525 = newJObject()
  var query_589526 = newJObject()
  add(query_589526, "upload_protocol", newJString(uploadProtocol))
  add(query_589526, "fields", newJString(fields))
  add(query_589526, "pageToken", newJString(pageToken))
  add(query_589526, "quotaUser", newJString(quotaUser))
  add(query_589526, "alt", newJString(alt))
  add(query_589526, "oauth_token", newJString(oauthToken))
  add(query_589526, "callback", newJString(callback))
  add(query_589526, "access_token", newJString(accessToken))
  add(query_589526, "uploadType", newJString(uploadType))
  add(path_589525, "parent", newJString(parent))
  add(query_589526, "key", newJString(key))
  add(query_589526, "$.xgafv", newJString(Xgafv))
  add(query_589526, "pageSize", newJInt(pageSize))
  add(query_589526, "prettyPrint", newJBool(prettyPrint))
  result = call_589524.call(path_589525, query_589526, nil, nil, nil)

var runProjectsLocationsAuthorizeddomainsList* = Call_RunProjectsLocationsAuthorizeddomainsList_589506(
    name: "runProjectsLocationsAuthorizeddomainsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/authorizeddomains",
    validator: validate_RunProjectsLocationsAuthorizeddomainsList_589507,
    base: "/", url: url_RunProjectsLocationsAuthorizeddomainsList_589508,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsConfigurationsList_589527 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsConfigurationsList_589529(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsConfigurationsList_589528(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the configurations should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589530 = path.getOrDefault("parent")
  valid_589530 = validateParameter(valid_589530, JString, required = true,
                                 default = nil)
  if valid_589530 != nil:
    section.add "parent", valid_589530
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
  var valid_589531 = query.getOrDefault("upload_protocol")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "upload_protocol", valid_589531
  var valid_589532 = query.getOrDefault("fields")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = nil)
  if valid_589532 != nil:
    section.add "fields", valid_589532
  var valid_589533 = query.getOrDefault("quotaUser")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "quotaUser", valid_589533
  var valid_589534 = query.getOrDefault("includeUninitialized")
  valid_589534 = validateParameter(valid_589534, JBool, required = false, default = nil)
  if valid_589534 != nil:
    section.add "includeUninitialized", valid_589534
  var valid_589535 = query.getOrDefault("alt")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = newJString("json"))
  if valid_589535 != nil:
    section.add "alt", valid_589535
  var valid_589536 = query.getOrDefault("continue")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "continue", valid_589536
  var valid_589537 = query.getOrDefault("oauth_token")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "oauth_token", valid_589537
  var valid_589538 = query.getOrDefault("callback")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "callback", valid_589538
  var valid_589539 = query.getOrDefault("access_token")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "access_token", valid_589539
  var valid_589540 = query.getOrDefault("uploadType")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "uploadType", valid_589540
  var valid_589541 = query.getOrDefault("resourceVersion")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "resourceVersion", valid_589541
  var valid_589542 = query.getOrDefault("watch")
  valid_589542 = validateParameter(valid_589542, JBool, required = false, default = nil)
  if valid_589542 != nil:
    section.add "watch", valid_589542
  var valid_589543 = query.getOrDefault("key")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "key", valid_589543
  var valid_589544 = query.getOrDefault("$.xgafv")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = newJString("1"))
  if valid_589544 != nil:
    section.add "$.xgafv", valid_589544
  var valid_589545 = query.getOrDefault("labelSelector")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "labelSelector", valid_589545
  var valid_589546 = query.getOrDefault("prettyPrint")
  valid_589546 = validateParameter(valid_589546, JBool, required = false,
                                 default = newJBool(true))
  if valid_589546 != nil:
    section.add "prettyPrint", valid_589546
  var valid_589547 = query.getOrDefault("fieldSelector")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "fieldSelector", valid_589547
  var valid_589548 = query.getOrDefault("limit")
  valid_589548 = validateParameter(valid_589548, JInt, required = false, default = nil)
  if valid_589548 != nil:
    section.add "limit", valid_589548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589549: Call_RunProjectsLocationsConfigurationsList_589527;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list configurations.
  ## 
  let valid = call_589549.validator(path, query, header, formData, body)
  let scheme = call_589549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589549.url(scheme.get, call_589549.host, call_589549.base,
                         call_589549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589549, url, valid)

proc call*(call_589550: Call_RunProjectsLocationsConfigurationsList_589527;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsConfigurationsList
  ## Rpc to list configurations.
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
  var path_589551 = newJObject()
  var query_589552 = newJObject()
  add(query_589552, "upload_protocol", newJString(uploadProtocol))
  add(query_589552, "fields", newJString(fields))
  add(query_589552, "quotaUser", newJString(quotaUser))
  add(query_589552, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589552, "alt", newJString(alt))
  add(query_589552, "continue", newJString(`continue`))
  add(query_589552, "oauth_token", newJString(oauthToken))
  add(query_589552, "callback", newJString(callback))
  add(query_589552, "access_token", newJString(accessToken))
  add(query_589552, "uploadType", newJString(uploadType))
  add(path_589551, "parent", newJString(parent))
  add(query_589552, "resourceVersion", newJString(resourceVersion))
  add(query_589552, "watch", newJBool(watch))
  add(query_589552, "key", newJString(key))
  add(query_589552, "$.xgafv", newJString(Xgafv))
  add(query_589552, "labelSelector", newJString(labelSelector))
  add(query_589552, "prettyPrint", newJBool(prettyPrint))
  add(query_589552, "fieldSelector", newJString(fieldSelector))
  add(query_589552, "limit", newJInt(limit))
  result = call_589550.call(path_589551, query_589552, nil, nil, nil)

var runProjectsLocationsConfigurationsList* = Call_RunProjectsLocationsConfigurationsList_589527(
    name: "runProjectsLocationsConfigurationsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/configurations",
    validator: validate_RunProjectsLocationsConfigurationsList_589528, base: "/",
    url: url_RunProjectsLocationsConfigurationsList_589529,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsCreate_589579 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsDomainmappingsCreate_589581(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsCreate_589580(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new domain mapping.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this domain mapping should be
  ## created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589582 = path.getOrDefault("parent")
  valid_589582 = validateParameter(valid_589582, JString, required = true,
                                 default = nil)
  if valid_589582 != nil:
    section.add "parent", valid_589582
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
  var valid_589583 = query.getOrDefault("upload_protocol")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "upload_protocol", valid_589583
  var valid_589584 = query.getOrDefault("fields")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "fields", valid_589584
  var valid_589585 = query.getOrDefault("quotaUser")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = nil)
  if valid_589585 != nil:
    section.add "quotaUser", valid_589585
  var valid_589586 = query.getOrDefault("alt")
  valid_589586 = validateParameter(valid_589586, JString, required = false,
                                 default = newJString("json"))
  if valid_589586 != nil:
    section.add "alt", valid_589586
  var valid_589587 = query.getOrDefault("oauth_token")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = nil)
  if valid_589587 != nil:
    section.add "oauth_token", valid_589587
  var valid_589588 = query.getOrDefault("callback")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "callback", valid_589588
  var valid_589589 = query.getOrDefault("access_token")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = nil)
  if valid_589589 != nil:
    section.add "access_token", valid_589589
  var valid_589590 = query.getOrDefault("uploadType")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = nil)
  if valid_589590 != nil:
    section.add "uploadType", valid_589590
  var valid_589591 = query.getOrDefault("key")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "key", valid_589591
  var valid_589592 = query.getOrDefault("$.xgafv")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = newJString("1"))
  if valid_589592 != nil:
    section.add "$.xgafv", valid_589592
  var valid_589593 = query.getOrDefault("prettyPrint")
  valid_589593 = validateParameter(valid_589593, JBool, required = false,
                                 default = newJBool(true))
  if valid_589593 != nil:
    section.add "prettyPrint", valid_589593
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

proc call*(call_589595: Call_RunProjectsLocationsDomainmappingsCreate_589579;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new domain mapping.
  ## 
  let valid = call_589595.validator(path, query, header, formData, body)
  let scheme = call_589595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589595.url(scheme.get, call_589595.host, call_589595.base,
                         call_589595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589595, url, valid)

proc call*(call_589596: Call_RunProjectsLocationsDomainmappingsCreate_589579;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsDomainmappingsCreate
  ## Creates a new domain mapping.
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
  var path_589597 = newJObject()
  var query_589598 = newJObject()
  var body_589599 = newJObject()
  add(query_589598, "upload_protocol", newJString(uploadProtocol))
  add(query_589598, "fields", newJString(fields))
  add(query_589598, "quotaUser", newJString(quotaUser))
  add(query_589598, "alt", newJString(alt))
  add(query_589598, "oauth_token", newJString(oauthToken))
  add(query_589598, "callback", newJString(callback))
  add(query_589598, "access_token", newJString(accessToken))
  add(query_589598, "uploadType", newJString(uploadType))
  add(path_589597, "parent", newJString(parent))
  add(query_589598, "key", newJString(key))
  add(query_589598, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589599 = body
  add(query_589598, "prettyPrint", newJBool(prettyPrint))
  result = call_589596.call(path_589597, query_589598, nil, nil, body_589599)

var runProjectsLocationsDomainmappingsCreate* = Call_RunProjectsLocationsDomainmappingsCreate_589579(
    name: "runProjectsLocationsDomainmappingsCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsCreate_589580,
    base: "/", url: url_RunProjectsLocationsDomainmappingsCreate_589581,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsDomainmappingsList_589553 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsDomainmappingsList_589555(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/domainmappings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsDomainmappingsList_589554(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list domain mappings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the domain mappings should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589556 = path.getOrDefault("parent")
  valid_589556 = validateParameter(valid_589556, JString, required = true,
                                 default = nil)
  if valid_589556 != nil:
    section.add "parent", valid_589556
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
  var valid_589557 = query.getOrDefault("upload_protocol")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "upload_protocol", valid_589557
  var valid_589558 = query.getOrDefault("fields")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "fields", valid_589558
  var valid_589559 = query.getOrDefault("quotaUser")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "quotaUser", valid_589559
  var valid_589560 = query.getOrDefault("includeUninitialized")
  valid_589560 = validateParameter(valid_589560, JBool, required = false, default = nil)
  if valid_589560 != nil:
    section.add "includeUninitialized", valid_589560
  var valid_589561 = query.getOrDefault("alt")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = newJString("json"))
  if valid_589561 != nil:
    section.add "alt", valid_589561
  var valid_589562 = query.getOrDefault("continue")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "continue", valid_589562
  var valid_589563 = query.getOrDefault("oauth_token")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "oauth_token", valid_589563
  var valid_589564 = query.getOrDefault("callback")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "callback", valid_589564
  var valid_589565 = query.getOrDefault("access_token")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "access_token", valid_589565
  var valid_589566 = query.getOrDefault("uploadType")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = nil)
  if valid_589566 != nil:
    section.add "uploadType", valid_589566
  var valid_589567 = query.getOrDefault("resourceVersion")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "resourceVersion", valid_589567
  var valid_589568 = query.getOrDefault("watch")
  valid_589568 = validateParameter(valid_589568, JBool, required = false, default = nil)
  if valid_589568 != nil:
    section.add "watch", valid_589568
  var valid_589569 = query.getOrDefault("key")
  valid_589569 = validateParameter(valid_589569, JString, required = false,
                                 default = nil)
  if valid_589569 != nil:
    section.add "key", valid_589569
  var valid_589570 = query.getOrDefault("$.xgafv")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = newJString("1"))
  if valid_589570 != nil:
    section.add "$.xgafv", valid_589570
  var valid_589571 = query.getOrDefault("labelSelector")
  valid_589571 = validateParameter(valid_589571, JString, required = false,
                                 default = nil)
  if valid_589571 != nil:
    section.add "labelSelector", valid_589571
  var valid_589572 = query.getOrDefault("prettyPrint")
  valid_589572 = validateParameter(valid_589572, JBool, required = false,
                                 default = newJBool(true))
  if valid_589572 != nil:
    section.add "prettyPrint", valid_589572
  var valid_589573 = query.getOrDefault("fieldSelector")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "fieldSelector", valid_589573
  var valid_589574 = query.getOrDefault("limit")
  valid_589574 = validateParameter(valid_589574, JInt, required = false, default = nil)
  if valid_589574 != nil:
    section.add "limit", valid_589574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589575: Call_RunProjectsLocationsDomainmappingsList_589553;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list domain mappings.
  ## 
  let valid = call_589575.validator(path, query, header, formData, body)
  let scheme = call_589575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589575.url(scheme.get, call_589575.host, call_589575.base,
                         call_589575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589575, url, valid)

proc call*(call_589576: Call_RunProjectsLocationsDomainmappingsList_589553;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsDomainmappingsList
  ## Rpc to list domain mappings.
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
  var path_589577 = newJObject()
  var query_589578 = newJObject()
  add(query_589578, "upload_protocol", newJString(uploadProtocol))
  add(query_589578, "fields", newJString(fields))
  add(query_589578, "quotaUser", newJString(quotaUser))
  add(query_589578, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589578, "alt", newJString(alt))
  add(query_589578, "continue", newJString(`continue`))
  add(query_589578, "oauth_token", newJString(oauthToken))
  add(query_589578, "callback", newJString(callback))
  add(query_589578, "access_token", newJString(accessToken))
  add(query_589578, "uploadType", newJString(uploadType))
  add(path_589577, "parent", newJString(parent))
  add(query_589578, "resourceVersion", newJString(resourceVersion))
  add(query_589578, "watch", newJBool(watch))
  add(query_589578, "key", newJString(key))
  add(query_589578, "$.xgafv", newJString(Xgafv))
  add(query_589578, "labelSelector", newJString(labelSelector))
  add(query_589578, "prettyPrint", newJBool(prettyPrint))
  add(query_589578, "fieldSelector", newJString(fieldSelector))
  add(query_589578, "limit", newJInt(limit))
  result = call_589576.call(path_589577, query_589578, nil, nil, nil)

var runProjectsLocationsDomainmappingsList* = Call_RunProjectsLocationsDomainmappingsList_589553(
    name: "runProjectsLocationsDomainmappingsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/domainmappings",
    validator: validate_RunProjectsLocationsDomainmappingsList_589554, base: "/",
    url: url_RunProjectsLocationsDomainmappingsList_589555,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsEventtypesList_589600 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsEventtypesList_589602(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/eventtypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsEventtypesList_589601(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list EventTypes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the EventTypes should be
  ## listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589603 = path.getOrDefault("parent")
  valid_589603 = validateParameter(valid_589603, JString, required = true,
                                 default = nil)
  if valid_589603 != nil:
    section.add "parent", valid_589603
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
  var valid_589604 = query.getOrDefault("upload_protocol")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = nil)
  if valid_589604 != nil:
    section.add "upload_protocol", valid_589604
  var valid_589605 = query.getOrDefault("fields")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = nil)
  if valid_589605 != nil:
    section.add "fields", valid_589605
  var valid_589606 = query.getOrDefault("quotaUser")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "quotaUser", valid_589606
  var valid_589607 = query.getOrDefault("includeUninitialized")
  valid_589607 = validateParameter(valid_589607, JBool, required = false, default = nil)
  if valid_589607 != nil:
    section.add "includeUninitialized", valid_589607
  var valid_589608 = query.getOrDefault("alt")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = newJString("json"))
  if valid_589608 != nil:
    section.add "alt", valid_589608
  var valid_589609 = query.getOrDefault("continue")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "continue", valid_589609
  var valid_589610 = query.getOrDefault("oauth_token")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = nil)
  if valid_589610 != nil:
    section.add "oauth_token", valid_589610
  var valid_589611 = query.getOrDefault("callback")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "callback", valid_589611
  var valid_589612 = query.getOrDefault("access_token")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "access_token", valid_589612
  var valid_589613 = query.getOrDefault("uploadType")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "uploadType", valid_589613
  var valid_589614 = query.getOrDefault("resourceVersion")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "resourceVersion", valid_589614
  var valid_589615 = query.getOrDefault("watch")
  valid_589615 = validateParameter(valid_589615, JBool, required = false, default = nil)
  if valid_589615 != nil:
    section.add "watch", valid_589615
  var valid_589616 = query.getOrDefault("key")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = nil)
  if valid_589616 != nil:
    section.add "key", valid_589616
  var valid_589617 = query.getOrDefault("$.xgafv")
  valid_589617 = validateParameter(valid_589617, JString, required = false,
                                 default = newJString("1"))
  if valid_589617 != nil:
    section.add "$.xgafv", valid_589617
  var valid_589618 = query.getOrDefault("labelSelector")
  valid_589618 = validateParameter(valid_589618, JString, required = false,
                                 default = nil)
  if valid_589618 != nil:
    section.add "labelSelector", valid_589618
  var valid_589619 = query.getOrDefault("prettyPrint")
  valid_589619 = validateParameter(valid_589619, JBool, required = false,
                                 default = newJBool(true))
  if valid_589619 != nil:
    section.add "prettyPrint", valid_589619
  var valid_589620 = query.getOrDefault("fieldSelector")
  valid_589620 = validateParameter(valid_589620, JString, required = false,
                                 default = nil)
  if valid_589620 != nil:
    section.add "fieldSelector", valid_589620
  var valid_589621 = query.getOrDefault("limit")
  valid_589621 = validateParameter(valid_589621, JInt, required = false, default = nil)
  if valid_589621 != nil:
    section.add "limit", valid_589621
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589622: Call_RunProjectsLocationsEventtypesList_589600;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list EventTypes.
  ## 
  let valid = call_589622.validator(path, query, header, formData, body)
  let scheme = call_589622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589622.url(scheme.get, call_589622.host, call_589622.base,
                         call_589622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589622, url, valid)

proc call*(call_589623: Call_RunProjectsLocationsEventtypesList_589600;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsEventtypesList
  ## Rpc to list EventTypes.
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
  ##         : The project ID or project number from which the EventTypes should be
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
  var path_589624 = newJObject()
  var query_589625 = newJObject()
  add(query_589625, "upload_protocol", newJString(uploadProtocol))
  add(query_589625, "fields", newJString(fields))
  add(query_589625, "quotaUser", newJString(quotaUser))
  add(query_589625, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589625, "alt", newJString(alt))
  add(query_589625, "continue", newJString(`continue`))
  add(query_589625, "oauth_token", newJString(oauthToken))
  add(query_589625, "callback", newJString(callback))
  add(query_589625, "access_token", newJString(accessToken))
  add(query_589625, "uploadType", newJString(uploadType))
  add(path_589624, "parent", newJString(parent))
  add(query_589625, "resourceVersion", newJString(resourceVersion))
  add(query_589625, "watch", newJBool(watch))
  add(query_589625, "key", newJString(key))
  add(query_589625, "$.xgafv", newJString(Xgafv))
  add(query_589625, "labelSelector", newJString(labelSelector))
  add(query_589625, "prettyPrint", newJBool(prettyPrint))
  add(query_589625, "fieldSelector", newJString(fieldSelector))
  add(query_589625, "limit", newJInt(limit))
  result = call_589623.call(path_589624, query_589625, nil, nil, nil)

var runProjectsLocationsEventtypesList* = Call_RunProjectsLocationsEventtypesList_589600(
    name: "runProjectsLocationsEventtypesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/eventtypes",
    validator: validate_RunProjectsLocationsEventtypesList_589601, base: "/",
    url: url_RunProjectsLocationsEventtypesList_589602, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRevisionsList_589626 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsRevisionsList_589628(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/revisions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRevisionsList_589627(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list revisions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the revisions should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589629 = path.getOrDefault("parent")
  valid_589629 = validateParameter(valid_589629, JString, required = true,
                                 default = nil)
  if valid_589629 != nil:
    section.add "parent", valid_589629
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
  var valid_589630 = query.getOrDefault("upload_protocol")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "upload_protocol", valid_589630
  var valid_589631 = query.getOrDefault("fields")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = nil)
  if valid_589631 != nil:
    section.add "fields", valid_589631
  var valid_589632 = query.getOrDefault("quotaUser")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "quotaUser", valid_589632
  var valid_589633 = query.getOrDefault("includeUninitialized")
  valid_589633 = validateParameter(valid_589633, JBool, required = false, default = nil)
  if valid_589633 != nil:
    section.add "includeUninitialized", valid_589633
  var valid_589634 = query.getOrDefault("alt")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = newJString("json"))
  if valid_589634 != nil:
    section.add "alt", valid_589634
  var valid_589635 = query.getOrDefault("continue")
  valid_589635 = validateParameter(valid_589635, JString, required = false,
                                 default = nil)
  if valid_589635 != nil:
    section.add "continue", valid_589635
  var valid_589636 = query.getOrDefault("oauth_token")
  valid_589636 = validateParameter(valid_589636, JString, required = false,
                                 default = nil)
  if valid_589636 != nil:
    section.add "oauth_token", valid_589636
  var valid_589637 = query.getOrDefault("callback")
  valid_589637 = validateParameter(valid_589637, JString, required = false,
                                 default = nil)
  if valid_589637 != nil:
    section.add "callback", valid_589637
  var valid_589638 = query.getOrDefault("access_token")
  valid_589638 = validateParameter(valid_589638, JString, required = false,
                                 default = nil)
  if valid_589638 != nil:
    section.add "access_token", valid_589638
  var valid_589639 = query.getOrDefault("uploadType")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = nil)
  if valid_589639 != nil:
    section.add "uploadType", valid_589639
  var valid_589640 = query.getOrDefault("resourceVersion")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "resourceVersion", valid_589640
  var valid_589641 = query.getOrDefault("watch")
  valid_589641 = validateParameter(valid_589641, JBool, required = false, default = nil)
  if valid_589641 != nil:
    section.add "watch", valid_589641
  var valid_589642 = query.getOrDefault("key")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "key", valid_589642
  var valid_589643 = query.getOrDefault("$.xgafv")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = newJString("1"))
  if valid_589643 != nil:
    section.add "$.xgafv", valid_589643
  var valid_589644 = query.getOrDefault("labelSelector")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "labelSelector", valid_589644
  var valid_589645 = query.getOrDefault("prettyPrint")
  valid_589645 = validateParameter(valid_589645, JBool, required = false,
                                 default = newJBool(true))
  if valid_589645 != nil:
    section.add "prettyPrint", valid_589645
  var valid_589646 = query.getOrDefault("fieldSelector")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "fieldSelector", valid_589646
  var valid_589647 = query.getOrDefault("limit")
  valid_589647 = validateParameter(valid_589647, JInt, required = false, default = nil)
  if valid_589647 != nil:
    section.add "limit", valid_589647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589648: Call_RunProjectsLocationsRevisionsList_589626;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list revisions.
  ## 
  let valid = call_589648.validator(path, query, header, formData, body)
  let scheme = call_589648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589648.url(scheme.get, call_589648.host, call_589648.base,
                         call_589648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589648, url, valid)

proc call*(call_589649: Call_RunProjectsLocationsRevisionsList_589626;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsRevisionsList
  ## Rpc to list revisions.
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
  var path_589650 = newJObject()
  var query_589651 = newJObject()
  add(query_589651, "upload_protocol", newJString(uploadProtocol))
  add(query_589651, "fields", newJString(fields))
  add(query_589651, "quotaUser", newJString(quotaUser))
  add(query_589651, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589651, "alt", newJString(alt))
  add(query_589651, "continue", newJString(`continue`))
  add(query_589651, "oauth_token", newJString(oauthToken))
  add(query_589651, "callback", newJString(callback))
  add(query_589651, "access_token", newJString(accessToken))
  add(query_589651, "uploadType", newJString(uploadType))
  add(path_589650, "parent", newJString(parent))
  add(query_589651, "resourceVersion", newJString(resourceVersion))
  add(query_589651, "watch", newJBool(watch))
  add(query_589651, "key", newJString(key))
  add(query_589651, "$.xgafv", newJString(Xgafv))
  add(query_589651, "labelSelector", newJString(labelSelector))
  add(query_589651, "prettyPrint", newJBool(prettyPrint))
  add(query_589651, "fieldSelector", newJString(fieldSelector))
  add(query_589651, "limit", newJInt(limit))
  result = call_589649.call(path_589650, query_589651, nil, nil, nil)

var runProjectsLocationsRevisionsList* = Call_RunProjectsLocationsRevisionsList_589626(
    name: "runProjectsLocationsRevisionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/revisions",
    validator: validate_RunProjectsLocationsRevisionsList_589627, base: "/",
    url: url_RunProjectsLocationsRevisionsList_589628, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsRoutesList_589652 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsRoutesList_589654(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/routes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsRoutesList_589653(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list routes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the routes should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589655 = path.getOrDefault("parent")
  valid_589655 = validateParameter(valid_589655, JString, required = true,
                                 default = nil)
  if valid_589655 != nil:
    section.add "parent", valid_589655
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
  var valid_589656 = query.getOrDefault("upload_protocol")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "upload_protocol", valid_589656
  var valid_589657 = query.getOrDefault("fields")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "fields", valid_589657
  var valid_589658 = query.getOrDefault("quotaUser")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = nil)
  if valid_589658 != nil:
    section.add "quotaUser", valid_589658
  var valid_589659 = query.getOrDefault("includeUninitialized")
  valid_589659 = validateParameter(valid_589659, JBool, required = false, default = nil)
  if valid_589659 != nil:
    section.add "includeUninitialized", valid_589659
  var valid_589660 = query.getOrDefault("alt")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = newJString("json"))
  if valid_589660 != nil:
    section.add "alt", valid_589660
  var valid_589661 = query.getOrDefault("continue")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "continue", valid_589661
  var valid_589662 = query.getOrDefault("oauth_token")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "oauth_token", valid_589662
  var valid_589663 = query.getOrDefault("callback")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "callback", valid_589663
  var valid_589664 = query.getOrDefault("access_token")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "access_token", valid_589664
  var valid_589665 = query.getOrDefault("uploadType")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "uploadType", valid_589665
  var valid_589666 = query.getOrDefault("resourceVersion")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "resourceVersion", valid_589666
  var valid_589667 = query.getOrDefault("watch")
  valid_589667 = validateParameter(valid_589667, JBool, required = false, default = nil)
  if valid_589667 != nil:
    section.add "watch", valid_589667
  var valid_589668 = query.getOrDefault("key")
  valid_589668 = validateParameter(valid_589668, JString, required = false,
                                 default = nil)
  if valid_589668 != nil:
    section.add "key", valid_589668
  var valid_589669 = query.getOrDefault("$.xgafv")
  valid_589669 = validateParameter(valid_589669, JString, required = false,
                                 default = newJString("1"))
  if valid_589669 != nil:
    section.add "$.xgafv", valid_589669
  var valid_589670 = query.getOrDefault("labelSelector")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = nil)
  if valid_589670 != nil:
    section.add "labelSelector", valid_589670
  var valid_589671 = query.getOrDefault("prettyPrint")
  valid_589671 = validateParameter(valid_589671, JBool, required = false,
                                 default = newJBool(true))
  if valid_589671 != nil:
    section.add "prettyPrint", valid_589671
  var valid_589672 = query.getOrDefault("fieldSelector")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "fieldSelector", valid_589672
  var valid_589673 = query.getOrDefault("limit")
  valid_589673 = validateParameter(valid_589673, JInt, required = false, default = nil)
  if valid_589673 != nil:
    section.add "limit", valid_589673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589674: Call_RunProjectsLocationsRoutesList_589652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rpc to list routes.
  ## 
  let valid = call_589674.validator(path, query, header, formData, body)
  let scheme = call_589674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589674.url(scheme.get, call_589674.host, call_589674.base,
                         call_589674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589674, url, valid)

proc call*(call_589675: Call_RunProjectsLocationsRoutesList_589652; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          includeUninitialized: bool = false; alt: string = "json";
          `continue`: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsRoutesList
  ## Rpc to list routes.
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
  var path_589676 = newJObject()
  var query_589677 = newJObject()
  add(query_589677, "upload_protocol", newJString(uploadProtocol))
  add(query_589677, "fields", newJString(fields))
  add(query_589677, "quotaUser", newJString(quotaUser))
  add(query_589677, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589677, "alt", newJString(alt))
  add(query_589677, "continue", newJString(`continue`))
  add(query_589677, "oauth_token", newJString(oauthToken))
  add(query_589677, "callback", newJString(callback))
  add(query_589677, "access_token", newJString(accessToken))
  add(query_589677, "uploadType", newJString(uploadType))
  add(path_589676, "parent", newJString(parent))
  add(query_589677, "resourceVersion", newJString(resourceVersion))
  add(query_589677, "watch", newJBool(watch))
  add(query_589677, "key", newJString(key))
  add(query_589677, "$.xgafv", newJString(Xgafv))
  add(query_589677, "labelSelector", newJString(labelSelector))
  add(query_589677, "prettyPrint", newJBool(prettyPrint))
  add(query_589677, "fieldSelector", newJString(fieldSelector))
  add(query_589677, "limit", newJInt(limit))
  result = call_589675.call(path_589676, query_589677, nil, nil, nil)

var runProjectsLocationsRoutesList* = Call_RunProjectsLocationsRoutesList_589652(
    name: "runProjectsLocationsRoutesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/routes",
    validator: validate_RunProjectsLocationsRoutesList_589653, base: "/",
    url: url_RunProjectsLocationsRoutesList_589654, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesCreate_589704 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesCreate_589706(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesCreate_589705(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to create a service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this service should be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589707 = path.getOrDefault("parent")
  valid_589707 = validateParameter(valid_589707, JString, required = true,
                                 default = nil)
  if valid_589707 != nil:
    section.add "parent", valid_589707
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
  var valid_589708 = query.getOrDefault("upload_protocol")
  valid_589708 = validateParameter(valid_589708, JString, required = false,
                                 default = nil)
  if valid_589708 != nil:
    section.add "upload_protocol", valid_589708
  var valid_589709 = query.getOrDefault("fields")
  valid_589709 = validateParameter(valid_589709, JString, required = false,
                                 default = nil)
  if valid_589709 != nil:
    section.add "fields", valid_589709
  var valid_589710 = query.getOrDefault("quotaUser")
  valid_589710 = validateParameter(valid_589710, JString, required = false,
                                 default = nil)
  if valid_589710 != nil:
    section.add "quotaUser", valid_589710
  var valid_589711 = query.getOrDefault("alt")
  valid_589711 = validateParameter(valid_589711, JString, required = false,
                                 default = newJString("json"))
  if valid_589711 != nil:
    section.add "alt", valid_589711
  var valid_589712 = query.getOrDefault("oauth_token")
  valid_589712 = validateParameter(valid_589712, JString, required = false,
                                 default = nil)
  if valid_589712 != nil:
    section.add "oauth_token", valid_589712
  var valid_589713 = query.getOrDefault("callback")
  valid_589713 = validateParameter(valid_589713, JString, required = false,
                                 default = nil)
  if valid_589713 != nil:
    section.add "callback", valid_589713
  var valid_589714 = query.getOrDefault("access_token")
  valid_589714 = validateParameter(valid_589714, JString, required = false,
                                 default = nil)
  if valid_589714 != nil:
    section.add "access_token", valid_589714
  var valid_589715 = query.getOrDefault("uploadType")
  valid_589715 = validateParameter(valid_589715, JString, required = false,
                                 default = nil)
  if valid_589715 != nil:
    section.add "uploadType", valid_589715
  var valid_589716 = query.getOrDefault("key")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = nil)
  if valid_589716 != nil:
    section.add "key", valid_589716
  var valid_589717 = query.getOrDefault("$.xgafv")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = newJString("1"))
  if valid_589717 != nil:
    section.add "$.xgafv", valid_589717
  var valid_589718 = query.getOrDefault("prettyPrint")
  valid_589718 = validateParameter(valid_589718, JBool, required = false,
                                 default = newJBool(true))
  if valid_589718 != nil:
    section.add "prettyPrint", valid_589718
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

proc call*(call_589720: Call_RunProjectsLocationsServicesCreate_589704;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to create a service.
  ## 
  let valid = call_589720.validator(path, query, header, formData, body)
  let scheme = call_589720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589720.url(scheme.get, call_589720.host, call_589720.base,
                         call_589720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589720, url, valid)

proc call*(call_589721: Call_RunProjectsLocationsServicesCreate_589704;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsServicesCreate
  ## Rpc to create a service.
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
  var path_589722 = newJObject()
  var query_589723 = newJObject()
  var body_589724 = newJObject()
  add(query_589723, "upload_protocol", newJString(uploadProtocol))
  add(query_589723, "fields", newJString(fields))
  add(query_589723, "quotaUser", newJString(quotaUser))
  add(query_589723, "alt", newJString(alt))
  add(query_589723, "oauth_token", newJString(oauthToken))
  add(query_589723, "callback", newJString(callback))
  add(query_589723, "access_token", newJString(accessToken))
  add(query_589723, "uploadType", newJString(uploadType))
  add(path_589722, "parent", newJString(parent))
  add(query_589723, "key", newJString(key))
  add(query_589723, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589724 = body
  add(query_589723, "prettyPrint", newJBool(prettyPrint))
  result = call_589721.call(path_589722, query_589723, nil, nil, body_589724)

var runProjectsLocationsServicesCreate* = Call_RunProjectsLocationsServicesCreate_589704(
    name: "runProjectsLocationsServicesCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesCreate_589705, base: "/",
    url: url_RunProjectsLocationsServicesCreate_589706, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesList_589678 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesList_589680(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesList_589679(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the services should be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589681 = path.getOrDefault("parent")
  valid_589681 = validateParameter(valid_589681, JString, required = true,
                                 default = nil)
  if valid_589681 != nil:
    section.add "parent", valid_589681
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
  var valid_589682 = query.getOrDefault("upload_protocol")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "upload_protocol", valid_589682
  var valid_589683 = query.getOrDefault("fields")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = nil)
  if valid_589683 != nil:
    section.add "fields", valid_589683
  var valid_589684 = query.getOrDefault("quotaUser")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "quotaUser", valid_589684
  var valid_589685 = query.getOrDefault("includeUninitialized")
  valid_589685 = validateParameter(valid_589685, JBool, required = false, default = nil)
  if valid_589685 != nil:
    section.add "includeUninitialized", valid_589685
  var valid_589686 = query.getOrDefault("alt")
  valid_589686 = validateParameter(valid_589686, JString, required = false,
                                 default = newJString("json"))
  if valid_589686 != nil:
    section.add "alt", valid_589686
  var valid_589687 = query.getOrDefault("continue")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = nil)
  if valid_589687 != nil:
    section.add "continue", valid_589687
  var valid_589688 = query.getOrDefault("oauth_token")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = nil)
  if valid_589688 != nil:
    section.add "oauth_token", valid_589688
  var valid_589689 = query.getOrDefault("callback")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = nil)
  if valid_589689 != nil:
    section.add "callback", valid_589689
  var valid_589690 = query.getOrDefault("access_token")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = nil)
  if valid_589690 != nil:
    section.add "access_token", valid_589690
  var valid_589691 = query.getOrDefault("uploadType")
  valid_589691 = validateParameter(valid_589691, JString, required = false,
                                 default = nil)
  if valid_589691 != nil:
    section.add "uploadType", valid_589691
  var valid_589692 = query.getOrDefault("resourceVersion")
  valid_589692 = validateParameter(valid_589692, JString, required = false,
                                 default = nil)
  if valid_589692 != nil:
    section.add "resourceVersion", valid_589692
  var valid_589693 = query.getOrDefault("watch")
  valid_589693 = validateParameter(valid_589693, JBool, required = false, default = nil)
  if valid_589693 != nil:
    section.add "watch", valid_589693
  var valid_589694 = query.getOrDefault("key")
  valid_589694 = validateParameter(valid_589694, JString, required = false,
                                 default = nil)
  if valid_589694 != nil:
    section.add "key", valid_589694
  var valid_589695 = query.getOrDefault("$.xgafv")
  valid_589695 = validateParameter(valid_589695, JString, required = false,
                                 default = newJString("1"))
  if valid_589695 != nil:
    section.add "$.xgafv", valid_589695
  var valid_589696 = query.getOrDefault("labelSelector")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "labelSelector", valid_589696
  var valid_589697 = query.getOrDefault("prettyPrint")
  valid_589697 = validateParameter(valid_589697, JBool, required = false,
                                 default = newJBool(true))
  if valid_589697 != nil:
    section.add "prettyPrint", valid_589697
  var valid_589698 = query.getOrDefault("fieldSelector")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "fieldSelector", valid_589698
  var valid_589699 = query.getOrDefault("limit")
  valid_589699 = validateParameter(valid_589699, JInt, required = false, default = nil)
  if valid_589699 != nil:
    section.add "limit", valid_589699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589700: Call_RunProjectsLocationsServicesList_589678;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list services.
  ## 
  let valid = call_589700.validator(path, query, header, formData, body)
  let scheme = call_589700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589700.url(scheme.get, call_589700.host, call_589700.base,
                         call_589700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589700, url, valid)

proc call*(call_589701: Call_RunProjectsLocationsServicesList_589678;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsServicesList
  ## Rpc to list services.
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
  var path_589702 = newJObject()
  var query_589703 = newJObject()
  add(query_589703, "upload_protocol", newJString(uploadProtocol))
  add(query_589703, "fields", newJString(fields))
  add(query_589703, "quotaUser", newJString(quotaUser))
  add(query_589703, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589703, "alt", newJString(alt))
  add(query_589703, "continue", newJString(`continue`))
  add(query_589703, "oauth_token", newJString(oauthToken))
  add(query_589703, "callback", newJString(callback))
  add(query_589703, "access_token", newJString(accessToken))
  add(query_589703, "uploadType", newJString(uploadType))
  add(path_589702, "parent", newJString(parent))
  add(query_589703, "resourceVersion", newJString(resourceVersion))
  add(query_589703, "watch", newJBool(watch))
  add(query_589703, "key", newJString(key))
  add(query_589703, "$.xgafv", newJString(Xgafv))
  add(query_589703, "labelSelector", newJString(labelSelector))
  add(query_589703, "prettyPrint", newJBool(prettyPrint))
  add(query_589703, "fieldSelector", newJString(fieldSelector))
  add(query_589703, "limit", newJInt(limit))
  result = call_589701.call(path_589702, query_589703, nil, nil, nil)

var runProjectsLocationsServicesList* = Call_RunProjectsLocationsServicesList_589678(
    name: "runProjectsLocationsServicesList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/services",
    validator: validate_RunProjectsLocationsServicesList_589679, base: "/",
    url: url_RunProjectsLocationsServicesList_589680, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersCreate_589751 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsTriggersCreate_589753(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsTriggersCreate_589752(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number in which this trigger should
  ## be created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589754 = path.getOrDefault("parent")
  valid_589754 = validateParameter(valid_589754, JString, required = true,
                                 default = nil)
  if valid_589754 != nil:
    section.add "parent", valid_589754
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
  var valid_589755 = query.getOrDefault("upload_protocol")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = nil)
  if valid_589755 != nil:
    section.add "upload_protocol", valid_589755
  var valid_589756 = query.getOrDefault("fields")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "fields", valid_589756
  var valid_589757 = query.getOrDefault("quotaUser")
  valid_589757 = validateParameter(valid_589757, JString, required = false,
                                 default = nil)
  if valid_589757 != nil:
    section.add "quotaUser", valid_589757
  var valid_589758 = query.getOrDefault("alt")
  valid_589758 = validateParameter(valid_589758, JString, required = false,
                                 default = newJString("json"))
  if valid_589758 != nil:
    section.add "alt", valid_589758
  var valid_589759 = query.getOrDefault("oauth_token")
  valid_589759 = validateParameter(valid_589759, JString, required = false,
                                 default = nil)
  if valid_589759 != nil:
    section.add "oauth_token", valid_589759
  var valid_589760 = query.getOrDefault("callback")
  valid_589760 = validateParameter(valid_589760, JString, required = false,
                                 default = nil)
  if valid_589760 != nil:
    section.add "callback", valid_589760
  var valid_589761 = query.getOrDefault("access_token")
  valid_589761 = validateParameter(valid_589761, JString, required = false,
                                 default = nil)
  if valid_589761 != nil:
    section.add "access_token", valid_589761
  var valid_589762 = query.getOrDefault("uploadType")
  valid_589762 = validateParameter(valid_589762, JString, required = false,
                                 default = nil)
  if valid_589762 != nil:
    section.add "uploadType", valid_589762
  var valid_589763 = query.getOrDefault("key")
  valid_589763 = validateParameter(valid_589763, JString, required = false,
                                 default = nil)
  if valid_589763 != nil:
    section.add "key", valid_589763
  var valid_589764 = query.getOrDefault("$.xgafv")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = newJString("1"))
  if valid_589764 != nil:
    section.add "$.xgafv", valid_589764
  var valid_589765 = query.getOrDefault("prettyPrint")
  valid_589765 = validateParameter(valid_589765, JBool, required = false,
                                 default = newJBool(true))
  if valid_589765 != nil:
    section.add "prettyPrint", valid_589765
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

proc call*(call_589767: Call_RunProjectsLocationsTriggersCreate_589751;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new trigger.
  ## 
  let valid = call_589767.validator(path, query, header, formData, body)
  let scheme = call_589767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589767.url(scheme.get, call_589767.host, call_589767.base,
                         call_589767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589767, url, valid)

proc call*(call_589768: Call_RunProjectsLocationsTriggersCreate_589751;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## runProjectsLocationsTriggersCreate
  ## Creates a new trigger.
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
  ##         : The project ID or project number in which this trigger should
  ## be created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589769 = newJObject()
  var query_589770 = newJObject()
  var body_589771 = newJObject()
  add(query_589770, "upload_protocol", newJString(uploadProtocol))
  add(query_589770, "fields", newJString(fields))
  add(query_589770, "quotaUser", newJString(quotaUser))
  add(query_589770, "alt", newJString(alt))
  add(query_589770, "oauth_token", newJString(oauthToken))
  add(query_589770, "callback", newJString(callback))
  add(query_589770, "access_token", newJString(accessToken))
  add(query_589770, "uploadType", newJString(uploadType))
  add(path_589769, "parent", newJString(parent))
  add(query_589770, "key", newJString(key))
  add(query_589770, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589771 = body
  add(query_589770, "prettyPrint", newJBool(prettyPrint))
  result = call_589768.call(path_589769, query_589770, nil, nil, body_589771)

var runProjectsLocationsTriggersCreate* = Call_RunProjectsLocationsTriggersCreate_589751(
    name: "runProjectsLocationsTriggersCreate", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersCreate_589752, base: "/",
    url: url_RunProjectsLocationsTriggersCreate_589753, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsTriggersList_589725 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsTriggersList_589727(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsTriggersList_589726(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the triggers should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589728 = path.getOrDefault("parent")
  valid_589728 = validateParameter(valid_589728, JString, required = true,
                                 default = nil)
  if valid_589728 != nil:
    section.add "parent", valid_589728
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
  var valid_589729 = query.getOrDefault("upload_protocol")
  valid_589729 = validateParameter(valid_589729, JString, required = false,
                                 default = nil)
  if valid_589729 != nil:
    section.add "upload_protocol", valid_589729
  var valid_589730 = query.getOrDefault("fields")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = nil)
  if valid_589730 != nil:
    section.add "fields", valid_589730
  var valid_589731 = query.getOrDefault("quotaUser")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = nil)
  if valid_589731 != nil:
    section.add "quotaUser", valid_589731
  var valid_589732 = query.getOrDefault("includeUninitialized")
  valid_589732 = validateParameter(valid_589732, JBool, required = false, default = nil)
  if valid_589732 != nil:
    section.add "includeUninitialized", valid_589732
  var valid_589733 = query.getOrDefault("alt")
  valid_589733 = validateParameter(valid_589733, JString, required = false,
                                 default = newJString("json"))
  if valid_589733 != nil:
    section.add "alt", valid_589733
  var valid_589734 = query.getOrDefault("continue")
  valid_589734 = validateParameter(valid_589734, JString, required = false,
                                 default = nil)
  if valid_589734 != nil:
    section.add "continue", valid_589734
  var valid_589735 = query.getOrDefault("oauth_token")
  valid_589735 = validateParameter(valid_589735, JString, required = false,
                                 default = nil)
  if valid_589735 != nil:
    section.add "oauth_token", valid_589735
  var valid_589736 = query.getOrDefault("callback")
  valid_589736 = validateParameter(valid_589736, JString, required = false,
                                 default = nil)
  if valid_589736 != nil:
    section.add "callback", valid_589736
  var valid_589737 = query.getOrDefault("access_token")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = nil)
  if valid_589737 != nil:
    section.add "access_token", valid_589737
  var valid_589738 = query.getOrDefault("uploadType")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = nil)
  if valid_589738 != nil:
    section.add "uploadType", valid_589738
  var valid_589739 = query.getOrDefault("resourceVersion")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = nil)
  if valid_589739 != nil:
    section.add "resourceVersion", valid_589739
  var valid_589740 = query.getOrDefault("watch")
  valid_589740 = validateParameter(valid_589740, JBool, required = false, default = nil)
  if valid_589740 != nil:
    section.add "watch", valid_589740
  var valid_589741 = query.getOrDefault("key")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "key", valid_589741
  var valid_589742 = query.getOrDefault("$.xgafv")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = newJString("1"))
  if valid_589742 != nil:
    section.add "$.xgafv", valid_589742
  var valid_589743 = query.getOrDefault("labelSelector")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "labelSelector", valid_589743
  var valid_589744 = query.getOrDefault("prettyPrint")
  valid_589744 = validateParameter(valid_589744, JBool, required = false,
                                 default = newJBool(true))
  if valid_589744 != nil:
    section.add "prettyPrint", valid_589744
  var valid_589745 = query.getOrDefault("fieldSelector")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = nil)
  if valid_589745 != nil:
    section.add "fieldSelector", valid_589745
  var valid_589746 = query.getOrDefault("limit")
  valid_589746 = validateParameter(valid_589746, JInt, required = false, default = nil)
  if valid_589746 != nil:
    section.add "limit", valid_589746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589747: Call_RunProjectsLocationsTriggersList_589725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list triggers.
  ## 
  let valid = call_589747.validator(path, query, header, formData, body)
  let scheme = call_589747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589747.url(scheme.get, call_589747.host, call_589747.base,
                         call_589747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589747, url, valid)

proc call*(call_589748: Call_RunProjectsLocationsTriggersList_589725;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; includeUninitialized: bool = false;
          alt: string = "json"; `continue`: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          resourceVersion: string = ""; watch: bool = false; key: string = "";
          Xgafv: string = "1"; labelSelector: string = ""; prettyPrint: bool = true;
          fieldSelector: string = ""; limit: int = 0): Recallable =
  ## runProjectsLocationsTriggersList
  ## Rpc to list triggers.
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
  ##         : The project ID or project number from which the triggers should
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
  var path_589749 = newJObject()
  var query_589750 = newJObject()
  add(query_589750, "upload_protocol", newJString(uploadProtocol))
  add(query_589750, "fields", newJString(fields))
  add(query_589750, "quotaUser", newJString(quotaUser))
  add(query_589750, "includeUninitialized", newJBool(includeUninitialized))
  add(query_589750, "alt", newJString(alt))
  add(query_589750, "continue", newJString(`continue`))
  add(query_589750, "oauth_token", newJString(oauthToken))
  add(query_589750, "callback", newJString(callback))
  add(query_589750, "access_token", newJString(accessToken))
  add(query_589750, "uploadType", newJString(uploadType))
  add(path_589749, "parent", newJString(parent))
  add(query_589750, "resourceVersion", newJString(resourceVersion))
  add(query_589750, "watch", newJBool(watch))
  add(query_589750, "key", newJString(key))
  add(query_589750, "$.xgafv", newJString(Xgafv))
  add(query_589750, "labelSelector", newJString(labelSelector))
  add(query_589750, "prettyPrint", newJBool(prettyPrint))
  add(query_589750, "fieldSelector", newJString(fieldSelector))
  add(query_589750, "limit", newJInt(limit))
  result = call_589748.call(path_589749, query_589750, nil, nil, nil)

var runProjectsLocationsTriggersList* = Call_RunProjectsLocationsTriggersList_589725(
    name: "runProjectsLocationsTriggersList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{parent}/triggers",
    validator: validate_RunProjectsLocationsTriggersList_589726, base: "/",
    url: url_RunProjectsLocationsTriggersList_589727, schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesGetIamPolicy_589772 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesGetIamPolicy_589774(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesGetIamPolicy_589773(path: JsonNode;
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
  var valid_589775 = path.getOrDefault("resource")
  valid_589775 = validateParameter(valid_589775, JString, required = true,
                                 default = nil)
  if valid_589775 != nil:
    section.add "resource", valid_589775
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
  var valid_589776 = query.getOrDefault("upload_protocol")
  valid_589776 = validateParameter(valid_589776, JString, required = false,
                                 default = nil)
  if valid_589776 != nil:
    section.add "upload_protocol", valid_589776
  var valid_589777 = query.getOrDefault("fields")
  valid_589777 = validateParameter(valid_589777, JString, required = false,
                                 default = nil)
  if valid_589777 != nil:
    section.add "fields", valid_589777
  var valid_589778 = query.getOrDefault("quotaUser")
  valid_589778 = validateParameter(valid_589778, JString, required = false,
                                 default = nil)
  if valid_589778 != nil:
    section.add "quotaUser", valid_589778
  var valid_589779 = query.getOrDefault("alt")
  valid_589779 = validateParameter(valid_589779, JString, required = false,
                                 default = newJString("json"))
  if valid_589779 != nil:
    section.add "alt", valid_589779
  var valid_589780 = query.getOrDefault("oauth_token")
  valid_589780 = validateParameter(valid_589780, JString, required = false,
                                 default = nil)
  if valid_589780 != nil:
    section.add "oauth_token", valid_589780
  var valid_589781 = query.getOrDefault("callback")
  valid_589781 = validateParameter(valid_589781, JString, required = false,
                                 default = nil)
  if valid_589781 != nil:
    section.add "callback", valid_589781
  var valid_589782 = query.getOrDefault("access_token")
  valid_589782 = validateParameter(valid_589782, JString, required = false,
                                 default = nil)
  if valid_589782 != nil:
    section.add "access_token", valid_589782
  var valid_589783 = query.getOrDefault("uploadType")
  valid_589783 = validateParameter(valid_589783, JString, required = false,
                                 default = nil)
  if valid_589783 != nil:
    section.add "uploadType", valid_589783
  var valid_589784 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589784 = validateParameter(valid_589784, JInt, required = false, default = nil)
  if valid_589784 != nil:
    section.add "options.requestedPolicyVersion", valid_589784
  var valid_589785 = query.getOrDefault("key")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "key", valid_589785
  var valid_589786 = query.getOrDefault("$.xgafv")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = newJString("1"))
  if valid_589786 != nil:
    section.add "$.xgafv", valid_589786
  var valid_589787 = query.getOrDefault("prettyPrint")
  valid_589787 = validateParameter(valid_589787, JBool, required = false,
                                 default = newJBool(true))
  if valid_589787 != nil:
    section.add "prettyPrint", valid_589787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589788: Call_RunProjectsLocationsServicesGetIamPolicy_589772;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IAM Access Control policy currently in effect for the given
  ## Cloud Run service. This result does not include any inherited policies.
  ## 
  let valid = call_589788.validator(path, query, header, formData, body)
  let scheme = call_589788.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589788.url(scheme.get, call_589788.host, call_589788.base,
                         call_589788.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589788, url, valid)

proc call*(call_589789: Call_RunProjectsLocationsServicesGetIamPolicy_589772;
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
  var path_589790 = newJObject()
  var query_589791 = newJObject()
  add(query_589791, "upload_protocol", newJString(uploadProtocol))
  add(query_589791, "fields", newJString(fields))
  add(query_589791, "quotaUser", newJString(quotaUser))
  add(query_589791, "alt", newJString(alt))
  add(query_589791, "oauth_token", newJString(oauthToken))
  add(query_589791, "callback", newJString(callback))
  add(query_589791, "access_token", newJString(accessToken))
  add(query_589791, "uploadType", newJString(uploadType))
  add(query_589791, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589791, "key", newJString(key))
  add(query_589791, "$.xgafv", newJString(Xgafv))
  add(path_589790, "resource", newJString(resource))
  add(query_589791, "prettyPrint", newJBool(prettyPrint))
  result = call_589789.call(path_589790, query_589791, nil, nil, nil)

var runProjectsLocationsServicesGetIamPolicy* = Call_RunProjectsLocationsServicesGetIamPolicy_589772(
    name: "runProjectsLocationsServicesGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_RunProjectsLocationsServicesGetIamPolicy_589773,
    base: "/", url: url_RunProjectsLocationsServicesGetIamPolicy_589774,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesSetIamPolicy_589792 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesSetIamPolicy_589794(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesSetIamPolicy_589793(path: JsonNode;
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
  var valid_589795 = path.getOrDefault("resource")
  valid_589795 = validateParameter(valid_589795, JString, required = true,
                                 default = nil)
  if valid_589795 != nil:
    section.add "resource", valid_589795
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
  var valid_589796 = query.getOrDefault("upload_protocol")
  valid_589796 = validateParameter(valid_589796, JString, required = false,
                                 default = nil)
  if valid_589796 != nil:
    section.add "upload_protocol", valid_589796
  var valid_589797 = query.getOrDefault("fields")
  valid_589797 = validateParameter(valid_589797, JString, required = false,
                                 default = nil)
  if valid_589797 != nil:
    section.add "fields", valid_589797
  var valid_589798 = query.getOrDefault("quotaUser")
  valid_589798 = validateParameter(valid_589798, JString, required = false,
                                 default = nil)
  if valid_589798 != nil:
    section.add "quotaUser", valid_589798
  var valid_589799 = query.getOrDefault("alt")
  valid_589799 = validateParameter(valid_589799, JString, required = false,
                                 default = newJString("json"))
  if valid_589799 != nil:
    section.add "alt", valid_589799
  var valid_589800 = query.getOrDefault("oauth_token")
  valid_589800 = validateParameter(valid_589800, JString, required = false,
                                 default = nil)
  if valid_589800 != nil:
    section.add "oauth_token", valid_589800
  var valid_589801 = query.getOrDefault("callback")
  valid_589801 = validateParameter(valid_589801, JString, required = false,
                                 default = nil)
  if valid_589801 != nil:
    section.add "callback", valid_589801
  var valid_589802 = query.getOrDefault("access_token")
  valid_589802 = validateParameter(valid_589802, JString, required = false,
                                 default = nil)
  if valid_589802 != nil:
    section.add "access_token", valid_589802
  var valid_589803 = query.getOrDefault("uploadType")
  valid_589803 = validateParameter(valid_589803, JString, required = false,
                                 default = nil)
  if valid_589803 != nil:
    section.add "uploadType", valid_589803
  var valid_589804 = query.getOrDefault("key")
  valid_589804 = validateParameter(valid_589804, JString, required = false,
                                 default = nil)
  if valid_589804 != nil:
    section.add "key", valid_589804
  var valid_589805 = query.getOrDefault("$.xgafv")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = newJString("1"))
  if valid_589805 != nil:
    section.add "$.xgafv", valid_589805
  var valid_589806 = query.getOrDefault("prettyPrint")
  valid_589806 = validateParameter(valid_589806, JBool, required = false,
                                 default = newJBool(true))
  if valid_589806 != nil:
    section.add "prettyPrint", valid_589806
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

proc call*(call_589808: Call_RunProjectsLocationsServicesSetIamPolicy_589792;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the IAM Access control policy for the specified Service. Overwrites
  ## any existing policy.
  ## 
  let valid = call_589808.validator(path, query, header, formData, body)
  let scheme = call_589808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589808.url(scheme.get, call_589808.host, call_589808.base,
                         call_589808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589808, url, valid)

proc call*(call_589809: Call_RunProjectsLocationsServicesSetIamPolicy_589792;
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
  var path_589810 = newJObject()
  var query_589811 = newJObject()
  var body_589812 = newJObject()
  add(query_589811, "upload_protocol", newJString(uploadProtocol))
  add(query_589811, "fields", newJString(fields))
  add(query_589811, "quotaUser", newJString(quotaUser))
  add(query_589811, "alt", newJString(alt))
  add(query_589811, "oauth_token", newJString(oauthToken))
  add(query_589811, "callback", newJString(callback))
  add(query_589811, "access_token", newJString(accessToken))
  add(query_589811, "uploadType", newJString(uploadType))
  add(query_589811, "key", newJString(key))
  add(query_589811, "$.xgafv", newJString(Xgafv))
  add(path_589810, "resource", newJString(resource))
  if body != nil:
    body_589812 = body
  add(query_589811, "prettyPrint", newJBool(prettyPrint))
  result = call_589809.call(path_589810, query_589811, nil, nil, body_589812)

var runProjectsLocationsServicesSetIamPolicy* = Call_RunProjectsLocationsServicesSetIamPolicy_589792(
    name: "runProjectsLocationsServicesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "run.googleapis.com", route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_RunProjectsLocationsServicesSetIamPolicy_589793,
    base: "/", url: url_RunProjectsLocationsServicesSetIamPolicy_589794,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsServicesTestIamPermissions_589813 = ref object of OpenApiRestCall_588450
proc url_RunProjectsLocationsServicesTestIamPermissions_589815(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RunProjectsLocationsServicesTestIamPermissions_589814(
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
  var valid_589816 = path.getOrDefault("resource")
  valid_589816 = validateParameter(valid_589816, JString, required = true,
                                 default = nil)
  if valid_589816 != nil:
    section.add "resource", valid_589816
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
  var valid_589817 = query.getOrDefault("upload_protocol")
  valid_589817 = validateParameter(valid_589817, JString, required = false,
                                 default = nil)
  if valid_589817 != nil:
    section.add "upload_protocol", valid_589817
  var valid_589818 = query.getOrDefault("fields")
  valid_589818 = validateParameter(valid_589818, JString, required = false,
                                 default = nil)
  if valid_589818 != nil:
    section.add "fields", valid_589818
  var valid_589819 = query.getOrDefault("quotaUser")
  valid_589819 = validateParameter(valid_589819, JString, required = false,
                                 default = nil)
  if valid_589819 != nil:
    section.add "quotaUser", valid_589819
  var valid_589820 = query.getOrDefault("alt")
  valid_589820 = validateParameter(valid_589820, JString, required = false,
                                 default = newJString("json"))
  if valid_589820 != nil:
    section.add "alt", valid_589820
  var valid_589821 = query.getOrDefault("oauth_token")
  valid_589821 = validateParameter(valid_589821, JString, required = false,
                                 default = nil)
  if valid_589821 != nil:
    section.add "oauth_token", valid_589821
  var valid_589822 = query.getOrDefault("callback")
  valid_589822 = validateParameter(valid_589822, JString, required = false,
                                 default = nil)
  if valid_589822 != nil:
    section.add "callback", valid_589822
  var valid_589823 = query.getOrDefault("access_token")
  valid_589823 = validateParameter(valid_589823, JString, required = false,
                                 default = nil)
  if valid_589823 != nil:
    section.add "access_token", valid_589823
  var valid_589824 = query.getOrDefault("uploadType")
  valid_589824 = validateParameter(valid_589824, JString, required = false,
                                 default = nil)
  if valid_589824 != nil:
    section.add "uploadType", valid_589824
  var valid_589825 = query.getOrDefault("key")
  valid_589825 = validateParameter(valid_589825, JString, required = false,
                                 default = nil)
  if valid_589825 != nil:
    section.add "key", valid_589825
  var valid_589826 = query.getOrDefault("$.xgafv")
  valid_589826 = validateParameter(valid_589826, JString, required = false,
                                 default = newJString("1"))
  if valid_589826 != nil:
    section.add "$.xgafv", valid_589826
  var valid_589827 = query.getOrDefault("prettyPrint")
  valid_589827 = validateParameter(valid_589827, JBool, required = false,
                                 default = newJBool(true))
  if valid_589827 != nil:
    section.add "prettyPrint", valid_589827
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

proc call*(call_589829: Call_RunProjectsLocationsServicesTestIamPermissions_589813;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified Project.
  ## 
  ## There are no permissions required for making this API call.
  ## 
  let valid = call_589829.validator(path, query, header, formData, body)
  let scheme = call_589829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589829.url(scheme.get, call_589829.host, call_589829.base,
                         call_589829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589829, url, valid)

proc call*(call_589830: Call_RunProjectsLocationsServicesTestIamPermissions_589813;
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
  var path_589831 = newJObject()
  var query_589832 = newJObject()
  var body_589833 = newJObject()
  add(query_589832, "upload_protocol", newJString(uploadProtocol))
  add(query_589832, "fields", newJString(fields))
  add(query_589832, "quotaUser", newJString(quotaUser))
  add(query_589832, "alt", newJString(alt))
  add(query_589832, "oauth_token", newJString(oauthToken))
  add(query_589832, "callback", newJString(callback))
  add(query_589832, "access_token", newJString(accessToken))
  add(query_589832, "uploadType", newJString(uploadType))
  add(query_589832, "key", newJString(key))
  add(query_589832, "$.xgafv", newJString(Xgafv))
  add(path_589831, "resource", newJString(resource))
  if body != nil:
    body_589833 = body
  add(query_589832, "prettyPrint", newJBool(prettyPrint))
  result = call_589830.call(path_589831, query_589832, nil, nil, body_589833)

var runProjectsLocationsServicesTestIamPermissions* = Call_RunProjectsLocationsServicesTestIamPermissions_589813(
    name: "runProjectsLocationsServicesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "run.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_RunProjectsLocationsServicesTestIamPermissions_589814,
    base: "/", url: url_RunProjectsLocationsServicesTestIamPermissions_589815,
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
