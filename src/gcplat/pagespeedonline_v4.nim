
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PageSpeed Insights
## version: v4
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Analyzes the performance of a web page and provides tailored suggestions to make that page faster.
## 
## https://developers.google.com/speed/docs/insights/v4/getting-started
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
  gcpServiceName = "pagespeedonline"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PagespeedonlinePagespeedapiRunpagespeed_593676 = ref object of OpenApiRestCall_593408
proc url_PagespeedonlinePagespeedapiRunpagespeed_593678(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PagespeedonlinePagespeedapiRunpagespeed_593677(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   utm_source: JString
  ##             : Campaign source for analytics.
  ##   locale: JString
  ##         : The locale used to localize formatted results
  ##   snapshots: JBool
  ##            : Indicates if binary data containing snapshot images should be included
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   filter_third_party_resources: JBool
  ##                               : Indicates if third party resources should be filtered out before PageSpeed analysis.
  ##   url: JString (required)
  ##      : The URL to fetch and analyze
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rule: JArray
  ##       : A PageSpeed rule to run; if none are given, all rules are run
  ##   screenshot: JBool
  ##             : Indicates if binary data containing a screenshot should be included
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   strategy: JString
  ##           : The analysis strategy (desktop or mobile) to use, and desktop is the default
  ##   utm_campaign: JString
  ##               : Campaign name for analytics.
  section = newJObject()
  var valid_593790 = query.getOrDefault("utm_source")
  valid_593790 = validateParameter(valid_593790, JString, required = false,
                                 default = nil)
  if valid_593790 != nil:
    section.add "utm_source", valid_593790
  var valid_593791 = query.getOrDefault("locale")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "locale", valid_593791
  var valid_593805 = query.getOrDefault("snapshots")
  valid_593805 = validateParameter(valid_593805, JBool, required = false,
                                 default = newJBool(false))
  if valid_593805 != nil:
    section.add "snapshots", valid_593805
  var valid_593806 = query.getOrDefault("fields")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "fields", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593808 = query.getOrDefault("alt")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = newJString("json"))
  if valid_593808 != nil:
    section.add "alt", valid_593808
  var valid_593809 = query.getOrDefault("oauth_token")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "oauth_token", valid_593809
  var valid_593810 = query.getOrDefault("userIp")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "userIp", valid_593810
  var valid_593811 = query.getOrDefault("filter_third_party_resources")
  valid_593811 = validateParameter(valid_593811, JBool, required = false,
                                 default = newJBool(false))
  if valid_593811 != nil:
    section.add "filter_third_party_resources", valid_593811
  assert query != nil, "query argument is necessary due to required `url` field"
  var valid_593812 = query.getOrDefault("url")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "url", valid_593812
  var valid_593813 = query.getOrDefault("key")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "key", valid_593813
  var valid_593814 = query.getOrDefault("rule")
  valid_593814 = validateParameter(valid_593814, JArray, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "rule", valid_593814
  var valid_593815 = query.getOrDefault("screenshot")
  valid_593815 = validateParameter(valid_593815, JBool, required = false,
                                 default = newJBool(false))
  if valid_593815 != nil:
    section.add "screenshot", valid_593815
  var valid_593816 = query.getOrDefault("prettyPrint")
  valid_593816 = validateParameter(valid_593816, JBool, required = false,
                                 default = newJBool(true))
  if valid_593816 != nil:
    section.add "prettyPrint", valid_593816
  var valid_593817 = query.getOrDefault("strategy")
  valid_593817 = validateParameter(valid_593817, JString, required = false,
                                 default = newJString("desktop"))
  if valid_593817 != nil:
    section.add "strategy", valid_593817
  var valid_593818 = query.getOrDefault("utm_campaign")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = nil)
  if valid_593818 != nil:
    section.add "utm_campaign", valid_593818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593841: Call_PagespeedonlinePagespeedapiRunpagespeed_593676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ## 
  let valid = call_593841.validator(path, query, header, formData, body)
  let scheme = call_593841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593841.url(scheme.get, call_593841.host, call_593841.base,
                         call_593841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593841, url, valid)

proc call*(call_593912: Call_PagespeedonlinePagespeedapiRunpagespeed_593676;
          url: string; utmSource: string = ""; locale: string = "";
          snapshots: bool = false; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          filterThirdPartyResources: bool = false; key: string = "";
          rule: JsonNode = nil; screenshot: bool = false; prettyPrint: bool = true;
          strategy: string = "desktop"; utmCampaign: string = ""): Recallable =
  ## pagespeedonlinePagespeedapiRunpagespeed
  ## Runs PageSpeed analysis on the page at the specified URL, and returns PageSpeed scores, a list of suggestions to make that page faster, and other information.
  ##   utmSource: string
  ##            : Campaign source for analytics.
  ##   locale: string
  ##         : The locale used to localize formatted results
  ##   snapshots: bool
  ##            : Indicates if binary data containing snapshot images should be included
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   filterThirdPartyResources: bool
  ##                            : Indicates if third party resources should be filtered out before PageSpeed analysis.
  ##   url: string (required)
  ##      : The URL to fetch and analyze
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   rule: JArray
  ##       : A PageSpeed rule to run; if none are given, all rules are run
  ##   screenshot: bool
  ##             : Indicates if binary data containing a screenshot should be included
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   strategy: string
  ##           : The analysis strategy (desktop or mobile) to use, and desktop is the default
  ##   utmCampaign: string
  ##              : Campaign name for analytics.
  var query_593913 = newJObject()
  add(query_593913, "utm_source", newJString(utmSource))
  add(query_593913, "locale", newJString(locale))
  add(query_593913, "snapshots", newJBool(snapshots))
  add(query_593913, "fields", newJString(fields))
  add(query_593913, "quotaUser", newJString(quotaUser))
  add(query_593913, "alt", newJString(alt))
  add(query_593913, "oauth_token", newJString(oauthToken))
  add(query_593913, "userIp", newJString(userIp))
  add(query_593913, "filter_third_party_resources",
      newJBool(filterThirdPartyResources))
  add(query_593913, "url", newJString(url))
  add(query_593913, "key", newJString(key))
  if rule != nil:
    query_593913.add "rule", rule
  add(query_593913, "screenshot", newJBool(screenshot))
  add(query_593913, "prettyPrint", newJBool(prettyPrint))
  add(query_593913, "strategy", newJString(strategy))
  add(query_593913, "utm_campaign", newJString(utmCampaign))
  result = call_593912.call(nil, query_593913, nil, nil, nil)

var pagespeedonlinePagespeedapiRunpagespeed* = Call_PagespeedonlinePagespeedapiRunpagespeed_593676(
    name: "pagespeedonlinePagespeedapiRunpagespeed", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/runPagespeed",
    validator: validate_PagespeedonlinePagespeedapiRunpagespeed_593677,
    base: "/pagespeedonline/v4", url: url_PagespeedonlinePagespeedapiRunpagespeed_593678,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
